[BotwV208]
moduleMatches = 0x6267BFD0

.origin = codecave

_BOTW_Staminax_Float2000 = 0x10013490
_BOTW_Staminax_StaminaScaleFactor:
.float (2000/$MaxYellowStamina)

_BOTW_Staminax_UpdateInventoryYellowStamina:
lfs f1, 0x18(r1)
lis r3, _BOTW_Staminax_StaminaScaleFactor@ha
lfs f0, _BOTW_Staminax_StaminaScaleFactor@l(r3)
fmuls f1, f1, f0
fadds f1, f1, f12
lis r3, _BOTW_Staminax_Float2000@ha
lfs f0, _BOTW_Staminax_Float2000@l(r3)
fcmpu cr0, f1, f0
ble .+0x8
fmr f1, f0
stfs f1, 0x18(r1)
blr

_BOTW_Staminax_UpdateInventoryYellowStaminaPreview:
lis r9, _BOTW_Staminax_StaminaScaleFactor@ha
lfs f0, _BOTW_Staminax_StaminaScaleFactor@l(r9)
fmuls f1, f1, f0
fadds f1, f1, f13
blr

_BOTW_Staminax_LimitInventoryYellowStaminaPreview:
lis r9, _BOTW_Staminax_Float2000@ha
lfs f0, _BOTW_Staminax_Float2000@l(r9)
fcmpu cr0, f1, f0
blelr
fmr f1, f0
blr

_BOTW_Staminax_UpdateYellowStamina:
lis r3, _BOTW_Staminax_StaminaScaleFactor@ha
lfs f13, _BOTW_Staminax_StaminaScaleFactor@l(r3)
fmuls f13, f13, f29
fadds f13, f13, f12
blr

_BOTW_Staminax_LimitYellowStamina:
lis r3, _BOTW_Staminax_Float2000@ha
lfs f1, _BOTW_Staminax_Float2000@l(r3)
lfs f13, 0x1a28(r31)
fcmpu cr0, f13, f1
lfs f13, 0x20(r30)
blelr
stfs f1, 0x1a28(r31)
blr

0x02ff15CC = lfs f12, 0x1d34(r31) # Inventory yellow stamina update by eating cooked foods [lfs f1, +0x18(r1)]
0x02ff15D0 = bla _BOTW_Staminax_UpdateInventoryYellowStamina # [lfs f12, +0x1d34(r31)]
0x02fe1778 = bla _BOTW_Staminax_UpdateInventoryYellowStaminaPreview # Inventory yellow stamina preview update area [fcmpu cr0, f13, f1]
0x02fe1784 = bla _BOTW_Staminax_LimitInventoryYellowStaminaPreview # [bge 0x02fe17cc]
0x02D90CD0 = bla _BOTW_Staminax_UpdateYellowStamina # Yellow stamina update area [fadds f13, f12, f29]
0x02d9d5BC = bla _BOTW_Staminax_LimitYellowStamina # Yellow stamina update on inventory close or on NPC rewards [lfs f13, +0x20(r30)]