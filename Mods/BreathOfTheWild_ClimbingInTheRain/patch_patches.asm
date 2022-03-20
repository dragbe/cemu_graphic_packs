[BotwV208]
moduleMatches = 0x6267BFD0

.origin = codecave

_BOTW_ClimbingInTheRain_ArmorSetBonus:
.int 0

_BOTW_ClimbingInTheRain_InitArmorSetBonus:
lis r31, _BOTW_ClimbingInTheRain_ArmorSetBonus@ha
stw r0, _BOTW_ClimbingInTheRain_ArmorSetBonus@l(r31)
mr r31, r3
blr

_BOTW_ClimbingInTheRain_EnableClimbingArmorSetBonus:
lis r26, _BOTW_ClimbingInTheRain_ArmorSetBonus@ha
stw r9, _BOTW_ClimbingInTheRain_ArmorSetBonus@l(r26)
stw r9, 0x0(r29)
blr

_BOTW_ClimbingInTheRain_ClimbWithoutSlip:
cmpwi r3, 0
beqlr
lis r3, _BOTW_ClimbingInTheRain_ArmorSetBonus@ha
lwz r3, _BOTW_ClimbingInTheRain_ArmorSetBonus@l(r3)
rlwinm r3, r3, 0, 23, 23
cmpwi r3, 256
blr

_BOTW_ClimbingInTheRain_UpdateLateralClimbingBonus:
rlwinm r3, r3, 0, 31, 31
cmpwi r3, 0
bne .+0x14
lis r3, _BOTW_ClimbingInTheRain_ArmorSetBonus@ha
lwz r3, _BOTW_ClimbingInTheRain_ArmorSetBonus@l(r3)
rlwinm r3, r3, 24, 31, 31
stb r3, 0x1AA3(r29)
addi r3, r29, 0x1D94
blr

0x0328EB9C = bla _BOTW_ClimbingInTheRain_InitArmorSetBonus # Init armor set bonus [mr r31, r3]
0x033A1E84 = bla _BOTW_ClimbingInTheRain_EnableClimbingArmorSetBonus # Enable climbing armor set bonus [stw r9, +0x0(r29)]
0x03343d40 = bla _BOTW_ClimbingInTheRain_ClimbWithoutSlip # check if climbing in the rain [cmpwi r3, 0]
0x02D59564 = bla _BOTW_ClimbingInTheRain_UpdateLateralClimbingBonus # lateral climbing bonus update area [addi r3, r29, 0x1D94]