include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = AltiliumPrefs

AltiliumPrefs_FILES = $(wildcard *.m)
AltiliumPrefs_INSTALL_PATH = /Library/PreferenceBundles
AltiliumPrefs_FRAMEWORKS = UIKit
AltiliumPrefs_PRIVATE_FRAMEWORKS = Preferences OnBoardingKit
AltiliumPrefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/AltiliumPrefs.plist$(ECHO_END)