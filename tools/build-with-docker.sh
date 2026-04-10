#!/bin/bash

root_dir=$(cd `dirname $0`/.. && pwd -P)
echo "$(id -u):$(id -g)"

# 如果传入了 --arch 参数，使用它；否则使用默认架构
arch=$(node "$root_dir/tools/parse-config.js" --get-arch $@)

image="msojocs/wechat-devtools-build:v1.0.6"
# 注意：loong64 交叉编译在 x86_64 环境上进行，使用通用镜像即可
# 不需要单独的 loong64 Docker 镜像
docker run --rm -i \
    -u "$(id -u):$(id -g)" \
    -e "ACTION_MODE=${ACTION_MODE:-false}" \
    -e "npm_config_prefix=/workspace/cache/npm/node_global" \
    -e "npm_config_cache=/workspace/cache/npm/node_cache" \
    -w /workspace \
    -v "$root_dir:/workspace" \
    $image \
    bash ./tools/setup-wechat-devtools.sh --arch $arch $@