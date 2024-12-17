# Changing mouse accel on wayland

Libinput is used on wayland to change input settings. 
Install libinput-tools if the `libinput` command is missing. 

## List devices

`libinput list-devices`

Then find your device in the list. My mouse looks like this: 

```
Device:           Razer Razer Viper
Kernel:           /dev/input/event21
Group:            6
Seat:             seat0, default
Capabilities:     pointer 
Tap-to-click:     n/a
Tap-and-drag:     n/a
Tap drag lock:    n/a
Left-handed:      disabled
Nat.scrolling:    disabled
Middle emulation: disabled
Calibration:      n/a
Scroll methods:   button
Click methods:    none
Disable-w-typing: n/a
Disable-w-trackpointing: n/a
Accel profiles:   flat *adaptive
Rotation:         n/a
```

The libinput command output might not update when settings are changed, but udevadm does: `udevadm info /dev/input/event21`. Run that command to verify your changes later.

## Config

Create a file `/etc/udev/rules.d/90-input-custom.rules` with this content to change mouse accel for the device: 

```
# Disable acceleration for the mouse
ATTRS{name}=="Razer Razer Viper", ATTR{capabilities/pointer}=="1", ENV{LIBINPUT_ACCEL_PROFILE}="flat"
```

If you want it back (why?), change "flat" to "adaptive". 

## Confirm the changes

```
sudo udevadm control --reload-rules
sudo udevadm trigger
```

That's it!
