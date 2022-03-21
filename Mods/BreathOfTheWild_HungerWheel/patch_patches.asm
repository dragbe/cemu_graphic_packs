[BotwV208]
moduleMatches = 0x6267BFD0

.origin = codecave

_BOTW_HungerWheel_Float2000 = 0x10013490
_BOTW_HungerWheel_Float360 = 0x10004FF6
_BOTW_HungerWheel_Float120 = 0x10002B3A
_BOTW_HungerWheel_Float.001 = 0x10007D5C
_BOTW_HungerWheel_StaminaRule:
.float ($StaminaRule/43200)
.float ($StaminaRule/24) # _BOTW_HungerWheel_StaminaForcedDec
_BOTW_HungerWheel_StaminaDec:
.float 0
_BOTW_HungerWheel_CurrentStamina:
.float -1
_BOTW_HungerWheel_StaminaAutoRecover:
.int 1
.float $StaminaHungerFactor # _BOTW_HungerWheel_StaminaHungerFactor
.float $SleepHungerFactor # _BOTW_HungerWheel_SleepHungerFactor
_BOTW_HungerWheel_StaminaScaleFactor:
.float (2000/$MaxYellowStamina)

_BOTW_HungerWheel_UpdateUiStaminaGauge:
lfs f12, 0x68(r3)
fcmpu cr0, f29, f12
lis r4, _BOTW_HungerWheel_CurrentStamina@ha
addi r4, r4, _BOTW_HungerWheel_CurrentStamina@l
bge .+0x20
lwz r3, 0x4(r4) # _BOTW_HungerWheel_StaminaAutoRecover
cmpwi r3, 1
beq .+0x14
lis r3, _BOTW_HungerWheel_Float.001@ha
lfs f12, _BOTW_HungerWheel_Float.001@l(r3)
fadds f1, f29, f12
stfs f1, 0x1324(r12)
fcmpu cr0, f29, f1
stfs f1, 0x0(r4)
blr

_BOTW_HungerWheel_RecoverStamina:
lis r3, _BOTW_HungerWheel_StaminaAutoRecover@ha
lwz r3, _BOTW_HungerWheel_StaminaAutoRecover@l(r3)
cmpwi r3, 1
beq .+0x14
fcmpu cr0, f29, f31
bne .+0xC
fmr f9, f31
blr
lfs f9, 0x12C(r10)
blr

_BOTW_HungerWheel_RestoreUiGauge:
lis r12, 0x1046
lwz r12, 0x3F38(r12)
lfs f31, 0x6C(r12)
lis r12, 0x1047
lwz r12, -0x4228(r12)
stfs f31, 0x2C(r12)
lis r12, _BOTW_HungerWheel_CurrentStamina@ha
stfs f1, _BOTW_HungerWheel_CurrentStamina@l(r12)
stfs f1, 0x1d2c(r31)
blr

_BOTW_HungerWheel_ResetUiStaminaGauge:
mr r3, r31
lis r4, _BOTW_HungerWheel_StaminaAutoRecover@ha
lwzu r17, _BOTW_HungerWheel_StaminaAutoRecover@l(r4)
cmpwi r17, 1
beqlr
lis r17, 0x101E
lfs f1, 0x5360(r17)
lfs f30, -0x4(r4)
fcmpu cr0, f30, f1
bltlr
lis r17, _BOTW_HungerWheel_Float.001@ha
lfs f1, _BOTW_HungerWheel_Float.001@l(r17)
bne .+0x14
fadds f30, f30, f1
stfs f30, -0x4(r4) # _BOTW_HungerWheel_CurrentStamina update
stfs f30, 0x1324(r12)
blr
stfs f30, 0x1324(r12)
fsubs f30, f30, f1
stfs f30, 0x68(r3)
blr

_BOTW_HungerWheel_UpdateInventoryStamina:
lis r12, _BOTW_HungerWheel_CurrentStamina@ha
stfs f12, _BOTW_HungerWheel_CurrentStamina@l(r12)
stfs f12, 0x1d2c(r30)
blr

_BOTW_HungerWheel_RestoreFullStamina:
lis r3, _BOTW_HungerWheel_Float.001@ha
lfs f20, _BOTW_HungerWheel_Float.001@l(r3)
mr r3, r31
fcmpu cr0, f1, f20
bnelr
fsubs f1, f1, f20
blr

_BOTW_HungerWheel_UpdateRelativeStamina:
lis r28, 0x1048
lwz r28, -0x3DA8(r28)
lfs f12, 0x1C(r28)
lis r28, _BOTW_HungerWheel_StaminaRule@ha
lfsu f13, _BOTW_HungerWheel_StaminaRule@l(r28)
fmuls f13, f13, f12
lfs f12, 0x8(r28)
fadds f12, f12, f13
stfs f12, 0x8(r28) # _BOTW_HungerWheel_StaminaDec update
fcmpu cr0, f30, f31
bgtlr
bne .+0x10
lfs f13, 0x4(r28) # _BOTW_HungerWheel_StaminaForcedDec
fcmpu cr0, f12, f13
ble .+0xC
fsubs f30, f30, f12
blr
fcmpu cr0, f30, f31
blr

_BOTW_HungerWheel_UpdateStamina:
lis r12, _BOTW_HungerWheel_StaminaDec@ha
lfsu f29, _BOTW_HungerWheel_StaminaDec@l(r12)
stfs f31, 0x0(r12)
lfs f12, 0x1a28(r31)
lfs f22, 0x14(r12) # _BOTW_HungerWheel_StaminaScaleFactor
fmuls f13, f22, f29
fsubs f13, f12, f13
bgt .+0x3C
fadds f30, f30, f29
lfs f29, 0xC(r12) # _BOTW_HungerWheel_StaminaHungerFactor
fmuls f29, f29, f30
fmuls f29, f29, f22
fadds f13, f13, f29
fadds f29, f1, f30
fcmpu cr0, f29, f31
bge .+0x8
fmr f29, f31
fcmpu cr0, f13, f31
bgtlr
stfs f31, 0x8(r12) # _BOTW_HungerWheel_StaminaAutoRecover
fmr f13, f31
blr
fcmpu cr0, f13, f31
bgt .+0x28
fmr f13, f31
stfs f31, 0x8(r12)
lis r3, _BOTW_HungerWheel_Float.001@ha
lfs f30, _BOTW_HungerWheel_Float.001@l(r3)
fsubs f29, f1, f30
fcmpu cr0, f29, f31
bgelr
fmr f29, f31
blr
fadds f29, f1, f30
blr

_BOTW_HungerWheel_PassTime:
lfs f7, 0x98(r30)
fsubs f7, f13, f7
lis r9, 0x101E
lfs f1, 0x5360(r9)
fcmpu cr0, f7, f1
bge .+0x10
lis r9, _BOTW_HungerWheel_Float360@ha
lfs f1, _BOTW_HungerWheel_Float360@l(r9)
fadds f7, f7, f1
lis r9, _BOTW_HungerWheel_Float120@ha
lfs f1, _BOTW_HungerWheel_Float120@l(r9)
fmuls f7, f7, f1
lis r9, _BOTW_HungerWheel_StaminaRule@ha
lfsu f1, _BOTW_HungerWheel_StaminaRule@l(r9)
fmuls f7, f7, f1
lfs f1, 0x18(r9) # _BOTW_HungerWheel_SleepHungerFactor
fmuls f7, f7, f1
lfs f1, 0x8(r9)
fadds f7, f7, f1
stfs f7, 0x8(r9) # _BOTW_HungerWheel_StaminaDec update
lis r9, 0x1030
blr

_BOTW_HungerWheel_EnableStaminaAutoRecover:
fcmpu cr0, f8, f31
bne .+0xC
lis r3, _BOTW_HungerWheel_StaminaDec@ha
stfs f31, _BOTW_HungerWheel_StaminaDec@l(r3)
li r12, 1
lis r3, _BOTW_HungerWheel_StaminaAutoRecover@ha
stw r12, _BOTW_HungerWheel_StaminaAutoRecover@l(r3)
lis r3, 0x1046
lwz r3, 0x3f38(r3)
lwz r12, 0x30(r3)
cmpwi r12, 0
beq .+0xC
lfs f1, 0x6C(r3)
stfs f1, 0x1324(r12)
fcmpu cr0, f0, f31
blr

_BOTW_HungerWheel_UpdateInventoryYellowStamina:
lfs f1, 0x18(r1)
lis r3, _BOTW_HungerWheel_StaminaScaleFactor@ha
lfs f0, _BOTW_HungerWheel_StaminaScaleFactor@l(r3)
fmuls f1, f1, f0
fadds f1, f1, f12
lis r3, _BOTW_HungerWheel_Float2000@ha
lfs f0, _BOTW_HungerWheel_Float2000@l(r3)
fcmpu cr0, f1, f0
ble .+0x8
fmr f1, f0
stfs f1, 0x18(r1)
blr

_BOTW_HungerWheel_UpdateInventoryYellowStaminaPreview:
lis r9, _BOTW_HungerWheel_StaminaScaleFactor@ha
lfs f0, _BOTW_HungerWheel_StaminaScaleFactor@l(r9)
fmuls f1, f1, f0
fadds f1, f1, f13
blr

_BOTW_HungerWheel_LimitInventoryYellowStaminaPreview:
lis r9, _BOTW_HungerWheel_Float2000@ha
lfs f0, _BOTW_HungerWheel_Float2000@l(r9)
fcmpu cr0, f1, f0
blelr
fmr f1, f0
blr

_BOTW_HungerWheel_LimitYellowStamina:
lis r3, _BOTW_HungerWheel_Float2000@ha
lfs f1, _BOTW_HungerWheel_Float2000@l(r3)
lfs f13, 0x1a28(r31)
fcmpu cr0, f13, f1
lfs f13, 0x20(r30)
blelr
stfs f1, 0x1a28(r31)
blr

0x02ff15CC = lfs f12, 0x1d34(r31) # Inventory yellow stamina update by eating cooked foods [lfs f1, +0x18(r1)]
0x02ff15D0 = bla _BOTW_HungerWheel_UpdateInventoryYellowStamina # [lfs f12, +0x1d34(r31)]
0x02fe1778 = bla _BOTW_HungerWheel_UpdateInventoryYellowStaminaPreview # Inventory yellow stamina preview update area [fcmpu cr0, f13, f1]
0x02fe1784 = bla _BOTW_HungerWheel_LimitInventoryYellowStaminaPreview # [bge 0x02fe17cc]
0x02d9d5BC = bla _BOTW_HungerWheel_LimitYellowStamina # Yellow stamina update on inventory close or on NPC rewards [lfs f13, +0x20(r30)]
0x02D90DC4 = bla _BOTW_HungerWheel_UpdateUiStaminaGauge # update UI stamina gauge area [fcmpu cr0, f29, f1]
0x02D90D84 = bla _BOTW_HungerWheel_RecoverStamina # stamina auto recover area [lfs f9, +0x12C(r10)]
0x02D5935c = bla _BOTW_HungerWheel_ResetUiStaminaGauge # reset UI stamina gauge area [mr r3, r31]
0x02FE67F0 = bla _BOTW_HungerWheel_RestoreUiGauge # inventory stamina initialization area [stfs f1, +0x1d2c(r31)]
0x02FE43F8 = bla _BOTW_HungerWheel_UpdateInventoryStamina # update inventory stamina [stfs f12, +0x1d2c(r30)]
0x02D37C74 = bla _BOTW_HungerWheel_RestoreFullStamina # restore full stamina area [mr r3, r31]
0x02FE4394 = bla _BOTW_HungerWheel_UpdateInventoryStamina # update inventory stamina by eating foods with yellow stamina bonus [stfs f12, +0x1d2c(r30)]
0x02D90C08 = bla _BOTW_HungerWheel_UpdateRelativeStamina # Stamina update area [fcmpu cr0, f30, f31]
0x02D90CC0 = nop # stamina update area [fadds f29, f1, f30]
0x02D90CC4 = nop # [fcmpu cr0, f29, f31]
0x02D90CC8 = nop # [bge 0x02d90ce8]
0x02D90CCC = nop # [lfs f12, +0x1a28(r31)]
0x02D90CD0 = bla _BOTW_HungerWheel_UpdateStamina # [fadds f13, f12, f29]
0x02D90CD4 = nop # [fcmpu cr0, f13, f31]
0x02D90CD8 = nop # [bge 0x02d90ce0]
0x02D90CDC = nop # [fmr f13, f31]
0x02D90CE0 = nop # [fmr f29, f31]
0x02D90878 = fcmpu cr0, f31, f31 # Update UI extra stamina gauge area
0x02D9D5D0 = bla _BOTW_HungerWheel_EnableStaminaAutoRecover # Extra stamina bonus update area [fcmpu cr0, f0, f31]
0x0365FA10 = bla _BOTW_HungerWheel_PassTime # Time of day update after sleep (campfire included) [lis r9, 0x1030]