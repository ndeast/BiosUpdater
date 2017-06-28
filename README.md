## Synopsis

A small powershell script I wrote to automate the installation of Dell Bios upgraders.

## Motivation

I needed to update the bios on some 500 Dell Optiplex PCs of varying models. Wrote this to try and save some time, and to get some more experience in Powershell.

## Installation

To get things working you will need to download the needed bios files from Dells Support website and place them in the BiosFiles folder. Then just run InstallBios.ps1.

Currently supported are the Dell Optiplex 7040, 990, 9020, and 9010. There are probably more models that this would work with, and it is easy enough to add them as extra conditions in the script.

As additional options you can have the script delete itself from your system (doesn't yet delete the folder or the in use bios file) by uncommenting the deleteYourself function call.

You can also hardcode in your bios password if you are using this in an environment that you are comfortable with that.

## License

MIT license
