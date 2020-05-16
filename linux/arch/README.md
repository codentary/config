#### **Pre-install**
##### Set the keyboard layout
```bash
$ ls /usr/share/kbd/keymaps/i386/qwerty/*.map.gz    # List available i386 qwerty layouts
$ loadkeys uk                                       # Default is us, change to uk if needed
```
##### Set the console font
```bash
$ setfont Lat2-Terminus16   # Default one should be fine, change only if needed
```

##### Connect to wifi network
```bash
$ wifi-menu
```
##### Partition disk (create a new GTP partition table and with 1 512M EFI partition and 1 Linux partition with leftover space)
> ```
> Device       Start       End   Sectors  Size Type
> /dev/sda1     2048   1050623   1048576  512M EFI System
> /dev/sda2  1050624 500118158 499067535  238G Linux filesystem
> ```
``` bash
$ lsblk             # List block devices
$ fdisk /dev/sda
```
##### Format partitions
```bash
$ mkfs.fat -F32 /dev/sda1
$ mkfs.ext4 /dev/sda2
```
##### Mount partitions
```bash
$ mount /dev/sda2 /mnt		# Linux partition
$ mkdir /mnt/boot
$ mount /dev/sda1 /mnt/boot	# EFI partition
```
---
#### **Install**
##### Install base packages
```bash
$ pacstrap /mnt base
```
##### Install linux kernel and firmware
```bash
$ pacstrap /mnt linux linux-firmware   # This will put the linux images (vmlinuz and initramfs) in /mnt/boot/
```
##### Add mount commands to fstab to automatically mount on bootup
```bash
$ genfstab -U /mnt >> /mnt/etc/fstab	# This will generate entries both for sda1(/mnt/boot) and sda2(/mnt) as both are mounted on /mnt
```
##### Change root into the new filesystem
```bash
$ arch-chroot /mnt
```
##### Install [bash-completion][11] package to extend the limited tab completion that comes by default with bash
```bash
$ pacman -Sy bash-completion
```

> Alternatively follow the guide [here]
##### Local time
```bash
$ timedatectl                                # Show current time details
$ timedatectl list-timezones                 # List available timezones
$ timedatectl set-timezone Europe/Bucharest  # Set the timezone
```
##### Locale
```bash
$ locale                        # Display current locale
$ localedef --list-archive      # List available locales which have been previously generated
$ edit /etc/locale.gen            # Uncomment en_US.UTF-8 UTF-8 and other needed localizations
$ locale-gen
```
> Set the `LANG` variable in `/etc/locale.conf`
> `LANG=en_US.UTF-8`

##### Persistent keymap
> Set the `KEYMAP` variable in `/etc/vconsole.conf`
> `KEYMAP=uk`

##### Persistent console font
> Set the `FONT` variable in `/etc/vconsole.conf`
> `FONT=Lat2-Terminus16

##### Hostname
> Write your hostname in `/etc/hostname`

##### Set root password
```bash
$ passwd
```

##### Install and enable DHCP
```bash
$ pacman -S dhcpcd
$ systemctl enable dhcpcd.service   # It will start on bootup
$ systemctl start dhcpcd.service    # To start it right away without rebooting
```

##### Install bootloader (sytemd-boot)
```bash
$ bootctl --path=/boot install
```

> *If you have an Intel CPU, install the [intel-ucode][1] package in addition, and enable [microcode updates][2]* 

##### Configure the bootloader   

``` bash
/boot/loader/loader.conf
------------------------
default  arch
timeout  3
editor   0
```

```bash
/boot/loader/entries/arch.conf
------------------------------
title	Arch Linux
linux	/vmlinuz-linux
initrd	/intel-ucode.img        # Remove this line if `intel-ucode` is not installed
initrd	/initramfs-linux.img
options	root=PARTUUID=14422928-2fe3-4df7-f0g2-43f65c618690
```

> You can use `blkid` to get the `PARTUUID`(*make sure that you use `PARTUUID` and not `UUID` as the identifier*)   
`$ blkid -s PARTUUID -o value /dev/sda2`   

> You can use [kms][23] `video` option to specify the screen(console) resolution
```bash
options	root=PARTUUID=14422928-2fe3-4df7-f0g2-43f65c618690 video=1920x1200
```
> In the same way, you can speify per display resolution
```bash
options	root=PARTUUID=14422928-2fe3-4df7-f0g2-43f65c618690 video=eDP-1:1366x768 video=DP-1:1920x1200
```
> Here, **eDP-1** and **DP-1** are the laptop and the external displays
> To see connected displays you can use the folowing shell oneliner or [xrandr][25] from within X
```bash
$ for p in /sys/class/drm/*/status; do con=${p%/status}; echo -n "${con#*/card?-}: "; cat $p; done
```

##### Reboot
---
#### **Post-install**

##### Connect to wifi using the [NetworkManager][3]

###### Install an AUR package manager (yay)
* first install [base-devel][12]
    * `$ sudo pacman -S --needed base-devel`
* search the wanted package on [AUR Web Interface][13]
* download and untar that package or clone the corresponding AUR git repo
* from within the package folder run
    * `$ makepkg -si`   # -s (install dependencies) and -i (install the package on succesfull build)

##### Install [neovim][6] and replace `vi` and `vim` with `nvim` 
```bash
$ pacman -Sy neovim                 # Install nvim if not present
$ yay -Sy neovim-symlink            # Will replace vi and vim with nvim (symbolik link handeling also dependencies)
```

##### User config
```bash
$ pacman -Syu sudo                  # Install sudo
$ useradd -m -s /bin/bash user      # Add your standard user
$ passwd user                       # Set a password
$ visudo -f /etc/sudoers.d/user     # Add `user ALL=(ALL) ALL`
$ su user                           # Switch to standard user
$ passwd -l root                    # Disable root login
```

##### Switch to zsh
* install [zsh][35] and [oh-my-zsh][36]
```bash
$ chsh -l                           # List available shells
$ chsh -s /absolute/path/to/zsh     # Set zsh as default shell
```

##### Gnome
```bash
$ pacman -Sy mu tter gnome-shell gnome-terminal gnome-control-center  # Minimal
$ pacman -Sy gdm gnome-color-manager gnome-tweaks gnome-backgrounds gnome-system-monitor # Extra
```
> Check the wiki [wayland section][41] for how to start itmanually or automatically on login

##### Headless vnc server setup
> Install and configure [TigerVNC][40]

##### i3
* install [xorg-server][9], [xorg-xinit][8] and [i3][7]
* copy the default xinitrc(`/etc/X11/xinit/xinitrc`) to your home folder(`~/.xinitrc`) and edit it to start i3 or use the ready one [here][10]
* install [dmenu][18]
* install [rxvt-unicode][19]
* use `startx` to start the x server and the window manager
* see [Xresources][17] for additional configuration options and you can use `.Xresources` file [here][17]
    * install some fonts
        * `$ pacaur -S otf-hermit ttf-font-awesome`
    * use [CharacterMap][37] to annalyze fonts
    * install [xcursor-vanilla-dmz-aa][22]
    * install [xcursor-themes][21]

##### Multiple displays ([multhead][24])
* X configuration examples
    * list current connected displays and corresponding info
        * `S xrandr -q`
    * manual configuration (using [xrandr][25])
        * set the displays at the prefered resolution with eDP-1 to the left of DP-1
            * `$ xrandr --output eDP-1 --auto --output DP-1 --auto --right-of eDP-1`
        * set DP-1 to the prefered resolution and turn eDP-1 (laptop embeded display port in this case) off
            * `$ xrandr --output DP-1 --auto --output eDP-1 --off`
        * set eDP-1 to specific resolution, and DP-1 to it's left with prefered resolution
            * `$ xrandr --output eDP-1 --mode 1366x768 --output DP-1 --auto --left-of eDP-1`
    * static xorg configuration ([10-monitor.conf][26])
        * `$ cp 10-monitor.conf /usr/share/X11/xorg.conf.d/`
    * check the state when X starts by calling [toogle-display.sh][27] from [.xinitrc][10] (prefered method)
        * this will turn on only the external display if connected, else only the laptop display

##### Sound ([alsa][29])
Install [alsa-utils][28] and reboot
Changeing the volume
```bash
$ aplay -l                      # List sound card to get the ID of your analog card
$ amixer -c 1 set Master 5%+    # Using the card ID, increase the volume by 5%
```

##### GTK
Install [LXAppearance][30] and a few [themes][31] from which to chose
```bash
$ pacman -S lxappearance
$ pacaur -S vertex-themes
```

##### QT (4) [themes][32]
```bash
$ pacaur -S adwaita-qt4     # use qtconfig-qt4 to set adwaita theme (not dark as bcompare looks bad)
```

##### QT (5) [themes][33]
```bash
$ pacaur -S adwaita-qt5     # use qt5ct (export QT_QPA_PLATFORMTHEME="qt5ct") to set adwaita theme
```

##### SMB 
* Client
    * install [cifs-utils][38] / [smbclient][39]
    * list available SMB shares
        * `$ smbtree`
    * mount SMB share as guest
        * manual: `$ sudo mount --types=cifs //server/partition /mount/point -o guest,uid=UID,gid=GID`
        * fstab: `//server/partition /mount/point cifs nofail,noauto,x-systemd.automount,x-systemd.requires=network-online.target,x-systemd.device-timeout=10,guest,uid=UID,gid=GID`
 
##### Misc
* Disable laptop display
    *  `$ vbetool dpms off` # Or use the systemd [service][34]
*  Disable sleep on lid closed
    *  edit `/etc/systemd/logind.conf` to have `HandleLidSwitch=ignore`

[1]: https://www.archlinux.org/packages/?name=intel-ucode
[2]: https://wiki.archlinux.org/index.php/Microcode#Enabling_Intel_microcode_updates
[3]: https://wiki.archlinux.org/index.php/NetworkManager
[6]: https://wiki.archlinux.org/index.php/Neovim
[7]: https://www.archlinux.org/groups/x86_64/i3/
[8]: https://www.archlinux.org/packages/?name=xorg-xinit
[9]: https://www.archlinux.org/packages/?name=xorg-server
[10]: https://github.com/codentary/config/blob/master/linux/home/.xinitrc
[11]: https://www.archlinux.org/packages/?name=bash-completion
[12]: https://www.archlinux.org/groups/x86_64/base-devel/
[13]: https://aur.archlinux.org/
[16]: https://aur.archlinux.org/packages/yay/
[17]: https://github.com/codentary/config/blob/master/linux/home/.Xresources
[18]: https://www.archlinux.org/packages/?name=dmenu
[19]: https://www.archlinux.org/packages/?name=rxvt-unicode
[21]: https://www.archlinux.org/packages/extra/any/xcursor-themes/
[22]: https://www.archlinux.org/packages/community/any/xcursor-vanilla-dmz-aa/
[23]: https://wiki.archlinux.org/index.php/Kernel_mode_setting
[24]: https://wiki.archlinux.org/index.php/multihead
[25]: https://wiki.archlinux.org/index.php/xrandr
[26]: https://github.com/codentary/config/blob/master/linux/X/10-monitor.conf
[27]: https://github.com/codentary/config/blob/master/linux/X/toogle-display.sh
[28]: https://www.archlinux.org/packages/?name=alsa-utils
[29]: https://wiki.archlinux.org/index.php/Advanced_Linux_Sound_Architecture#ALSA_Utilities
[30]: http://wiki.lxde.org/en/LXAppearance
[31]: https://wiki.archlinux.org/index.php/GTK%2B#Themes
[32]: https://wiki.archlinux.org/index.php/qt#Qt4
[33]: https://wiki.archlinux.org/index.php/qt#Qt5
[34]: https://github.com/codentary/config/blob/master/linux/arch/disable-display.service
[35]: https://www.archlinux.org/packages/?name=zsh
[36]: https://github.com/robbyrussell/oh-my-zsh
[37]: http://bluejamesbond.github.io/CharacterMap/
[38]: https://www.archlinux.org/packages/?name=smbclient 
[39]: https://www.archlinux.org/packages/?name=cifs-utils
[40]: https://wiki.archlinux.org/index.php/TigerVNC
[41]: https://wiki.archlinux.org/index.php/GNOME#Wayland_sessions