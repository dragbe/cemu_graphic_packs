[BotwV208]
moduleMatches = 0x6267BFD0

.origin = codecave

_BOTW_NoFlurryRush_StartFlurryRush:
stfs f31, 0x1304(r5)
lis r7, 0x1055
lhz r8, -0x990(r7)
cmpwi r8, 0x4475
bne .+0x18 # if (PlayerPosMapName.substr(0,2)!="Du") GOTO lis r6, 0x101E or if (*((int16 *) pPlayerPosMapName)!=0x4475) GOTO lis r6, 0x101E
li r8, 0x3939
addis r8, r8, 0x6E30
lwz r7, -0x98A(r7)
cmpw r7, r8
beqlr # if (PlayerPosMapName.substr(6,4)=="n099") EXITSUB or if (*((int32 *) (pPlayerPosMapName+6))!=0x6E303939) EXITSUB
lis r6, 0x101E
addi r6, r6, 0x5360
blr

0x02CD081C = lwz r5, 0x0(r29) # Start SideStep flurry rush area, also executed before shield surfing with f12=1.0 [lfs f12, +0x0(r6)]
0x02CD0820 = bla _BOTW_NoFlurryRush_StartFlurryRush # [lwz r5, +0x0(r29)]
0x02CD0824 = lfs f12, 0x0(r6) # [stfs f12, +0x12FC(r5)]
0x02CD082C = stfs f12, 0x12FC(r5) # [stfs f31, +0x1304(r5)]
0x02C625B0 = bla _BOTW_NoFlurryRush_StartFlurryRush # Start BackJump flurry rush area [lfs f0, +0x0(r6)]
0x02C625B4 = lfs f0, 0x0(r6) # [stfs f31, +0x1304(r5)]