#!/usr/bin/env bash

###############################################################################
bot "Configuring General System UI/UX..."
###############################################################################

running "Installing base16 theme for Gnome terminal"
source configs/base16-theme.sh;ok

running "Installing config AND base16 theme for Terminator"
cp ./configs/terminator.config ~/.config/terminator/config;ok
