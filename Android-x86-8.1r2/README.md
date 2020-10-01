# [Android-x86](https://www.android-x86.org) on the [Insignia Flex8](https://www.insigniaproducts.com/pdp/NS-P08W7100/5451211)

This repository contains kernel patches, scripts and more that I've utilized to get Android-x86 [v8.1-r2] running on a Insignia Flex8 [NS-P08W7100] tablet.

Based off [Kernel 4.18](https://osdn.net/projects/android-x86/scm/git/kernel/tree/kernel-4.18/)


To build from source, follow the instructions at [Android-x86.org](https://www.android-x86.org/source.html) and switch to the 4.18 kernel:

	cd /path/to/android/source/kernel
	git fetch x86 kernel-4.18
	git checkout FETCH_HEAD

## Instructions

* Patch 4.18 kernel with all patches in sequential order.
* Copy [touchscreen firmware](https://github.com/ouija/android-x86_insignia_flex8/blob/master/02%20%20Other/gsl1680-insignia_flex8.fw) to ./device/generic/firmware/silead/gsl1680-insignia_flex8.fw
* Copy [soundcard state file for alsa](https://github.com/ouija/android-x86_insignia_flex8/blob/master/02%20%20Other/bytcrrt5651.state) to ./device/generic/common/alsa/bytcrrt5651.state
* Build the kernel / iso and install to device
* Once booted in Android, create an /etc/insignia folder and copy all [scripts](https://github.com/ouija/android-x86_insignia_flex8/tree/master/01%20%20Scripts) to this folder
* Replace /system/build.prop with [this file](https://github.com/ouija/android-x86_insignia_flex8/blob/master/02%20%20Other/build.prop)
* Replace /etc/init.sh with [this file](https://github.com/ouija/android-x86_insignia_flex8/blob/master/02%20%20Other/init.sh)
* IMPORTANT: To fully resolve the c-stage bug, it is advised to add "intel_idle.max_state=1 reboot=acpi" kernel command to the grub loader


See [this topic](https://groups.google.com/forum/#!topic/android-x86/KvAhIKcf224) on the [Android-x86 Google Group](https://groups.google.com/forum/#!forum/android-x86) for more information and for further assistance if necessary

--------------------

## Download

Pre-built kernel and modules [here](https://mega.nz/file/2aw3hC7Q#O7emr5t-txQDiho_CN5ELauDoEeg0lZ49xUvHkefYxM)<br>
Create USB Installer based off [Andoid-x86 8.1r1](https://osdn.net/projects/android-x86/releases/69704) and replace kernel and system.sfs with zip contents.
