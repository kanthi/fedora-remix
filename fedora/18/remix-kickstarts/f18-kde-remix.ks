## f18-kde-remix.ks

%include f18-kde-desktop.ks
%include f18-base-remix.ks

part / --size 4096 --fstype ext4

%packages

# Unwanted stuff
-libreoffice-kde

# Graphics
digikam
# kamera
kamoso
kdegraphics-thumbnailers
kwebkitpart
sane-backends-drivers-scanners
skanlite

# Internet
icedtea-web
kde-plasma-ktorrent
pidgin

# Multimedia
# amarok
clementine
gnash-plugin
k3b
k3b-extras-freeworld
kffmpegthumbnailer
kscd
vlc
npapi-vlc

# Office
libreoffice
libreoffice-langpack-it

# Settings
kde-print-manager

%end


%post

echo ""
echo "**************"
echo "POST KDE REMIX"
echo "**************"

# Default apps: vlc (instead of dragonplayer)
grep kde4-dragonplayer.desktop /usr/share/kde-settings/kde-profile/default/share/applications/defaults.list \
	| sed 's/kde4-dragonplayer.desktop/vlc.desktop/g' >> /usr/local/share/applications/mimeapps.list

%end
