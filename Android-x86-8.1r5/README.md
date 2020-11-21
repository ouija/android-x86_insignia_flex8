# [Android-x86](https://www.android-x86.org) on the [Insignia Flex 8](https://www.insigniaproducts.com/pdp/NS-P08W7100/5451211)

Android-x86_64 [v8.1r5] running on a Insignia Flex 8 [NS-P08W7100] tablet.

Based off [Kernel 4.18.14](https://osdn.net/projects/android-x86/scm/git/kernel/tree/kernel-4.18/)

Please consider [donating](https://paypal.me/djouija) to support this project. Thanks!


To build from source, follow the instructions at [Android-x86.org](https://www.android-x86.org/source.html) and switch to the 4.18 kernel:

	cd /path/to/android/source/kernel
	git fetch x86 kernel-4.18
	git checkout FETCH_HEAD

## Instructions

* Patch 4.18.14 kernel with all patches in sequential order.
* As of this build, Kernel 4.18 has issues compiling due to missing `./kernel/drivers/net/wireless/broadcom/wl/Makefile`:
	* Edit `./kernel/drivers/net/wireless/broadcom/Makefile` and remove or comment out the line `obj-$(CONFIG_WL)       += wl/`
	* Edit `./kernel/drivers/net/wireless/broadcom/Kconfig` and remove or comment out the line `source "drivers/net/wireless/broadcom/wl/Kconfig"`
* Copy [touchscreen firmware](https://github.com/ouija/android-x86_insignia_flex8/blob/master/02%20%20Other/gsl1680-insignia_flex8.fw) to ./device/generic/firmware/silead/gsl1680-insignia_flex8.fw
* Copy [soundcard state file for alsa](https://github.com/ouija/android-x86_insignia_flex8/blob/master/02%20%20Other/bytcrrt5651.state) to ./device/generic/common/alsa/bytcrrt5651.state
* Build the kernel / iso and install to device
* Once booted in Android, create an /etc/insignia folder and copy all [scripts](https://github.com/ouija/android-x86_insignia_flex8/tree/master/01%20%20Scripts) to this folder
* Replace /system/build.prop with [this file](https://github.com/ouija/android-x86_insignia_flex8/blob/master/02%20%20Other/build.prop)
* Replace /etc/init.sh with [this file](https://github.com/ouija/android-x86_insignia_flex8/blob/master/02%20%20Other/init.sh)
* IMPORTANT: To fully resolve the c-stage bug, it is advised to at "intel_idle.max_state=1 reboot=acpi" kernel command to the grub loader


See [this topic](https://groups.google.com/forum/#!topic/android-x86/KvAhIKcf224) on the [Android-x86 Google Group](https://groups.google.com/forum/#!forum/android-x86) for more information and for further assistance if necessary
