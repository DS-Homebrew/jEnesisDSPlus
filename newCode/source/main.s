@---------------------------------------------------------------------------------
#define boot_memClr 0x0200015C
#define mainCode 0x020011E4
#define getFolderContents 0x020032A8
#define loadRom 0x02003418
#define returnFromRomList 0x02003690
#define afterSramAccessCheck 0x02004828
#define newRomArea 0x023FF000
#define newLargeRomArea 0x02800000
@---------------------------------------------------------------------------------
	.section ".init"
	.arm
@---------------------------------------------------------------------------------
	b		newInit
	b		loadRomFromArgv
	b		copyFirst4MBofROM
	b		checkRomBankRegister
@---------------------------------------------------------------------------------
newInit:
	ldr		r0, =0x04004000	@ Check for DSi mode
	ldrb	r0, [r0]
	cmp		r0, #1
	bne		newInit_dsMode
	bl		extRamEnabled
	cmp		r0, #1
	bne		saveArgv
	adr		r0, isDSi
	mov		r1, #1
	str		r1, [r0]
	b		enable4mbRomSupport
newInit_dsMode:
	ldr		r1, =0x0280002D	@ MPU region 7: Uncached main memory for mirror checking
	mcr		p15, 0, r1, c6, c7, 0
	bl		isDSDebugConsole
	ldr		r1, =0x0240002B
	mcr		p15, 0, r1, c6, c7, 0
	cmp		r0, #1
	bne		saveArgv
	mov		r1, #0
enable4mbRomSupport:	@ Increase ROM size limit from 3MB (0x306800 bytes) to either 4MB (0x400000 bytes) on DS debug consoles, or 7.5MB (0x780000 bytes) on DSi consoles
	cmp		r1, #0
	ldreq	r0, =0x0200002D	@ MPU region 1: Expand from 4MB to 8MB of RAM on DS debug consoles
	ldrne	r0, =0x0200002F	@ MPU region 1: Expand from 4MB to 16MB of RAM on DSi consoles
	mcr		p15, 0, r0, c6, c1, 0
	cmp		r1, #0
	ldreq	r0, =0x027FF017	@ MPU region 7: Keep user and header data uncached on DS debug consoles
	ldrne	r0, =0x02FFF017	@ MPU region 7: Keep last 4KB of RAM uncached on DSi consoles
	mcr		p15, 0, r0, c6, c7, 0

	ldr		r0, =newRomArea
	mov 	r3, #0
	adr		r4, romAreaPtrs
newInit_loop:
	ldr		r2, [r4, r3]
	str		r0, [r2]
	add		r3, #4
	cmp		r3, #0xD*4
	bne		newInit_loop

	cmp		r1, #0
	moveq	r0, #0x400000
	movne	r0, #0x780000
	ldr		r2, =0x02002058
	str		r0, [r2]
	ldreq	r0, =newRomArea
	ldrne	r0, =newLargeRomArea
	strne	r0, [r2, #8]
	b		saveArgv
isDSi:
.word 0
.pool
romAreaPtrs:
.word 0x02001634
.word 0x020016CC
.word 0x02001AFC
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
copyFirst4MBofROM:
	push	{r4, lr}
	ldr		r4, isDSi
	cmp		r4, #0
	moveq	r0, #1
	popeq	{r4, pc}
	bl		initRomBanks
	ldr		r0, =newRomArea
	mov		r1, #newLargeRomArea
	mov		r2, #0x400000
	bl		memcpy
	mov		r0, #1
	pop		{r4, pc}
.pool
@---------------------------------------------------------------------------------
checkRomBankRegister:
	ldr		r4, isDSi
	cmp		r4, #0
	ldreq	r3, =0xFF5ECF0D
	beq		afterSramAccessCheck
	ldr		r3, =0xA130F3
	cmp		r0, r3
	ldrge	r3, =0xA130FF
	cmpge	r0, r3
	ldrgt	r3, =0xFF5ECF0D
	bgt		afterSramAccessCheck
	push	{lr}
	bl		loadRomBank
	pop		{pc}
.pool
@---------------------------------------------------------------------------------
