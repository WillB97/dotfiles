#!/bin/bash
chown root:wheel /sys/devices/platform/thinkpad_acpi/bluetooth_enable
chmod g+w /sys/devices/platform/thinkpad_acpi/bluetooth_enable

# ls -l /sys/devices/platform/thinkpad_acpi/bluetooth_enable
# -rw-r--r-- 1 root wheel 4096 Jan  5 10:41 /sys/devices/platform/thinkpad_acpi/bluetooth_enable

