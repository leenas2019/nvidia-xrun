#!/bin/bash

## Structure
# **nvidia-xrun** - uses following dir structure:
# **/usr/bin/nvidia-xrun** - the executable script
# **/etc/X11/nvidia-xorg.conf** - the main X confing file
# **/etc/X11/xinit/nvidia-xinitrc** - xinitrc config file. Contains the setting of provider output source
# **/etc/X11/xinit/nvidia-xinitrc.d** - custom xinitrc scripts directory
# **/etc/X11/nvidia-xorg.conf.d** - custom X config directory
# **/etc/init.d/nvidia-xrun-pm** systemd service
# **/etc/default/nvidia-xrun** - nvidia-xrun config file
# **/usr/share/xsessions/nvidia-xrun-openbox.desktop** - xsession file for openbox
# **/usr/share/xsessions/nvidia-xrun-plasma.desktop** - xsession file for plasma
# **[OPTIONAL] $XDG_CONFIG_HOME/X11/nvidia-xinitrc** - user-level custom xinit script file. You can put here your favourite window manager for example
case $1 in
	install) flag=0
		echo install
	;;
	remove) flag=1
		echo remove
	;;
	*) echo -e "help:\n\tinstall | remove\n"
		exit 1
	;;
esac

X11="/etc/X11"
local_d=$(dirname $0)

if [ $flag -eq 0 ]; then
if [ ! -d $X11/xinit/nvidia-xinitrc.d ]; then
	mkdir -v $X11/xinit/nvidia-xinitrc.d
fi
if [ ! -d $X11/nvidia-xorg.conf.d ]; then
	mkdir -v $X11/nvidia-xorg.conf.d
fi

cp -v $local_d/nvidia-xrun-pm /etc/init.d
cp -v $local_d/config/nvidia-xrun /etc/default
cp -v $local_d/launchers/nvidia-xrun-openbox.desktop /usr/share/xsessions
cp -v $local_d/launchers/nvidia-xrun-plasma.desktop /usr/share/xsessions
cp -v $local_d/nvidia-xrun /usr/bin
cp -v $local_d/nvidia-xorg.conf $X11
cp -v $local_d/nvidia-xinitrc $X11/xinit

	[ ! $? -eq 0 ] && echo -e "requires root privileges" && exit 1
	exit 0
fi

[ ! $flag -eq 1 ] && exit

all+="/etc/init.d/nvidia-xrun-pm "
all+="/etc/default/nvidia-xrun "
all+="/usr/share/xsessions/nvidia-xrun-openbox.desktop "
all+="/usr/share/xsessions/nvidia-xrun-plasma.desktop "
all+="/usr/bin/nvidia-xrun "
all+="$X11/nvidia-xorg.conf "
all+="$X11/xinit/nvidia-xinitrc "

for i in $all; do
	rm -v $i
done

[ ! $EUID -eq 0 ] && echo -e "requires root privileges" && exit 1

exit 0
