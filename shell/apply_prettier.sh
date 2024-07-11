#!/bin/bash

jq '.scripts += {"format": "prettier --write **/*.{js,ts}"}' package.json > tmp.json && mv tmp.json package.json

