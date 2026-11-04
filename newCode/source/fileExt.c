#include <nds.h>

void changeExtToSrm(char* filename, const u8 len) {
	const char* srm = ".srm";
	for (u8 i = len; i >= 0; i--) {
		if (filename[i] == '.') {
			memcpy(filename+i, srm, 5); // Change ROM extension to ".srm"
			return;
		}
	}
	memcpy(filename+len, srm, 5); // Add ".srm" to end of filename if no extension is found
}

int checkIf2CharExt(char* extToCheck, char* filenameExt) {
	if (
		filenameExt[1] == extToCheck[0]
	&&	filenameExt[2] == extToCheck[1]
	&&	filenameExt[3] == extToCheck[2]
	&&	filenameExt[4] == extToCheck[3]
	) {
		return 0;
	}

	return 5;
}
