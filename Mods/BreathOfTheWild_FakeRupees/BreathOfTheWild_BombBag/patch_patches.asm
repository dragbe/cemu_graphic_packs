[BotwV208]
moduleMatches = 0x6267BFD0

.origin = codecave

#Optimized codecave size implementation
_BOTW_BombBag_TakeBomb:
li r5, 0
mr r3, r31
_BOTW_BombBag_UpdateBombsNumSaveData:
lwz r6, 0x1B18(r31)
lis r12, 0x1048
lwz r12, -0x3DA8(r12)
lwz r12, 0x1C(r12)
sub r6, r6, r12
cntlzw r6, r6
cmpwi r6, $WindBombSetting
bltlr
lis r6, $DataLayerMemoryBase
lwz r12, ($BombsNumGameDataPointerOffset+4)(r6)
cmpwi r12, 0
beqlr # if NOT EXIST(BombsNum gamedata) EXITSUB
lwz r6, $BombsNumGameDataPointerOffset(r6)
lwz r4, 0x14(r6)
addic. r4, r4, -1
bltlr # if (BombsNum==0) EXITSUB
stw r4, 0x14(r6)
stw r4, 0x4(r12)
blr

_BOTW_BombBag_DropBomb:
lwz r3, 0x0(r30)
addi r5, r1, 0x50
cmpwi r18, 0
beq _BOTW_BombBag_UpdateBombsNumSaveData
blr

0x02D1652C = li r18, 0 # [lwz r3, +0x0(r30)]
0x02D99DEC = lwz r30, 0x0(r30) # [mr r30, r3]
0x02D99E80 = lis r19, 0x101F # [lis r0, 0x101F]
0x02D99E8C = addic r0, r19, -0x7FBC # [addic r0, r0, -0x7FBC]
0x02D99F3C = subi r29, r19, 0x7FAC # [lis r29, 0x101F]
0x02D99F50 = lwzu r3, 0x3798(r28) # [subi r29, r29, 0x7FAC]
0x02D99F54 = mr r19, r3 # [lwzu r3, +0x3798(r28)]
0x02D99FAC = addi r3, r19, 0x22C # On detonate a cube bomb [lwz r3, +0x0(r28)]
0x02D9A194 = addi r3, r19, 0x22C # On detonate a spherical bomb [lwz r3, +0x0(r28)]
0x02A2C540 = li r18, 1 # [addi r3, r3, 0x22C]

0x02D999A8 = bla _BOTW_BombBag_TakeBomb # On take cube bomb [li r4, 0]
0x02D999AC = blt .+0x40C # [mr r3, r31]
0x02D999B0 = li r4, 0 # [mr r5, r4]
0x02D99AA0 = bla _BOTW_BombBag_TakeBomb # On take spherical bomb [li r4, 0]
0x02D99AA4 = blt .+0x314 # [mr r3, r31]
0x02D99AA8 = li r4, 0 # [mr r5, r4]
0x02D99D30 = bla _BOTW_BombBag_DropBomb # On drop or detonate a cube bomb when the player is not on the ground (paraglider, fall, ...) [lwz r3, +0x0(r30)]
0x02D99D34 = blt .+0x84 # [li r4, 1]
0x02D99D38 = li r4, 1 # [addi r5, r1, 0x50]
0x02D99DA0 = bla _BOTW_BombBag_DropBomb # On drop or detonate a spherical bomb when the player is not on the ground (paraglider, fall, ...) -> take or detonate bomb animations canceled [li r4, 0]
0x02D99DA4 = blt .+0x14 # [lwz r3, +0x0(r30)]
0x02D99DA8 = li r4, 0 # [addi r5, r1, 0x50]