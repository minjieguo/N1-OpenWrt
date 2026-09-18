#!/bin/bash

# Adjust source code
patch -p1 -f < $(dirname "$0")/luci.patch

# Add extra feeds
# Nikki 不在官方 feeds 中，按上游文档以 feed 方式引入（含 nikki / luci-app-nikki / mihomo-meta / mihomo-alpha）
if ! grep -q "OpenWrt-nikki" feeds.conf.default; then
	echo "src-git nikki https://github.com/nikkinikki-org/OpenWrt-nikki.git;main" >> feeds.conf.default
fi

# Clone packages
rm -rf clone/amlogic
git clone https://github.com/ophub/luci-app-amlogic --depth=1 clone/amlogic
rm -rf clone/daed
git clone https://github.com/QiuSimons/luci-app-daed clone/daed
rm -rf feeds/luci/applications/luci-app-podman
git clone https://github.com/Zerogiven-OpenWRT-Packages/luci-app-podman --depth=1 feeds/luci/applications/luci-app-podman

# Adjust packages
rm -rf feeds/luci/applications/luci-app-daed feeds/luci/applications/luci-app-passwall
cp -rf clone/amlogic/luci-app-amlogic clone/daed/luci-app-daed feeds/luci/applications/
sed -i '/luci-app-attendedsysupgrade/d' feeds/luci/collections/luci/Makefile

# Clean packages
rm -rf clone
