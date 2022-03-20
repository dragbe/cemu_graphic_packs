[BotwV208]
moduleMatches = 0x6267BFD0

.origin = codecave

_BOTW_DurabilityUI_UIString:
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
_BOTW_DurabilityUI_UIStringLength:
.int 0

_BOTW_DurabilityUI_ReadQuickMenuWeaponId:
lwz r12, 0x0(r11)
lwz r3, 0x8(r12)
cmpwi r3, 2
beqlr # if ISARROW(selected weapon) EXITSUB
lis r19, _BOTW_DurabilityUI_UIStringLength@ha
addi r19, r19, _BOTW_DurabilityUI_UIStringLength@l
lhz r3, 0x31(r12)
cmpwi r3, 19577
beq .+0x38 # if (WeaponStringId.substr(13,2)=="Ly") GOTO lis r17, $DataLayerMemoryBase
lwz r17, 0x10(r12)
_BOTW_DurabilityUI_CStrR17:
mr r18, r19
li r7, 10
mr r4, r17
divw. r17, r4, r7
mulli r5, r17, 10
sub r5, r4, r5
addi r5, r5, 48
stbu r5, -0x1(r18)
bne .-0x18
sub r18, r19, r18 # r18=len(CStr(R17))
stw r18, 0x0(r19)
blr
lis r17, $DataLayerMemoryBase
lwz r3, 0x0(r17)
cmpw r3, r17
bnelr
lwz r4, 0x74(r3)
lfs f19, 0x14(r4)
lis r17, 0x1030
lfs f20, 0x1898(r17) # Day duration
fcmpu f19, f20
bgt .+0x18 # if (WM_BloodyMoonTimer > 360.0) GOTO lwz r4, 0x4(r3)
li r4, 258
stw r4, 0x0(r19)
li r4, 0x2b2b
sth r4, -0x2(r19)
blr
lwz r4, 0x4(r3)
lbz r4, 0x7(r4)
cmpwi r4, 0
beq .+0x40 # if (WM_NighttimeFlag==OFF) GOTO fctiwz f19, f19
lwz r4, 0x4C(r3)
lwz r4, 0x14(r4)
addi r4, r4, 1 # Moon type = (WM_NumberOfDays + x + 1) % 8 where x = 1 if 0 < WM_TimeDivision < 7
lwz r3, 0x84(r3)
lwz r3, 0x14(r3)
addi r3, r3, 1
rlwinm r3, r3, 30, 31, 31
add r4, r4, r3
rlwinm. r4, r4, 0, 29, 31
bne .+0x18 # if NOT(Full moon type) GOTO fctiwz f19, f19
li r4, 257
stw r4, 0x0(r19)
li r4, 43
stb r4, -0x1(r19)
blr
fctiwz f19, f19
stfd f19, -0x4(r19)
lwz r4, 0x0(r19)
cmpwi r4, 2520
bgtlr # if (CLng(WM_BloodyMoonTimer) > 2520) EXITSUB === if (next day==bloody day) GOTO EXITSUB
li r3, 2520
sub r4, r3, r4
li r3, 900
divw r17, r4, r3 # Hours
mulli r3, r17, 900
sub r4, r4, r3
li r3, 0x2030
sth r3, -0x9(r19)
addi r17, r17, 48
stb r17, -0x7(r19)
li r3, 58
stb r3, -0x6(r19)
stb r3, -0x3(r19)
li r3, 15
divw r17, r4, r3 # Minutes
mulli r3, r17, 15
sub r4, r4, r3
li r3, 10
divw r10, r17, r3
addi r7, r10, 48
stb r7, -0x5(r19)
mulli r10, r10, 10
sub r17, r17, r10
addi r17, r17, 48
stb r17, -0x4(r19)
slwi r4, r4, 2 # Seconds
divw r10, r4, r3
addi r7, r10, 48
stb r7, -0x2(r19)
mulli r10, r10, 10
sub r4, r4, r10
addi r4, r4, 48
stb r4, -0x1(r19)
li r3, 265
stw r3, 0x0(r19)
blr

_BOTW_DurabilityUI_ReadQuickMenuRuneIndex:
lwz r3, 0x0(r9)
cmpwi r3, 1
bgtlr # if NOT(remote bomb runes) EXITSUB
lis r5, $DataLayerMemoryBase
lwz r4, 0x0(r5)
cmpw r4, r5
bnelr
lwz r5, 0xB0C(r4)
cmpwi r5, 0
beqlr # if NOT EXIST(BombsNum gamedata) EXITSUB
lwz r5, 0xB08(r4)
lwz r17, 0x14(r5)
lis r19, _BOTW_DurabilityUI_UIStringLength@ha
addi r19, r19, _BOTW_DurabilityUI_UIStringLength@l
b _BOTW_DurabilityUI_CStrR17

_BOTW_DurabilityUI_setUIString:
lis r5, _BOTW_DurabilityUI_UIStringLength@ha
lwzu r4, _BOTW_DurabilityUI_UIStringLength@l(r5)
cmpwi r4, 0
bgt .+0xC
srwi r4, r3, 1
blr
addi r17, r29, -2
lis r29, _BOTW_DurabilityUI_UIString@ha
addi r29, r29, _BOTW_DurabilityUI_UIString@l
addi r18, r29, -2
cmpwi r4, 255
bgt .+0x10 # if (force custom concat mode) GOTO add r3, r17, r3
li r19, $UIDurFormat
cmpwi r19, 0
beq .+0x30 # if (Show durability only) GOTO li r3, 0
add r3, r17, r3
lhzu r19, 0x2(r17)
sthu r19, 0x2(r18)
cmpw r17, r3
bne .-0xC
cmpwi r4, 255
bgt .+0x14 # if (force custom concat mode) GOTO li r3, 0
li r3, 58
sth r3, 0x2(r18)
li r3, 32
sthu r3, 0x4(r18)
li r3, 0
stw r3, 0x0(r5)
rlwinm r4, r4, 0, 24, 31
sub r4, r3, r4
lbzx r3, r4, r5
sthu r3, 0x2(r18)
addic. r4, r4, 1
bne .-0xC
sthu r4, 0x2(r18)
sub r4, r18, r29
srwi r4, r4, 1
blr

0x02FC8FE0 = bla _BOTW_DurabilityUI_ReadQuickMenuRuneIndex # Selected quick menu rune shortcut management area [lwz r3, +0x0(r9)]
0x03A38B34 = bla _BOTW_DurabilityUI_setUIString # set UI string area (length computing included) [srwi r4, r3, 1]
0x02FC90B8 = bla _BOTW_DurabilityUI_ReadQuickMenuWeaponId # Selected quick menu weapon shortcut management area [lwz r12, +0x0(r11)]
0x024aca84 = li r3, $LowDurWarning # Low durability warning check area when taking the equipped weapons [bl 0x0249e2e0]
0x024b138c = li r3, $LowDurWarning # Low durability warning check area after a weapon durability update [bl 0x0249e2e0]
0x030879f8 = li r3, $LowDurWarning # Low durability warning check area related to the flashing red icons in the inventory [bl 0x0249e2e0]
0x024a3580 = li r3, $LowDurWarning # Low durability check when you loot a weapon [bl 0x0249E2E0]
0x024a0df4 = li r3, $MSPowerLossWarning # Low durability warning check area related to the Master Sword [bl 0x0249E2E0]