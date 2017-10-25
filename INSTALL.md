# INSTALL
## pre-requisites
Have at least following versions installed:
* Flightgear >= 2017.3.0

## Install using zip
[Download](https://github.com/it0uchpods/IDG-A32X/archive/master.zip) the zip file.  
Change to the download directory and do `unzip IDG-A32X-master.zip` or use your prefered graphical tool to unpack the .zip file.  
Move the unpacked directory to the Aircraft directory. Depending on your System it's located in diffrence places:  
* Windows `<Flightgear install directory>\data\Aircraft\`
* Linux
  * `~/.fgfs/Aircraft/` (The `.fgfs` directory is created when runing Flightgear the first time)
  * `/usr/share/games/flightgear/Aircraft/` (This path maybe diffrent on diffrent distributions or on builds from source. Works for Debian/Ubuntu)

Rename the directory to `IDG-A32X`.
Make sure that the `IDG-A32X` directory does not contain another one (this can happen with winrar). If so, move the inner `IDG-A32X` directory outside

To update, delete the `IDG-A32X` directory and install the latest version.

## Install using git
Change to the Aircraft directory. Depending on your System it's located in diffrence places:  
* Windows `<Flightgear install directory>\data\Aircraft\`
* Linux 
  * `~/.fgfs/Aircraft/` (The `.fgfs` directory is created when runing Flightgear the first time)
  * `/usr/share/games/flightgear/Aircraft/` (This path maybe diffrent on diffrent distributions or on builds from source. Works for Debian/Ubuntu)
  
  
Clone the repository with `git clone https://github.com/it0uchpods/IDG-A32X.git`

To update just run `git pull` in the `IDG-A32X` directory.
