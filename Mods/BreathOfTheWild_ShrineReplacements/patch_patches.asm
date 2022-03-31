[BotwV208]
moduleMatches = 0x6267BFD0

.origin = codecave

_BOTW_ShrineReplacements_ShrinesData:
.int 0 # Replaced shrine location marker data pointer
.int 1148546663 # Dung
.int 1701801521 # eon1
.int 859176960 # 36, null character, replacement shrine Clear_DungeonXXX [uint8]
.int 0 # Replaced shrine id [uint16], replacement shrine id [uint16]
_BOTW_ShrineReplacements_UserDefinedData:
.int $Shrines0001
.int $Shrines0203
.int $Shrines0405
.int $Shrines0607
.int $Shrines0809
.int $Shrines0a0b
.int $Shrines0c0d
.int $Shrines0e0f
.int $Shrines1011
.int $Shrines1213
.int $Shrines1415
.int $Shrines1617
.int $Shrines1819
.int $Shrines1a1b
.int $Shrines1c1d
.int $Shrines1e1f
.int $Shrines2021
.int $Shrines2223
.int $Shrines2425
.int $Shrines2627
.int $Shrines2829
.int $Shrines2a2b
.int $Shrines2c2d
.int $Shrines2e2f
.int $Shrines3031
.int $Shrines3233
.int $Shrines3435
.int $Shrines3637
.int $Shrines3839
.int $Shrines3a3b
.int $Shrines3c3d
.int $Shrines3e3f
.int $Shrines4041
.int $Shrines4243
.int $Shrines4445
.int $Shrines4647
.int $Shrines4849
.int $Shrines4a4b
.int $Shrines4c4d
.int $Shrines4e4f
.int $Shrines5051
.int $Shrines5253
.int $Shrines5455
.int $Shrines5657
.int $Shrines5859
.int $Shrines5a5b
.int $Shrines5c5d
.int $Shrines5e5f
.int $Shrines6061
.int $Shrines6263
.int $Shrines6465
.int $Shrines6667
.int $Shrines6869
.int $Shrines6a6b
.int $Shrines6c6d
.int $Shrines6e6f
.int $Shrines7071
.int $Shrines7273
.int $Shrines7475
.int $Shrines7677
.int $Shrines7879
.int $Shrines7a7b
.int $Shrines7c7d
.int $Shrines7e7f
.int $Shrines8081
.int $Shrines8283
.int $Shrines8485
.int $Shrines8687
.int $Shrines8889
.int $Shrines8a8b
.int $Shrines8c8d
.int $Shrines8e8f
.int $Shrines9091
.int $Shrines9293
.int $Shrines9495
.int $Shrines9697
.int $Shrines9899
.int $Shrines9a9b
.int $Shrines9c9d
.int $Shrines9e9f
.int $Shrinesa0a1
.int $Shrinesa2a3
.int $Shrinesa4a5
.int $Shrinesa6a7
.int $Shrinesa8a9
.int $Shrinesaaab
.int $Shrinesacad
.int $Shrinesaeaf
.int $Shrinesb0b1
.int $Shrinesb2b3
.int $Shrinesb4b5
.int $Shrinesb6b7
.int $Shrinesb8b9
.int $Shrinesbabb
.int $Shrinesbcbd
.int $Shrinesbebf
.int $Shrinesc0c1
.int $Shrinesc2c3
.int $Shrinesc4c5
.int $Shrinesc6c7
.int $Shrinesc8c9
.int $Shrinescacb
.int $Shrinescccd
.int $Shrinescecf
.int $Shrinesd0d1
.int $Shrinesd2d3
.int $Shrinesd4d5
.int $Shrinesd6d7
.int $Shrinesd8d9
.int $Shrinesdadb
.int $Shrinesdcdd
.int $Shrinesdedf
.int $Shrinese0e1
.int $Shrinese2e3
.int $Shrinese4e5
.int $Shrinese6e7
.int $Shrinese8e9
.int $Shrineseaeb
.int $Shrineseced
.int $Shrineseeef
.int $Shrinesf0f1
.int $Shrinesf2f3
.int $Shrinesf4f5
.int $Shrinesf6f7
.int $Shrinesf8f9
.int $Shrinesfafb
.int $Shrinesfcfd
.int $Shrinesfeff

_BOTW_ShrineReplacements_EnterShrine:
lwz r26, 0x0(r17)
lwz r26, 0x6(r26) # r26={'n','X','X','X'} extracted from the replaced shrine DungeonXXX string id ("000"<=XXX<="255" only supported)
lis r28, _BOTW_ShrineReplacements_UserDefinedData@ha
addi r28, r28, _BOTW_ShrineReplacements_UserDefinedData@l
rlwinm r8, r26, 16, 28, 31
mulli r12, r8, 100
rlwinm r8, r26, 24, 28, 31
mulli r8, r8, 10
add r12, r12, r8
rlwinm r8, r26, 0, 28, 31
add r12, r12, r8 # r12=CByte("XXX")
slwi r8, r12, 1
lis r30, $DataLayerMemoryBase
lwz r11, 0x0(r30)
cmpw r11, r30
bne .+0x1C # Data Layer check: if (*((int32 *) ((void *) 0x1800000))!=0x1800000) GOTO lbzx r8, r8, r28
slwi r30, r12, 3
addi r30, r30, 0x308
lwzx r9, r30, r11
lbz r30, 0x7(r9)
rlwinm r30, r30, 0, 31, 31 # r30=Clear_DungeonXXX & 1
add r8, r8, r30
lbzx r8, r8, r28
cmpw r8, r12
bne .+0xC # if (r8!=r12) GOTO sth r12, -0x4(r28)
li r3, 0
b .+0x70 # GOTO stw r3, -0x14(r28)
sth r12, -0x4(r28) # r12=replaced shrine id
sth r8, -0x2(r28) # r8=replacement shrine id
cmpwi r30, 1
bgt .+0x18 # if (r30>1) GOTO li r12, 10
slwi r9, r8, 3
addi r9, r9, 0x308
lwzx r9, r9, r11
lbz r9, 0x7(r9)
stb r9, -0x5(r28)
li r12, 10
divw r9, r8, r12
mulli r26, r9, 10
sub r26, r8, r26
addi r26, r26, 48
divw r12, r9, r12
mulli r8, r12, 10
sub r9, r9, r8
addi r9, r9, 48
slwi r9, r9, 8
add r26, r26, r9
addi r12, r12, 48
slwi r12, r12, 16
add r26, r26, r12
addis r26, r26, 0x6E00 # r26={'n','X','X','X'} from replacement shrine id
addi r12, r28, -16
stw r12, 0x0(r17)
stw r26, -0xA(r28)
stw r3, -0x14(r28)
lis r28, 0x1026
blr

_BOTW_ShrineReplacements_GoOutsideShrine:
lis r27, _BOTW_ShrineReplacements_ShrinesData@ha
lwzu r23, _BOTW_ShrineReplacements_ShrinesData@l(r27)
cmpwi r23, 0
beq .+0x48 # GOTO lmw r22, 0x118(r1)
stw r31, 0x0(r27)
lwz r24, 0x4(r23)
lwz r24, 0x6(r24) # r24={'n','X','X','X'} from replaced shrine id string (lwz r25, 0x5F(r6) -> r25=replacement shrine id)
lis r22, $DataLayerMemoryBase
lwz r28, 0x0(r22)
cmpw r22, r28
bne .+0x1C # Data Layer check: if (*((int32 *) ((void *) 0x1800000))!=0x1800000) GOTO stw r24, 0x5F(r6)
lbz r29, 0xF(r27)
lhz r30, 0x12(r27)
slwi r30, r30, 3
addi r30, r30, 0x308
lwzx r30, r30, r22
stb r29, 0x7(r30)
stw r24, 0x5F(r6) # Patch 'CDungeonXXX_1' string
lwz r24, 0x18(r23)
lwz r24, 0xA(r24)
stw r24, 0x2C(r6) # Patch '[A-J]-[1-8]' map string
lmw r22, 0x118(r1)
blr

_BOTW_ShrineReplacements_CompleteShrine:
li r5, 0
lis r9, _BOTW_ShrineReplacements_ShrinesData@ha
lwzu r6, _BOTW_ShrineReplacements_ShrinesData@l(r9)
cmpwi r6, 0
beqlr # if (r6==0) EXITSUB
lis r4, $DataLayerMemoryBase
lwz r6, 0x0(r4)
cmpw r4, r6
bnelr # Data Layer check: if (*((int32 *) ((void *) 0x1800000))!=0x1800000) EXITSUB
lhz r6, 0x10(r9)
slwi r6, r6, 3
addi r6, r6, 0x308
lwzx r4, r6, r4
li r6, 3 # r6=1+(1<<Clear_DungeonXXX flags Category)=1+(1<<1)
stb r6, 0x7(r4)
blr

_BOTW_ShrineReplacements_StartStageLoading:
lis r3, 0x1048
lis r4, $DataLayerMemoryBase
lwz r12, 0x0(r4)
cmpw r4, r12
bnelr # Data Layer check: if (*((int32 *) ((void *) 0x1800000))!=0x1800000) EXITSUB
lis r17, 0x1055
lhz r19, -0x9BC(r17)
cmpwi r19, 0x5469
beqlr # return to the title menu check: if (PlayerPosMapType.substr(0,2)=="Ti") EXITSUB or if (*((int16 *) pPlayerPosMapType)==0x5469) EXITSUB
lwz r19, 0x748(r12)
lbz r20, 0x7(r19)
cmpwi r20, 3
beqlr # check if loading from a game save: if (Clear_Dungeon136==3) EXITSUB
li r20, 3
stb r20, 0x7(r19)
lhz r18, -0x990(r17)
cmpwi r18, 0x4475
li r18, 136
bne .+0x24 # if (PlayerPosMapName.substr(0,2)!="Du") GOTO lis r4, _BOTW_ShrineReplacements_EnterShrine@ha or if (*((int16 *) pPlayerPosMapName)!=0x4475) GOTO lis r4, _BOTW_ShrineReplacements_EnterShrine@ha
lwz r17, -0x98A(r17)
rlwinm r4, r17, 16, 28, 31
mulli r18, r4, 100
rlwinm r4, r17, 24, 28, 31
mulli r4, r4, 10
add r18, r18, r4
rlwinm r4, r17, 0, 28, 31
add r18, r18, r4 # r18=CByte("XXX")=replacement shrine id
lis r4, _BOTW_ShrineReplacements_EnterShrine@ha
addi r4, r4, _BOTW_ShrineReplacements_EnterShrine@l
li r20, 256
mtctr r20
lbzu r19, -0x1(r4)
cmpw r19, r18
bne .+0x8
subi r21, r20, 1
lbzu r19, -0x1(r4)
cmpw r19, r18
bne .+0x8
subi r21, r20, 1
addic. r20, r20, -1
slwi r19, r19, 3
addi r19, r19, 0x308 # Clear_DungeonXXX swaps area
lwzx r19, r19, r12
lbz r19, 0x7(r19)
slwi r17, r20, 3
addi r17, r17, 0x308
lwzx r17, r17, r12
stb r19, 0x6(r17)
bne .-0x44 # if (r20!=0) GOTO lbzu r19, -0x1(r4)
addi r12, r12, 0xB08
lwzu r19, -0x8(r12)
lbz r17, 0x6(r19)
stb r20, 0x6(r19)
stb r17, 0x7(r19)
bdnz .-0x10 # if (CTR!=0) GOTO lwzu r19, -0x8(r12)
cmpw r21, r18
bne .+0xC # if (replaced shrine id r21!=replacement shrine id r18) GOTO sth r21, -0x4(r4)
stw r20, -0x14(r4)
blr
sth r21, -0x4(r4)
sth r18, -0x2(r4)
slwi r18, r18, 3
lwzx r18, r18, r12
lbz r18, 0x7(r18)
stb r18, -0x5(r4)
li r12, 10
divw r18, r21, r12
mulli r17, r18, 10
sub r17, r21, r17
addi r17, r17, 48
divw r12, r18, r12
mulli r26, r12, 10
sub r18, r18, r26
addi r18, r18, 48
slwi r18, r18, 8
add r17, r17, r18
addi r12, r12, 48
slwi r12, r12, 16
add r17, r17, r12
addis r17, r17, 0x6E00 # r17={'n','X','X','X'} from replaced shrine id
lis r12, 0x1047
lwz r12, -0x4228(r12)
addi r21, r12, 0x88
lwz r19, 0xc4(r12)
subi r12, r19, 0x38
cmplw r21, r12
beq .+0x34 # if ((uint32) r21==(uint32) r12) GOTO stw r20, -0x14(r4)
lwz r19, 0x4(r12)
cmpwi r19, 0
beq .+0x18 # if (r19==0) GOTO lwz r19, 0x3C(r12)
lwz r19, 0x6(r19)
cmpw r19, r17
bne .+0xC # if (r19!=r17) GOTO lwz r19, 0x3C(r12)
stw r12, -0x14(r4) # r12=replaced shrine location marker data address
blr
lwz r19, 0x3C(r12)
subi r12, r19, 0x38
cmplw r21, r12
bne .-0x2C # if ((uint32) r21!=(uint32) r12) GOTO lwz r19, 0x4(r12)
stw r20, -0x14(r4)
blr

0x0242C34C = bla _BOTW_ShrineReplacements_EnterShrine # Shrine entrance area (Demo008_1) [lis r28, 0x1026]
0x02C3E334 = bla _BOTW_ShrineReplacements_GoOutsideShrine # Go outside shrine area (Demo008_4) [lmw r22, +0x118(r1)]
0x0305948C = mr r17, r4 # Inside sub (probably used by AIDef:Action/ToCDungeon) to find near location marker string id area [mr r25, r4]
0x030595B8 = lwz r9, 0x4(r17) # [lwz r9, +0x4(r25)]
0x030595C4 = mr r3, r17 # [mr r3, r25]
0x030595D0 = mr r30, r23 # [li r30, 1]
0x02c2a714 = bla _BOTW_ShrineReplacements_StartStageLoading # after the PlayerPosMapType and PlayerPosMapName updates at the beginning of the loading screen (OpenWorldStage_Custom, IndoorStage_Custom, ...) [lis r3, 0x1048]
0x023A1054 = bla _BOTW_ShrineReplacements_CompleteShrine # inside AIDef:Action/SetCurrentDungeonClearFlag with r5=MakeSaveFlag, r3=SaveFlag, r4=SaveFlagOnOffType in this area [li r5, 0]
#0x02138814 = bla _BOTW_ShrineReplacements_Teleportation # Teleportation action area from Player[Save]PosMapType/Player[Save]PosMapName. Pointers list in the r31 memory area to get the destination {wrap point|map unit} and demo animation string id (Demo005_1 or Demo202_1 or ...) [lwz r5, +0x24(r31)]
#0x02E1D11C bl 0x02E1CB18 r5=MakeSaveFlag, r4=SaveFlag, r3=SaveFlagOnOffType (used by AIDef:Action/SetCurrentDungeonClearFlag[0x023A1044] for example)
#PlayerPosMapType=0x1054F644, PlayerPosMapName=0x1054F670: updated in the loading screen, permanently updated in the overworld, constant in the shrine