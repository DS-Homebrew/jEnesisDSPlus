#include <nds.h>

#define newRomArea 0x023FF000
#define newLargeRomArea 0x02800000

static u8 banks[7] = {1, 2, 3, 4, 5, 6, 7};

void initRomBanks() {
	for (int i = 1; i <= 7; i++) {
		banks[i-1] = i;
	}
}

void loadRomBank(u32 a, u8 page) {
	u32 src = newLargeRomArea+(page*0x80000);
	u32 dst = newRomArea;
	switch (a) {
		case 0xA130F3:
			if (banks[0] == page) {
				return;
			}
			banks[0] = page;
			dst += 0x80000;
			break;
		case 0xA130F5:
			if (banks[1] == page) {
				return;
			}
			banks[1] = page;
			dst += 0x100000;
			break;
		case 0xA130F7:
			if (banks[2] == page) {
				return;
			}
			banks[2] = page;
			dst += 0x180000;
			break;
		case 0xA130F9:
			if (banks[3] == page) {
				return;
			}
			banks[3] = page;
			dst += 0x200000;
			break;
		case 0xA130FB:
			if (banks[4] == page) {
				return;
			}
			banks[4] = page;
			dst += 0x280000;
			break;
		case 0xA130FD:
			if (banks[5] == page) {
				return;
			}
			banks[5] = page;
			dst += 0x300000;
			break;
		case 0xA130FF:
			if (banks[6] == page) {
				return;
			}
			banks[6] = page;
			dst += 0x380000;
			break;
	}

	memcpy((u32*)dst, (u32*)src, 0x80000);
}
