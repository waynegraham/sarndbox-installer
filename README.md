# SARndbox Installer Script

This script wraps the building of
[SARndbox](https://github.com/KeckCAVES/SARndbox) and its depedencies. The one
thing it does not The one dependency it does not install is
[xquartz](http://xquartz.macosforge.org/landing/). You can install this
via the disk image, or via Homebrew
[Cask](https://github.com/caskroom/homebrew-cask).

If you go the Cask route, you'll need to run these lines:

```
$ brew install caskroom/cask/brew-cask
$ brew install xquartz
```

## Installing

You'll just need to run the `installer.sh` script.

```
$ sh installer.sh
```

This **should** walk
you through everything that's going on on the system, including
dowloading the source files, patching the `makefile` and moving the
files to you `~/bin` directory.

## Post-install
To run SARndbox, execute the programs in `~/bin/`

```
$ ~/bin/CalibrateProjector
$ ~/bin/SARndbox [options]
```

## Adding to PATH

In the terminal, either set this for the session with:

```
$ export PATH=~/bin:$PATH
```

Or you can make it perminate by adding this to you `~/.bash_profile`

```
$ echo "PATH=~/bin:$PATH" >> ~/.bash_profile
$ source ~/.bash_profile
```

