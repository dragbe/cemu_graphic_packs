[BotwV208]
moduleMatches = 0x6267BFD0

.origin = codecave

_BOTW_ItemLimiter_InitItems:
lis r4, $DataLayerMemoryBase
lwz r31, 0x0(r4)
cmpw r4, r31
bne .+0x34 # if (DataLayer is not ready) GOTO lwz r4, 0x1c(r30)
li r31, ($MatMaxCount%65536)
addis r31, r31, ($MatMaxCount/65536+($MatMaxCount%65536)/32768)
stw r31, 0xA4(r4)
lis r31, $MatMaxItemsCount
addi r31, r31, $MatMaxSlotsCount
stw r31, 0xA8(r4)
li r31, ($FoodMaxCount%65536)
addis r31, r31, ($FoodMaxCount/65536+($FoodMaxCount%65536)/32768)
stw r31, 0xAC(r4)
lis r31, $FoodMaxItemsCount
addi r31, r31, $FoodMaxSlotsCount
stw r31, 0xB0(r4)
lwz r4, 0x1c(r30)
blr

_BOTW_ItemLimiter_NewMat:
lis r3, $DataLayerMemoryBase
lwz r5, 0xA4(r3)
lhz r4, 0xA8(r3)
cmpw r4, r5
ble .+0x8
mr r4, r5
cmpw r11, r4
blr

_BOTW_ItemLimiter_AddNewMat:
sub r5, r5, r11
stw r5, 0xA4(r3)
li r5, 0
blr

_BOTW_ItemLimiter_NewFood:
lis r3, $DataLayerMemoryBase
lwz r5, 0xAC(r3)
lhz r4, 0xB0(r3)
cmpw r4, r5
ble .+0x8
mr r4, r5
cmpw r12, r4
blr

_BOTW_ItemLimiter_AddNewFood:
sub r5, r5, r12
stw r5, 0xAC(r3)
li r5, 0
blr

_BOTW_ItemLimiter_TakeMat:
stw r0, 0x10(r27)
lis r3, $DataLayerMemoryBase
lwz r4, 0xA4(r3)
addi r4, r4, 1
stw r4, 0xA4(r3)
blr

_BOTW_ItemLimiter_RestoreMat:
lis r12, $DataLayerMemoryBase
lwz r9, 0xA4(r12)
subi r9, r9, 1
stw r9, 0xA4(r12)
lwz r12, 0x10(r7)
blr

_BOTW_ItemLimiter_EatItem:
stw r0, 0x10(r30)
lis r3, $DataLayerMemoryBase
lwz r4, 0x8(r30)
cmpwi r4, 7
bne .+0x14
lwz r4, 0xA4(r3)
addi r4, r4, 1
stw r4, 0xA4(r3)
blr
cmpwi r4, 8
bnelr
lwz r4, 0xAC(r3)
addi r4, r4, 1
stw r4, 0xAC(r3)
blr

_BOTW_ItemLimiter_CookFood:
lis r3, $DataLayerMemoryBase
lwz r31, 0xAC(r3)
cmpwi r31, 0
ble .+0x8
lhz r31, 0xB2(r3)
cmpw r0, r31
blr

_BOTW_ItemLimiter_SellItems:
lwz r8, 0x10(r31)
lis r18, $DataLayerMemoryBase
lwz r3, 0x8(r31)
cmpwi r3, 7
bne .+0x14
lwz r3, 0xA4(r18)
add r3, r3, r27
stw r3, 0xA4(r18)
blr
cmpwi r3, 8
bnelr
lwz r3, 0xAC(r18)
add r3, r3, r27
stw r3, 0xAC(r18)
blr

_BOTW_ItemLimiter_SellItem:
mr r3, r30
lwz r18, 0x8(r31)
cmpwi r18, 8
bnelr
lis r19, $DataLayerMemoryBase
lwz r18, 0xAC(r19)
addi r18, r18, 1
stw r18, 0xAC(r19)
blr

_BOTW_ItemLimiter_NPCRequestedItem:
lis r23, $DataLayerMemoryBase
lwz r10, 0x8(r22)
cmpwi r10, 7
bne .+0x18
lwz r10, 0xA4(r23)
add r10, r10, r29
stw r10, 0xA4(r23)
subf. r23, r29, r8
blr
cmpwi r10, 8
bne .+0x10
lwz r10, 0xAC(r23)
add r10, r10, r29
stw r10, 0xAC(r23)
subf. r23, r29, r8
blr

#_BOTW_ItemLimiter_StartCooking:
#cmpwi r11, 49
#bnelr
#lis r16, $DataLayerMemoryBase
#lwz r16, 0xAC(r16)
#cmpwi r16, 0
#bgt .+0x8
#li r11, 50
#cmpwi r11, 49
#blr

_BOTW_ItemLimiter_Crafting:
lwz r10, 0x8(r23)
cmpwi r10, 7
bne .+0x14
lis r6, $DataLayerMemoryBase
lwz r10, 0xA4(r6)
add r10, r10, r7
stw r10, 0xA4(r6)
subf. r6, r7, r8
blr

_BOTW_ItemLimiter_UpgradeArmor:
lwz r10, 0x8(r23)
cmpwi r10, 7
bne .+0x14
lis r6, $DataLayerMemoryBase
lwz r10, 0xA4(r6)
add r10, r10, r0
stw r10, 0xA4(r6)
subf. r6, r0, r8
blr

_BOTW_ItemLimiter_ResurrectWithFairy:
lwz r3, 0x8(r27)
cmpwi r3, 7
bne .+0x14
lis r9, $DataLayerMemoryBase
lwz r3, 0xA4(r9)
addi r3, r3, 1
stw r3, 0xA4(r9)
lwz r9, 0x10(r27)
blr

_BOTW_ItemLimiter_GameSaveLoadingCompleted:
mr r3, r31
lis r7, $DataLayerMemoryBase
lwz r16, 0x0(r7)
cmpw r7, r16
bnelr
lwz r16, 0x14(r7)
lbz r16, 0x7(r16)
cmpwi r16, 0
beqlr # if (IsGet_Obj_DRStone_Get==OFF) EXITSUB
lwz r16, 0xFC(r7)
addi r16, r16, -68
li r20, -1
addi r20, r20, 1
lhzu r15, 0x140(r16)
cmpwi r15, 17490
bne .-0xC # if (PorchItemStringId.substr(4,2)!="DR") GOTO addi r20, r20, 1
cmpwi r20, 0
beqlr # if (Only Sheikah Slate in the PorchItem array) EXITSUB
mr r23, r20
addi r16, r16, -4
li r14, 0
addi r18, r7, 0x1E4 # Roasted|Blackened|Seared|Baked|Toasted|Charred foods filter
addi r16, r16, -320
addi r17, r18, -32
lwzu r15, 0x10(r17)
lwzx r15, r15, r16
lwz r19, 0x4(r17)
cmpw r15, r19
blt .+0x1C # if NOT(PorchItemStringId LIKE FoodFilter) GOTO cmpw r17, r18
lwz r19, 0x8(r17)
cmpw r19, r15
blt .+0x10 # if NOT(PorchItemStringId LIKE FoodFilter) GOTO cmpw r17, r18
addi r14, r14, 1
addi r23, r23, -1
b .-0x30 # GOTO addi r16, r16, -320
cmpw r17, r18
bne .-0x30 # if (still next food filter[s]) GOTO lwzu r15, 0x10(r17)
li r22, 0
addi r18, r7, 0x224 # Courser Bee Honey filter
addi r17, r18, -64
lwzu r15, 0x10(r17)
lwzx r15, r15, r16
lwz r19, 0x4(r17)
cmpw r15, r19
blt .+0x20 # if NOT(PorchItemStringId LIKE MaterialFilter) GOTO cmpw r17, r18
lwz r19, 0x8(r17)
cmpw r19, r15
blt .+0x14 # if NOT(PorchItemStringId LIKE MaterialFilter) GOTO cmpw r17, r18
addi r22, r22, 1
addi r23, r23, -1
addi r16, r16, -320
b .-0x30 # GOTO addi r17, r18, -64
cmpw r17, r18
bne .-0x34 # if (still next material filter[s]) GOTO lwzu r15, 0x10(r17)
cmpw r23, r20
beqlr # if (No materials|foods in the PorchItem array) EXITSUB
lwz r15, 0x2F4(r7) # PorchItem_Value1
addi r15, r15, -12
slwi r17, r23, 5
add r15, r15, r17
cmpwi r22, 0
beq .+0x58 # if (no material in the PorchItem array) GOTO lwz r12, 0x2FC(r7)
lhz r17, 0xAA(r7)
cmpw r17, r22
ble .+0x8 # if (Max material slots count<=materials count in the PorchItem array) GOTO lhz r18, 0xA8(r7)
mr r17, r22
lhz r18, 0xA8(r7)
lwz r19, 0xA4(r7)
lwzu r21, 0x20(r15)
cmpw r21, r18
ble .+0x8 # if (material qty<=Max items count for material slots) GOTO cmpw r21, r19
mr r21, r18
cmpw r21, r19
ble .+0x8 # if (material qty<=Max materials count) GOTO stw r21, 0x0(r15)
mr r21, r19
stw r21, 0x0(r15)
subf. r19, r21, r19
addi r16, r16, 320
addi r23, r23, 1
addi r22, r22, -1
beq .+0xC # if (r19==0) GOTO lwz r12, 0x2FC(r7)
addic. r17, r17, -1
bne .-0x38 # if (r17!=0) GOTO lwzu r21, 0x20(r15)
lwz r12, 0x2FC(r7) # PorchItem_EquipFlag
addi r12, r12, -9
slwi r17, r23, 4
add r12, r12, r17
cmpwi r14, 0
li r9, 15
beq .+0xD0 # if (no food in the PorchItem array) GOTO cmpw r23, r20
lhz r17, 0xB2(r7)
cmpw r17, r14
ble .+0x8 # if (Max food slots count<=foods count in the PorchItem array) GOTO lhz r18, 0xB0(r7)
mr r17, r14
lhz r18, 0xB0(r7)
lwz r19, 0xAC(r7)
cmpwi r22, 0
bne .+0x44 # if (material loss) GOTO slwi r11, r22, 4
lwzu r21, 0x20(r15)
cmpw r21, r18
ble .+0x8 # if (food qty<=Max items count for food slots) GOTO cmpw r21, r19
mr r21, r18
cmpw r21, r19
ble .+0x8 # if (food qty<=Max foods count) GOTO stw r21, 0x0(r15)
mr r21, r19
stw r21, 0x0(r15)
subf. r19, r21, r19
addi r23, r23, 1
addi r12, r12, 16
addi r16, r16, 320
beq .+0x7C # if (r19==0) GOTO cmpw r23, r20
addic. r17, r17, -1
bne .-0x38 # if (r17!=0) GOTO lwzu r21, 0x20(r15)
b .+0x70 # GOTO cmpw r23, r20
slwi r11, r22, 4
add r11, r12, r11
slwi r8, r22, 5
add r8, r8, r15
mulli r4, r22, 320
add r4, r4, r16
lwzu r21, 0x20(r8)
cmpw r21, r18
ble .+0x8 # if (food qty<=Max items count for food slots) GOTO cmpw r21, r19
mr r21, r18
cmpw r21, r19
ble .+0x8 # if (food qty<=Max foods count) GOTO stwu r21, 0x20(r15)
mr r21, r19
stwu r21, 0x20(r15)
addi r23, r23, 1
lbzu r14, 0x10(r11)
stbu r14, 0x10(r12)
lwzu r14, 0x17C(r4)
stwu r14, 0x17C(r16)
mtctr r9
lwzu r14, -0x4(r4)
stwu r14, -0x4(r16)
bdnz .-0x8
subf. r19, r21, r19
beq .+0xC # if (r19==0) GOTO cmpw r23, r20
addic. r17, r17, -1
bne .-0x50 # if (r17!=0) GOTO lwzu r21, 0x20(r8)
cmpw r23, r20
beqlr # if (No material|food slots loss) EXITSUB
sub r18, r20, r23
slwi r11, r18, 4
add r11, r12, r11
slwi r8, r18, 5
add r8, r8, r15
mulli r4, r18, 320
add r4, r4, r16
lwz r17, 0x40(r16)
lwzu r21, 0x20(r8)
stwu r21, 0x20(r15)
lbzu r21, 0x10(r11)
stbu r21, 0x10(r12)
lwzu r21, 0x17C(r4)
stwu r21, 0x17C(r16)
mtctr r9
lwzu r21, -0x4(r4)
stwu r21, -0x4(r16)
bdnz .-0x8
lwz r21, 0x20(r8)
cmpwi r21, 0
beq .+0x14 # if (PorchItem_Value1==0) GOTO mtctr r18
lwz r21, 0x180(r4)
cmpw r17, r21
beq .-0x3C # if (next porchItem gamedata hash==porchItem hash) GOTO lwzu r21, 0x20(r8)
li r21, 0
mtctr r18
stbu r21, 0x140(r16)
stbu r21, 0x10(r12)
stwu r21, 0x20(r15)
bdnz .-0xC
blr

_BOTW_ItemLimiter_ExistFreeFoodSlot:
lis r3, $DataLayerMemoryBase
lwz r31, 0xAC(r3)
cmpwi r31, 0
beq .+0x8
lhz r31, 0xB2(r3)
cmpw r30, r31
blr

#_BOTW_ItemLimiter_ExistFreeMaterialSlot:
#lis r3, $DataLayerMemoryBase
#lwz r31, 0xA4(r3)
#cmpwi r31, 0
#beq .+0x8
#lhz r31, 0xAA(r3)
#cmpw r30, r31
#blr

0x0322cd24 = bla _BOTW_ItemLimiter_InitItems # Data structure initialization area when (re)start|(re)load a game [lwz r4, +0x1c(r30)]
0x02eb1fe8 = bla _BOTW_ItemLimiter_NewFood # Quantity initialization in a new food slot [cmpwi r12, 0x3e7]
0x02eb1ff0 = mr r12, r4 # [li r12, 0x3e7]
0x02eb1ff4 = bla _BOTW_ItemLimiter_AddNewFood # [li r5, 0]
0x02eb1f88 = bla _BOTW_ItemLimiter_NewMat # Quantity initialization in a new material slot [cmpwi r11, 0x3e7]
0x02eb1f90 = mr r11, r4 # [li r11, 0x3e7]
0x02eb1f94 = bla _BOTW_ItemLimiter_AddNewMat # [li r5, 0]
0x02eba610 = bla _BOTW_ItemLimiter_TakeMat # Material quantity update for the hold action (PouchTrash) [stw r0, +0x10(r27)]
0x02ebcdb0 = bla _BOTW_ItemLimiter_RestoreMat # Material quantity update for the restore action [lwz r12, +0x10(r7)]
0x02ebaaf4 = bla _BOTW_ItemLimiter_EatItem # Item (material|food) quantity update for the eat action (PouchUse) [stw r0, +0x10(r30)]
0x02eb01c4 = bla _BOTW_ItemLimiter_CookFood # Cook food [cmpwi r0, 0x3C]
0x02ebf08c = bla _BOTW_ItemLimiter_SellItems # Item (material|uncooked food) quantity update for the sell action [lwz r8, +0x10(r31)]
0x02ebf0bc = bla _BOTW_ItemLimiter_SellItem # Item (armor|cooked food) equipped state update for the sell action [mr r3, r30]
0x02eb82f4 = bla _BOTW_ItemLimiter_NPCRequestedItem # Item (material|food) quantity update for the NPC request (when forge champion weapons for example) [subf. r23, r29, r8]
#0x02d0d2a8 = bla _BOTW_ItemLimiter_StartCooking # Start cooking area [cmpwi r11, 0x31]
0x02ebc11c = bla _BOTW_ItemLimiter_Crafting # Material|arrow quantity update area when craft with Cherry [subf. r6, r7, r8]
0x02ebbe8c = bla _BOTW_ItemLimiter_UpgradeArmor # Material quantity update area when upgrade armor with the great fairies [subf. r6, r0, r8]
0x02eb6394 = bla _BOTW_ItemLimiter_ResurrectWithFairy # Update resurrection fairy quantity area (PouchDelete) [lwz r9, +0x10(r27)]
0x03254f9C = bla _BOTW_ItemLimiter_GameSaveLoadingCompleted # Game save loading completed area [mr r3, r31]
0x02ebf938 = bla _BOTW_ItemLimiter_ExistFreeFoodSlot # check if new food can be stored in the inventory [cmpwi r30, 0x3c]
#0x02ebf8e8 = bla _BOTW_ItemLimiter_ExistFreeMaterialSlot # check if new material can be stored in the inventory [cmpwi r30, 0xa0]