module.exports = {
  brew: [
    'ack',
    // Install GNU core utilities (those that come with OS X are outdated)
    // Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
    'coreutils',
    'dos2unix',
    // Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed
    'findutils',
    'fortune',
    //'gawk',
    // http://www.lcdf.org/gifsicle/ (because I'm a gif junky)
    'gifsicle',
    'gnupg',
    // Install GNU `sed`, overwriting the built-in `sed`
    // so we can do "sed -i 's/foo/bar/' file" instead of "sed -i '' 's/foo/bar/' file"
    'gnu-sed --default-names',
    'gzip',
    'make',
    'npm',
    'less',
    'openssh',
    'rsync',
    'unzip',
    // better, more recent grep
    'homebrew/dupes/grep',
    'imagemagick',
    'imagesnap',
    // jq is a sort of JSON grep
    'jq',
    // Install some other useful utilities like `sponge`
    'moreutils',
    'nmap',
    'openconnect',
    'python',
    'leiningen',
    'reattach-to-user-namespace',
    // better/more recent version of screen
    'homebrew/dupes/screen',
    'tmux',
    'tree',
    'ttyrec',
    // better, more recent vim
    'vim --override-system-vi',
    'watch',
    // Install wget with IRI support
    'wget --enable-iri'
  ],
  cask: [
    //'adium',
    //'amazon-cloud-drive',
    'android-studio',
    'atom',
    //'comicbooklover',
    //'diffmerge',
    'flux',
    'cheatsheet',
    'cyberduck',
    'docker',
    'dropbox',
    'google-chrome',
    'google-drive',
    'evernote',
    'gpgtools',
    'graphviz',
    //'ireadfast',
    'intellij-idea-ce',
    'java',
    //'macvim',
    'cinch',
    'sizeup',
    'tuck',
    //'sketchup',
    'radian-player',
    'gitter',
    'slack',
    'skitch',
    'skype',
    'the-unarchiver',
    'pycharm-ce',
    'pocketcast',
    'picasa',
    //'torbrowser',
    //'transmission',
    //'vlc',
    'elmedia-player',
    'thebrain',
    'swi-prolog',
    'vagrant',
    'visual-studio-code',
    'virtualbox',
    'virtualbox-extension-pack',
    'xquartz'
  ],
  gem: [
  ],
  npm: [
    'antic',
    'buzzphrase',
    'bower',
    'bower-check-updates',
    'esformatter',
    'eslint',
    'instant-markdown-d',
    'npm-check',
    'yo',
    'generator-dockerize',
    'gulp',
    'prettyjson',
    'trash',
    'vtop'
  ]
};
