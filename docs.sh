#!/usr/bin/env sh
cp USERGUIDE.md 'User Guide.md'
jazzy
rm 'User Guide.md'

cp USERGUIDE_CN.md '用户指南.md'
jazzy --config .jazzy_CN.yaml
rm '用户指南.md'
