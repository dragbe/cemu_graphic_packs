[BotwV208]
moduleMatches = 0x6267BFD0

.origin = codecave

_BOTW_Byakugan_GuardianChildComponentsCount:
.int 0
_BOTW_Byakugan_GuardianChildComponentsCounter:
.int 0
_BOTW_Byakugan_GuardianTargetComponentId:
.int 0
_BOTW_Byakugan_GuardianParentComponentId:
.int 0

_BOTW_Byakugan_TargetGuardianChildComponents:
mr r12, r0
rlwinm. r0, r0, 0, 27, 27
blr

_BOTW_Byakugan_TargetGuardianChildComponent:
lis r3, _BOTW_Byakugan_GuardianTargetComponentId@ha
lwzu r11, _BOTW_Byakugan_GuardianTargetComponentId@l(r3)
cmpwi r11, 0
beq .+0x2C
lwz r4, -0x8(r3)
lwz r7, -0x4(r3)
addi r7, r7, 1
stw r7, -0x4(r3)
cmpw r7, r4
bne .+0x14
cmpw r11, r31
beq .+0xC
xori r12, r12, 16
stw r12, 0x48C(r31)
cmpw r30, r11
mr r3, r30
li r4, 0x10
blr

_BOTW_Byakugan_HandleGuardianParentComponent:
cmpwi r8, 0
beq .+0x2C
lis r3, _BOTW_Byakugan_GuardianChildComponentsCounter@ha
lwzu r12, _BOTW_Byakugan_GuardianChildComponentsCounter@l(r3)
stw r12, -0x4(r3)
li r12, 0
stw r12, 0x0(r3)
stw r31, 0x8(r3)
lwz r3, 0x48c(r31)
ori r3, r3, 16
stw r3, 0x48c(r31)
blr
lis r3, _BOTW_Byakugan_GuardianParentComponentId@ha
lwzu r12, _BOTW_Byakugan_GuardianParentComponentId@l(r3)
cmpw r31, r12
beq .+0xC
cmpwi r8, 0
blr
lwz r12, 0x48c(r31)
ori r12, r12, 16
stw r12, 0x48c(r31)
stw r8, 0x0(r3)
stw r8, -0x4(r3)
stw r8, -0x8(r3)
stw r8, -0xC(r3)
blr

_BOTW_Byakugan_TargetGuardianComponent:
lis r3, _BOTW_Byakugan_GuardianTargetComponentId@ha
stw r28, _BOTW_Byakugan_GuardianTargetComponentId@l(r3)
mr r3, r28
blr

0x02A3B60C = bla _BOTW_Byakugan_TargetGuardianComponent # Target guardian with stasis area [mr r3, r28]
0x0204fDFC = bla _BOTW_Byakugan_TargetGuardianChildComponents # Propagate the guardian stasis status on all its elements [rlwinm. r0, r0, 0, 27, 27]
0x0204fE04 = bla _BOTW_Byakugan_TargetGuardianChildComponent # Same area as above [mr r3, r30]
0x0204fE08 = bne .+0x30 # Same area as above [li r4, 0x10]
0x0204ABDC = bla _BOTW_Byakugan_HandleGuardianParentComponent # Handle the guardian parent component stasis status [cmpwi r8, 0]
0x02FAFE28 = li r28, 1 # Enemy life gauge hidden status update area [li r28, 0]
0x02FAFE44 = li r28, 1 # Same area as above [li r28, 0]