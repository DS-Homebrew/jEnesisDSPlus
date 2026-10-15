@---------------------------------------------------------------------------------
#define boot_memClr 0x0200015C
#define mainCode 0x020011E4
#define getFolderContents 0x020032A8
#define loadRom 0x02003418
#define returnFromRomList 0x02003690
#define newRomArea 0x023FF000
@---------------------------------------------------------------------------------
	.section ".init"
	.arm
@---------------------------------------------------------------------------------
	b		newInit
	b		loadRomFromArgv
@---------------------------------------------------------------------------------
newInit:
	ldr		r0, =0x04004000	@ Check for DSi mode
	ldrb	r0, [r0]
	cmp		r0, #1
	bne		newInit_dsMode
	bl		extRamEnabled
	cmp		r0, #1
	bne		saveArgv
	b		enable4mbRomSupport
newInit_dsMode:
	swi		0x0F0000		@ isDebugger: Check if DS is a debug model with 8MB of RAM
	cmp		r0, #1
	bne		saveArgv
enable4mbRomSupport:	@ Increase ROM size limit from 3MB (0x306800 bytes) to 4MB (0x400000 bytes)
	ldr		r0, =0x0200002D
	mcr		p15, 0, r0, c6, c1, 0	@ MPU region 1: Expand from 4MB to 8MB of RAM
	ldr		r0, =0x027FF017
	mcr		p15, 0, r0, c6, c7, 0	@ MPU region 7: Leave user and header data uncached

	ldr		r0, =newRomArea
	mov 	r3, #0
	adr		r1, romAreaPtrs
newInit_loop:
	ldr		r2, [r1, r3]
	str		r0, [r2]
	add		r3, #4
	cmp		r3, #0xE*4
	bne		newInit_loop

	mov		r0, #0x400000
	ldr		r1, =0x02002058
	str		r0, [r1]
	b		saveArgv
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
saveArgv:
	ldr		r0, =0x027FFE70
	ldr		r1, [r0]
	ldr		r2, =0x5F617267 @ '_arg'
	cmp		r1, r2
	bne		saveArgv_continue
	ldr		r1, [r0, #4]
	cmp		r1, #0
	beq		saveArgv_continue
	ldrb	r2, [r1]
	cmp		r2, #0
	beq		saveArgv_continue

saveArgv_loop:	@ look for argv[1] containing the ROM path
	add		r1, #1
	ldrb	r2, [r1]
	cmp		r2, #0
	bne		saveArgv_loop

	adr		r0, argvRomPath
saveArgv_loop2:	@ copy argv[1] to argvRomPath
	add		r1, #1
	ldrb	r2, [r1]
	strb	r2, [r0]
	cmp		r2, #0
	addne	r0, #1
	bne		saveArgv_loop2

saveArgv_continue:
	ldr		r0, =0x2098F70
	mov		r1, #256
	bl		boot_memClr
	b		mainCode
.pool
argvRomPath:
	.space 256
@---------------------------------------------------------------------------------
loadRomFromArgv:
	adr		r5, romFromArgvLoaded
	ldr		r4, [r5]
	cmp		r4, #1
	beq		getFolderContents
	mov		r4, #1
	str		r4, [r5]

	adr		r4, argvRomPath
	ldrb	r5, [r4]
	cmp		r5, #0
	beq		getFolderContents

	push	{r4-r5, lr}
	ldr lr,	=loadRomFromArgv_ret
	push	{r4-r5, lr}
	sub		sp, #4

	b		loadRom
loadRomFromArgv_ret:
	pop		{r4-r5, lr}
	b		returnFromRomList
romFromArgvLoaded:
.word 0
.pool
@---------------------------------------------------------------------------------
