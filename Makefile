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

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/share/koolproxy

ifeq ($(ARCH),aarch64)
	$(INSTALL_BIN) ./koolproxy/files/aarch64 $(1)/usr/share/koolproxy/koolproxy

else ifeq ($(ARCH),arm)
	$(INSTALL_BIN) ./koolproxy/files/arm $(1)/usr/share/koolproxy/koolproxy

else ifeq ($(ARCH),i386)
	$(INSTALL_BIN) ./koolproxy/files/i386 $(1)/usr/share/koolproxy/koolproxy

else ifeq ($(ARCH),mips)
	$(INSTALL_BIN) ./koolproxy/files/mips $(1)/usr/share/koolproxy/koolproxy

else ifeq ($(ARCH),mipsel)
	$(INSTALL_BIN) ./koolproxy/files/mipsel $(1)/usr/share/koolproxy/koolproxy

else ifeq ($(ARCH),x86_64)
	$(INSTALL_BIN) ./koolproxy/files/x86_64 $(1)/usr/share/koolproxy/koolproxy
endif
endef

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
