
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ContactTimeSpringBoard
ContactTimeSpringBoard_FILES = ContactTimeSpringBoard.xm $(wildcard ../Util/*.xm ./Classes/*.xm)
ContactTimeSpringBoard_CFLAGS = -fobjc-arc
ContactTimeSpringBoard_LIBRARIES = rocketbootstrap
ContactTimeSpringBoard_PRIVATE_FRAMEWORKS +=  AppSupport

include $(THEOS_MAKE_PATH)/tweak.mk
