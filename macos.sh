#!/bin/bash

# check if a command/package is installed
is_installed() 
{
  CMD=$1
  command -v $CMD 1>/dev/null || brew ls --versions $CMD
}


is_installed curl || { echo >&2 "curl is not installed, cannot conitunue"; exit 1; }

# install Homebrew
is_installed brew || {
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # FIXME - profile file
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/izimbra/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
}

# update Homebrew
brew update -q

# install Homebrew formulas
# TODO curl formulae.txt from GH
while read FORMULA; do
  is_installed $FORMULA || brew install $FORMULA
done < formulae.txt

# install Homebrew casks
# TODO curl casks.txt from GH
while read CASK; do
  is_installed $CASK || brew install --cask $CASK
done < casks.txt

