#!/usr/bin/env bash

################################################
# Haskell
################################################
softcheck=`stat $HOME/.ghcup/env`
if [ $? == 1]; then
  running "Downloading and installing Haskell's ghcup"; filler
  curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
  ok
fi

################################################
# TLA+
################################################
softcheck=`which tlc > /dev/null 2>&1`
if [ $? == 1]; then
  running "Downloading and installing tla-bin"; filler
  git clone https://github.com/pmer/tla-bin.git ~/.tla-bin
  pushd ~/.tla-bin > /dev/null 2>&1
  ./download_or_update_tla.sh
  sudo ./install.sh
  popd > /dev/null 2>&1
  ok
fi

if [[ $OSTYPE == darwin* ]]; then
  ###############################################################################
  bot "Downloading OmniPlan"
  ###############################################################################
  download_app 'OmniPlan' '1HJI4OkHQWnC5-tEEc31OlFNltncN9eSC'
  botdone

  ###############################################################################
  bot "Downloading OmniGraffle"
  ###############################################################################
  download_app 'OmniGraffle' '1eKntPOP-Yl1ExV65f308s1HahWPV7EfW'
  botdone

  ###############################################################################
  bot "Downloading Final Cut Pro X 10.4.8"
  ###############################################################################
  download_app 'Final Cut Pro X 10.4.8' '1MbKfLa8NilJ970ILTrrQhVtIwHcNUWHP'
  botdone

  ###############################################################################
  bot "Downloading Grammarly"
  ###############################################################################
  download_app 'Grammarly' 'https://download-editor.grammarly.com/osx/Grammarly.dmg'
  botdone

  ###############################################################################
  bot "Downloading SizeUp with License"
  ###############################################################################
  download_app 'SizeUp' '1ClbmLG_3k6UDpjPquG8Tl9GzkgJ2UGnf'
  botdone

  ###############################################################################
  bot "Downloading Zotero"
  ###############################################################################
  download_app 'Zotero' '1SRs0PaB7FDh8z4gvFdrqE1xkodcfZZyB'
  botdone
fi

