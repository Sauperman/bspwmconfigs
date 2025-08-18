# ARCH-LINUX-BSPWM-MINIMAL-DESKTOP
#==============#
# DEPENDENCIES #
#==============#
.
sudo pacman -S bspwm sxhkd polybar xterm picom rofi kitty scrot nm-connection-editor brightnessctl pamixer ffmpeg xorg-server xorg-xinit xorg-xrandr xf86-video-intel xorg-server xorg-apps xorg-xinit xorg-xkill xorg-xset xorg-xrandr xorg-xrdb xorg-xprop libqalculate intel-gpu-tools ffmpeg mpv xf86-video-fbdev xorg-xbacklight dmenu

#YAY
.
git clone https://aur.archlinux.org/yay.git ~/yay
cd ~/yay
makepkg -si --noconfirm

#YAY dependencies
.
yay -S wlogout nm-applet ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-mono xwinwrap-git
.

#==============#
#     AFTER    #
#==============#

sudo chmod +x .config/bspwm/bspwmrc
sudo chmod +x .config/sxhkd/sxhkdrc
.
win + t = terminal
.
for wifi you use
.
nmtui, nm-connection-editor on polybar

Keybinds are in .config/sxhkd/sxhkdrc

and copy the .Xresources and .Bashrc into /home
#=====================#
# EXTRA               #
#=====================#

#gaming
#user linux-zen kernel or linux-xanmod

sudo pacman -S linux-zen linux-zen-headers
yay -S linux-xanmod linux-xanmod-headers

#load kernel
sudo grub-mkconfig -o /boot/grub/grub.cfg

#dependencies
pacman -S chromium git steam gamemode mangohud wine-staging gamemode gamescope

#pipewire audio
sudo pacman -S pipewire pipewire-pulse pipewire-alsa wireplumber
systemctl --user enable --now pipewire pipewire-pulse wireplumber
