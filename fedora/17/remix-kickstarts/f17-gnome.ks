## f17-gnome.ks

%include f17-common.ks

part / --size 4096

%packages

# Unwanted stuff
-abrt*
-at-*
-caribou*
-deja-dup*
-gnome-games*
-icedtea*
-orca*

@gnome-desktop --nodefaults

### @gnome-desktop defaults 
control-center
notification-daemon
NetworkManager-gnome 
PackageKit-gtk*
avahi    
brasero-nautilus
cheese
eog
evince-nautilus
file-roller-nautilus
gcalctool
gdm
gedit
gnome-backgrounds
gnome-bluetooth
gnome-color-manager
gnome-contacts
gnome-disk-utility
gnome-media
gnome-packagekit
gnome-power-manager
gnome-screensaver
gnome-system-monitor
gnome-terminal
gnome-user-docs
# gnome-utils
gucharmap
gvfs-archive
gvfs-fuse
gvfs-gphoto2
gvfs-smb
ibus
libproxy-mozjs
libsane-hpaio
mousetweaks
nautilus-sendto
policycoreutils-restorecond
pulseaudio-module-gconf
pulseaudio-module-x11
sane-backends-drivers-scanners
seahorse
shotwell                 
simple-scan
sushi
vinagre
vino
xdg-user-dirs-gtk
yelp

### @graphical-internet
firefox
empathy
thunderbird  
transmission-gtk
# evolution
# evolution-NetworkManager  
# evolution-help  

### @sound-and-video
alsa-plugins-pulseaudio
pavucontrol
rhythmbox
totem-mozplugin
totem-nautilus

### Multimedia
ffmpegthumbnailer
gnash-plugin

### Tools
gnome-tweak-tool
gparted

# FIXME; apparently the glibc maintainers dislike this, but it got put into the
# desktop image at some point.  We won't touch this one for now.
nss-mdns

# This one needs to be kicked out of @base
-smartmontools

# The gnome-shell team does not want extensions in the default spin;
# ibus support in gnome-shell will be integrated in GNOME 3.4
-ibus-gnome3

%end

%post
cat >> /etc/rc.d/init.d/livesys << EOF
# disable screensaver locking
cat >> /usr/share/glib-2.0/schemas/org.gnome.desktop.screensaver.gschema.override << FOE
[org.gnome.desktop.screensaver]
lock-enabled=false
FOE

# and hide the lock screen option
cat >> /usr/share/glib-2.0/schemas/org.gnome.desktop.lockdown.gschema.override << FOE
[org.gnome.desktop.lockdown]
disable-lock-screen=true
FOE

# disable updates plugin
cat >> /usr/share/glib-2.0/schemas/org.gnome.settings-daemon.plugins.updates.gschema.override << FOE
[org.gnome.settings-daemon.plugins.updates]
active=false
FOE

# make the installer show up
if [ -f /usr/share/applications/liveinst.desktop ]; then
  # Show harddisk install in shell dash
  sed -i -e 's/NoDisplay=true/NoDisplay=false/' /usr/share/applications/liveinst.desktop ""
  # need to move it to anaconda.desktop to make shell happy
  mv /usr/share/applications/liveinst.desktop /usr/share/applications/anaconda.desktop

  cat > /usr/share/glib-2.0/schemas/org.gnome.shell.remix.gschema.override << FOE
[org.gnome.shell]
favorite-apps=['gnome-tweak-tool.desktop', 'firefox.desktop', 'nautilus.desktop', 'gnome-terminal.desktop', 'anaconda.desktop']
FOE
fi

# rebuild schema cache with any overrides we installed
glib-compile-schemas /usr/share/glib-2.0/schemas

# set up auto-login
cat >> /etc/gdm/custom.conf << FOE
[daemon]
AutomaticLoginEnable=True
AutomaticLogin=liveuser
DefaultSession=gnome.desktop
FOE

# Turn off PackageKit-command-not-found while uninstalled
if [ -f /etc/PackageKit/CommandNotFound.conf ]; then
  sed -i -e 's/^SoftwareSourceSearch=true/SoftwareSourceSearch=false/' /etc/PackageKit/CommandNotFound.conf
fi

EOF

%end


## REMIX gnome

%post

echo -e "\n**********\nPOST GNOME\n**********\n"

# override default gnome settings
cat >> /usr/share/glib-2.0/schemas/org.gnome.remix.gschema.override << GNOME_EOF
[org.gnome.desktop.interface]
font-name='Liberation Sans 10'
document-font-name='Liberation Sans 10'
monospace-font-name='Liberation Mono 10'

[org.gnome.nautilus.desktop]
font='Liberation Sans Bold 9'

[org.gnome.settings-daemon.plugins.updates]
auto-update-type='none'
frequency-get-updates=0
GNOME_EOF

# override default settings
cat > /usr/share/glib-2.0/schemas/org.gnome.shell.remix.gschema.override << EOF
[org.gnome.shell]
favorite-apps=['gnome-tweak-tool.desktop','firefox.desktop', 'nautilus.desktop', 'gnome-terminal.desktop']
EOF

# window title font
gconftool-2 --direct --config-source xml:readwrite:/etc/gconf/gconf.xml.defaults --type string --set /apps/metacity/general/titlebar_font "Liberation Sans Bold 9"

glib-compile-schemas /usr/share/glib-2.0/schemas

%end

%post --nochroot

echo -e "\n**********\nPOST NOCHROOT GNOME\n**********\n"

%end

