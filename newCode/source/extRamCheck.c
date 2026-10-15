#include <nds.h>

bool extRamEnabled() {
	return (REG_SCFG_EXT & (BIT(14) | BIT(15)));
}
