#!/usr/bin/env bash
# Regenerates the Dockerfile lock files; torch is overridden out because the Dockerfile installs it from the PyTorch index.
set -euo pipefail
cd "$(dirname "$0")"

PYTHON_VERSION=$(sed -nE 's/^requires-python = ">=([0-9]+\.[0-9]+),<[^"]+"$/\1/p' ../pyproject.toml)

test -n "$PYTHON_VERSION"

flags=(--universal --python-version "$PYTHON_VERSION" --generate-hashes --no-header --quiet)
uv pip compile requirements-slim.txt "${flags[@]}" -o requirements-slim.lock
uv pip compile requirements.txt "${flags[@]}" --override <(echo "torch; python_version < '0'") -o requirements.lock
