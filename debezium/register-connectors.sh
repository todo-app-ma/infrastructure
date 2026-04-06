#!/bin/bash
set -e

CONNECT_URL="http://localhost:8083/connectors"

echo "Registering Debezium connectors..."

for connector in debezium/connectors/*.json; do
  echo "Registering $connector..."
  curl -s -X POST \
    -H "Content-Type: application/json" \
    --data @"$connector" \
    "$CONNECT_URL"
  echo ""
done

echo "All connectors registered."
