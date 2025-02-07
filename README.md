libgo2 - Support library for the ODROID-GO Advance


Buildroot package
======
```
################################################################################
#
# LIBGO2
#
################################################################################

LIBGO2_VERSION = master
LIBGO2_SITE = $(call github,lualiliu,libgo2,$(LIBGO2_VERSION))
LIBGO2_INSTALL_STAGING = YES
LIBGO2_DEPENDENCIES = host-pkgconf libpng libdrm openal librga

ifeq ($(BR2_STATIC_LIBS),y)
LIBGO2_CONF_OPTS += STATIC_ENABLED=1
endif
LIBGO2_MAKE_ENV = AS="$(TARGET_AS)" CC="$(TARGET_CC)" PREFIX=/usr PKG_CONFIG="$(BASE_DIR)/host/bin/pkg-config" CFLAGS="$(TARGET_CFLAGS) $(LUA_CFLAGS) -flto"

define LIBGO2_BUILD_CMDS
	$(LIBGO2_MAKE_ENV) $(MAKE) -C $(@D) $(LIBGO2_CONF_OPTS)
endef

define LIBGO2_INSTALL_STAGING_CMDS
	mkdir -p $(STAGING_DIR)/usr/include/go2
	$(LIBGO2_MAKE_ENV) DESTDIR="$(STAGING_DIR)" $(MAKE) -C $(@D) install-headers install-lib
endef

define LIBGO2_INSTALL_TARGET_CMDS
	$(LIBGO2_MAKE_ENV) DESTDIR="$(TARGET_DIR)" $(MAKE) -C $(@D) install-lib
endef

$(eval $(generic-package))

```
