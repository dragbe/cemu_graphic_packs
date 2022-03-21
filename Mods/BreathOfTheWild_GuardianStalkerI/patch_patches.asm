[BotwV208]
moduleMatches = 0x6267BFD0

.origin = codecave

_BOTW_GuardianStalkerI_GuardianStalkerId:
.int 1634623297 # an_A

_BOTW_GuardianStalkerI_SetRuneCrosshairTargetId:
lwz r3, 0x8(r1)
lwz r4, 0x368(r31)
xori r4, r4, 256
cmpwi r4, 257
bltlr
lis r18, _BOTW_GuardianStalkerI_GuardianStalkerId@ha
lwz r18, _BOTW_GuardianStalkerI_GuardianStalkerId@l(r18)
lwz r4, 0x16(r3)
cmpw r4, r18
beq .+0x30
lwz r4, 0x1C(r3)
cmpw r4, r18
bnelr
lwz r4, 0x720(r3)
cmpw r4, r18
beqlr
lwz r4, 0x848(r3)
cmpwi r4, -1
beq .+0xC
stw r18, 0x720(r3)
blr
li r3, 0
stw r3, 0x8(r1)
blr

_BOTW_GuardianStalkerI_ResetGuardianAwareness:
lis r8, _BOTW_GuardianStalkerI_GuardianStalkerId@ha
lwz r8, _BOTW_GuardianStalkerI_GuardianStalkerId@l(r8)
lwz r7, -0x828(r3)
cmpw r7, r8
lwz r7, 0xf38(r29)
bnelr
stw r8, -0x124(r3)
blr

0x02A2C20C = bla _BOTW_GuardianStalkerI_SetRuneCrosshairTargetId # set Rune Crosshair Target's ID area [lwz r3, +0x8(r1)]
0x02049ac4 = bla _BOTW_GuardianStalkerI_ResetGuardianAwareness # reset Guardian Awareness area [lwz r7, +0xf38(r29)]