#!/usr/bin/env bash

# nvm
require_nvm 4.4.4

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

###############################################################################
bot "Not Downloading Microsoft Office"
###############################################################################
#download_app 'Microsoft Office' https://
botdone

###############################################################################
bot "Downloading OmniGraffle"
###############################################################################
download_app 'OmniGraffle' https://www.dropbox.com/s/4vsywp1g981hu9s/OmniGraffle%207.2.2.zip?dl=0
botdone

###############################################################################
bot "Downloading OmniPlan"
###############################################################################
download_app 'OmniPlan' https://www.dropbox.com/s/6a5k1wng3l15l1z/OmniPlan%20Pro%203.5.1.zip?dl=0
botdone

###############################################################################
bot "Downloading Fantastical"
###############################################################################
download_app 'Fantastical' https://www.dropbox.com/s/musjgt6y9v2liws/Fantastical%202.2.1.zip?dl=0
botdone

###############################################################################
bot "Downloading Geogebra"
###############################################################################
download 'Geogebra' https://www.dropbox.com/s/kegkbggym9g5pap/geogebra_5-0-309-0_en_228222.zip?dl=0
botdone

