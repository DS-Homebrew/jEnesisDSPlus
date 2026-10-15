#include <nds.h>

bool isDSDebugConsole() {
	const u32 wordBak1 = *(vu32*)0x02800000;
	const u32 wordBak2 = *(vu32*)0x02C00000;
	*(vu32*)0x02800000 = 0x314D4152; // 'RAM1'
	*(vu32*)0x02C00000 = 0x324D4152; // 'RAM2'
	const bool mirrored = (*(vu32*)0x02800000 == *(vu32*)0x02C00000);
	*(vu32*)0x02800000 = wordBak1;
	*(vu32*)0x02C00000 = wordBak2;

	return mirrored ? false : true;
}

bool extRamEnabled() {
	return (REG_SCFG_EXT & (BIT(14) | BIT(15)));
}
