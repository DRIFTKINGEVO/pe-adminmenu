# PE-adminmenu (WIP) [DO NOT USE](https://www.safetysign.com/images/source/large-images/R5332.png)

This is the first full script that I have created. While the code may not be the best, it is something I am proud of. This is a fully working admin menu for esx which uses esx_menu_default instead of Warmenu which caused an incremented ms. I first began working on this because all the other admin menus out there are not "optimized".

## Description

An admin menu created with esx_menu_default that allows gives you admin commands, server commands, and player commands. It also has basic server stuff for RP purposes like deleting weapons from peds, cars, etc.

#### Commands:
/admin To see your rank

## Getting Started

### Dependencies

* T-notify
* el-bwh (optional)

### Installing

* You can either download it or clone it with git.

### How to use in FiveM

* 1) Add ensure pe-adminmenu to the server.cfg
* 2) Place your script in your server.
* 3) Add yourself (steam hex|identifier) to the admin_sv.lua
* 4) Press INSERT to open the menu.

## Issues

If you find any issues with this please make sure to report them.
* [Issues](https://github.com/Project-Entity/pe-adminmenu/issues)
* [Pull Request](https://github.com/Project-Entity/pe-adminmenu/pulls)

## What version are we in?

* 1.0
    * Initial Release
* 1.1
    * Modified discord presence
* 1.2
    * Removed discord presence for efficiency
* 1.3
    * Added locales for es.lua
* 1.4
    * Added webhooks to everything
    * Added armor to the heal action
    * Fixed an issue where godmode was deactivated by noclip
    * Fixed an issue where invisible was deactivated by noclip
    * Fixed clear chat for all
    * Fixed Spanish locale
    * Noclip no longer makes you invencible/invisible. It now has to be activated individually.
    * Optimized a little bit
    * Changed tp to the closest vehicle
    * Changed tpm for optimization.
    * Changed webhook to config.lua
    * Changed opening key to config.lua
* 1.5
    * Added more webhooks
    * New kick system
    * Freeze fixed
    * Noclip with vehicle
    * New locales
    
## Acknowledgments

Thank you for the basic esx_menu
* [esx_policejob](https://github.com/esx-framework/esx_policejob)
