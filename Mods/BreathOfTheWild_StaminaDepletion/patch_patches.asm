[BotwV208]
moduleMatches = 0x6267BFD0

.origin = codecave

_BOTW_StaminaDepletion_Float360 = 0x10004FF6
_BOTW_StaminaDepletion_Float120 = 0x10002B3A
_BOTW_StaminaDepletion_StaminaRule:
.float ($StaminaRule/43200)
.float ($StaminaRule/24) # _BOTW_StaminaDepletion_StaminaForcedDec
_BOTW_StaminaDepletion_StaminaDec:
.float 0
.float $ActionStaminaScaleFactor # _BOTW_StaminaDepletion_ActionStaminaScaleFactor
.float $SleepDepletionFactor # _BOTW_StaminaDepletion_SleepDepletionFactor

_BOTW_StaminaDepletion_UpdateRelativeStamina:
lis r28, 0x1048
lwz r28, -0x3DA8(r28)
lfs f12, 0x1C(r28)
lis r28, _BOTW_StaminaDepletion_StaminaRule@ha
lfsu f13, _BOTW_StaminaDepletion_StaminaRule@l(r28)
fmuls f13, f13, f12
lfs f12, 0x8(r28) # _BOTW_StaminaDepletion_StaminaDec
fadds f12, f12, f13
fcmpu cr0, f30, f31
bgt .+0x2C
bne .+0x10
lfs f13, 0x4(r28) # _BOTW_StaminaDepletion_StaminaForcedDec
fcmpu cr0, f12, f13
ble .+0x18
stfs f31, 0x8(r28)
lfs f13, 0xC(r28) # _BOTW_StaminaDepletion_ActionStaminaScaleFactor
fmuls f30, f30, f13
fsubs f30, f30, f12
blr
fcmpu cr0, f30, f31
stfs f12, 0x8(r28)
blr

_BOTW_StaminaDepletion_PassTime:
lfs f7, 0x98(r30)
fsubs f7, f13, f7
lis r9, 0x101E
lfs f1, 0x5360(r9)
fcmpu cr0, f7, f1
bge .+0x10
lis r9, _BOTW_StaminaDepletion_Float360@ha
lfs f1, _BOTW_StaminaDepletion_Float360@l(r9)
fadds f7, f7, f1
lis r9, _BOTW_StaminaDepletion_Float120@ha
lfs f1, _BOTW_StaminaDepletion_Float120@l(r9)
fmuls f7, f7, f1
lis r9, _BOTW_StaminaDepletion_StaminaRule@ha
lfsu f1, _BOTW_StaminaDepletion_StaminaRule@l(r9)
fmuls f7, f7, f1
lfs f1, 0x10(r9) # _BOTW_StaminaDepletion_SleepDepletionFactor
fmuls f7, f7, f1
lfs f1, 0x8(r9)
fadds f7, f7, f1
stfs f7, 0x8(r9) # _BOTW_StaminaDepletion_StaminaDec update
lis r9, 0x1030
blr

_BOTW_StaminaDepletion_InitInventoryGoldenStamina:
stfs f1, 0x1D34(r31)
fcmpu cr0, f1, f31
bgtlr
lis r3, 0x1046
lwz r3, 0x3F38(r3)
lfs f21, 0x68(r3)
fcmpu cr0, f21, f31
bgtlr
lis r3, _BOTW_StaminaDepletion_StaminaDec@ha
stfs f31, _BOTW_StaminaDepletion_StaminaDec@l(r3)
blr

_BOTW_StaminaDepletion_InitStaminaDepletionVars:
li r31, 0
lis r3, _BOTW_StaminaDepletion_StaminaDec@ha
stw r31, _BOTW_StaminaDepletion_StaminaDec@l(r3)
blr

0x02D90C08 = bla _BOTW_StaminaDepletion_UpdateRelativeStamina # Stamina update area [fcmpu cr0, f30, f31]
0x02FE6800 = bla _BOTW_StaminaDepletion_InitInventoryGoldenStamina # init inventory golden stamina [stfs f1, +0x1D34(r31)]
0x0322CD58 = bla _BOTW_StaminaDepletion_InitStaminaDepletionVars # savedata structure initialization area [li r31, 0]
0x0365FA10 = bla _BOTW_StaminaDepletion_PassTime # Time of day update after sleep (campfire included) [lis r9, 0x1030]