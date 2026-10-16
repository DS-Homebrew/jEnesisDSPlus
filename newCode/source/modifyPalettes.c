#include <nds/system.h>

#define PersonalData8MB ((PERSONAL_DATA *)0x27FFC80)

u16* fpsCounterPalette = (u16*)0x02087468;

static u16 fpsCounterPalettes[16][2] = {
	{0x4E0C, 0x24A0}, // 0 = Gray
	{0x0137, 0x0048}, // 1 = Brown
	{0x0C1F, 0x0009}, // 2 = Red
	{0x7DFF, 0x2011}, // 3 = Pink
	{0x019F, 0x000E}, // 4 = Orange (original color)
	{0x03BF, 0x012C}, // 5 = Yellow
	{0x03F4, 0x0142}, // 6 = Yellow/Green-ish
	{0x03E0, 0x0140}, // 7 = Green
	{0x0260, 0x00E0}, // 8 = Dark Green
	{0x3F80, 0x2540}, // 9 = Green/Blue-ish
	{0x7EE0, 0x5060}, // 10 = Light Blue
	{0x7C80, 0x3800}, // 11 = Blue
	{0x4800, 0x1800}, // 12 = Dark Blue
	{0x6811, 0x1C07}, // 13 = Dark Purple
	{0x741A, 0x280A}, // 14 = Purple
	{0x401F, 0x000B}  // 15 = Purple/Red-ish
};

void applyUserPalette() {
	u8 userColor = PersonalData8MB->theme;
	if (userColor > 15) userColor = 0; // Display gray if invalid color is found

	fpsCounterPalette[0] = fpsCounterPalettes[userColor][0];
	fpsCounterPalette[2] = fpsCounterPalettes[userColor][1];
}
