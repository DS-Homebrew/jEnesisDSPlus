# jEnesisDS Plus

An improved version of jEnesisDS (a SEGA Genesis/Mega Drive emulator) which adds new features such as:

- Support for ROMs up to 4MB (if running on DS debug consoles) or 7.5MB (if running on DSi consoles)
- ARGV support, allowing a ROM to start when passed from a homebrew launcher (such as [**TW**i**L**ight Menu++](https://github.com/DS-Homebrew/TWiLightMenu))

# Compiling

### Installing apps

1. Install [BlocksDS](https://blocksds.skylyrac.net/docs/setup/)
1. Install a hex editor such as [HxD](https://mh-nexus.de/en/hxd/)
1. Download [jEnesisDS v0.7.4](https://gamebrew.org/wiki/JEnesisDS) (the last version released)

### Building code

1. Open your terminal application (such as Command Prompt on Windows)
1. Run `cd <path of this repo folder>`
1. Run `cd newCode`
1. Run `make` to build `newCode.bin`

### Injecting new code

1. Open your hex editor
1. Open `jEnesisDS.nds`
1. Go to these offsets and change the following bytes:
    - `0x2F0`: `F8 10 9F E5 B4 20 9F E5 F4 40 9F E5 1F` -> `B8 00 9F E5 F8 10 9F E5 00 10 41 E0 16`
    - `0x3F9`: `8F` -> `90`
    - `0x414`: `E4 11 00` -> `04 00 09`
    - `0x1FF8`: `04 00 A0 E1` -> `83 38 02 EB`
    - `0x36DC`: `71 FF FF` -> `C9 32 02`
    - `0x4A24`: `94 30 9F E5` -> `F9 2D 02 EA`
1. Open `newCode.bin` inside the `newCode` folder
1. Copy everything inside the file
1. Go back to `jEnesisDS.nds`
1. Go to offset `0x90204` and paste-write over the `00` bytes with the copied data from `newCode.bin`
1. Save as a new file called `jEnesisDSPlus.nds`

# Credits
- Lordus: Developer of the original jEnesisDS emulator
