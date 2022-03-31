[BotwV208]
moduleMatches = 0x6267BFD0

.origin = codecave

_BOTW_RawStamina_Float2000 = 0x10013490
_BOTW_RawStamina_Float.001 = 0x10007D5C
_BOTW_RawStamina_Floatneg1 = 0x100005F0
_BOTW_RawStamina_CurrentStamina:
.float -1
_BOTW_RawStamina_StaminaScaleFactor:
.float (2000/$MaxYellowStamina)

_BOTW_RawStamina_UpdateUiStaminaGauge:
lfs f12, 0x68(r3)
fcmpu cr0, f29, f12
bge .+0x14
lis r3, _BOTW_RawStamina_Float.001@ha
lfs f12, _BOTW_RawStamina_Float.001@l(r3)
fadds f1, f29, f12
stfs f1, 0x1324(r12)
fcmpu cr0, f29, f1
lis r3, _BOTW_RawStamina_CurrentStamina@ha
stfs f1, _BOTW_RawStamina_CurrentStamina@l(r3)
blr

_BOTW_RawStamina_RecoverStamina:
fcmpu cr0, f29, f31
bne .+0xC
fmr f9, f31
blr
lfs f9, 0x12C(r10)
blr

_BOTW_RawStamina_RestoreUiGauge:
lis r12, 0x1046
lwz r12, 0x3F38(r12)
lfs f31, 0x6C(r12)
lis r12, 0x1047
lwz r12, -0x4228(r12)
stfs f31, 0x2C(r12)
lis r12, _BOTW_RawStamina_CurrentStamina@ha
stfs f1, _BOTW_RawStamina_CurrentStamina@l(r12)
stfs f1, 0x1d2c(r31)
blr

_BOTW_RawStamina_ResetUiStaminaGauge:
mr r3, r31
lis r17, 0x101E
lfs f1, 0x5360(r17)
lis r4, _BOTW_RawStamina_CurrentStamina@ha
lfs f30, _BOTW_RawStamina_CurrentStamina@l(r4)
fcmpu cr0, f30, f1
bltlr
lis r17, _BOTW_RawStamina_Float.001@ha
lfs f1, _BOTW_RawStamina_Float.001@l(r17)
bne .+0x14
fadds f30, f30, f1
stfs f30, _BOTW_RawStamina_CurrentStamina@l(r4)
stfs f30, 0x1324(r12)
blr
stfs f30, 0x1324(r12)
fsubs f30, f30, f1
stfs f30, 0x68(r3)
blr

_BOTW_RawStamina_UpdateInventoryStamina:
lis r12, _BOTW_RawStamina_CurrentStamina@ha
stfs f12, _BOTW_RawStamina_CurrentStamina@l(r12)
stfs f12, 0x1d2c(r30)
blr

_BOTW_RawStamina_ResetStamina:
lis r10, _BOTW_RawStamina_Floatneg1@ha
lfs f31, _BOTW_RawStamina_Floatneg1@l(r10)
lis r10, _BOTW_RawStamina_CurrentStamina@ha
stfs f31, _BOTW_RawStamina_CurrentStamina@l(r10)
lwz r10, 0x10(r30)
blr

_BOTW_RawStamina_InitStamina:
lis r3, _BOTW_RawStamina_CurrentStamina@ha
lfs f19, _BOTW_RawStamina_CurrentStamina@l(r3)
lis r18, _BOTW_RawStamina_Floatneg1@ha
lfs f20, _BOTW_RawStamina_Floatneg1@l(r18)
stfs f1, 0x68(r31)
fcmpu cr0, f19, f20
bnelr
stfs f1, _BOTW_RawStamina_CurrentStamina@l(r3)
blr

_BOTW_RawStamina_RestoreFullStamina:
lis r3, _BOTW_RawStamina_Float.001@ha
lfs f20, _BOTW_RawStamina_Float.001@l(r3)
mr r3, r31
fcmpu cr0, f1, f20
bnelr
fsubs f1, f1, f20
blr

_BOTW_RawStamina_UpdateStamina:
bge .+0x60
lfs f12, 0x1A28(r31)
fcmpu cr0, f12, f31
beq .+0x24
lis r12, _BOTW_RawStamina_StaminaScaleFactor@ha
lfs f22, _BOTW_RawStamina_StaminaScaleFactor@l(r12)
fmuls f30, f30, f22
fadds f13, f12, f30
fcmpu cr0, f13, f31
bge .+0x24
stfs f31, 0x1A28(r31)
fdivs f30, f13, f22
lfs f1, 0x68(r3)
fadds f29, f1, f30
fcmpu cr0, f29, f31
bgelr
fmr f29, f31
blr
lfs f1, 0x6C(r3)
lis r3, _BOTW_RawStamina_Float.001@ha
lfs f29, _BOTW_RawStamina_Float.001@l(r3)
fsubs f29, f1, f29
stfs f13, 0x1A28(r31)
blr
lfs f1, 0x68(r3)
fadds f29, f1, f30
blr

_BOTW_RawStamina_UpdateInventoryYellowStamina:
lfs f1, 0x18(r1)
lis r3, _BOTW_RawStamina_StaminaScaleFactor@ha
lfs f0, _BOTW_RawStamina_StaminaScaleFactor@l(r3)
fmuls f1, f1, f0
fadds f1, f1, f12
lis r3, _BOTW_RawStamina_Float2000@ha
lfs f0, _BOTW_RawStamina_Float2000@l(r3)
fcmpu cr0, f1, f0
ble .+0x8
fmr f1, f0
stfs f1, 0x18(r1)
blr

_BOTW_RawStamina_UpdateInventoryYellowStaminaPreview:
lis r9, _BOTW_RawStamina_StaminaScaleFactor@ha
lfs f0, _BOTW_RawStamina_StaminaScaleFactor@l(r9)
fmuls f1, f1, f0
fadds f1, f1, f13
blr

_BOTW_RawStamina_LimitInventoryYellowStaminaPreview:
lis r9, _BOTW_RawStamina_Float2000@ha
lfs f0, _BOTW_RawStamina_Float2000@l(r9)
fcmpu cr0, f1, f0
blelr
fmr f1, f0
blr

_BOTW_RawStamina_LimitYellowStamina:
lis r3, _BOTW_RawStamina_Float2000@ha
lfs f1, _BOTW_RawStamina_Float2000@l(r3)
lfs f13, 0x1a28(r31)
fcmpu cr0, f13, f1
lfs f13, 0x20(r30)
blelr
stfs f1, 0x1a28(r31)
blr

0x02ff15CC = lfs f12, 0x1d34(r31) # Inventory yellow stamina update by eating cooked foods [lfs f1, +0x18(r1)]
0x02ff15D0 = bla _BOTW_RawStamina_UpdateInventoryYellowStamina # [lfs f12, +0x1d34(r31)]
0x02fe1778 = bla _BOTW_RawStamina_UpdateInventoryYellowStaminaPreview # Inventory yellow stamina preview update area [fcmpu cr0, f13, f1]
0x02fe1784 = bla _BOTW_RawStamina_LimitInventoryYellowStaminaPreview # [bge 0x02fe17cc]
0x02d9d5BC = bla _BOTW_RawStamina_LimitYellowStamina # Yellow stamina update on inventory close or on NPC rewards [lfs f13, +0x20(r30)]
0x02D90DC4 = bla _BOTW_RawStamina_UpdateUiStaminaGauge # update UI stamina gauge area [fcmpu cr0, f29, f1]
0x02D90D84 = bla _BOTW_RawStamina_RecoverStamina # stamina auto recover area [lfs f9, +0x12C(r10)]
0x02D5935c = bla _BOTW_RawStamina_ResetUiStaminaGauge # reset UI stamina gauge area [mr r3, r31]
0x02FE67F0 = bla _BOTW_RawStamina_RestoreUiGauge # inventory stamina initialization area [stfs f1, +0x1d2c(r31)]
0x02FE43F8 = bla _BOTW_RawStamina_UpdateInventoryStamina # update inventory stamina [stfs f12, +0x1d2c(r30)]
0x0322CCF4 = bla _BOTW_RawStamina_ResetStamina # savedata structure initialization area [lwz r10, +0x10(r30)]
0x02D49DE4 = bla _BOTW_RawStamina_InitStamina # restore full stamina or load saved stamina [stfs f1, +0x68(r31)]
0x02D37C74 = bla _BOTW_RawStamina_RestoreFullStamina # restore full stamina area [mr r3, r31]
0x02FE4394 = bla _BOTW_RawStamina_UpdateInventoryStamina # update inventory stamina by eating foods with yellow stamina bonus [stfs f12, +0x1d2c(r30)]
0x02D90CBC = nop # stamina update area [bl 0x02d49dc0]
0x02D90CC0 = nop # [fadds f29, f1, f30]
0x02D90CC4 = nop # [fcmpu cr0, f29, f31]
0x02D90CC8 = nop # [bge 0x02d90ce8]
0x02D90CCC = nop # [lfs f12, +0x1a28(r31)]
0x02D90CD0 = bla _BOTW_RawStamina_UpdateStamina # [fadds f13, f12, f29]
0x02D90CD4 = nop # [fcmpu cr0, f13, f31]
0x02D90CD8 = nop # [bge 0x02d90ce0]
0x02D90CDC = nop # [fmr f13, f31]
0x02D90CE0 = nop # [fmr f29, f31]
0x02D90CE4 = nop # [stfs f13, +0x1A28(r31)]