# [Android-x86](https://www.android-x86.org) on the [Insignia Flex 8](https://www.insigniaproducts.com/pdp/NS-P08W7100/5451211)

Android-x86_64 [v8.1r5] running on a Insignia Flex 8 [NS-P08W7100] tablet.

Based off [Kernel 4.18.14](https://osdn.net/projects/android-x86/scm/git/kernel/tree/kernel-4.18/)

Please consider [donating](https://paypal.me/djouija) to support this project. Thanks!

----------------------------------------------------------------------------------

## Installation Instructions

* [Download latest pre-built image here]() &nbsp; | &nbsp; [View all builds](https://www.androidfilehost.com/?w=files&flid=320110)
* Use [Rufus](https://rufus.ie/) to create USB drive installer.
* Use OTG adapter to connect USB drive and keyboard to device and press `DEL` at bios logo and navigate to `<Security>` then select `Secure Boot menu` and make sure `Secure Boot` is disabled.
* Boot from USB drive under the `Save & Exit` menu via the `Boot Override` section *(If `Secure Boot` was enabled, ensure you `Save Changes & Reset` before booting from USB!)*
* Select `Live` to test Android directly from USB, or choose `Auto-Install` to install Android-x86 to the internal storage (`mmcblk0`).
* If installing, choose the internal storage device (`mmcblk0`) and click `Yes` and allow for installation to finish and then select `reboot`.
* Note you should login to a Google account and update all pre-installed applications to ensure proper functionality after fresh install.
* Enjoy your Insigna Flex 8 running Android-x86!

<br>
## Recent Bugfixes and Improvements

* 2020-11-18:
	* First pre-built image released!
	* Improved s2idle [[s0ix]](https://01.org/blogs/qwang59/2018/how-achieve-s0ix-states-linux) support [(per these patches)](https://bugzilla.kernel.org/show_bug.cgi?id=196861)
	* Improved Wi-Fi support and random disconnects via alternate `rtl8723bs` driver.
	* Improved `/etc/scripts/sleep.sh` script for better s2idle support.
	* Fixed "audio pop" issue with touch events when using headphones via `/etc/scripts/pop-fix.sh` script.
	* Fixed headphone switching on boot _(audio will automatically output to headphones if connected on startup)_ 
	* Fixed levels for internal and external headset microphones.
	* Added "HDMI Output" switching to GRUB2 loader menu.

<br>
## Kernel Build Instructions

To build from source, follow the instructions at [Android-x86.org](https://www.android-x86.org/source.html) and switch to the 4.18 kernel:

	cd /path/to/android/source/kernel
	git fetch x86 kernel-4.18
	git checkout FETCH_HEAD

* Patch 4.18.14 kernel with [all patches](./00%20 Patches) in sequential order.
* As of this build, Kernel 4.18 had issues compiling due to missing `./kernel/drivers/net/wireless/broadcom/wl/Makefile`:
	* Edit `./kernel/drivers/net/wireless/broadcom/Makefile` and remove or comment out the line `obj-$(CONFIG_WL)       += wl/`
	* Edit `./kernel/drivers/net/wireless/broadcom/Kconfig` and remove or comment out the line `source "drivers/net/wireless/broadcom/wl/Kconfig"`
* Copy [touchscreen firmware](https://github.com/ouija/android-x86_insignia_flex8/blob/master/02%20%20Other/gsl1680-insignia_flex8.fw) to `./device/generic/firmware/silead/gsl1680-insignia_flex8.fw` if 	building iso from source, or place in `./system/lib/firmware/silead/` for pre-built system image.
* Copy [soundcard state file for alsa](https://github.com/ouija/android-x86_insignia_flex8/blob/master/02%20%20Other/bytcrrt5651.state) to `./device/generic/common/alsa/bytcrrt5651.state` if building iso from source, or place in `./system/etc/alsa` for pre-built system image.
* Replaced the staging `rtl8723bs` driver with [youling257's version](https://github.com/youling257/rockchip_wlan) and compiled from source [as per these instructions](https://groups.google.com/g/android-x86/c/iwSFhlLyW7A/m/kSxTf-rBAwAJ).
* Build the kernel / iso and install to device.
* Once booted in Android, create an /etc/scripts folder and copy all [scripts](https://github.com/ouija/android-x86_insignia_flex8/tree/master/01%20%20Scripts) to this folder
* Replace /system/build.prop with [this file](https://github.com/ouija/android-x86_insignia_flex8/blob/master/02%20%20Other/build.prop)
* Replace /etc/init.sh with [this file](https://github.com/ouija/android-x86_insignia_flex8/blob/master/02%20%20Other/init.sh)

<br>
## Additional Build Details

* Replaced staging `rtl8723bs` driver with [youling257's version](https://github.com/youling257/rockchip_wlan) for improved wirless connectivity.
* Added `acpi=force reboot=acpi acpi_osi='!Windows 2013' acpi_osi='!Windows 2012' acpi_osi='Linux'` boot args to GRUB -> `android.cfg` to improve ACPI support.
* Added `acpi_backlight=vendor` boot args to GRUB (`android.cfg`) to resolve black screen when resume from sleep.
* Added `intel_idle.max_cstate=1` boot args to GRUB (`android.cfg`) to improve deep sleep issues with IGFX and Baytrail/Cherrytrail c-state bug.
* Updated `/system/etc/init.sh` startup script and added `NS-P08W7100` to `init_hal_sensors` function to properly initialize accelerometers _(screen rotation)_.
* Updated `/system/etc/init.sh` startup script and added `NS-P08W7100` to `do_bootcomplete` function to run custom scripts _(enable headphone switching, suspend-to-ram, audio pop fix, etc)_.
* Enabled `navtivebridge` support by default and included `houdini` in the pre-built image, and fixed url link issue with `/system/bin/enable_nativebridge` script.
* Updated `build.prop` with optimizations for better GPU and system performance.
* Removed `taskbar`, `calibration` and `developer tools` apps from pre-built image.
* Updates Android-x86 GRUB loader with prettier theme.
* Added `ES File Explorer` to pre-built image.
* Added `nano` to pre-built image.

<br>
## Known Bugs and Issues

* The `bytcr5651` audio card in this device has a strange ext-amp (internal speaker) configuration, and it fails to be detected by almost all modern kernels _except_ for k4.18 _(with the use of an additional patch to enable the GPIO pin)_; Hoping to figure out a solution to resolve this on newer kernels but sick of compiling from source with no results, and sticking with 4.18 for now!
* Cameras do not work _(no kernel support)_
	_Note k5.8 has ressurected the [atomisp driver](https://www.phoronix.com/scan.php?page=news_item&px=Linux-5.8-Media-Updates) and camera support **may** be possible in the near future!_
	_Tested a build w/atomisp enabled but camera sensors are failing to power up, still debugging)_
* Bluetooth is partially working but not reliably discovering or connecting to all devices.
* Formatting SD card with Android isn't working _(cannot be used for internal app storage - format with PC for use as portable storage)_.
* Baytrail/Cherrytrail devices suffer from a c-state bug with linux, which can cause issues with freezing or resuming from standby, but this latest build is fairly stable.
* If having issues resuming from suspend/sleep, you can try using `intel_idle.max_state=1` or `i915.enable_execlists=0` boot args in GRUB (`android.cfg`).
* For Netflix support, use version [4.16 build 15172](https://netflixhelp.s3.amazonaws.com/netflix-4.16-15172-release.apk)

<br>
## Notes

* Special thanks to [@cwhuang](https://github.com/cwhuang) and [@youling257](https://github.com/youling257) for their support.
* See [this topic](https://groups.google.com/forum/#!topic/android-x86/KvAhIKcf224) on the [Android-x86 Google Group](https://groups.google.com/forum/#!forum/android-x86) for more information and for further assistance if necessary
