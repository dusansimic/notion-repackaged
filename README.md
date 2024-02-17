# Repackaged Notion for Linux

> [!WARNING]
> Not meant for general public just yet. The installation experience needs to be
> polished so please be patient.

This repository is forked from the [notion-enhancer](https://github.com/notion-enhancer/notion-repackaged)
project. All the credit for original repackaging scripts and the heavy lifting
done for making this possible goes to them.

Also, current repackaging scripts are based on the process defined in the AUR
package [notion-app-electron](https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=notion-app-electron)
so all the credits for patching Notion to work goes to them.

I've created this repo so I could automate packaging of the latest version of
Notion and later use it to make standalone packages for various distributions.

## Provided packages

There are two types of packages which are built.

1. The plain one which is essentially just a patched version of Notion to work
   on Linux.
2. One with Electron bundled in, so there are no other parts needed for the for
   the installation of the app.

You can use the [install](./tools/install) to install the app on your machine.

Go to the [release page](https://github.com/dusansimic/notion-repackaged/releases)
to see all available packages.
