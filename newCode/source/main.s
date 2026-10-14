@---------------------------------------------------------------------------------
#define mainCode 0x020011E4
#define newRomArea 0x023FF000
@---------------------------------------------------------------------------------
	.section ".init"
	.arm
@---------------------------------------------------------------------------------
	b		newInit
@---------------------------------------------------------------------------------
newInit:
	ldr		r0, =0x04004000	@ Check for DSi mode
	ldrb	r0, [r0]
	cmp		r0, #1
	beq		enable4mbRomSupport
	swi		0x0F0000		@ isDebugger: Check if DS is a debug model with 8MB of RAM
	cmp		r0, #1
	bne		mainCode
enable4mbRomSupport:	@ Increase ROM size limit from 3MB (0x306800 bytes) to 4MB (0x400000 bytes)
	ldr		r0, =0x0200002D
	mcr		p15, 0, r0, c6, c1, 0	@ MPU region 1: Expand from 4MB to 8MB of RAM
	ldr		r0, =0x027FF017
	mcr		p15, 0, r0, c6, c7, 0	@ MPU region 7: Leave user and header data uncached

	ldr		r0, =newRomArea
	mov 	r3, #0
	adr		r1, romAreaPtrs
.loop:
	ldr		r2, [r1, r3]
	str		r0, [r2]
	add		r3, #4
	cmp		r3, #0xE*4
	bne		.loop

	mov		r0, #0x400000
	ldr		r1, =0x02002058
	str		r0, [r1]
	b		mainCode
.pool
romAreaPtrs:
.word 0x02001634
.word 0x020016CC
.word 0x02001AFC
.word 0x02002060
.word 0x02003B2C
.word 0x02003C0C
.word 0x02003C50
.word 0x02003C84
.word 0x02003CAC
.word 0x02003CF4
.word 0x02003E1C
.word 0x02003EB0
.word 0x02003F2C
.word 0x02004480
@---------------------------------------------------------------------------------
