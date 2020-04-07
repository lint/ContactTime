include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ContactTimeContactsUI
ContactTimeContactsUI_FILES = ContactTimeContactsUI.xm $(wildcard ./Classes/*.m ./Classes/*.xm ../Util/*.xm)
ContactTimeContactsUI_CFLAGS = -fobjc-arc
ContactTimeContactsUI_LIBRARIES = rocketbootstrap
ContactTimeContactsUI_FRAMEWORKS += Contacts ContactsUI SafariServices
ContactTimeContactsUI_PRIVATE_FRAMEWORKS += ContactsUICore AppSupport

include $(THEOS_MAKE_PATH)/tweak.mk
