[BotwV208]
moduleMatches = 0x6267BFD0

.origin = codecave

_BOTW_LifeExtension_MaxExtraGoldenHearts:
.int ($MaxExtraGoldenHearts*4)
_BOTW_LifeExtension_FoodGoldenHearts:
.int 0
_BOTW_LifeExtension_InventoryGoldenHearts:
.int 0
_BOTW_LifeExtension_ExtraGoldenHearts:
.int 0
_BOTW_LifeExtension_FoodExtraGoldenHearts:
.int 0

_BOTW_LifeExtension_UpdateGoldenHeartsPreview:
slwi r0, r3, 2
lis r7, _BOTW_LifeExtension_FoodGoldenHearts@ha
stw r0, _BOTW_LifeExtension_FoodGoldenHearts@l(r7)
lis r7, _BOTW_LifeExtension_InventoryGoldenHearts@ha
lwz r7, _BOTW_LifeExtension_InventoryGoldenHearts@l(r7)
rlwinm r7, r7, 30, 2, 31
slwi r7, r7, 2
add r0, r0, r7
blr

_BOTW_LifeExtension_SelectInventoryItem:
lis r20, _BOTW_LifeExtension_FoodGoldenHearts@ha
stw r16, _BOTW_LifeExtension_FoodGoldenHearts@l(r20)
lwz r20, 0x8(r28)
blr

_BOTW_LifeExtension_EatItem:
lis r22, _BOTW_LifeExtension_ExtraGoldenHearts@ha
lwz r3, _BOTW_LifeExtension_ExtraGoldenHearts@l(r22)
lis r4, _BOTW_LifeExtension_FoodExtraGoldenHearts@ha
lwz r4, _BOTW_LifeExtension_FoodExtraGoldenHearts@l(r4)
rlwinm r3, r3, 30, 2, 31
slwi r3, r3, 2
add r3, r3, r4
lis r4, _BOTW_LifeExtension_MaxExtraGoldenHearts@ha
lwz r4, _BOTW_LifeExtension_MaxExtraGoldenHearts@l(r4)
cmpw r3, r4
ble .+0x8
mr r3, r4
stw r3, _BOTW_LifeExtension_ExtraGoldenHearts@l(r22)
li r3, 0
lis r4, _BOTW_LifeExtension_FoodGoldenHearts@ha
stw r3, _BOTW_LifeExtension_FoodGoldenHearts@l(r4)
mr r3, r28
blr

_BOTW_LifeExtension_UpdateInventoryGoldenHearts:
lis r19, _BOTW_LifeExtension_InventoryGoldenHearts@ha
stw r3, _BOTW_LifeExtension_InventoryGoldenHearts@l(r19)
lis r19, _BOTW_LifeExtension_FoodGoldenHearts@ha
lwz r19, _BOTW_LifeExtension_FoodGoldenHearts@l(r19)
subf r19, r12, r19
rlwinm r19, r19, 30, 2, 31
slwi r19, r19, 2
lis r10, _BOTW_LifeExtension_FoodExtraGoldenHearts@ha
stw r19, _BOTW_LifeExtension_FoodExtraGoldenHearts@l(r10)
add r10, r3, r12
blr

_BOTW_LifeExtension_UpdateHearts:
lis r12, _BOTW_LifeExtension_ExtraGoldenHearts@ha
lwz r3, _BOTW_LifeExtension_ExtraGoldenHearts@l(r12)
cmpwi r3, 0
beq .+0x28
lwz r4, 0x0(r28)
subf r31, r31, r4
subf r3, r31, r3
cmpwi r3, 0
bge .+0x1C
add r31, r4, r3
li r3, 0
stw r3, _BOTW_LifeExtension_ExtraGoldenHearts@l(r12)
stw r31, 0x8(r1)
stw r31, 0x0(r28)
blr
stw r3, _BOTW_LifeExtension_ExtraGoldenHearts@l(r12)
mr r31, r4
stw r31, 0x8(r1)
blr

_BOTW_LifeExtension_InitGoldenHeartsVars:
li r31, 0
lis r4, _BOTW_LifeExtension_ExtraGoldenHearts@ha
stw r31, _BOTW_LifeExtension_ExtraGoldenHearts@l(r4)
lis r4, _BOTW_LifeExtension_FoodGoldenHearts@ha
stw r31, _BOTW_LifeExtension_FoodGoldenHearts@l(r4)
blr

0x0308507C = bla _BOTW_LifeExtension_UpdateGoldenHeartsPreview # Golden hearts preview update area [rlwinm r0, r3, 2, 0, 29]
0x02FE1BB0 = bla _BOTW_LifeExtension_SelectInventoryItem # read selected item data [lwz r20, +0x8(r28)]
0x02EBAAF8 = bla _BOTW_LifeExtension_EatItem # Item (material|food) quantity update for the eat action [mr r3, r28]
0x02E89DC4 = bla _BOTW_LifeExtension_UpdateInventoryGoldenHearts # inventory golden hearts update area [add r10, r3, r12]
0x02D452A4 = bla _BOTW_LifeExtension_UpdateHearts # hearts update area [stw r31, +0x0(r28)]
0x0322CCF8 = bla _BOTW_LifeExtension_InitGoldenHeartsVars # savedata structure initialization area [li r31, 0]