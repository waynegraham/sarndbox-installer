#! /usr/bin/env bash

ESC_SEQ="\x1b["
COL_RESET=$ESC_SEQ"39;49;00m"
COL_RED=$ESC_SEQ"31;01m"
COL_GREEN=$ESC_SEQ"32;01m"
COL_YELLOW=$ESC_SEQ"33;01m"
COL_BLUE=$ESC_SEQ"34;01m"
COL_MAGENTA=$ESC_SEQ"35;01m"
COL_CYAN=$ESC_SEQ"36;01m"

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
# VRUI_MAKEDIR to point to actual path
sed -i.bu 's/VRUI_MAKEDIR := $(HOME)\/Vrui-3.1\/share\/make/VRUI_MAKEDIR := \/usr\/local\/Cellar\/vrui\/3.1-002-1\/share\/vrui\/make/' /tmp/Kinect-2.8-001/makefile
sed -i.bu 's/VRUI_MAKEDIR := $(HOME)\/Vrui-3.1\/share\/make/VRUI_MAKEDIR := \/usr\/local\/Cellar\/vrui\/3.1-002-1\/share\/vrui\/make/' /tmp/SARndbox-1.5-001/makefile


NUM_CPUS=$(sysctl -n hw.ncpu)

echo "Building Kinect 3D Video Capture with $NUM_CPUS CPUs"
cd /tmp/Kinect-2.8-001
make -j$NUM_CPUS&& make install

echo "Building SARndbox with $NUM_CPUS CPUs"
cd /tmp/SARndbox-1.5-001
make -j$NUM_CPUS && make install

echo "Moving files to ~/bin"
mkdir -p ~/bin
cd /tmp/SARndbox-1.5-001/bin
chmod +x /tmp/SARndbox-1.5-001/bin
mv * ~/bin

echo "Make sure ~/bin is in your PATH"
echo 'export PATH=~/bin:$PATH'
