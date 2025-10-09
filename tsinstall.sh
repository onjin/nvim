#!/usr/bin/env bash
PARSER=${1:-}
PARSER_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/parser"

if [[ -z ${PARSER} ]]; then
	echo "Usage: $0 <parser> - f.e python"
	exit 1
fi
TMP=$(mktemp -d)

git clone https://github.com/tree-sitter/tree-sitter-${PARSER} ${TMP} || true

cd ${TMP} && make

mkdir -p ${PARSER_DIR}
cp ${TMP}/libtree-sitter-${PARSER}.so ${PARSER_DIR}/${PARSER}.so
echo "✅ Installed parser for ${PARSER} → ${PARSER_DIR}/${PARSER}.so"

