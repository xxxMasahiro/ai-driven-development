#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

make_repo() {
  local repo="$1"
  mkdir -p "$repo"
  git -C "$repo" init -q
  git -C "$repo" config user.name "Product Launch Test"
  git -C "$repo" config user.email "product-launch@example.com"
}

good_repo="$TMP_DIR/good"
make_repo "$good_repo"
cat >"$good_repo/README.md" <<'DOC'
# Task Tracker

Open `index.html` directly to start the product.
DOC
cat >"$good_repo/index.html" <<'HTML'
<!doctype html>
<html lang="en">
  <body>
    <form id="task-form">
      <input id="task-title" name="title" />
      <button type="submit">Add Task</button>
    </form>
    <ul id="task-list"></ul>
    <script src="app.js"></script>
  </body>
</html>
HTML
cat >"$good_repo/app.js" <<'JS'
const form = document.querySelector("#task-form");
const list = document.querySelector("#task-list");
form.addEventListener("submit", (event) => {
  event.preventDefault();
  const item = document.createElement("li");
  item.textContent = document.querySelector("#task-title").value;
  list.appendChild(item);
});
JS
"$ROOT/tools/product-launch-check" check --repo "$good_repo" --launch direct-index --profile task-tracker \
  | grep 'Product launch check passed'

module_repo="$TMP_DIR/module"
make_repo "$module_repo"
printf '# Task Tracker\n\nOpen `index.html` directly.\n' >"$module_repo/README.md"
cat >"$module_repo/index.html" <<'HTML'
<!doctype html>
<html lang="en">
  <body>
    <form id="task-form"><input id="task-title" name="title" /></form>
    <ul id="task-list"></ul>
    <script type="module" src="app.js"></script>
  </body>
</html>
HTML
printf 'export const noop = true;\n' >"$module_repo/app.js"
"$ROOT/tools/product-launch-check" check --repo "$module_repo" --launch direct-index --profile task-tracker \
  >/tmp/product-launch-module.out 2>&1 && exit 1 || true
grep 'direct index launch cannot depend on type="module" scripts' /tmp/product-launch-module.out >/dev/null

navigation_repo="$TMP_DIR/navigation"
make_repo "$navigation_repo"
printf '# Task Tracker\n\nOpen `index.html` directly.\n' >"$navigation_repo/README.md"
cat >"$navigation_repo/index.html" <<'HTML'
<!doctype html>
<html lang="en">
  <body>
    <form id="task-form"><input id="task-title" name="title" /></form>
    <ul id="task-list"></ul>
    <script src="app.js"></script>
  </body>
</html>
HTML
printf 'document.querySelector("#task-form").addEventListener("submit", () => {});\n' >"$navigation_repo/app.js"
"$ROOT/tools/product-launch-check" check --repo "$navigation_repo" --launch direct-index --profile task-tracker \
  >/tmp/product-launch-navigation.out 2>&1 && exit 1 || true
grep 'prevents form navigation' /tmp/product-launch-navigation.out >/dev/null

missing_repo="$TMP_DIR/missing-index"
make_repo "$missing_repo"
printf '# Task Tracker\n\nOpen `index.html` directly.\n' >"$missing_repo/README.md"
"$ROOT/tools/product-launch-check" check --repo "$missing_repo" --launch direct-index --profile task-tracker \
  >/tmp/product-launch-missing-index.out 2>&1 && exit 1 || true
grep 'direct index launch requires the manifest entrypoint' /tmp/product-launch-missing-index.out >/dev/null

nonroot_repo="$TMP_DIR/nonroot"
make_repo "$nonroot_repo"
mkdir -p "$nonroot_repo/public" "$nonroot_repo/src" "$nonroot_repo/tests" "$nonroot_repo/ops"
printf '# Task Tracker\n\nOpen `public/index.html` directly.\n' >"$nonroot_repo/README.md"
cat >"$nonroot_repo/public/index.html" <<'HTML'
<!doctype html>
<html lang="en">
  <body>
    <form id="task-form"><input id="task-title" name="title" /></form>
    <ul id="task-list"></ul>
    <script src="../src/app.js"></script>
  </body>
</html>
HTML
cat >"$nonroot_repo/src/app.js" <<'JS'
document.querySelector("#task-form").addEventListener("submit", (event) => {
  event.preventDefault();
  document.querySelector("#task-list").appendChild(document.createElement("li"));
});
JS
printf 'test\n' >"$nonroot_repo/tests/app.test.js"
cat >"$nonroot_repo/ops/PRODUCT_MANIFEST.tsv" <<'DOC'
# authority_id	required_mode	contexts	product_types	path	path_role	validation_rule	dashboard_group	description
product.entrypoint	required	all	all	public/index.html	entrypoint	file_exists	workflow	Browser entrypoint.
product.source	required	all	all	src/app.js	source	file_nonempty	workflow	Application source authority.
product.test	required	all	all	tests/app.test.js	test	file_nonempty	workflow	Test authority.
DOC
"$ROOT/tools/product-launch-check" check --repo "$nonroot_repo" --launch direct-index --profile task-tracker \
  | grep 'Product launch check passed'

server_repo="$TMP_DIR/server"
make_repo "$server_repo"
mkdir -p "$server_repo/src" "$server_repo/tests" "$server_repo/ops"
printf '# Web App\n\nRun `npm run dev` and open http://localhost:5173.\n' >"$server_repo/README.md"
cat >"$server_repo/package.json" <<'JSON'
{
  "scripts": {
    "dev": "vite"
  }
}
JSON
printf 'console.log("server");\n' >"$server_repo/src/app.js"
printf 'test\n' >"$server_repo/tests/app.test.js"
cat >"$server_repo/ops/PRODUCT_MANIFEST.tsv" <<'DOC'
# authority_id	required_mode	contexts	product_types	path	path_role	validation_rule	dashboard_group	description
product.entrypoint	required	all	all	src/app.js	entrypoint	file_exists	workflow	Server entrypoint.
product.source	required	all	all	src/app.js	source	file_nonempty	workflow	Application source authority.
product.test	required	all	all	tests/app.test.js	test	file_nonempty	workflow	Test authority.
DOC
"$ROOT/tools/product-launch-check" check --repo "$server_repo" --launch auto --profile generic \
  | grep 'Product launch check passed'

server_missing_script="$TMP_DIR/server-missing-script"
make_repo "$server_missing_script"
mkdir -p "$server_missing_script/src" "$server_missing_script/tests" "$server_missing_script/ops"
printf '# Web App\n\nRun `npm run dev` and open http://localhost:5173.\n' >"$server_missing_script/README.md"
printf '{ "scripts": {} }\n' >"$server_missing_script/package.json"
printf 'console.log("server");\n' >"$server_missing_script/src/app.js"
printf 'test\n' >"$server_missing_script/tests/app.test.js"
cat >"$server_missing_script/ops/PRODUCT_MANIFEST.tsv" <<'DOC'
# authority_id	required_mode	contexts	product_types	path	path_role	validation_rule	dashboard_group	description
product.entrypoint	required	all	all	src/app.js	entrypoint	file_exists	workflow	Server entrypoint.
product.source	required	all	all	src/app.js	source	file_nonempty	workflow	Application source authority.
product.test	required	all	all	tests/app.test.js	test	file_nonempty	workflow	Test authority.
DOC
"$ROOT/tools/product-launch-check" check --repo "$server_missing_script" --launch auto --profile generic \
  >/tmp/product-launch-missing-server-script.out 2>&1 && exit 1 || true
grep 'server launch README references missing npm script: dev' /tmp/product-launch-missing-server-script.out >/dev/null

printf 'Product launch check tests passed.\n'
