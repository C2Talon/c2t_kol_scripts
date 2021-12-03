# Summary
Small, single-purpose, stand-alone KoLmafia scripts written in ASH. Some were their own projects for a time, but now are consolidated here for simplicity sake.

Can be installed via the KoLmafia CLI:
* `svn checkout https://github.com/c2talon/c2t_kol_scripts/branches/master/kolmafia/`

### Table of Contents
* [c2t_advent](#c2t_advent)
* [c2t_capeMe](#c2t_capeme)
* [c2t_cartographyHunt](#c2t_cartographyhunt)
* [c2t_cast](#c2t_cast)
* [c2t_coldCabinetTracker](#c2t_coldcabinettracker)
* [c2t_harvest_battery](#c2t_harvest_battery)
* [c2t_lprom](#c2t_lprom)
* [c2t_mapgrim](#c2t_mapgrim)
* [c2t_shrugall](#c2t_shrugall)
* [c2t_stacheTracker](#c2t_stachetracker)


## c2t_advent

Meant to be added to a breakfast script, or something similar, to automatically acquire things from the advent calendar and factory during crimbo.

## c2t_capeMe

Kolmafia script that is a wrapper for the CLI command `retrocape` to have arguments that have meaning.

### Usage

Can be used with the CLI via:
`c2t_capeme <mus | res | lifesteal | undead | mys | stun | yr | lantern | mox | delevel | sleaze | crit gun>`
* The following 4 are "muscle" capes, which always grant +30% muscle and +50 HP:
  * `mus` will set the cape to also give 3 extra muscle stats at the end of combat
  * `res` will set the cape to also give +3 to all resistances
  * `lifesteal` will grant a skill that steals life from the enemy
  * `undead` will grant a skill that instantly kills undead monsters if wielding a sword
* The following 4 are "mysticality" capes, which always grant +30% mysticality and +50 MP:
  * `mys` will set the cape to also give 3 extra mysticality stats at the end of combat
  * `stun` will automatically stun an enemy at the start of combat
  * `yr` will grant a skill that acts as a yellow ray which gives 100 turns of "everything looks yellow" on use
  * `lantern` spells will deal spooky damage in addition to what they already do
* The following 4 are "moxie" capes, which always grant +30% moxie and +25 to both HP and MP:
  * `mox` will set the cape to also give 3 extra moxie stats at the end of combat
  * `delevel` will grant a skill that delevels enemies 10%, or constructs 20%
  * `sleaze` will grant a skill that deals sleaze damage
  * `crit gun` will grant a skill that auto-crits if wielding a gun

## c2t_cartographyHunt

Kolmafia function to handle the choice adventure from the Map the Monsters skill, leaving the player in the combat.

### Usage

`import` this script to use its function to handle the choice adventure for the Map the Monsters skill. This will leave the player in the combat with the desired monster if all goes well.

`boolean c2t_cartographyHunt(location loc,monster mon)`
* `loc` must be a valid location
* `mon` must be a valid monster
* returns whether combat was entered after the correct non-combat adventure or not
* will automatically use the Map the Monsters skill if needed
* aborts in the non-combat adventure if the `loc` and `mon` pair is invalid
* aborts if something other than correct non-combat adventure is encountered, such as a wanderer or superlikely

## c2t_cast

Kolmafia script to multi-cast blood spells or cheat codes, or to burn all health on blood spells or burn all charges on the Powerful Glove on a cheat code. This script is the successor to `c2t_burn`.

This script basically makes equivalents to the `cast` command on the CLI and the `use_skill()` function in ASH, but for skills that don't behave the same as most other skills with those methods. For example, normally those methods don't allow the multi-casting of powerful gloves skills. This script handles that. Another example is you can't `cast * blood bubble` normally, but you can `c2t_cast * blood bubble`.

List of skills supported:
* Blood Bond
* Blood Bubble
* Blood Frenzy
* CHEAT CODE: Invisible Avatar
* CHEAT CODE: Triple Size

### Usage

#### CLI

Can be used with the CLI via:
`c2t_cast [casts] <bubble | bond | frenzy | triple | invisible | invis>`
* `casts` is optional, and indicates how many times to use the skill. Without it, the script assumes to cast only once.
* `bubble` will cast Blood Bubble using health
* `bond` will cast Blood Bond using health
* `frenzy` will cast Blood Frenzy using health
* `triple` will cast Triple Size using Powerful Glove charges
* `invisible` or `invis` will cast Invisible Avatar using Powerful Glove charges

#### Functions

Functions within can be called via another script when `import`ed. Each of these will return `true` if it cast something at least 1 time.

`boolean c2t_burn(skill spell)`
* This is for max-casting a blood spell or cheat code, where `spell` is the skill to use. Ex: `c2t_burn($skill[Blood Bubble])`

`boolean c2t_cast(int num,skill spell)`
* This is for multi-casting a blood spell or cheat code, where `spell` is the skill to use and `num` is the times to use it. Ex: `c2t_cast(2,$skill[CHEAT CODE: Triple Size])`

## c2t_coldCabinetTracker

Simply gets the list of items offered by the cold medicine cabinet and puts them into the property `c2t_coldCabinetItems`.

`c2t_coldCabinetItems` is arraged based on the choice order in the adventure. Example:
* "ice crown,frozen tofu pop,Doc's Fortifying Wine,anti-odor cream,Fleshazole&trade;"

### Usage

Can be used on the CLI to update the property if the cabinet has items listed.

If `imported` into a script, the following function can be used to update the property:
* `void c2t_coldCabinetTracker(boolean autoExit)`
  * `autoExit` is optional, but will default to `true`
    * if `autoExit` is `true`, the choice adventure will be exited automatically at the end of the function
    * if `autoExit` is `false`, the function will leave you in the choice adventure and you will have to exit it yourself. In this way, you can select an item from the options once the property is updated to grab a specific item once it is availabe without having to reenter the choice adventure, for example.


## c2t_harvest_battery

Simply harvests batteries from the power plant.

## c2t_lprom

Kolmafia script to fully and automatically use the warbear LP-ROM to make all the recordings. It uses magical sausages as fuel, but can also use mafia's built-in method for MP recovery (untested). Only works for accordion thiefs with their ability to make 20-turn recordings. 10-turn recordings by other classes are not supported with this.

### Prerequisites

Make sure to have enough sausages pre-made to recover all the MP needed to cover the costs of the recordings if planning to use sausages, otherwise things may break. Also, wearing gear that increases maximum MP makes things easier and quicker. It takes 6750 MP by default to make the maximimum amount of recordings of all the recordable skills, so plan accordingly. Of course, simply having more than 6750 MP on hand will work as well.

### Usage

First, `import` the function into a script. The following function will be available:

`boolean c2t_lprom(boolean sausageMode)`
* `sausageMode` is optional and determines whether to use magical sausages to recover MP or not. `false` will use mafia's built-in method for MP recovery. Defaults to `true` if omitted
* Returns `true` if it finishes with no critical error. Returns `false` with message if it was unable to finish.

Optionally, it can be called from the CLI simply using its script name, though only with using sausages as fuel, via:
* `c2t_lprom`

## c2t_mapgrim

Kolmafia script to evenly acquire synthetic dog hair pills and distention pills from using maps of safety shelter grimace prime.

## c2t_shrugall

Kolmafia script to remove all active effects that are removeable from the player. Mostly useful for PvP.

## c2t_stacheTracker

Rudimentary tracking of buffs the Daylight Shavings Helmet doles out. It tracks and stores what the last buff it detect from the helmet, and as well as what the next buff should be.

Warning: the tracking will fall apart if you manipulate your buffs in such a way as to have 2 or more non-sequential buffs.

### Usage
This is meant to be included in a post-adventure script that runs after every adventure.

It can either be `import`ed to a script with which the function `c2t_stacheTracker()` can be used to update properties. Or it can be ran from the CLI via `c2t_stacheTracker` to do the same.

Properties this script uses that can be referenced in other scripts:
* `c2t_stacheLast` &mdash; contains the name of the last buff obtained
* `c2t_stacheNext` &mdash; contains the name of the next buff that is expected

