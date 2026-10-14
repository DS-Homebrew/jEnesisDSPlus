# jEnesisDS Plus

An improved version of jEnesisDS (a SEGA Genesis/Mega Drive emulator) (based on v0.7.4, the last version released) with support for ROMs up to 4MB (if running on DS debug or DSi consoles).

# Compiling

## Installing apps

1. Install [BlocksDS](https://blocksds.skylyrac.net/docs/setup/)
1. Install a hex editor such as [HxD](https://mh-nexus.de/en/hxd/)
1. Download [jEnesisDS v0.7.4](https://gamebrew.org/wiki/JEnesisDS) (the last version released)

## Building code

1. Open your terminal application (such as Command Prompt on Windows)
1. Run `cd <path of this repo folder>`
1. Run `cd newCode`
1. Run `make` to build `newCode.bin`

## Injecting new code

1. Open your hex editor
1. Open `jEnesisDS.nds`
1. Go to offset `0x414` and overwrite `E4` `11` `00` `02` with `04` `00` `09` `02` in order for the new code to run
1. Open `newCode.bin` inside the `newCode` folder
1. Copy everything inside the file
1. Go back to `jEnesisDS.nds`
1. Go to offset `0x90204` and paste-write over the `00` bytes with the copied data from `newCode.bin`
1. Save as a new file called `jEnesisDSPlus.nds`

# Credits
- Lordus: Developer of the original jEnesisDS emulator
