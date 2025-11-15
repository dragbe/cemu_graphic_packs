[BotwV208]
moduleMatches = 0x6267BFD0

.origin = codecave

_BOTW_FakeRupees_RupeeUpdateOnLoot:
cmpwi r3, $RedPotionRupeeValue
bne .+0x24 # if (RupeeValue!=$RedPotionRupeeValue) GOTO cmpwi r3, $VanillaMaxRupeeValue
_BOTW_FakeRupees_HealthUpdate:
lis r6, 0x1046
lwz r6, 0x3F38(r6)
lwz r6, 0x30(r6)
lwz r5, 0x540(r6)
addi r5, r5, $RedPotionRupeeValue
stw r5, 0x540(r6) # strategic area in the vanilla code for health update (0x02D8F520>0x02D49A3C)
cmpwi r5, 0
blr
cmpwi r3, $VanillaMaxRupeeValue
bgt .+0x14 # if (RupeeValue>$VanillaMaxRupeeValue) GOTO lis r12, $DataLayerMemoryBase
mr r31, r3
li r3, 1
cmpwi r3, 1
blr
_BOTW_FakeRupees_UpdateFakeRupeeSaveData:
lis r12, $DataLayerMemoryBase
lwzux r6, r12, r3
lwz r3, 0xC(r6)
lwz r5, 0x14(r6)
sub r3, r5, r3
lwz r5, 0x10(r6)
cmpw r3, r5
ble .+0x8
mr r3, r5
stw r3, 0x14(r6)
lwz r6, 0x4(r12)
stw r3, 0x4(r6)
cmpwi r3, 0
blr

_BOTW_FakeRupees_LootRupee:
lhz r6, 0x3(r4)
cmpwi r6, 21109
bne .+0x10 # if (RupeeActorName.substr(3,2)!="Ru") GOTO cmpwi r6, $AncientCrystalId
lis r3, 0x1047
lwz r3, -0x357C(r3)
blr
cmpwi r6, $AncientCrystalId
bne .+0xC # if (FakeRupeeActorName.substr(3,2)!="An") GOTO cmpwi r6, $MasterKeyId
li r3, $AncientCrystalRupeeValue
b _BOTW_FakeRupees_UpdateFakeRupeeSaveData
cmpwi r6, $MasterKeyId
bne .+0xC # if (FakeRupeeActorName.substr(3,2)!="Ma") GOTO cmpwi r6, $RedPotionId
li r3, $MasterKeyRupeeValue
b _BOTW_FakeRupees_UpdateFakeRupeeSaveData
cmpwi r6, $RedPotionId
bnelr # if (FakeRupeeActorName.substr(3,2)!="Re") EXITSUB
b _BOTW_FakeRupees_HealthUpdate

#0x02B769DC = bl 0x02B621E4 To be considered as isRupeeItem
0x02B7657C = bla _BOTW_FakeRupees_RupeeUpdateOnLoot # Rupee update on loot area [mr r31, r3]
0x02B76584 = bne .+0x20 # [li r3, 1]
0x02B76B68 = lwz r4, 0x0(r30) # Loot rupee (treasure chest, mini game, rewards, ...) area [lis r3, 0x1047]
0x02B76B6C = bla _BOTW_FakeRupees_LootRupee # [lwz r4, +0x0(r30)]
0x02B76B70 = bne .+0xC # [lwz r3, -0x357C(r3)]
#0x02B76B74 = bl 0x0310da00 return RupeeActorName.rupeeRupeeValue but not designed for the fake rupees
#0x02B77078 = lwz r3, +0x2C(r6) Executed on auto loot rupee

#Usable code if all rupee update areas are patches with custom save code
#0x02B76570 = lis r12, $DataLayerMemoryBase # [mflr r0]
#0x02B76574 = cmpwi r3, $VanillaMaxRupeeValue # [stwu r1, -0x10(r1)]
#0x02B76578 = bgt .+0xC # if (RupeeValue>$VanillaMaxRupeeValue) GOTO lwzux r6, r12, r3 [stw r31, +0xC(r1)]
#0x02B7657C = lwzu r6, 0x54(r12) # [mr r31, r3]
#0x02B76580 = b .+0x14 # GOTO lwz r5, 0x14(r6) [stw r0, +0x14(r1)]
#0x02B76584 = lwzux r6, r12, r3 # [li r3, 1]
#0x02B76588 = lwz r3, 0xC(r6) # GOTO lwz r5, 0x14(r3) [bl 0x03074240]
#0x02B76590 = sub r3, r4, r3 # RupeeValue=0-'Fake rupee custom s32_data'.MinValue [mr r3, r31]
#0x02B76594 = lwz r5, 0x14(r6) # [bl 0x02E17F58]
#0x02B76598 = add r3, r5, r3 # [li r4, 0]
#0x02B7659C = lwz r5, 0x10(r6) # [mr r3, r31]
#0x02B765A0 = cmpw r3, r5 # if (s32_data.Value+RupeeValue > s32_data.MaxValue) EXITSUB, s32_data=CurrentRupee or Fake rupee custom s32_data [bl 0x02E17FB8]
#0x02B765A4 = bgtlr # Intentional minor bug since the number of rupee is not always set to its maximum value when it exceeds it [lwz r0, +0x14(r1)]
#0x02B765A8 = stw r3, 0x14(r6) # [mtlr r0]
#0x02B765AC = lwz r6, 0x4(r12) # [lwz r31, +0xC(r1)]
#0x02B765B0 = stw r3, 0x4(r6) # [addi r1, r1, 0x10]