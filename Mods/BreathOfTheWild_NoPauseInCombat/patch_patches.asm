[BotwV208]
moduleMatches = 0x6267BFD0

.origin = codecave

_BOTW_NoPauseInCombat_FlagToCancelExclusion:
.int 108
_BOTW_NoPauseInCombat_CanLockEnemy:
.int 0
_BOTW_NoPauseInCombat_GuardiansTargetStatus:
.int 0
_BOTW_NoPauseInCombat_FixedGuardiansTargetStatus:
.int 0
_BOTW_NoPauseInCombat_PausesCount:
.int 0

_BOTW_NoPauseInCombat_Exclusions:
.int 1
.int $SanctumMaxPausesCount
.int $SanctumNoPauseIfTrueFlag
.int 19
.int 1215918709 # Hyru
.int 1818575713 # leCa
.int 1937009765 # stle
.int 1598579052 # _Hal
.int 1818177536 # l_0
.int 0
.int 0
.int 0

_BOTW_NoPauseInCombat_ResetModVars:
li r31, 0
lis r6, _BOTW_NoPauseInCombat_PausesCount@ha
stwu r31, _BOTW_NoPauseInCombat_PausesCount@l(r6)
stw r31, -0x4(r6)
stw r31, -0x8(r6)
blr

_BOTW_NoPauseInCombat_LeaveLocation:
li r5, 1
lis r3, $DataLayerMemoryBase
lwz r4, 0x0(r3)
cmpw r3, r4
bnelr
lwz r3, 0x5C(r4)
lbz r3, 0x7(r3)
cmpwi r3, 0
bnelr # if (FirstInHyruleCastleBossRoom==ON) EXITSUB
lis r4, _BOTW_NoPauseInCombat_PausesCount@ha
stw r3, _BOTW_NoPauseInCombat_PausesCount@l(r4)
blr

_BOTW_NoPauseInCombat_EnterLocation:
lwz r11, 0xe44(r29)
addi r19, r31, 12
lis r12, _BOTW_NoPauseInCombat_Exclusions@ha
lwzu r27, _BOTW_NoPauseInCombat_Exclusions@l(r12)
mr r10, r12
lwz r16, 0xC(r12)
addi r12, r12, 16
lwzx r17, r16, r19
stwx r17, r16, r12
li r17, 0
stbx r17, r16, r12
srwi r16, r16, 2
slwi r16, r16, 2
lwzx r17, r16, r19
lwzx r18, r16, r12
cmpw r17, r18
bne .+0x20 # if (LocationName!=current LocationName in the Exclusions) GOTO addi r12, r12, 28
addic. r16, r16, -4
bge .-0x14 # if (str4cmp start offset>=0) GOTO lwzx r17, r16, r19
lwz r27, -0xC(r12)
stw r27, -0x4(r10)
lwz r27, -0x8(r12)
stw r27, -0x14(r10)
blr
addi r12, r12, 28
addic. r27, r27, -1
bne .-0x54 # if (still exclusions) GOTO lwz r16, 0xC(r12)
stw r27, -0x4(r10)
blr

_BOTW_NoPauseInCombat_PressGPPauseButton:
lis r31, _BOTW_NoPauseInCombat_CanLockEnemy@ha
lwzu r25, _BOTW_NoPauseInCombat_CanLockEnemy@l(r31)
cmpwi r25, 0
bne .+0x50 # if (r25!=0) GOTO lwz r25, 0xC(r31)
lis r25, 0x1048
lwz r25, -0x3C70(r25)
cmpwi r25, 0
beq .+0x28 # if (usable campfire check #1) GOTO lwz r25, 0x4(r31)
lwz r25, 0x18(r25)
cmpwi r25, 0
beq .+0x1C # if (usable campfire check #2) GOTO lwz r25, 0x4(r31)
lwz r25, 0x24(r25)
cmpwi r25, 0
beq .+0x10 # if (usable campfire check #3) GOTO lwz r25, 0x4(r31)
lbz r25, 0x60(r25)
cmpwi r25, 0
bne .+0x1C # if (not usable campfire) GOTO lwz r25, 0xC(r31)
lwz r25, 0x4(r31)
cmpwi r25, 0
bne .+0x10 # if (Battle with Guardians) GOTO lwz r25, 0xC(r31)
lwz r25, 0x8(r31)
cmpwi r25, 0
beq .+0x40 # if (Not Battle with Fixed Guardians) GOTO or r10, r10, r12
lwz r25, 0xC(r31)
cmpwi r25, 0
beqlr # if (allowed pauses count==0) EXITSUB
lis r5, $DataLayerMemoryBase
lwz r25, 0x0(r5)
cmpw r25, r5
bne .+0x24 # if (DataLayer is not ready) GOTO or r10, r10, r12
lwz r5, -0x4(r31)
lwzx r5, r5, r25
lbz r5, 0x7(r5)
cmpwi r5, 0
beq .+0x10
li r5, 0
stw r5, 0xC(r31)
blr
or r10, r10, r12
blr

_BOTW_NoPauseInCombat_PressGPPlusButton:
li r12, 0xc00
b _BOTW_NoPauseInCombat_PressGPPauseButton

_BOTW_NoPauseInCombat_PressGPMinusButton:
li r12, 0x1200
b _BOTW_NoPauseInCombat_PressGPPauseButton

_BOTW_NoPauseInCombat_PressPCPauseButton:
lis r12, _BOTW_NoPauseInCombat_CanLockEnemy@ha
lwzu r7, _BOTW_NoPauseInCombat_CanLockEnemy@l(r12)
cmpwi r7, 0
bne .+0x50
lis r7, 0x1048
lwz r7, -0x3C70(r7)
cmpwi r7, 0
beq .+0x28
lwz r7, 0x18(r7)
cmpwi r7, 0
beq .+0x1C
lwz r7, 0x24(r7)
cmpwi r7, 0
beq .+0x10
lbz r7, 0x60(r7)
cmpwi r7, 0
bne .+0x1C
lwz r7, 0x4(r12)
cmpwi r7, 0
bne .+0x10
lwz r7, 0x8(r12)
cmpwi r7, 0
beq .+0x40
lwz r7, 0xC(r12)
cmpwi r7, 0
beqlr
lis r9, $DataLayerMemoryBase
lwz r7, 0x0(r9)
cmpw r7, r9
bne .+0x24
lwz r9, -0x4(r12)
lwzx r9, r9, r7
lbz r9, 0x7(r9)
cmpwi r9, 0
beq .+0x10
li r9, 0
stw r9, 0xC(r12)
blr
or r0, r0, r11
blr

_BOTW_NoPauseInCombat_PressPCPlusButton:
li r11, 0xc00
b _BOTW_NoPauseInCombat_PressPCPauseButton

_BOTW_NoPauseInCombat_PressPCMinusButton:
li r11, 0x1200
b _BOTW_NoPauseInCombat_PressPCPauseButton

_BOTW_NoPauseInCombat_ExitPause:
addi r6, r1, 0x80
lis r7, _BOTW_NoPauseInCombat_PausesCount@ha
lwz r3, _BOTW_NoPauseInCombat_PausesCount@l(r7)
cmpwi r3, 0
beqlr
addi r3, r3, -1
stw r3, _BOTW_NoPauseInCombat_PausesCount@l(r7)
blr

_BOTW_NoPauseInCombat_FixedGuardiansLoseTarget:
stw r0, 0x138(r31)
lis r31, _BOTW_NoPauseInCombat_FixedGuardiansTargetStatus@ha
stw r0, _BOTW_NoPauseInCombat_FixedGuardiansTargetStatus@l(r31)
blr

_BOTW_NoPauseInCombat_FixedGuardiansRelockTarget:
lis r3, _BOTW_NoPauseInCombat_FixedGuardiansTargetStatus@ha
stw r0, _BOTW_NoPauseInCombat_FixedGuardiansTargetStatus@l(r3)
addi r3, r31, 0x13c
blr

_BOTW_NoPauseInCombat_FixedGuardiansLockTarget:
lis r3, _BOTW_NoPauseInCombat_FixedGuardiansTargetStatus@ha
stw r12, _BOTW_NoPauseInCombat_FixedGuardiansTargetStatus@l(r3)
addi r3, r31, 0x13c
blr

_BOTW_NoPauseInCombat_ReadyToFight:
lis r12, _BOTW_NoPauseInCombat_CanLockEnemy@ha
stw r3, _BOTW_NoPauseInCombat_CanLockEnemy@l(r12)
cmpwi r3, 0
blr

_BOTW_NoPauseInCombat_GuardiansLoseTarget:
stw r0, 0x138(r31)
lis r31, _BOTW_NoPauseInCombat_GuardiansTargetStatus@ha
stw r0, _BOTW_NoPauseInCombat_GuardiansTargetStatus@l(r31)
blr

_BOTW_NoPauseInCombat_GuardiansLockTarget:
lis r3, _BOTW_NoPauseInCombat_GuardiansTargetStatus@ha
stw r0, _BOTW_NoPauseInCombat_GuardiansTargetStatus@l(r3)
addi r3, r31, 0x13c
blr

_BOTW_NoPauseInCombat_OpenQuickMenu:
mr r3, r29
lis r4, _BOTW_NoPauseInCombat_PausesCount@ha
lwz r10, _BOTW_NoPauseInCombat_PausesCount@l(r4)
cmpwi r10, 0
beqlr
addi r10, r10, 1
stw r10, _BOTW_NoPauseInCombat_PausesCount@l(r4)
blr

0x02e71ec4 = bla _BOTW_NoPauseInCombat_OpenQuickMenu # open quick menu area [mr r3, r29]
0x0322cd28 = bla _BOTW_NoPauseInCombat_ResetModVars # Data structure initialization area when a game is (re)started [li r31, 0]
0x02D75954 = bla _BOTW_NoPauseInCombat_ExitPause # Exit the inventory|quick|map menu [addi r6, r1, 0x80]
0x02d7d2d8 = bla _BOTW_NoPauseInCombat_ReadyToFight # Can lock enemy area [cmpwi r3, 0]
0x03536780 = bla _BOTW_NoPauseInCombat_GuardiansLoseTarget # Guardians lose target area [stw r0, +0x138(r31)]
0x03536AE0 = bla _BOTW_NoPauseInCombat_GuardiansLockTarget # Guardians relock target area (after stasis for example) [addi r3, r31, 0x13c]
0x03536998 = bla _BOTW_NoPauseInCombat_GuardiansLockTarget # Guardians lock target area [addi r3, r31, 0x13c]
0x03532CD8 = bla _BOTW_NoPauseInCombat_FixedGuardiansLoseTarget # Fixed guardians lose target area [stw r0, +0x138(r31)]
0x03532EA8 = bla _BOTW_NoPauseInCombat_FixedGuardiansLockTarget # Fixed guardians lock target area [addi r3, r31, 0x13c]
0x03532F7C = bla _BOTW_NoPauseInCombat_FixedGuardiansRelockTarget # Fixed guardians relock target area (after stasis for example) [addi r3, r31, 0x13c]
0x02e27ad4 = bla _BOTW_NoPauseInCombat_EnterLocation # Enter location area [lwz r11, +0xe44(r29)]
0x02e27c30 = bla _BOTW_NoPauseInCombat_LeaveLocation # Leave location area [li r5, 1]
0x030D8B40 = bla _BOTW_NoPauseInCombat_PressGPPlusButton # Press gamepad + button [ori r10, r10, 0xc00]
0x030D8B4C = bla _BOTW_NoPauseInCombat_PressGPMinusButton # Press gamepad - button [ori r10, r10, 0x1200]
0x030D958C = bla _BOTW_NoPauseInCombat_PressPCPlusButton # Press pro controller + button [extrwi. r8, r4, 1, 19]
0x030D9590 = extrwi. r8, r4, 1, 19 # [ori r0, r0, 0xc00]
0x030D95A8 = bla _BOTW_NoPauseInCombat_PressPCMinusButton # Press pro controller - button [extrwi. r11, r4, 1, 20]
0x030D95AC = extrwi. r11, r4, 1, 20 # [ori r0, r0, 0x1200]