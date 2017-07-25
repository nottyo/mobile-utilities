#!/bin/bash

export ANDROID_HOME=~/Library/Android/sdk
export PATH=$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$PATH
#AVD_NAME=$(emulator -list-avds)
AVD_NAME=$1
CONSOLE_PORT=$2

function start_avd {
  echo "Starting AVD $1..."
  emulator -avd $AVD_NAME -port $CONSOLE_PORT -no-boot-anim &
  wait_until_booted "getprop dev.bootcomplete" 1
  wait_until_booted "getprop sys.boot_completed" 1
}

function wait_until_booted {
  local boot_property=$1
  local boot_property_test=$2
  local result=$(adb -s emulator-$CONSOLE_PORT shell $boot_property 2>/dev/null | grep "$boot_property_test")
  while [ -z $result ]; do
      sleep 1
      echo "[emulator-$CONSOLE_PORT] Checking $boot_property...  "
      result=$(adb -s emulator-$CONSOLE_PORT shell $boot_property 2>/dev/null | grep "$boot_property_test")
  done
  echo "[emulator-$CONSOLE_PORT] All boot properties successful"
}

function kill_all_avds {
  adb -s emulator-$CONSOLE_PORT emu kill
}

kill_all_avds
start_avd
