#! /usr/bin/env bash

unamestr=$(uname)

if [[ "$unamestr" != 'Darwin' ]]; then
  echo "Sorry, this script is only for OS X."
  exit
fi

#Ensure homebrew is installed
brew -v >/dev/null 2>&1 || { echo >&2 "You need to install homebrew first."; exit; }

echo "Updating brew recipes..."
brew update && brew upgrade
echo "Tapping keckcaves.."
brew tap KeckCAVES/keckcaves
echo "installing vrui-examples.."
brew install vrui-examples

#Download the dependencies
echo "Downloading dependencies..."
cd /tmp && curl -O http://idav.ucdavis.edu/~okreylos/ResDev/SARndbox/SARndbox-1.5-001.tar.gz
cd /tmp && curl -O http://idav.ucdavis.edu/~okreylos/ResDev/Kinect/Kinect-2.8-001.tar.gz

echo "Expanding files"
cd /tmp && tar xvf SARndbox-1.5-001.tar.gz
cd /tmp && tar xvf Kinect-2.8-001.tar.gz

# Update make file paths
#VRUI_MAKEDIR to point to actual path
vrui_makedir="\/usr/local\/Cellar\/vrui\/3.1-002-1\/share\/vrui\/make"

sed -i.bu 's/VRUI_MAKEDIR := $(HOME)\/Vrui-3.1\/share\/make/VRUI_MAKEDIR := \/usr\/local\/Cellar\/vrui\/3.1-002-1\/share\/vrui\/make/' /tmp/Kinect-2.8-001/makefile
sed -i.bu 's/VRUI_MAKEDIR := $(HOME)\/Vrui-3.1\/share\/make/VRUI_MAKEDIR := \/usr\/local\/Cellar\/vrui\/3.1-002-1\/share\/vrui\/make/' /tmp/SARndbox-1.5-001/makefile

#VRUI_MAKEDIR := $(HOME)/Vrui-3.1/share/make
#sed -i "s/\$(HOME)\/Vrui-3.1\/share\/make /'VRUI_MAKEDIR := $vrui_makedir/" /tmp/Kinect-2.8-001/makefile

echo "Building Kinect 3D Video Capture"
cd /tmp/Kinect-2.8-001
make && make install

echo "Building SARndbox..."
cd /tmp/SARndbox-1.5-001
make && make install
