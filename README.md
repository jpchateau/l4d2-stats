L4D2 Advanced Stats
===================

*L4D2 Advanced Stats is an add-on for Left 4 Dead 2 which displays better stats at map transitions and end games.*

Features
--------

* Coop and Realism game modes
* Friendly Fire (damage, incapacitated, team kills)
* Damage done and kills of special infected
* Damage done to Tanks and Witches
* Hits from common infected and damage received from special infected
* Configurable by editing the source files

Install
-------

Download the vpk.exe file located in the dist folder.

Copy this file in your L4D2 add-ons folder.

Example on Windows: C:\Program Files (x86)\Steam\SteamApps\common\left 4 dead 2\left4dead2\addons\

Launch the game and activate the add-on if not already activated.

Contributing
------------

Feel free to contribute to this project and open pull requests.

Copy these files in a directory placed into your L4D2 add-ons directory.

Example on Windows: C:\Program Files (x86)\Steam\SteamApps\common\left 4 dead 2\left4dead2\addons\

```bash
git clone git@github.com:RenaudParis/l4d2-stats.git advstats
```

### Usage

Change these settings at your own convenience:

```squirrel
// main.nut

::ADV_STATS_BOTS_DISPLAY <- true 		// Activate the display of bots stats
::ADV_STATS_FF_BOTS_ENABLED <- true 	// Activate FF done to bots
```

### Scripting

http://squirrel-lang.org/doc/squirrel2.html

Bugs
----

* Script's damage to Tanks and Witches does not match game-computed values
* Sometimes the event 'incapacitated' happens after only 4 zombie hits (events) instead of five
* When using a survivor mod (for example, 'Lee' for Coach) the stats do not save for Lee
* When a player uses a bot's name (for instance, "Rochelle"), the stats do not save for bot "(1)Rochelle"

License
-------

Copyright (c) 2015 RenaudParis.
This content is released under [the MIT license](https://github.com/RenaudParis/l4d2-stats/blob/master/LICENSE).