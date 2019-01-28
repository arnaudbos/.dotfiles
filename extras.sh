#!/usr/bin/env bash

#####################################
# Now we can switch to node.js mode
# for better maintainability and
# easier configuration via
# JSON files and inquirer prompts
#####################################

bot "installing npm tools needed to run this project..."
npm install
ok

bot "installing packages from config.js..."
node index.js
ok

if [[ $OSTYPE == darwin* ]]; then
  ###############################################################################
  bot "Downloading OmniPlan"
  ###############################################################################
  #download_app 'OmniPlan' TODO
  botdone
  
  ###############################################################################
  bot "Downloading OmniGraffle"
  ###############################################################################
  #download_app 'OmniGraffle' TODO
  botdone
  
  ###############################################################################
  bot "Downloading Final Cut Pro X"
  ###############################################################################
  #download_app 'Final Cut Pro X' TODO
  botdone
  
  ###############################################################################
  bot "Downloading Compressor"
  ###############################################################################
  #download_app 'Compressor' TODO
  botdone
  
  ###############################################################################
  bot "Downloading Grammarly"
  ###############################################################################
  #download_app 'Grammarly' TODO
  botdone
  
  ###############################################################################
  bot "Downloading SizeUp License"
  ###############################################################################
  #download TODO
  #open TODO
  botdone
  
  ###############################################################################
  bot "Downloading Cursive License"
  ###############################################################################
  #download TODO
  #open TODO
  botdone
fi

