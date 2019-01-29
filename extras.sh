#!/usr/bin/env bash

if [[ $OSTYPE == darwin* ]]; then
  ###############################################################################
  bot "Downloading OmniPlan"
  ###############################################################################
  download_app 'OmniPlan' 1HJI4OkHQWnC5-tEEc31OlFNltncN9eSC
  botdone

  ###############################################################################
  bot "Downloading OmniGraffle"
  ###############################################################################
  download_app 'OmniGraffle' 1eKntPOP-Yl1ExV65f308s1HahWPV7EfW
  botdone

  ###############################################################################
  bot "Downloading Final Cut Pro X"
  ###############################################################################
  download_app 'Final Cut Pro X' 1RNUfXL6342IQ8QGguXcQR3yaSCZq790d
  botdone

  ###############################################################################
  bot "Downloading Compressor"
  ###############################################################################
  download_app 'Compressor' 1jgQ62F8M9zs0immW4RHQs4eROOwcG1jp
  botdone

  ###############################################################################
  bot "Downloading Grammarly"
  ###############################################################################
  download_app 'Grammarly' https://download-editor.grammarly.com/osx/Grammarly.dmg
  botdone

  ###############################################################################
  bot "Downloading SizeUp with License"
  ###############################################################################
  download_app 'SizeUp' 1ClbmLG_3k6UDpjPquG8Tl9GzkgJ2UGnf
  botdone

  ###############################################################################
  bot "Downloading Cursive License"
  ###############################################################################
  running "Downloading Cursive Licence to ~/Downloads"; filler
  pushd ~/Downloads > /dev/null 2>&1
  download 'Cursive License' 1HKXWQImbTUob0TiH1x3oEzqp-BA7Giya
  popd > /dev/null 2>&1
  botdone

  ###############################################################################
  bot "Downloading useless TouchBarNyanCat"
  download_app 'TouchBarNyanCat' 1SL54cb1lCQHM1FsDTVRYMVH-UXgBIwFB
  botdone

  ###############################################################################
  bot "Downloading Zotero"
  download_app 'Zotero' 1SRs0PaB7FDh8z4gvFdrqE1xkodcfZZyB
  botdone
fi

