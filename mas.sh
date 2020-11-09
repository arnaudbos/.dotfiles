#!/usr/bin/env bash

source lib_sh/echos.sh
source lib_sh/utils.sh

################################################
bot "Setting up Mac App Store apps"
################################################

bot "Installing >HP Smart<"
download_mac_app "HP Smart"

bot "Installing >MarginNote 3"
download_mac_app "MarginNote 3"

bot "Installing >Notability<"
download_mac_app "Notability"

bot "Installing >GarageBand<"
download_mac_app "GarageBand"

bot "Installing >Xcode<"
download_mac_app "Xcode"

bot "Installing >Pages<"
download_mac_app "Pages"

bot "Installing >Keynote<"
download_mac_app "Keynote"

bot "Installing >Numbers<"
download_mac_app "Numbers"

bot "Installing >Slack<"
download_mac_app "Slack"

filler
filler

botdone
