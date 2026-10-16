# jEnesisDS Plus

Screenshots taken with NO$GBA

![Sonic 3D Blast](https://github.com/DS-Homebrew/jenesisDSPlus/blob/main/screenshots/Sonic3DBlast.png)
![Toy Story](https://github.com/DS-Homebrew/jenesisDSPlus/blob/main/screenshots/ToyStory.png)
![Super Street Fighter II: The New Challengers](https://github.com/DS-Homebrew/jenesisDSPlus/blob/main/screenshots/SSFII.png)
![Sonic Delta Reloaded](https://github.com/DS-Homebrew/jenesisDSPlus/blob/main/screenshots/SonicDeltaReloaded.png)
![Earthion](https://github.com/DS-Homebrew/jenesisDSPlus/blob/main/screenshots/Earthion.png)

An improved version of jEnesisDS (a SEGA Genesis/Mega Drive emulator) which adds new features such as:

- Support for ROMs up to 4MB (if running on DS debug consoles) or 7.5MB (if running on DSi consoles)
    - On DSi, SEGA mapper (aka SSF2 mapper) emulation is implemented in order for ROMs above 4MB to run
- ARGV support, allowing a ROM to start when passed from a homebrew launcher (such as [**TW**i**L**ight Menu++](https://github.com/DS-Homebrew/TWiLightMenu))

# Compiling

### Installing apps

1. Install [BlocksDS](https://blocksds.skylyrac.net/docs/setup/)
1. Install [Lunar IPS](https://www.romhacking.net/utilities/240/)
1. Install a hex editor such as [HxD](https://mh-nexus.de/en/hxd/)
1. Download [jEnesisDS v0.7.4](https://gamebrew.org/wiki/JEnesisDS) (the last version released)

### Building code

1. Open your terminal application (such as Command Prompt on Windows)
1. Run `cd <path of this repo folder>`
1. Run `cd newCode`
1. Run `make` to build `newCode.bin`

### Injecting new code

1. Make a copy of `jEnesisDS.nds` named `jEnesisDSPlus.nds`
1. Apply the `jEnesisDSPlus.ips` patch to `jEnesisDSPlus.nds`
1. Open your hex editor
1. Open `jEnesisDSPlus.nds`
1. Open `newCode.bin` inside the `newCode` folder
1. Copy everything inside the file
1. Go back to `jEnesisDSPlus.nds`
1. Go to offset `0x90204` and paste-write over the `00` bytes with the copied data from `newCode.bin`
1. Save `jEnesisDSPlus.nds`

### Displaying the game on the bottom screen

1. Make a copy of `jEnesisDSPlus.nds` named `jEnesisDSPlus_macro.nds`
1. Apply the `macroMode.ips` patch to `jEnesisDSPlus_macro.nds`

# Credits
- Lordus: Developer of the original jEnesisDS emulator
- [xonn83](https://github.com/xonn83): Bottom screen patch
