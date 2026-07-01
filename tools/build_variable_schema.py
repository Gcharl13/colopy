#!/usr/bin/env python3
"""DEPRECATED shim — superseded by tools/build_schema.py.

The canonical binding list used to live in a hardcoded Python `LIVE` dict here; it now lives as
DATA in data_extracted/engine/bindings.json (+ cfg.json, function_writes.json). tools/build_schema.py
is the single generator for schema.json / functions.json / variables.json / schemas.md. This shim
just delegates so old invocations keep working.
"""
import build_schema

if __name__ == "__main__":
    build_schema.main()
