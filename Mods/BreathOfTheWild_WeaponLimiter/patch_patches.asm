[BotwV208]
moduleMatches = 0x6267BFD0

.origin = codecave

_BOTW_WeaponLimiter_WLData:
.int (16777216*$WeaponMaxCount+65536*$BowMaxCount+256*6+$ShieldMaxCount)

_BOTW_WeaponLimiter_LookNewWeapon:
lis r28, _BOTW_WeaponLimiter_WLData@ha
addi r28, r28, _BOTW_WeaponLimiter_WLData@l
lbzx r28, r28, r26
blr

0x02EB0020 = bla _BOTW_WeaponLimiter_LookNewWeapon # Is focus weapon lootable [mr r28, r3]
0x02EB00E8 = bla _BOTW_WeaponLimiter_LookNewWeapon # Is focus bow lootable [mr r28, r3]
0x02EB0084 = bla _BOTW_WeaponLimiter_LookNewWeapon # Is focus shield lootable [mr r28, r3]