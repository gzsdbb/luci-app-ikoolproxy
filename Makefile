include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-ikoolproxy
PKG_VERSION:=1.0.0
PKG_RELEASE:=20220324

PKG_MAINTAINER:=panda-mute <wxuzju@gmail.com>

LUCI_TITLE:=LuCI support for koolproxy
LUCI_PKGARCH:=all
LUCI_DEPENDS:=+openssl-util +ipset +dnsmasq-full +@BUSYBOX_CONFIG_DIFF +iptables-mod-nat-extra +wget

define Package/$(PKG_NAME)/conffiles
/etc/config/koolproxy
/usr/share/koolproxy/data/rules/
endef

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
