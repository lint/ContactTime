export ARCHS = armv7 armv7s arm64 arm64e

include $(THEOS)/makefiles/common.mk

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += ContactTimeContactsUI ContactTimeMessages ContactTimeSpringBoard
SUBPROJECTS += Preferences

include $(THEOS_MAKE_PATH)/aggregate.mk
