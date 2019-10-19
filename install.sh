#!/bin/bash

## Structure
# **nvidia-xrun** - uses following dir structure:
# **/usr/bin/nvidia-xrun** - the executable script
# **/etc/X11/nvidia-xorg.conf** - the main X confing file
# **/etc/X11/xinit/nvidia-xinitrc** - xinitrc config file. Contains the setting of provider output source
# **/etc/X11/xinit/nvidia-xinitrc.d** - custom xinitrc scripts directory
# **/etc/X11/nvidia-xorg.conf.d** - custom X config directory
# **/etc/systemd/system/nvidia-xrun-pm.service** systemd service
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
nxr_initd=/etc/init.d
nxr_default=/etc/default
xsession_dir=/usr/share/xsessions
nxr_bin=/usr/bin
nxo_conf=$X11
x11_xinitrc=$X11/xinit
local_d='.'

if [ $flag -eq 0 ]; then
if [ ! -d $X11/xinit/nvidia-xinitrc.d ]; then
	mkdir $X11/xinit/nvidia-xinitrc.d
	echo "mkdir $X11/xinit/nvidia-xinitrc.d/"
fi
if [ ! -d $X11/nvidia-xorg.conf.d ]; then
	mkdir $X11/nvidia-xorg.conf.d
	echo "mkdir $X11/nvidia-xorg.conf.d/"
fi

cp $local_d/nvidia-xrun-pm $nxr_initd && echo "cp $local_d/nvidia-xrun-pm $nxr_initd"
cp $local_d/config/nvidia-xrun $nxr_default && echo "cp $local_d/config/nvidia-xrun $nxr_default"
cp $local_d/launchers/nvidia-xrun-openbox.desktop $xsession_dir && echo "cp $local_d/launchers/nvidia-xrun-openbox.desktop $xsession_dir"
cp $local_d/launchers/nvidia-xrun-plasma.desktop $xsession_dir && echo "cp $local_d/launchers/nvidia-xrun-plasma.desktop $xsession_dir"
cp $local_d/nvidia-xrun  $nxr_bin && echo "cp $local_d/nvidia-xrun $nxr_bin"
cp $local_d/nvidia-xorg.conf $X11 && echo "cp $local_d/nvidia-xorg.conf $X11"
cp $local_d/nvidia-xinitrc $x11_xinitrc && echo "cp $local_d/nvidia-xinitrc $x11_xinitrc"

	[ ! $? -eq 0 ] && echo -e "requires root privileges" && exit 1
	exit 0
fi

[ ! $flag -eq 1 ] && exit

all+="$nxr_initd/nvidia-xrun-pm "
all+="$nxr_default/nvidia-xrun "
all+="$xsession_dir/nvidia-xrun-openbox.desktop "
all+="$xsession_dir/nvidia-xrun-plasma.desktop "
all+="$nxr_bin/nvidia-xrun "
all+="$X11/nvidia-xorg.conf "
all+="$x11_xinitrc/nvidia-xinitrc "

for i in $all; do
	echo -ne "rm $i"
	if [ -f $i ]; then
		rm $i
		echo -e "\e[${COLUMNS}C ok"
	else
		echo -e "\e[${COLUMNS}C file does not exist"
	fi
done

[ ! $EUID -eq 0 ] && echo -e "requires root privileges" && exit 1

exit 0
