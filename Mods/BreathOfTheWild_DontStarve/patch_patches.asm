[BotwV208]
moduleMatches = 0x6267BFD0

.origin = codecave

_BOTW_DontStarve_HeartAutoRecoverIntervalMax:
.float (43200/$HeartAutoRecoverNumPerDay)
_BOTW_DontStarve_HeartAutoRecoverTimer:
.float (43200/$HeartAutoRecoverNumPerDay)
_BOTW_DontStarve_StaminaHeartTimerScaleFactor:
.float (43200/$HeartAutoRecoverNumPerDay/$StaminaHealthLoss)

_BOTW_DontStarve_UpdateStamina:
li r29, 1
bgelr
lis r30, _BOTW_DontStarve_StaminaHeartTimerScaleFactor@ha
lfs f12, _BOTW_DontStarve_StaminaHeartTimerScaleFactor@l(r30)
fmuls f12, f12, f30
lfs f13, 0x1748(r31)
fadds f13, f13, f12
stfs f13, 0x1748(r31)
blr

_BOTW_DontStarve_RecoverHeart:
lis r3, _BOTW_DontStarve_HeartAutoRecoverTimer@ha
lfs f19, _BOTW_DontStarve_HeartAutoRecoverTimer@l(r3)
fcmpu f19, f12
bgtlr
lwz r12, 0xe8(r31)
mr r3, r31
blr

_BOTW_DontStarve_SetDataMgrFlag1:
stb r11, 0x2f8(r12)
lis r12, 0x1046
lwz r12, 0x3F38(r12)
cmpwi r12, 0
beqlr
lwz r12, 0x30(r12)
lfs f19, 0x1748(r12)
lis r12, 0x101E
lfs f18, 0x7948(r12)
fcmpu f19, f18
lis r19, _BOTW_DontStarve_HeartAutoRecoverTimer@ha
bge .+0x8
fadds f19, f18, f18
stfs f19, _BOTW_DontStarve_HeartAutoRecoverTimer@l(r19)
blr

_BOTW_DontStarve_UnsetDataMgrFlag1:
stb r0, 0x2f8(r12)
lis r9, 0x1046
lwz r9, 0x3F38(r9)
cmpwi r9, 0
beqlr
lis r19, _BOTW_DontStarve_HeartAutoRecoverTimer@ha
lfs f19, _BOTW_DontStarve_HeartAutoRecoverTimer@l(r19)
lwz r9, 0x30(r9)
stfs f19, 0x1748(r9)
lis r9, 0x101E
lfs f19, 0x7948(r9)
stfs f19, _BOTW_DontStarve_HeartAutoRecoverTimer@l(r19)
blr

0x02D90CAC = bla _BOTW_DontStarve_UpdateStamina # Update stamina area [li r29, 1]
0x02d8fbe4 = bla _BOTW_DontStarve_RecoverHeart # Heart auto recover area [lwz r12, +0xe8(r31)]
0x02d8fbe8 = bgt .+0x134 # Same area as above [lwz r0, +0x664(r12)]
0x02d8fbec = lwz r0, 0x664(r12) # Same area as above [mtctr r0]
0x02d8fbf0 = mtctr r0 # Same area as above [mr r3, r31]
0x03201EDC = bla _BOTW_DontStarve_SetDataMgrFlag1 # Update flag related to samemgr|gamedatamgr when start sleep or open map|inventory|ingame weapons+runes selector (and briefly in other cases) [stb r11, +0x2f8(r12)]
0x03201F5C = bla _BOTW_DontStarve_UnsetDataMgrFlag1 # Update flag related to samemgr|gamedatamgr when stop sleep or close map|inventory|weapons|ingame weapons+runes selector (and briefly in other cases) [stb r0, +0x2f8(r12)]
0x021B7CDC = nop # Restore health after sleep area for all beds [bl 0x02D49D38]
0x02D8FC60 = lis r10, _BOTW_DontStarve_HeartAutoRecoverIntervalMax@ha # Reset heart auto recover interval area [lwz r10, +0x0(r11)]
0x02D8FC64 = lfs f11, _BOTW_DontStarve_HeartAutoRecoverIntervalMax@l(r10) # Same area as above [lfs f11, +0x20C(r10)]
# Warning: 0x02D8FC4C = cmplwi r0, 0x15 always false ???
0x02D8FCF4 = lis r12, 0x1000 # Apply heart auto recover area [lwz r12, +0x0(r10)]
0x02D8FCFC = lfs f11, 0x05F0(r12) # Same area as above [lfs f11, +0x1ec(r12)]
0x023a3358 = cmpw r0, r0 # Restore health after sleep area for beds with yellow hearts bonus [cmpwi r0, 0]
#Action/SetExtraEnergyOfPlayer 0x023a2990
#Action/EventRecoverPlayerLife 0x021B7cc0
#Action/SetExtraLifeOfPlayer 0x023a3328