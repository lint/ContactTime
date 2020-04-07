
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ContactTimeMessages
ContactTimeMessages_FILES = ContactTimeMessages.xm $(wildcard ../Util/*.xm ./Classes/*.m)
ContactTimeMessages_CFLAGS = -fobjc-arc
ContactTimeMessages_LIBRARIES = rocketbootstrap
ContactTimeMessages_PRIVATE_FRAMEWORKS += AppSupport

include $(THEOS_MAKE_PATH)/tweak.mk
