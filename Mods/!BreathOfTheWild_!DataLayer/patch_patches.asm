[BotwV208]
moduleMatches = 0x6267BFD0

.origin = codecave

# [bool_data|revival_bool_data]
# *((s32 *) ((void *) pointer + 0x8)) = HashValue
# *((u8 *) ((void *) pointer + 0x7)) = value
# if Category is set (for some Kilton's medals of honor quest bool flags for example) then value = value & 1
# *((u8 *) ((void *) pointer + 0x6)) = InitValue
# *((u8 *) ((void *) pointer + 0x5)) = bit mask build from IsEventAssociated, IsOneTrigger, IsProgramReadable, IsProgramWritable, IsSave,... states
# [s32_data]
# *((s32 *) ((void *) pointer + 0x14)) = value
# ...
# [f32_data]
# *((f32 *) ((void *) pointer + 0x14)) = value
# ...
# [string32_data]
# *((char *) pointer + 152) = string[0]
# ...
# [vector2f_array_data]
# *((f32 *) ((void *) pointer + 48 * array item zero-based index + 0x20)) = value[array item zero-based index][0]
# *((f32 *) ((void *) pointer + 48 * array item zero-based index + 0x24)) = value[array item zero-based index][1]
# ...
# [string64_array_data]
# *((char *) pointer + 320 * array item zero-based index + 0xF8) = string[array item zero-based index] first character
# ...
# [s32_array_data]
# *((s32 *) ((void *) pointer + 32 * array item zero-based index + 0x14)) = value[array item zero-based index]
# ...
# [bool_array_data]
# *((u8 *) ((void *) pointer + 16 * array item zero-based index + 0x7)) = value[array item zero-based index]
# ...
# [vector3f_data]
# *((f32 *) ((void *) pointer + 0x2C)) = value[0]
# *((f32 *) ((void *) pointer + 0x30)) = value[1]
# *((f32 *) ((void *) pointer + 0x34)) = value[2]

_BOTW_DataLayer_SharedData:
.int 0 # 0x1800000 when data layer is ready
.int 0 # WM_NighttimeFlag gamedata pointer [0x4] -> *((u8 *) ((void *) pointer + 0x7)) = WM_NighttimeFlag
.int 0 # WM_NighttimeFlag savedata pointer [0x8] -> init value 0 means do not extract this pointer -> free memory to use
.int 0 # IsGet_Armor_001_Lower gamedata pointer [0xC]
.int 0 # IsGet_Armor_001_Lower savedata pointer [0x10]
.int 0 # IsGet_Obj_DRStone_Get gamedata pointer [0x14]
.int 0 # IsGet_Obj_DRStone_Get savedata pointer [0x18]
.int 0 # IsGet_Armor_014_Head gamedata pointer [0x1C]
.int 0 # IsGet_Armor_014_Head savedata pointer [0x20]
.int 0 # IsGet_Armor_014_Lower gamedata pointer [0x24]
.int 0 # IsGet_Armor_014_Lower savedata pointer [0x28]
.int 0 # IsGet_Armor_006_Head gamedata pointer [0x2C]
.int 0 # IsGet_Armor_006_Head savedata pointer [0x30]
.int 0 # LastBossGanonBeastGenerateFlag gamedata pointer [0x34]
.int 0 # LastBossGanonBeastGenerateFlag savedata pointer [0x38]
.int 0 # IsGet_Armor_014_Upper gamedata pointer [0x3C]
.int 0 # IsGet_Armor_014_Upper savedata pointer [0x40]
.int 0 # CurrentMamo gamedata pointer [0x44] -> *((s32 *) ((void *) pointer + 0x14)) = CurrentMamo
.int 0 # CurrentMamo savedata pointer [0x48]
.int 0 # WM_NumberOfDays gamedata pointer [0x4C]
.int 0 # WM_NumberOfDays savedata pointer [0x50]
.int 0 # CurrentRupee gamedata pointer [0x54]
.int 0 # CurrentRupee savedata pointer [0x58]
.int 0 # FirstInHyruleCastleBossRoom gamedata pointer [0x5C]
.int 0 # FirstInHyruleCastleBossRoom savedata pointer [0x60]
.int 0 # LastBossIncompleteGanonGenerateFlag gamedata pointer [0x64]
.int 0 # LastBossIncompleteGanonGenerateFlag gamedata pointer [0x68]
.int 0 # GanonQuest_Finished gamedata pointer [0x6C]
.int 0 # GanonQuest_Finished savedata pointer [0x70]
.int 0 # WM_BloodyMoonTimer gamedata pointer [0x74] -> *((f32 *) ((void *) pointer + 0x14)) = WM_BloodyMoonTimer
.int 0 # WM_BloodyMoonTimer savedata pointer [0x78]
.int 0 # MaxHartValue gamedata pointer [0x7C]
.int 0 # MaxHartValue savedata pointer [0x80]
.int 0 # WM_TimeDivision gamedata pointer [0x84]
.int 0 # WM_TimeDivision savedata pointer [0x88]
.int 0 # PlayerSavePos gamedata pointer [0x8C] -> *((f32 *) ((void *) pointer + 0x2C)) = PlayerSavePosX, *((f32 *) ((void *) pointer + 0x30)) = PlayerSavePosY, *((f32 *) ((void *) pointer + 0x34)) = PlayerSavePosZ
.int 0 # PlayerSavePos savedata pointer [0x90]
.int 0 # PorchItem_EquipFlag|PorchItem_Value1|PorchItem array length [0x94], CookMaterialName(0-4) array length [0x96]
.int 0 # CookEffect(0-1)|StaminaRecover array length [0x98], SmallKey array length [0x9A]
.int -1 # Conditional loot #1 (0 < user defined uint hashId #1 <= user defined uint hashId #2) [0x9C]
.int -1 # Conditional loot #2 [0xA0]
_BOTW_DataLayer_MatCount:
.int 1073741824 # Max materials count [0xA4]
.int 0x03E700A0 # Max items count for material slots [0xA8], max material slots count [0xAA]
_BOTW_DataLayer_FoodCount:
.int 1073741824 # Max foods count [0xAC]
.int 0x03E7003C # Max items count for food slots [0xB0], max food slots count [0xB2]
.int 0 # Reserved (custom message index for example) [0xB4]
.int 0 # Free to use [0xB8]
.int 0 # StaminaRecover gamedata pointer [0xBC] -> *((f32 *) ((void *) pointer + 48 * Food item zero-based index + 0x20)) = heal bonus, *((f32 *) ((void *) pointer + 48 * Food item zero-based index + 0x24)) = bonus duration
.int 0 # StaminaRecover savedata pointer [0xC0]
.int 0 # CookEffect0 gamedata pointer [0xC4] -> *((f32 *) ((void *) pointer + 48 * Food item zero-based index + 0x20)) = effect type, *((f32 *) ((void *) pointer + 48 * Food item zero-based index + 0x24)) = effect level|value
.int 0 # CookEffect0 savedata pointer [0xC8]
.int 0 # CookEffect1 gamedata pointer [0xCC] -> *((f32 *) ((void *) pointer + 48 * Food item zero-based index + 0x20)) = selling price
.int 0 # CookEffect1 savedata pointer [0xD0]
.int 0 # CookMaterialName0 gamedata pointer [0xD4] -> *((char *) pointer + 320 * Food item zero-based index + 0xF8) = CookMaterialName0[Food item zero-based index][0]
.int 0 # CookMaterialName0 savedata pointer [0xD8]
.int 0 # CookMaterialName1 gamedata pointer [0xDC] -> *((char *) pointer + 320 * Food item zero-based index + 0xF8) = CookMaterialName1[Food item zero-based index][0]
.int 0 # CookMaterialName1 savedata pointer [0xE0]
.int 0 # CookMaterialName2 gamedata pointer [0xE4] -> *((char *) pointer + 320 * Food item zero-based index + 0xF8) = CookMaterialName2[Food item zero-based index][0]
.int 0 # CookMaterialName2 savedata pointer [0xE8]
.int 0 # CookMaterialName3 gamedata pointer [0xEC] -> *((char *) pointer + 320 * Food item zero-based index + 0xF8) = CookMaterialName3[Food item zero-based index][0]
.int 0 # CookMaterialName3 savedata pointer [0xF0]
.int 0 # CookMaterialName4 gamedata pointer [0xF4] -> *((char *) pointer + 320 * Food item zero-based index + 0xF8) = CookMaterialName4[Food item zero-based index][0]
.int 0 # CookMaterialName4 savedata pointer [0xF8]
.int 0 # PorchItem gamedata pointer [0xFC] -> *((char *) pointer + 320 * Item zero-based index + 0xF8) = PorchItem[Item zero-based index][0]
.int 0 # PorchItem savedata pointer [0x100]
.int 12 # [1] Master Sword filter: Item ID LIKE "............_070.*" [0x104]
.int 1596995376
.int 1596995376
.int 1
.int 12 # [2] Moon Slayer filter: Item ID LIKE "............_Lyl.*" [0x114]
.int 1598847340
.int 1598847340
.int 1
.int -4 # [4] Normal|ice|fire|electric|ancien arrows filter: Item ID LIKE ".*rrow$" [0x124]
.int 1920102263
.int 1920102263
.int 1
.int 2 # [8] Bomb arrows filter: Item ID LIKE ".*mbAr.*" [0x134]
.int 1835155826
.int 1835155826
.int 1
.int -4 # [16] Normal|ice|fire|electric|ancien arrows exclusion filter: Item ID LIKE ".*rrow$" [0x144]
.int 1920102263
.int 1920102263
.int -1
.int 2 # [32] Bomb arrows exclusion filter: Item ID LIKE ".*mbAr.*" [0x154]
.int 1835155826
.int 1835155826
.int -1
.int 6 # [64] Wild set filter: Item ID LIKE "......005_.*" [0x164]
.int 808465759
.int 808465759
.int 1
.int 6 # [128] Wild set * filter: Item ID LIKE "......035_.*" [0x174]
.int 808662367
.int 808662367
.int 1
.int 6 # [256] Wild set ** filter: Item ID LIKE "......039_.*" [0x184]
.int 808663391
.int 808663391
.int 1
.int 6 # [512] Wild set ***[*] filter: Item ID LIKE "......06[0-1]_.*" [0x194]
.int 808857695
.int 808857951
.int 1
.int 6 # [1024] Thunder Helm and Champion's Tunic filter: Item ID LIKE "......11[5-6]_.*" [0x1A4]
.int 825308511
.int 825308767
.int 1
.int 6 # [2048] Champion's Tunic *[*][*][*] filter: Item ID LIKE "......[148-151]_.*" [0x1B4]
.int 825505887
.int 825569631
.int 1
.int 9 # [4096] Ancient Materials filter: Item ID LIKE ".........y_[26-31].*" [0x1C4]
.int 2036281910
.int 2036282161
.int 1
.int 2 # [8192] Boiled|Cooked|Frozen|Icy foods filter: Item ID LIKE "..em_[B-C].*" [0x1D4]
.int 1701666626
.int 1701666627
.int 1
.int 2 # [16384] Roasted|Blackened|Seared|Baked|Toasted|Charred foods filter: Item ID LIKE "..em_R.*" [0x1E4]
.int 1701666642
.int 1701666642
.int 1
.int 0 # [32768] Animal materials filter: Item ID LIKE "^Anim.*" [0x1F4]
.int 1097754989
.int 1097754989
.int 1
.int 2 # [65536] Materials filter: Item ID LIKE "..em_[E-P].*" [0x204]
.int 1701666629
.int 1701666640
.int 1
.int 10 # [131072] Wood filter: Item ID LIKE "..........odBu.*" [0x214]
.int 1868841589
.int 1868841589
.int 1
.int 0 # [262144] Courser Bee Honey filter: Item ID LIKE "^BeeH.*" [0x224]
.int 1113941320
.int 1113941320
.int 1
.int 2 # [524288] Boiled|Cooked|Frozen|Icy foods exclusion filter: Item ID LIKE "..em_[B-C].*" [0x234]
.int 1701666626
.int 1701666627
.int -1
.int 2 # [1048576] Roasted|Blackened|Seared|Baked|Toasted|Charred foods exclusion filter: Item ID LIKE "..em_R.*" [0x244]
.int 1701666642
.int 1701666642
.int -1
.int 0 # [2097152] Animal materials exclusion filter: Item ID LIKE "^Anim.*" [0x254]
.int 1097754989
.int 1097754989
.int -1
.int 2 # [4194304] Materials exclusion filter: Item ID LIKE "..em_[E-P].*" [0x264]
.int 1701666629
.int 1701666640
.int -1
.int 10 # [8388608] Wood exclusion filter: Item ID LIKE "..........odBu.*" [0x274]
.int 1868841589
.int 1868841589
.int -1
.int 0 # [16777216] Courser Bee Honey exclusion filter: Item ID LIKE "^BeeH.*" [0x284]
.int 1113941320
.int 1113941320
.int -1
.int 0 # [33554432] Armor filter: Item ID LIKE "^Armo.*" [0x294]
.int 1098018159
.int 1098018159
.int 1
.int 0 # [67108864] Non-weapons items filter: Item ID NOT LIKE "^Weap.*" [0x2A4]
.int 1466261872
.int 1466261872
.int 0
.int 0 # [134217728] Weapons filter: Item ID LIKE "^Weap.*" [0x2B4]
.int 1466261872
.int 1466261872
.int 1
.int 0 # [268435456] Reserved for a new filter [0x2C4]
.int 0
.int 0
.int 0
.int 0 # [536870912] Reserved for a new filter [0x2D4]
.int 0
.int 0
.int 0
.int 0 # [1073741824] Reserved for a new filter [0x2E4]
.int 0
.int 0
.int 0
.int 0 # PorchItem_Value1 gamedata pointer [0x2F4] -> *((s32 *) ((void *) pointer + 32 * Item zero-based index + 0x14)) = PorchItem_Value1[Item zero-based index]
.int 0 # PorchItem_Value1 savedata pointer [0x2F8]
.int 0 # PorchItem_EquipFlag gamedata pointer [0x2FC] -> *((u8 *) ((void *) pointer + 16 * Item zero-based index + 0x7)) = PorchItem_EquipFlag[Item zero-based index]
.int 0 # PorchItem_EquipFlag savedata pointer [0x300]
.int 0 # Pointer to a free memory area usable after Data Layer is ready [0x304]
.int 0 # Clear_Dungeon000 gamedata pointer [0x308] -> (*((u8 *) ((void *) pointer + 0x7))) & 1 = Clear_Dungeon000
.int 0 # Clear_Dungeon000 savedata pointer [0x30C]
.int 0 # Clear_Dungeon001 gamedata pointer [0x310]
.int 0 # Clear_Dungeon001 savedata pointer [0x314]
.int 0 # Clear_Dungeon002 gamedata pointer [0x318]
.int 0 # Clear_Dungeon002 savedata pointer [0x31C]
.int 0 # Clear_Dungeon003 gamedata pointer [0x320]
.int 0 # Clear_Dungeon003 savedata pointer [0x324]
.int 0 # Clear_Dungeon004 gamedata pointer [0x328]
.int 0 # Clear_Dungeon004 savedata pointer [0x32C]
.int 0 # Clear_Dungeon005 gamedata pointer [0x330]
.int 0 # Clear_Dungeon005 savedata pointer [0x334]
.int 0 # Clear_Dungeon006 gamedata pointer [0x338]
.int 0 # Clear_Dungeon006 savedata pointer [0x33C]
.int 0 # Clear_Dungeon007 gamedata pointer [0x340]
.int 0 # Clear_Dungeon007 savedata pointer [0x344]
.int 0 # Clear_Dungeon008 gamedata pointer [0x348]
.int 0 # Clear_Dungeon008 savedata pointer [0x34C]
.int 0 # Clear_Dungeon009 gamedata pointer [0x350]
.int 0 # Clear_Dungeon009 savedata pointer [0x354]
.int 0 # Clear_Dungeon010 gamedata pointer [0x358]
.int 0 # Clear_Dungeon010 savedata pointer [0x35C]
.int 0 # Clear_Dungeon011 gamedata pointer [0x360]
.int 0 # Clear_Dungeon011 savedata pointer [0x364]
.int 0 # Clear_Dungeon012 gamedata pointer [0x368]
.int 0 # Clear_Dungeon012 savedata pointer [0x36C]
.int 0 # Clear_Dungeon013 gamedata pointer [0x370]
.int 0 # Clear_Dungeon013 savedata pointer [0x374]
.int 0 # Clear_Dungeon014 gamedata pointer [0x378]
.int 0 # Clear_Dungeon014 savedata pointer [0x37C]
.int 0 # Clear_Dungeon015 gamedata pointer [0x380]
.int 0 # Clear_Dungeon015 savedata pointer [0x384]
.int 0 # Clear_Dungeon016 gamedata pointer [0x388]
.int 0 # Clear_Dungeon016 savedata pointer [0x38C]
.int 0 # Clear_Dungeon017 gamedata pointer [0x390]
.int 0 # Clear_Dungeon017 savedata pointer [0x394]
.int 0 # Clear_Dungeon018 gamedata pointer [0x398]
.int 0 # Clear_Dungeon018 savedata pointer [0x39C]
.int 0 # Clear_Dungeon019 gamedata pointer [0x3A0]
.int 0 # Clear_Dungeon019 savedata pointer [0x3A4]
.int 0 # Clear_Dungeon020 gamedata pointer [0x3A8]
.int 0 # Clear_Dungeon020 savedata pointer [0x3AC]
.int 0 # Clear_Dungeon021 gamedata pointer [0x3B0]
.int 0 # Clear_Dungeon021 savedata pointer [0x3B4]
.int 0 # Clear_Dungeon022 gamedata pointer [0x3B8]
.int 0 # Clear_Dungeon022 savedata pointer [0x3BC]
.int 0 # Clear_Dungeon023 gamedata pointer [0x3C0]
.int 0 # Clear_Dungeon023 savedata pointer [0x3C4]
.int 0 # Clear_Dungeon024 gamedata pointer [0x3C8]
.int 0 # Clear_Dungeon024 savedata pointer [0x3CC]
.int 0 # Clear_Dungeon025 gamedata pointer [0x3D0]
.int 0 # Clear_Dungeon025 savedata pointer [0x3D4]
.int 0 # Clear_Dungeon026 gamedata pointer [0x3D8]
.int 0 # Clear_Dungeon026 savedata pointer [0x3DC]
.int 0 # Clear_Dungeon027 gamedata pointer [0x3E0]
.int 0 # Clear_Dungeon027 savedata pointer [0x3E4]
.int 0 # Clear_Dungeon028 gamedata pointer [0x3E8]
.int 0 # Clear_Dungeon028 savedata pointer [0x3EC]
.int 0 # Clear_Dungeon029 gamedata pointer [0x3F0]
.int 0 # Clear_Dungeon029 savedata pointer [0x3F4]
.int 0 # Clear_Dungeon030 gamedata pointer [0x3F8]
.int 0 # Clear_Dungeon030 savedata pointer [0x3FC]
.int 0 # Clear_Dungeon031 gamedata pointer [0x400]
.int 0 # Clear_Dungeon031 savedata pointer [0x404]
.int 0 # Clear_Dungeon032 gamedata pointer [0x408]
.int 0 # Clear_Dungeon032 savedata pointer [0x40C]
.int 0 # Clear_Dungeon033 gamedata pointer [0x410]
.int 0 # Clear_Dungeon033 savedata pointer [0x414]
.int 0 # Clear_Dungeon034 gamedata pointer [0x418]
.int 0 # Clear_Dungeon034 savedata pointer [0x41C]
.int 0 # Clear_Dungeon035 gamedata pointer [0x420]
.int 0 # Clear_Dungeon035 savedata pointer [0x424]
.int 0 # Clear_Dungeon036 gamedata pointer [0x428]
.int 0 # Clear_Dungeon036 savedata pointer [0x42C]
.int 0 # Clear_Dungeon037 gamedata pointer [0x430]
.int 0 # Clear_Dungeon037 savedata pointer [0x434]
.int 0 # Clear_Dungeon038 gamedata pointer [0x438]
.int 0 # Clear_Dungeon038 savedata pointer [0x43C]
.int 0 # Clear_Dungeon039 gamedata pointer [0x440]
.int 0 # Clear_Dungeon039 savedata pointer [0x444]
.int 0 # Clear_Dungeon040 gamedata pointer [0x448]
.int 0 # Clear_Dungeon040 savedata pointer [0x44C]
.int 0 # Clear_Dungeon041 gamedata pointer [0x450]
.int 0 # Clear_Dungeon041 savedata pointer [0x454]
.int 0 # Clear_Dungeon042 gamedata pointer [0x458]
.int 0 # Clear_Dungeon042 savedata pointer [0x45C]
.int 0 # Clear_Dungeon043 gamedata pointer [0x460]
.int 0 # Clear_Dungeon043 savedata pointer [0x464]
.int 0 # Clear_Dungeon044 gamedata pointer [0x468]
.int 0 # Clear_Dungeon044 savedata pointer [0x46C]
.int 0 # Clear_Dungeon045 gamedata pointer [0x470]
.int 0 # Clear_Dungeon045 savedata pointer [0x474]
.int 0 # Clear_Dungeon046 gamedata pointer [0x478]
.int 0 # Clear_Dungeon046 savedata pointer [0x47C]
.int 0 # Clear_Dungeon047 gamedata pointer [0x480]
.int 0 # Clear_Dungeon047 savedata pointer [0x484]
.int 0 # Clear_Dungeon048 gamedata pointer [0x488]
.int 0 # Clear_Dungeon048 savedata pointer [0x48C]
.int 0 # Clear_Dungeon049 gamedata pointer [0x490]
.int 0 # Clear_Dungeon049 savedata pointer [0x494]
.int 0 # Clear_Dungeon050 gamedata pointer [0x498]
.int 0 # Clear_Dungeon050 savedata pointer [0x49C]
.int 0 # Clear_Dungeon051 gamedata pointer [0x4A0]
.int 0 # Clear_Dungeon051 savedata pointer [0x4A4]
.int 0 # Clear_Dungeon052 gamedata pointer [0x4A8]
.int 0 # Clear_Dungeon052 savedata pointer [0x4AC]
.int 0 # Clear_Dungeon053 gamedata pointer [0x4B0]
.int 0 # Clear_Dungeon053 savedata pointer [0x4B4]
.int 0 # Clear_Dungeon054 gamedata pointer [0x4B8]
.int 0 # Clear_Dungeon054 savedata pointer [0x4BC]
.int 0 # Clear_Dungeon055 gamedata pointer [0x4C0]
.int 0 # Clear_Dungeon055 savedata pointer [0x4C4]
.int 0 # Clear_Dungeon056 gamedata pointer [0x4C8]
.int 0 # Clear_Dungeon056 savedata pointer [0x4CC]
.int 0 # Clear_Dungeon057 gamedata pointer [0x4D0]
.int 0 # Clear_Dungeon057 savedata pointer [0x4D4]
.int 0 # Clear_Dungeon058 gamedata pointer [0x4D8]
.int 0 # Clear_Dungeon058 savedata pointer [0x4DC]
.int 0 # Clear_Dungeon059 gamedata pointer [0x4E0]
.int 0 # Clear_Dungeon059 savedata pointer [0x4E4]
.int 0 # Clear_Dungeon060 gamedata pointer [0x4E8]
.int 0 # Clear_Dungeon060 savedata pointer [0x4EC]
.int 0 # Clear_Dungeon061 gamedata pointer [0x4F0]
.int 0 # Clear_Dungeon061 savedata pointer [0x4F4]
.int 0 # Clear_Dungeon062 gamedata pointer [0x4F8]
.int 0 # Clear_Dungeon062 savedata pointer [0x4FC]
.int 0 # Clear_Dungeon063 gamedata pointer [0x500]
.int 0 # Clear_Dungeon063 savedata pointer [0x504]
.int 0 # Clear_Dungeon064 gamedata pointer [0x508]
.int 0 # Clear_Dungeon064 savedata pointer [0x50C]
.int 0 # Clear_Dungeon065 gamedata pointer [0x510]
.int 0 # Clear_Dungeon065 savedata pointer [0x514]
.int 0 # Clear_Dungeon066 gamedata pointer [0x518]
.int 0 # Clear_Dungeon066 savedata pointer [0x51C]
.int 0 # Clear_Dungeon067 gamedata pointer [0x520]
.int 0 # Clear_Dungeon067 savedata pointer [0x524]
.int 0 # Clear_Dungeon068 gamedata pointer [0x528]
.int 0 # Clear_Dungeon068 savedata pointer [0x52C]
.int 0 # Clear_Dungeon069 gamedata pointer [0x530]
.int 0 # Clear_Dungeon069 savedata pointer [0x534]
.int 0 # Clear_Dungeon070 gamedata pointer [0x538]
.int 0 # Clear_Dungeon070 savedata pointer [0x53C]
.int 0 # Clear_Dungeon071 gamedata pointer [0x540]
.int 0 # Clear_Dungeon071 savedata pointer [0x544]
.int 0 # Clear_Dungeon072 gamedata pointer [0x548]
.int 0 # Clear_Dungeon072 savedata pointer [0x54C]
.int 0 # Clear_Dungeon073 gamedata pointer [0x550]
.int 0 # Clear_Dungeon073 savedata pointer [0x554]
.int 0 # Clear_Dungeon074 gamedata pointer [0x558]
.int 0 # Clear_Dungeon074 savedata pointer [0x55C]
.int 0 # Clear_Dungeon075 gamedata pointer [0x560]
.int 0 # Clear_Dungeon075 savedata pointer [0x564]
.int 0 # Clear_Dungeon076 gamedata pointer [0x568]
.int 0 # Clear_Dungeon076 savedata pointer [0x56C]
.int 0 # Clear_Dungeon077 gamedata pointer [0x570]
.int 0 # Clear_Dungeon077 savedata pointer [0x574]
.int 0 # Clear_Dungeon078 gamedata pointer [0x578]
.int 0 # Clear_Dungeon078 savedata pointer [0x57C]
.int 0 # Clear_Dungeon079 gamedata pointer [0x580]
.int 0 # Clear_Dungeon079 savedata pointer [0x584]
.int 0 # Clear_Dungeon080 gamedata pointer [0x588]
.int 0 # Clear_Dungeon080 savedata pointer [0x58C]
.int 0 # Clear_Dungeon081 gamedata pointer [0x590]
.int 0 # Clear_Dungeon081 savedata pointer [0x594]
.int 0 # Clear_Dungeon082 gamedata pointer [0x598]
.int 0 # Clear_Dungeon082 savedata pointer [0x59C]
.int 0 # Clear_Dungeon083 gamedata pointer [0x5A0]
.int 0 # Clear_Dungeon083 savedata pointer [0x5A4]
.int 0 # Clear_Dungeon084 gamedata pointer [0x5A8]
.int 0 # Clear_Dungeon084 savedata pointer [0x5AC]
.int 0 # Clear_Dungeon085 gamedata pointer [0x5B0]
.int 0 # Clear_Dungeon085 savedata pointer [0x5B4]
.int 0 # Clear_Dungeon086 gamedata pointer [0x5B8]
.int 0 # Clear_Dungeon086 savedata pointer [0x5BC]
.int 0 # Clear_Dungeon087 gamedata pointer [0x5C0]
.int 0 # Clear_Dungeon087 savedata pointer [0x5C4]
.int 0 # Clear_Dungeon088 gamedata pointer [0x5C8]
.int 0 # Clear_Dungeon088 savedata pointer [0x5CC]
.int 0 # Clear_Dungeon089 gamedata pointer [0x5D0]
.int 0 # Clear_Dungeon089 savedata pointer [0x5D4]
.int 0 # Clear_Dungeon090 gamedata pointer [0x5D8]
.int 0 # Clear_Dungeon090 savedata pointer [0x5DC]
.int 0 # Clear_Dungeon091 gamedata pointer [0x5E0]
.int 0 # Clear_Dungeon091 savedata pointer [0x5E4]
.int 0 # Clear_Dungeon092 gamedata pointer [0x5E8]
.int 0 # Clear_Dungeon092 savedata pointer [0x5EC]
.int 0 # Clear_Dungeon093 gamedata pointer [0x5F0]
.int 0 # Clear_Dungeon093 savedata pointer [0x5F4]
.int 0 # Clear_Dungeon094 gamedata pointer [0x5F8]
.int 0 # Clear_Dungeon094 savedata pointer [0x5FC]
.int 0 # Clear_Dungeon095 gamedata pointer [0x600]
.int 0 # Clear_Dungeon095 savedata pointer [0x604]
.int 0 # Clear_Dungeon096 gamedata pointer [0x608]
.int 0 # Clear_Dungeon096 savedata pointer [0x60C]
.int 0 # Clear_Dungeon097 gamedata pointer [0x610]
.int 0 # Clear_Dungeon097 savedata pointer [0x614]
.int 0 # Clear_Dungeon098 gamedata pointer [0x618]
.int 0 # Clear_Dungeon098 savedata pointer [0x61C]
.int 0 # Clear_Dungeon099 gamedata pointer [0x620]
.int 0 # Clear_Dungeon099 savedata pointer [0x624]
.int 0 # Clear_Dungeon100 gamedata pointer [0x628]
.int 0 # Clear_Dungeon100 savedata pointer [0x62C]
.int 0 # Clear_Dungeon101 gamedata pointer [0x630]
.int 0 # Clear_Dungeon101 savedata pointer [0x634]
.int 0 # Clear_Dungeon102 gamedata pointer [0x638]
.int 0 # Clear_Dungeon102 savedata pointer [0x63C]
.int 0 # Clear_Dungeon103 gamedata pointer [0x640]
.int 0 # Clear_Dungeon103 savedata pointer [0x644]
.int 0 # Clear_Dungeon104 gamedata pointer [0x648]
.int 0 # Clear_Dungeon104 savedata pointer [0x64C]
.int 0 # Clear_Dungeon105 gamedata pointer [0x650]
.int 0 # Clear_Dungeon105 savedata pointer [0x654]
.int 0 # Clear_Dungeon106 gamedata pointer [0x658]
.int 0 # Clear_Dungeon106 savedata pointer [0x65C]
.int 0 # Clear_Dungeon107 gamedata pointer [0x660]
.int 0 # Clear_Dungeon107 savedata pointer [0x664]
.int 0 # Clear_Dungeon108 gamedata pointer [0x668]
.int 0 # Clear_Dungeon108 savedata pointer [0x66C]
.int 0 # Clear_Dungeon109 gamedata pointer [0x670]
.int 0 # Clear_Dungeon109 savedata pointer [0x674]
.int 0 # Clear_Dungeon110 gamedata pointer [0x678]
.int 0 # Clear_Dungeon110 savedata pointer [0x67C]
.int 0 # Clear_Dungeon111 gamedata pointer [0x680]
.int 0 # Clear_Dungeon111 savedata pointer [0x684]
.int 0 # Clear_Dungeon112 gamedata pointer [0x688]
.int 0 # Clear_Dungeon112 savedata pointer [0x68C]
.int 0 # Clear_Dungeon113 gamedata pointer [0x690]
.int 0 # Clear_Dungeon113 savedata pointer [0x694]
.int 0 # Clear_Dungeon114 gamedata pointer [0x698]
.int 0 # Clear_Dungeon114 savedata pointer [0x69C]
.int 0 # Clear_Dungeon115 gamedata pointer [0x6A0]
.int 0 # Clear_Dungeon115 savedata pointer [0x6A4]
.int 0 # Clear_Dungeon116 gamedata pointer [0x6A8]
.int 0 # Clear_Dungeon116 savedata pointer [0x6AC]
.int 0 # Clear_Dungeon117 gamedata pointer [0x6B0]
.int 0 # Clear_Dungeon117 savedata pointer [0x6B4]
.int 0 # Clear_Dungeon118 gamedata pointer [0x6B8]
.int 0 # Clear_Dungeon118 savedata pointer [0x6BC]
.int 0 # Clear_Dungeon119 gamedata pointer [0x6C0]
.int 0 # Clear_Dungeon119 savedata pointer [0x6C4]
.int 0 # Clear_Dungeon120 gamedata pointer [0x6C8]
.int 0 # Clear_Dungeon120 savedata pointer [0x6CC]
.int 0 # Clear_Dungeon121 gamedata pointer [0x6D0]
.int 0 # Clear_Dungeon121 savedata pointer [0x6D4]
.int 0 # Clear_Dungeon122 gamedata pointer [0x6D8]
.int 0 # Clear_Dungeon122 savedata pointer [0x6DC]
.int 0 # Clear_Dungeon123 gamedata pointer [0x6E0]
.int 0 # Clear_Dungeon123 savedata pointer [0x6E4]
.int 0 # Clear_Dungeon124 gamedata pointer [0x6E8]
.int 0 # Clear_Dungeon124 savedata pointer [0x6EC]
.int 0 # Clear_Dungeon125 gamedata pointer [0x6F0]
.int 0 # Clear_Dungeon125 savedata pointer [0x6F4]
.int 0 # Clear_Dungeon126 gamedata pointer [0x6F8]
.int 0 # Clear_Dungeon126 savedata pointer [0x6FC]
.int 0 # Clear_Dungeon127 gamedata pointer [0x700]
.int 0 # Clear_Dungeon127 savedata pointer [0x704]
.int 0 # Clear_Dungeon128 gamedata pointer [0x708]
.int 0 # Clear_Dungeon128 savedata pointer [0x70C]
.int 0 # Clear_Dungeon129 gamedata pointer [0x710]
.int 0 # Clear_Dungeon129 savedata pointer [0x714]
.int 0 # Clear_Dungeon130 gamedata pointer [0x718]
.int 0 # Clear_Dungeon130 savedata pointer [0x71C]
.int 0 # Clear_Dungeon131 gamedata pointer [0x720]
.int 0 # Clear_Dungeon131 savedata pointer [0x724]
.int 0 # Clear_Dungeon132 gamedata pointer [0x728]
.int 0 # Clear_Dungeon132 savedata pointer [0x72C]
.int 0 # Clear_Dungeon133 gamedata pointer [0x730]
.int 0 # Clear_Dungeon133 savedata pointer [0x734]
.int 0 # Clear_Dungeon134 gamedata pointer [0x738]
.int 0 # Clear_Dungeon134 savedata pointer [0x73C]
.int 0 # Clear_Dungeon135 gamedata pointer [0x740]
.int 0 # Clear_Dungeon135 savedata pointer [0x744]
.int 0 # Clear_Dungeon136 gamedata pointer [0x748]
.int 0 # Clear_Dungeon136 savedata pointer [0x74C]
.int 0 # Clear_Dungeon137 gamedata pointer [0x750]
.int 0 # Clear_Dungeon137 savedata pointer [0x754]
.int 0 # Clear_Dungeon138 gamedata pointer [0x758]
.int 0 # Clear_Dungeon138 savedata pointer [0x75C]
.int 0 # Clear_Dungeon139 gamedata pointer [0x760]
.int 0 # Clear_Dungeon139 savedata pointer [0x764]
.int 0 # Clear_Dungeon140 gamedata pointer [0x768]
.int 0 # Clear_Dungeon140 savedata pointer [0x76C]
.int 0 # Clear_Dungeon141 gamedata pointer [0x770]
.int 0 # Clear_Dungeon141 savedata pointer [0x774]
.int 0 # Clear_Dungeon142 gamedata pointer [0x778]
.int 0 # Clear_Dungeon142 savedata pointer [0x77C]
.int 0 # Clear_Dungeon143 gamedata pointer [0x780]
.int 0 # Clear_Dungeon143 savedata pointer [0x784]
.int 0 # Clear_Dungeon144 gamedata pointer [0x788]
.int 0 # Clear_Dungeon144 savedata pointer [0x78C]
.int 0 # Clear_Dungeon145 gamedata pointer [0x790]
.int 0 # Clear_Dungeon145 savedata pointer [0x794]
.int 0 # Clear_Dungeon146 gamedata pointer [0x798]
.int 0 # Clear_Dungeon146 savedata pointer [0x79C]
.int 0 # Clear_Dungeon147 gamedata pointer [0x7A0]
.int 0 # Clear_Dungeon147 savedata pointer [0x7A4]
.int 0 # Clear_Dungeon148 gamedata pointer [0x7A8]
.int 0 # Clear_Dungeon148 savedata pointer [0x7AC]
.int 0 # Clear_Dungeon149 gamedata pointer [0x7B0]
.int 0 # Clear_Dungeon149 savedata pointer [0x7B4]
.int 0 # Clear_Dungeon150 gamedata pointer [0x7B8]
.int 0 # Clear_Dungeon150 savedata pointer [0x7BC]
.int 0 # Clear_Dungeon151 gamedata pointer [0x7C0]
.int 0 # Clear_Dungeon151 savedata pointer [0x7C4]
.int 0 # Clear_Dungeon152 gamedata pointer [0x7C8]
.int 0 # Clear_Dungeon152 savedata pointer [0x7CC]
.int 0 # Clear_Dungeon153 gamedata pointer [0x7D0]
.int 0 # Clear_Dungeon153 savedata pointer [0x7D4]
.int 0 # Clear_Dungeon154 gamedata pointer [0x7D8]
.int 0 # Clear_Dungeon154 savedata pointer [0x7DC]
.int 0 # Clear_Dungeon155 gamedata pointer [0x7E0]
.int 0 # Clear_Dungeon155 savedata pointer [0x7E4]
.int 0 # Clear_Dungeon156 gamedata pointer [0x7E8]
.int 0 # Clear_Dungeon156 savedata pointer [0x7EC]
.int 0 # Clear_Dungeon157 gamedata pointer [0x7F0]
.int 0 # Clear_Dungeon157 savedata pointer [0x7F4]
.int 0 # Clear_Dungeon158 gamedata pointer [0x7F8]
.int 0 # Clear_Dungeon158 savedata pointer [0x7FC]
.int 0 # Clear_Dungeon159 gamedata pointer [0x800]
.int 0 # Clear_Dungeon159 savedata pointer [0x804]
.int 0 # Clear_Dungeon160 gamedata pointer [0x808]
.int 0 # Clear_Dungeon160 savedata pointer [0x80C]
.int 0 # Clear_Dungeon161 gamedata pointer [0x810]
.int 0 # Clear_Dungeon161 savedata pointer [0x814]
.int 0 # Clear_Dungeon162 gamedata pointer [0x818]
.int 0 # Clear_Dungeon162 savedata pointer [0x81C]
.int 0 # Clear_Dungeon163 gamedata pointer [0x820]
.int 0 # Clear_Dungeon163 savedata pointer [0x824]
.int 0 # Clear_Dungeon164 gamedata pointer [0x828]
.int 0 # Clear_Dungeon164 savedata pointer [0x82C]
.int 0 # Clear_Dungeon165 gamedata pointer [0x830]
.int 0 # Clear_Dungeon165 savedata pointer [0x834]
.int 0 # Clear_Dungeon166 gamedata pointer [0x838]
.int 0 # Clear_Dungeon166 savedata pointer [0x83C]
.int 0 # Clear_Dungeon167 gamedata pointer [0x840]
.int 0 # Clear_Dungeon167 savedata pointer [0x844]
.int 0 # Clear_Dungeon168 gamedata pointer [0x848]
.int 0 # Clear_Dungeon168 savedata pointer [0x84C]
.int 0 # Clear_Dungeon169 gamedata pointer [0x850]
.int 0 # Clear_Dungeon169 savedata pointer [0x854]
.int 0 # Clear_Dungeon170 gamedata pointer [0x858]
.int 0 # Clear_Dungeon170 savedata pointer [0x85C]
.int 0 # Clear_Dungeon171 gamedata pointer [0x860]
.int 0 # Clear_Dungeon171 savedata pointer [0x864]
.int 0 # Clear_Dungeon172 gamedata pointer [0x868]
.int 0 # Clear_Dungeon172 savedata pointer [0x86C]
.int 0 # Clear_Dungeon173 gamedata pointer [0x870]
.int 0 # Clear_Dungeon173 savedata pointer [0x874]
.int 0 # Clear_Dungeon174 gamedata pointer [0x878]
.int 0 # Clear_Dungeon174 savedata pointer [0x87C]
.int 0 # Clear_Dungeon175 gamedata pointer [0x880]
.int 0 # Clear_Dungeon175 savedata pointer [0x884]
.int 0 # Clear_Dungeon176 gamedata pointer [0x888]
.int 0 # Clear_Dungeon176 savedata pointer [0x88C]
.int 0 # Clear_Dungeon177 gamedata pointer [0x890]
.int 0 # Clear_Dungeon177 savedata pointer [0x894]
.int 0 # Clear_Dungeon178 gamedata pointer [0x898]
.int 0 # Clear_Dungeon178 savedata pointer [0x89C]
.int 0 # Clear_Dungeon179 gamedata pointer [0x8A0]
.int 0 # Clear_Dungeon179 savedata pointer [0x8A4]
.int 0 # Clear_Dungeon180 gamedata pointer [0x8A8]
.int 0 # Clear_Dungeon180 savedata pointer [0x8AC]
.int 0 # Clear_Dungeon181 gamedata pointer [0x8B0]
.int 0 # Clear_Dungeon181 savedata pointer [0x8B4]
.int 0 # Clear_Dungeon182 gamedata pointer [0x8B8]
.int 0 # Clear_Dungeon182 savedata pointer [0x8BC]
.int 0 # Clear_Dungeon183 gamedata pointer [0x8C0]
.int 0 # Clear_Dungeon183 savedata pointer [0x8C4]
.int 0 # Clear_Dungeon184 gamedata pointer [0x8C8]
.int 0 # Clear_Dungeon184 savedata pointer [0x8CC]
.int 0 # Clear_Dungeon185 gamedata pointer [0x8D0]
.int 0 # Clear_Dungeon185 savedata pointer [0x8D4]
.int 0 # Clear_Dungeon186 gamedata pointer [0x8D8]
.int 0 # Clear_Dungeon186 savedata pointer [0x8DC]
.int 0 # Clear_Dungeon187 gamedata pointer [0x8E0]
.int 0 # Clear_Dungeon187 savedata pointer [0x8E4]
.int 0 # Clear_Dungeon188 gamedata pointer [0x8E8]
.int 0 # Clear_Dungeon188 savedata pointer [0x8EC]
.int 0 # Clear_Dungeon189 gamedata pointer [0x8F0]
.int 0 # Clear_Dungeon189 savedata pointer [0x8F4]
.int 0 # Clear_Dungeon190 gamedata pointer [0x8F8]
.int 0 # Clear_Dungeon190 savedata pointer [0x8FC]
.int 0 # Clear_Dungeon191 gamedata pointer [0x900]
.int 0 # Clear_Dungeon191 savedata pointer [0x904]
.int 0 # Clear_Dungeon192 gamedata pointer [0x908]
.int 0 # Clear_Dungeon192 savedata pointer [0x90C]
.int 0 # Clear_Dungeon193 gamedata pointer [0x910]
.int 0 # Clear_Dungeon193 savedata pointer [0x914]
.int 0 # Clear_Dungeon194 gamedata pointer [0x918]
.int 0 # Clear_Dungeon194 savedata pointer [0x91C]
.int 0 # Clear_Dungeon195 gamedata pointer [0x920]
.int 0 # Clear_Dungeon195 savedata pointer [0x924]
.int 0 # Clear_Dungeon196 gamedata pointer [0x928]
.int 0 # Clear_Dungeon196 savedata pointer [0x92C]
.int 0 # Clear_Dungeon197 gamedata pointer [0x930]
.int 0 # Clear_Dungeon197 savedata pointer [0x934]
.int 0 # Clear_Dungeon198 gamedata pointer [0x938]
.int 0 # Clear_Dungeon198 savedata pointer [0x93C]
.int 0 # Clear_Dungeon199 gamedata pointer [0x940]
.int 0 # Clear_Dungeon199 savedata pointer [0x944]
.int 0 # Clear_Dungeon200 gamedata pointer [0x948]
.int 0 # Clear_Dungeon200 savedata pointer [0x94C]
.int 0 # Clear_Dungeon201 gamedata pointer [0x950]
.int 0 # Clear_Dungeon201 savedata pointer [0x954]
.int 0 # Clear_Dungeon202 gamedata pointer [0x958]
.int 0 # Clear_Dungeon202 savedata pointer [0x95C]
.int 0 # Clear_Dungeon203 gamedata pointer [0x960]
.int 0 # Clear_Dungeon203 savedata pointer [0x964]
.int 0 # Clear_Dungeon204 gamedata pointer [0x968]
.int 0 # Clear_Dungeon204 savedata pointer [0x96C]
.int 0 # Clear_Dungeon205 gamedata pointer [0x970]
.int 0 # Clear_Dungeon205 savedata pointer [0x974]
.int 0 # Clear_Dungeon206 gamedata pointer [0x978]
.int 0 # Clear_Dungeon206 savedata pointer [0x97C]
.int 0 # Clear_Dungeon207 gamedata pointer [0x980]
.int 0 # Clear_Dungeon207 savedata pointer [0x984]
.int 0 # Clear_Dungeon208 gamedata pointer [0x988]
.int 0 # Clear_Dungeon208 savedata pointer [0x98C]
.int 0 # Clear_Dungeon209 gamedata pointer [0x990]
.int 0 # Clear_Dungeon209 savedata pointer [0x994]
.int 0 # Clear_Dungeon210 gamedata pointer [0x998]
.int 0 # Clear_Dungeon210 savedata pointer [0x99C]
.int 0 # Clear_Dungeon211 gamedata pointer [0x9A0]
.int 0 # Clear_Dungeon211 savedata pointer [0x9A4]
.int 0 # Clear_Dungeon212 gamedata pointer [0x9A8]
.int 0 # Clear_Dungeon212 savedata pointer [0x9AC]
.int 0 # Clear_Dungeon213 gamedata pointer [0x9B0]
.int 0 # Clear_Dungeon213 savedata pointer [0x9B4]
.int 0 # Clear_Dungeon214 gamedata pointer [0x9B8]
.int 0 # Clear_Dungeon214 savedata pointer [0x9BC]
.int 0 # Clear_Dungeon215 gamedata pointer [0x9C0]
.int 0 # Clear_Dungeon215 savedata pointer [0x9C4]
.int 0 # Clear_Dungeon216 gamedata pointer [0x9C8]
.int 0 # Clear_Dungeon216 savedata pointer [0x9CC]
.int 0 # Clear_Dungeon217 gamedata pointer [0x9D0]
.int 0 # Clear_Dungeon217 savedata pointer [0x9D4]
.int 0 # Clear_Dungeon218 gamedata pointer [0x9D8]
.int 0 # Clear_Dungeon218 savedata pointer [0x9DC]
.int 0 # Clear_Dungeon219 gamedata pointer [0x9E0]
.int 0 # Clear_Dungeon219 savedata pointer [0x9E4]
.int 0 # Clear_Dungeon220 gamedata pointer [0x9E8]
.int 0 # Clear_Dungeon220 savedata pointer [0x9EC]
.int 0 # Clear_Dungeon221 gamedata pointer [0x9F0]
.int 0 # Clear_Dungeon221 savedata pointer [0x9F4]
.int 0 # Clear_Dungeon222 gamedata pointer [0x9F8]
.int 0 # Clear_Dungeon222 savedata pointer [0x9FC]
.int 0 # Clear_Dungeon223 gamedata pointer [0xA00]
.int 0 # Clear_Dungeon223 savedata pointer [0xA04]
.int 0 # Clear_Dungeon224 gamedata pointer [0xA08]
.int 0 # Clear_Dungeon224 savedata pointer [0xA0C]
.int 0 # Clear_Dungeon225 gamedata pointer [0xA10]
.int 0 # Clear_Dungeon225 savedata pointer [0xA14]
.int 0 # Clear_Dungeon226 gamedata pointer [0xA18]
.int 0 # Clear_Dungeon226 savedata pointer [0xA1C]
.int 0 # Clear_Dungeon227 gamedata pointer [0xA20]
.int 0 # Clear_Dungeon227 savedata pointer [0xA24]
.int 0 # Clear_Dungeon228 gamedata pointer [0xA28]
.int 0 # Clear_Dungeon228 savedata pointer [0xA2C]
.int 0 # Clear_Dungeon229 gamedata pointer [0xA30]
.int 0 # Clear_Dungeon229 savedata pointer [0xA34]
.int 0 # Clear_Dungeon230 gamedata pointer [0xA38]
.int 0 # Clear_Dungeon230 savedata pointer [0xA3C]
.int 0 # Clear_Dungeon231 gamedata pointer [0xA40]
.int 0 # Clear_Dungeon231 savedata pointer [0xA44]
.int 0 # Clear_Dungeon232 gamedata pointer [0xA48]
.int 0 # Clear_Dungeon232 savedata pointer [0xA4C]
.int 0 # Clear_Dungeon233 gamedata pointer [0xA50]
.int 0 # Clear_Dungeon233 savedata pointer [0xA54]
.int 0 # Clear_Dungeon234 gamedata pointer [0xA58]
.int 0 # Clear_Dungeon234 savedata pointer [0xA5C]
.int 0 # Clear_Dungeon235 gamedata pointer [0xA60]
.int 0 # Clear_Dungeon235 savedata pointer [0xA64]
.int 0 # Clear_Dungeon236 gamedata pointer [0xA68]
.int 0 # Clear_Dungeon236 savedata pointer [0xA6C]
.int 0 # Clear_Dungeon237 gamedata pointer [0xA70]
.int 0 # Clear_Dungeon237 savedata pointer [0xA74]
.int 0 # Clear_Dungeon238 gamedata pointer [0xA78]
.int 0 # Clear_Dungeon238 savedata pointer [0xA7C]
.int 0 # Clear_Dungeon239 gamedata pointer [0xA80]
.int 0 # Clear_Dungeon239 savedata pointer [0xA84]
.int 0 # Clear_Dungeon240 gamedata pointer [0xA88]
.int 0 # Clear_Dungeon240 savedata pointer [0xA8C]
.int 0 # Clear_Dungeon241 gamedata pointer [0xA90]
.int 0 # Clear_Dungeon241 savedata pointer [0xA94]
.int 0 # Clear_Dungeon242 gamedata pointer [0xA98]
.int 0 # Clear_Dungeon242 savedata pointer [0xA9C]
.int 0 # Clear_Dungeon243 gamedata pointer [0xAA0]
.int 0 # Clear_Dungeon243 savedata pointer [0xAA4]
.int 0 # Clear_Dungeon244 gamedata pointer [0xAA8]
.int 0 # Clear_Dungeon244 savedata pointer [0xAAC]
.int 0 # Clear_Dungeon245 gamedata pointer [0xAB0]
.int 0 # Clear_Dungeon245 savedata pointer [0xAB4]
.int 0 # Clear_Dungeon246 gamedata pointer [0xAB8]
.int 0 # Clear_Dungeon246 savedata pointer [0xABC]
.int 0 # Clear_Dungeon247 gamedata pointer [0xAC0]
.int 0 # Clear_Dungeon247 savedata pointer [0xAC4]
.int 0 # Clear_Dungeon248 gamedata pointer [0xAC8]
.int 0 # Clear_Dungeon248 savedata pointer [0xACC]
.int 0 # Clear_Dungeon249 gamedata pointer [0xAD0]
.int 0 # Clear_Dungeon249 savedata pointer [0xAD4]
.int 0 # Clear_Dungeon250 gamedata pointer [0xAD8]
.int 0 # Clear_Dungeon250 savedata pointer [0xADC]
.int 0 # Clear_Dungeon251 gamedata pointer [0xAE0]
.int 0 # Clear_Dungeon251 savedata pointer [0xAE4]
.int 0 # Clear_Dungeon252 gamedata pointer [0xAE8]
.int 0 # Clear_Dungeon252 savedata pointer [0xAEC]
.int 0 # Clear_Dungeon253 gamedata pointer [0xAF0]
.int 0 # Clear_Dungeon253 savedata pointer [0xAF4]
.int 0 # Clear_Dungeon254 gamedata pointer [0xAF8]
.int 0 # Clear_Dungeon254 savedata pointer [0xAFC]
.int 0 # Clear_Dungeon255 gamedata pointer [0xB00]
.int 0 # Clear_Dungeon255 savedata pointer [0xB04]
.int 0 # BombsNum gamedata pointer [0xB08]
.int -1 # BombsNum savedata pointer [0xB0C]
.int 0 # SmallKey gamedata pointer [0xB10] -> *((s32 *) ((void *) pointer + 32 * Item zero-based index + 0x14)) = SmallKey[Item zero-based index]
.int -1 # SmallKey savedata pointer [0xB14]

_BOTW_DataLayer_GameData:
.int 8 # Data types count
# Bool game data to collect
.int 0x010B0008 # Data count(267), HashValue offset(8)
.int -2784 # Data offset in the '_BOTW_DataLayer_SharedData array' (multiplied by -1 for custom bool data)
.int -27402791 # Clear_Dungeon251 (FE5DDDD9)
.int 1184
.int -36107849 # Clear_Dungeon051 (FDD909B7)
.int -1984
.int -65313920 # Clear_Dungeon151 (FC1B6380)
.int -2016
.int -76109927 # Clear_Dungeon155 (FB76A799)
.int -2440
.int -84504264 # Clear_Dungeon208 (FAF69138)
.int 1216
.int -88814162 # Clear_Dungeon055 (FAB4CDAE)
.int 4
.int -109086105 # WM_NighttimeFlag (F97F7A67)
.int 840
.int -109951658 # Clear_Dungeon008 (F9724556)
.int -2816
.int -114288192 # Clear_Dungeon255 (F93019C0)
.int 1640
.int -122671263 # Clear_Dungeon108 (F8B02F61)
.int 776
.int -139866780 # Clear_Dungeon000 (F7A9CD64)
.int 1576
.int -160716973 # Clear_Dungeon100 (F66BA753)
.int -2376
.int -198371062 # Clear_Dungeon200 (F42D190A)
.int -2408
.int -213852909 # Clear_Dungeon204 (F340DD13)
.int 100
.int -215260033 # LastBossIncompleteGanonGenerateFlag (F32B647F)
.int 1248
.int -217939579 # Clear_Dungeon059 (F3028185)
.int -2048
.int -222237774 # Clear_Dungeon159 (F2C0EBB2)
.int 1608
.int -251239606 # Clear_Dungeon104 (F106634A)
.int 808
.int -255587971 # Clear_Dungeon004 (F0C4097D)
.int 1656
.int -277834222 # Clear_Dungeon110 (EF709612)
.int 856
.int -290259931 # Clear_Dungeon010 (EEB2FC25)
.int 12
.int -290582316 # IsGet_Armor_001_Lower (EEAE10D4)
.int -2456
.int -315217845 # Clear_Dungeon210 (ED36284B)
.int -1968
.int -337913101 # Clear_Dungeon149 (EBDBDAF3)
.int -2488
.int -363074478 # Clear_Dungeon214 (EA5BEC52)
.int 1168
.int -367415100 # Clear_Dungeon049 (EA19B0C4)
.int 888
.int -371247044 # Clear_Dungeon014 (E9DF383C)
.int -2768
.int -375561046 # Clear_Dungeon249 (E99D64AA)
.int 1688
.int -400731637 # Clear_Dungeon114 (E81D520B)
.int -2704
.int -414782312 # Clear_Dungeon241 (E746EC98)
.int -1904
.int -452963647 # Clear_Dungeon141 (E50052C1)
.int 1104
.int -457033482 # Clear_Dungeon041 (E4C238F6)
.int -2520
.int -470966151 # Clear_Dungeon218 (E3EDA079)
.int 1136
.int -475005713 # Clear_Dungeon045 (E3AFFCEF)
.int -1936
.int -496134440 # Clear_Dungeon145 (E26D96D8)
.int 1720
.int -508879328 # Clear_Dungeon118 (E1AB1E20)
.int 920
.int -529959913 # Clear_Dungeon018 (E0697417)
.int -2736
.int -534042495 # Clear_Dungeon245 (E02B2881)
.int -2616
.int -553628983 # Clear_Dungeon230 (DF004AC9)
.int 1816
.int -582552432 # Clear_Dungeon130 (DD46F490)
.int 1016
.int -595288409 # Clear_Dungeon030 (DC849EA7)
.int 1048
.int -605463874 # Clear_Dungeon034 (DBE95ABE)
.int 1848
.int -634703735 # Clear_Dungeon134 (DA2B3089)
.int -2128
.int -638732175 # Clear_Dungeon169 (D9EDB871)
.int -2648
.int -663908656 # Clear_Dungeon234 (D86D8ED0)
.int 1328
.int -667954618 # Clear_Dungeon069 (D82FD246)
.int -2264
.int -674133906 # Clear_Dungeon186 (D7D1886E)
.int -2064
.int -684314557 # Clear_Dungeon161 (D7363043)
.int 1264
.int -688629132 # Clear_Dungeon061 (D6F45A74)
.int 1464
.int -703339943 # Clear_Dungeon086 (D613E259)
.int -1880
.int -744653662 # Clear_Dungeon138 (D39D7CA2)
.int 1080
.int -765520235 # Clear_Dungeon038 (D25F1695)
.int -2680
.int -774126853 # Clear_Dungeon238 (D1DBC2FB)
.int 1296
.int -778461587 # Clear_Dungeon065 (D1999E6D)
.int 1432
.int -780261824 # Clear_Dungeon082 (D17E2640)
.int -2232
.int -792966025 # Clear_Dungeon182 (D0BC4C77)
.int -2096
.int -799280038 # Clear_Dungeon165 (D05BF45A)
.int 1344
.int -806393035 # Clear_Dungeon071 (CFEF6B35)
.int 1544
.int -821505256 # Clear_Dungeon096 (CF08D318)
.int -2344
.int -825575121 # Clear_Dungeon196 (CECAB92F)
.int -2144
.int -835911422 # Clear_Dungeon171 (CE2D0102)
.int 1000
.int -884725804 # Clear_Dungeon028 (CB4427D4)
.int 1800
.int -897167901 # Clear_Dungeon128 (CA864DE3)
.int -2312
.int -911770314 # Clear_Dungeon192 (C9A77D36)
.int -2176
.int -918502117 # Clear_Dungeon175 (C940C51B)
.int -2600
.int -926878790 # Clear_Dungeon228 (C8C0F3BA)
.int 1376
.int -930959572 # Clear_Dungeon075 (C882AF2C)
.int 1512
.int -932899071 # Clear_Dungeon092 (C8651701)
.int -2536
.int -971277432 # Clear_Dungeon220 (C61B7B88)
.int 936
.int -979390490 # Clear_Dungeon020 (C59FAFE6)
.int 1736
.int -1000487471 # Clear_Dungeon120 (C45DC5D1)
.int 1768
.int -1020263992 # Clear_Dungeon124 (C33001C8)
.int 968
.int -1024300033 # Clear_Dungeon024 (C2F26BFF)
.int -2568
.int -1049182319 # Clear_Dungeon224 (C176BF91)
.int 1408
.int -1053498617 # Clear_Dungeon079 (C134E307)
.int -2208
.int -1057584848 # Clear_Dungeon179 (C0F68930)
.int -2608
.int -1077427412 # Clear_Dungeon229 (BFC7C32C)
.int 1368
.int -1081761862 # Clear_Dungeon074 (BF859FBA)
.int 1520
.int -1084086377 # Clear_Dungeon093 (BF622797)
.int -2320
.int -1096790624 # Clear_Dungeon193 (BEA04DA0)
.int -2168
.int -1102580339 # Clear_Dungeon174 (BE47F58D)
.int 1808
.int -1115587211 # Clear_Dungeon129 (BD817D75)
.int 1008
.int -1136453822 # Clear_Dungeon029 (BC431742)
.int 20
.int -1139553125 # IsGet_Obj_DRStone_Get (BC13CC9B)
.int -2352
.int -1177712199 # Clear_Dungeon197 (B9CD89B9)
.int -2136
.int -1188417132 # Clear_Dungeon170 (B92A3194)
.int 1336
.int -1192731741 # Clear_Dungeon070 (B8E85BA3)
.int 1552
.int -1206918258 # Clear_Dungeon097 (B80FE38E)
.int -2200
.int -1208895066 # Clear_Dungeon178 (B7F1B9A6)
.int -2576
.int -1234071801 # Clear_Dungeon225 (B6718F07)
.int 1400
.int -1238117487 # Clear_Dungeon078 (B633D391)
.int 976
.int -1242211479 # Clear_Dungeon025 (B5F55B69)
.int 1776
.int -1271451298 # Clear_Dungeon125 (B437315E)
.int 1744
.int -1285884601 # Clear_Dungeon121 (B35AF547)
.int 944
.int -1298620560 # Clear_Dungeon021 (B2989F70)
.int -2544
.int -1323545826 # Clear_Dungeon221 (B11C4B1E)
.int 28
.int -1328839279 # IsGet_Armor_014_Head (B0CB8591)
.int -2656
.int -1351958970 # Clear_Dungeon235 (AF6ABE46)
.int 1320
.int -1356274992 # Clear_Dungeon068 (AF28E2D0)
.int -2120
.int -1360361241 # Clear_Dungeon168 (AEEA88E7)
.int 1856
.int -1389625313 # Clear_Dungeon135 (AD2C001F)
.int 1056
.int -1393661400 # Clear_Dungeon035 (ACEE6A28)
.int 1024
.int -1417433551 # Clear_Dungeon031 (AB83AE31)
.int 1824
.int -1438530554 # Clear_Dungeon131 (AA41C406)
.int -2624
.int -1475904929 # Clear_Dungeon231 (A8077A5F)
.int -2240
.int -1480885023 # Clear_Dungeon183 (A7BB7CE1)
.int -2088
.int -1487092532 # Clear_Dungeon164 (A75CC4CC)
.int -2688
.int -1495469459 # Clear_Dungeon239 (A6DCF26D)
.int 1288
.int -1499549957 # Clear_Dungeon064 (A69EAEFB)
.int 1440
.int -1502013738 # Clear_Dungeon083 (A67916D6)
.int 1088
.int -1520949757 # Clear_Dungeon039 (A5582603)
.int -1888
.int -1533391820 # Clear_Dungeon139 (A49A4C34)
.int 1256
.int -1577882910 # Clear_Dungeon060 (A1F36AE2)
.int 1472
.int -1592470833 # Clear_Dungeon087 (A114D2CF)
.int -2272
.int -1596540680 # Clear_Dungeon187 (A0D6B8F8)
.int -2056
.int -1607401259 # Clear_Dungeon160 (A03100D5)
.int 1696
.int -1625660771 # Clear_Dungeon115 (9F1A629D)
.int 896
.int -1630009174 # Clear_Dungeon015 (9ED808AA)
.int -2760
.int -1634053060 # Clear_Dungeon248 (9E9A543C)
.int -2496
.int -1654858556 # Clear_Dungeon215 (9D5CDCC4)
.int 1160
.int -1658945454 # Clear_Dungeon048 (9D1E8052)
.int -1960
.int -1663243675 # Clear_Dungeon148 (9CDCEA65)
.int -2464
.int -1708058403 # Clear_Dungeon211 (9A3118DD)
.int 864
.int -1716138829 # Clear_Dungeon011 (99B5CCB3)
.int 1664
.int -1736989052 # Clear_Dungeon111 (9877A684)
.int 928
.int -1754381183 # Clear_Dungeon019 (976E4481)
.int -2728
.int -1758717929 # Clear_Dungeon244 (972C1817)
.int 1728
.int -1767100746 # Clear_Dungeon119 (96AC2EB6)
.int -1928
.int -1788172722 # Clear_Dungeon144 (956AA64E)
.int -2528
.int -1796566801 # Clear_Dungeon219 (94EA90EF)
.int 1128
.int -1800876935 # Clear_Dungeon044 (94A8CC79)
.int 1096
.int -1815803808 # Clear_Dungeon040 (93C50860)
.int -1896
.int -1845009833 # Clear_Dungeon140 (92076257)
.int -2696
.int -1874732018 # Clear_Dungeon240 (9041DC0E)
.int 1648
.int -1883824137 # Clear_Dungeon109 (8FB71FF7)
.int 848
.int -1904904768 # Clear_Dungeon009 (8E7575C0)
.int -2808
.int -1908987562 # Clear_Dungeon254 (8E372956)
.int -2448
.int -1913544274 # Clear_Dungeon209 (8DF1A1AE)
.int 1208
.int -1917584072 # Clear_Dungeon054 (8DB3FD38)
.int -2008
.int -1938712817 # Clear_Dungeon154 (8C71970F)
.int -1976
.int -1961077994 # Clear_Dungeon150 (8B1C5316)
.int 1176
.int -1965147871 # Clear_Dungeon050 (8ADE3921)
.int -2776
.int -1990529713 # Clear_Dungeon250 (895AED4F)
.int 816
.int -2017248789 # Clear_Dungeon005 (87C339EB)
.int 1616
.int -2046733348 # Clear_Dungeon105 (860153DC)
.int -2040
.int -2050499804 # Clear_Dungeon158 (85C7DB24)
.int -2416
.int -2075660923 # Clear_Dungeon205 (8447ED85)
.int 1240
.int -2080001773 # Clear_Dungeon058 (8405B113)
.int -2384
.int -2094388836 # Clear_Dungeon201 (832A299C)
.int 1584
.int -2123589691 # Clear_Dungeon101 (816C97C5)
.int 784
.int -2136015374 # Clear_Dungeon001 (80AEFDF2)
.int -2712
.int 2119154978 # Clear_Dungeon242 (7E4FBD22)
.int 1112
.int 2110482764 # Clear_Dungeon042 (7DCB694C)
.int -1912
.int 2080965499 # Clear_Dungeon142 (7C09037B)
.int -1944
.int 2070202210 # Clear_Dungeon146 (7B64C762)
.int 1144
.int 2057743701 # Clear_Dungeon046 (7AA6AD55)
.int -2744
.int 2032302395 # Clear_Dungeon246 (7922793B)
.int 880
.int 2008788383 # Clear_Dungeon013 (77BBAD9F)
.int 1680
.int 1987692456 # Clear_Dungeon113 (7679C7A8)
.int -2480
.int 1950317041 # Clear_Dungeon213 (743F79F1)
.int -2512
.int 1934802408 # Clear_Dungeon217 (7352BDE8)
.int 1712
.int 1897137073 # Clear_Dungeon117 (711403B1)
.int 912
.int 1893099910 # Clear_Dungeon017 (70D66986)
.int 36
.int 1882996717 # IsGet_Armor_014_Lower (703C3FED)
.int 1600
.int 1868756713 # Clear_Dungeon103 (6F62F6E9)
.int 800
.int 1856019678 # Clear_Dungeon003 (6EA09CDE)
.int -2400
.int 1831094448 # Clear_Dungeon203 (6D2448B0)
.int -2432
.int 1783205033 # Clear_Dungeon207 (6A498CA9)
.int 832
.int 1775065287 # Clear_Dungeon007 (69CD58C7)
.int 1632
.int 1745826544 # Clear_Dungeon107 (680F32F0)
.int -2792
.int 1733594211 # Clear_Dungeon252 (67548C63)
.int -1992
.int 1695691322 # Clear_Dungeon152 (6512323A)
.int 1192
.int 1691375629 # Clear_Dungeon052 (64D0580D)
.int 1224
.int 1673370644 # Clear_Dungeon056 (63BD9C14)
.int -2024
.int 1652553251 # Clear_Dungeon156 (627FF623)
.int 1568
.int 1605881481 # Clear_Dungeon099 (5FB7CE89)
.int -2560
.int 1595025970 # Clear_Dungeon223 (5F122A32)
.int -2368
.int 1584768190 # Clear_Dungeon199 (5E75A4BE)
.int 1760
.int 1565824107 # Clear_Dungeon123 (5D54946B)
.int 108
.int 1564262366 # GanonQuest_Finished (5D3CBFDE)
.int 960
.int 1553399388 # Clear_Dungeon023 (5C96FE5C)
.int 992
.int 1543191109 # Clear_Dungeon027 (5BFB3A45)
.int 44
.int 1534340910 # IsGet_Armor_006_Head (5B742F2E)
.int 1792
.int 1513705586 # Clear_Dungeon127 (5A395072)
.int -2592
.int 1484779051 # Clear_Dungeon227 (587FEE2B)
.int -2336
.int 1472456853 # Clear_Dungeon195 (57C3E895)
.int -2152
.int 1461997752 # Clear_Dungeon172 (572450B8)
.int 1352
.int 1457928847 # Clear_Dungeon072 (56E63A8F)
.int 92
.int 1450198373 # FirstInHyruleCastleBossRoom (56704565)
.int 1536
.int 1442939554 # Clear_Dungeon095 (560182A2)
.int 1384
.int 1368129174 # Clear_Dungeon076 (518BFE96)
.int 1504
.int 1366050491 # Clear_Dungeon091 (516C46BB)
.int -2304
.int 1353591948 # Clear_Dungeon191 (50AE2C8C)
.int -2184
.int 1346999457 # Clear_Dungeon176 (504994A1)
.int 1272
.int 1341983694 # Clear_Dungeon062 (4FFD0BCE)
.int 1456
.int 1327150051 # Clear_Dungeon085 (4F1AB3E3)
.int -2256
.int 1322834388 # Clear_Dungeon185 (4ED8D9D4)
.int -2072
.int 1312776697 # Clear_Dungeon162 (4E3F61F9)
.int -2224
.int 1236606413 # Clear_Dungeon181 (49B51DCD)
.int -2104
.int 1230153184 # Clear_Dungeon166 (4952A5E0)
.int 1304
.int 1217449943 # Clear_Dungeon066 (4890CFD7)
.int 1424
.int 1215789050 # Clear_Dungeon081 (487777FA)
.int -2288
.int 1198429695 # Clear_Dungeon189 (476E95FF)
.int 1488
.int 1185742792 # Clear_Dungeon089 (46ACFFC8)
.int 52
.int 1177225519 # LastBossGanonBeastGenerateFlag (462B092F)
.int -2640
.int 1175001971 # Clear_Dungeon233 (46091B73)
.int 1040
.int 1166921501 # Clear_Dungeon033 (458DCF1D)
.int 1840
.int 1146070314 # Clear_Dungeon133 (444FA52A)
.int -1872
.int 1126326579 # Clear_Dungeon137 (43226133)
.int 1072
.int 1121979140 # Clear_Dungeon037 (42E00B04)
.int -2672
.int 1097129834 # Clear_Dungeon237 (4164DF6A)
.int 1312
.int 1066925889 # Clear_Dungeon067 (3F97FF41)
.int 1416
.int 1064322924 # Clear_Dungeon080 (3F70476C)
.int -2216
.int 1051864411 # Clear_Dungeon180 (3EB22D5B)
.int -2112
.int 1045796214 # Clear_Dungeon167 (3E559576)
.int -2248
.int 970975554 # Clear_Dungeon184 (39DFE942)
.int -2080
.int 959992175 # Clear_Dungeon163 (3938516F)
.int 1280
.int 955923288 # Clear_Dungeon063 (38FA3B58)
.int 1448
.int 941458293 # Clear_Dungeon084 (381D8375)
.int -2664
.int 912519164 # Clear_Dungeon236 (3663EFFC)
.int 1064
.int 904346514 # Clear_Dungeon036 (35E73B92)
.int 1864
.int 874860965 # Clear_Dungeon136 (342551A5)
.int 1832
.int 860394940 # Clear_Dungeon132 (334895BC)
.int 1032
.int 847970187 # Clear_Dungeon032 (328AFF8B)
.int 1480
.int 833343326 # Clear_Dungeon088 (31ABCF5E)
.int -2632
.int 823012325 # Clear_Dungeon232 (310E2BE5)
.int -2280
.int 812229993 # Clear_Dungeon188 (3069A569)
.int -2584
.int 796450493 # Clear_Dungeon226 (2F78DEBD)
.int 1784
.int 759062756 # Clear_Dungeon126 (2D3E60E4)
.int 984
.int 754715347 # Clear_Dungeon026 (2CFC0AD3)
.int 952
.int 730975946 # Clear_Dungeon022 (2B91CECA)
.int 1752
.int 710124797 # Clear_Dungeon122 (2A53A4FD)
.int -2360
.int 695374888 # Clear_Dungeon198 (29729428)
.int 1560
.int 682688031 # Clear_Dungeon098 (28B0FE1F)
.int -2552
.int 672471716 # Clear_Dungeon222 (28151AA4)
.int -2296
.int 665394202 # Clear_Dungeon190 (27A91C1A)
.int -2192
.int 659465271 # Clear_Dungeon177 (274EA437)
.int 1392
.int 646761984 # Clear_Dungeon077 (268CCE00)
.int 1496
.int 644576813 # Clear_Dungeon090 (266B762D)
.int 1360
.int 568396313 # Clear_Dungeon073 (21E10A19)
.int 1528
.int 554086964 # Clear_Dungeon094 (2106B234)
.int -2328
.int 549771267 # Clear_Dungeon194 (20C4D803)
.int -2160
.int 539189294 # Clear_Dungeon173 (2023602E)
.int 1624
.int 520618598 # Clear_Dungeon106 (1F080266)
.int 824
.int 516581457 # Clear_Dungeon006 (1ECA6851)
.int -2424
.int 491699263 # Clear_Dungeon206 (1D4EBC3F)
.int -2392
.int 438532134 # Clear_Dungeon202 (1A237826)
.int 792
.int 430419016 # Clear_Dungeon002 (19A7AC48)
.int 1592
.int 409323135 # Clear_Dungeon102 (1865C67F)
.int -2032
.int 360236725 # Clear_Dungeon157 (1578C6B5)
.int 1232
.int 347778178 # Clear_Dungeon057 (14BAAC82)
.int 1200
.int 332884123 # Clear_Dungeon053 (13D7689B)
.int -2000
.int 303366828 # Clear_Dungeon153 (121502AC)
.int 60
.int 284793682 # IsGet_Armor_014_Upper (10F99B52)
.int -2800
.int 273923317 # Clear_Dungeon253 (1053BCF5)
.int -2752
.int 237324717 # Clear_Dungeon247 (0E2549AD)
.int 1152
.int 228695491 # Clear_Dungeon047 (0DA19DC3)
.int -1952
.int 207878132 # Clear_Dungeon147 (0C63F7F4)
.int -1920
.int 185480173 # Clear_Dungeon143 (0B0E33ED)
.int 1120
.int 181164506 # Clear_Dungeon043 (0ACC59DA)
.int -2720
.int 155749812 # Clear_Dungeon243 (09488DB4)
.int 904
.int 131160336 # Clear_Dungeon016 (07D15910)
.int 1704
.int 101921575 # Clear_Dungeon116 (06133327)
.int -2504
.int 72715646 # Clear_Dungeon216 (04558D7E)
.int -2472
.int 54020455 # Clear_Dungeon212 (03384967)
.int 1672
.int 25098046 # Clear_Dungeon112 (017EF73E)
.int 872
.int 12360969 # Clear_Dungeon012 (00BC9D09)
# S32 game data to collect
.int 0x00060018 # Data count(6), HashValue offset(24)
.int 68 # Data offset in the '_BOTW_DataLayer_SharedData array' (multiplied by -1 for custom s32 data)
.int -830800173 # CurrentMamo (CE7AFED3)
.int 132
.int -1330055697 # WM_TimeDivision (B0B8F5EF)
.int 76
.int 2068572241 # WM_NumberOfDays (7B4BE851)
.int -2824
.int 1178149298 # BombsNum (463921B2)
.int 124
.int 688321319 # MaxHartValue (2906F327)
.int 84
.int 588553208 # CurrentRupee (23149BF8)
# F32 game data to collect
.int 0x00010018 # Data count(1), HashValue offset(24)
.int 116 # Data offset in the '_BOTW_DataLayer_SharedData array' (multiplied by -1 for custom f32 data)
.int 1110761881 # WM_BloodyMoonTimer (4234E199)
# String32 game data to collect (HashValue offset=184, PlayerSavePosMapName useful only [200187462][0BEE9E46])
.int 0
# String64 game data to collect
.int 0
# String256 game data to collect
.int 0
# Vector2f game data to collect
.int 0
# Vector3f game data to collect
.int 0x00010038 # Data count(1), HashValue offset(56)
.int 140 # Data offset in the '_BOTW_DataLayer_SharedData array'
.int -1542741757 # PlayerSavePos (A40BA103)
# Vector4f game data to collect
.int 0
# Bool array game data to collect
.int -0x00010008 # Data count(1), HashValue offset(8)
.int 0x009402FC # Data (array length, array pointer) offsets in the '_BOTW_DataLayer_SharedData array'
.int -2109173058 # PorchItem_EquipFlag (824892BE)
# S32 array game data to collect
.int -0x00020018 # Data count(2), HashValue offset(24)
.int 0x009A0B10 # Data (array length, array pointer) offsets in the '_BOTW_DataLayer_SharedData array'
.int -135513030 # SmallKey (F7EC3C3A)
.int 0x009402F4
.int 1779039321 # PorchItem_Value1 (6A09FC59)
# F32 array game data to collect
.int 0
# String32 array game data to collect (no string32_array_data)
.int 0
# String64 array game data to collect
.int -0x00060138 # Data count(6), HashValue offset(312)
.int 0x009400FC # Data (array length, array pointer) offsets in the '_BOTW_DataLayer_SharedData array'
.int 1596469897 # PorchItem (5F283289)
.int 0x009600D4
.int -861179395 # CookMaterialName0 (CCAB71FD)
.int 0x009600DC
.int -1146338965 # CookMaterialName1 (BBAC416B)
.int 0x009600E4
.int 581243089 # CookMaterialName2 (22A510D1)
.int 0x009600EC
.int 1436688455 # CookMaterialName3 (55A22047)
.int 0x009600F4
.int -876169756 # CookMaterialName4 (CBC6B5E4)
# String256 array game data to collect
.int 0
# Vector2f array game data to collect
.int -0x00030028 # Data count(3), HashValue offset(40)
.int 0x009800CC # Data (array length, array pointer) offsets in the '_BOTW_DataLayer_SharedData array'
.int -2003658349 # CookEffect1 [selling prices, 0.0] for cooked foods (88929993)
.int 0x009800C4
.int -6969083 # CookEffect0 [effect type, effect level|value] for cooked foods (FF95A905)
.int 0x009800BC
.int -631195443 # StaminaRecover [heal bonus, bonus duration] for cooked foods (DA60B8CD)
# vector3f array game data to collect
.int 0

_BOTW_DataLayer_BuildDataLayer:
lis r3, _BOTW_DataLayer_SharedData@ha
lwzu r4, _BOTW_DataLayer_SharedData@l(r3)
lis r31, 0x4000 # Restore the Item Limiter default settings
stw r31, 0xA4(r3)
stw r31, 0xAC(r3)
lis r31, 0x3E7
addi r31, r31, 160
stw r31, 0xA8(r3)
subi r31, r31, 100
stw r31, 0xB0(r3)
cmpw r4, r3
li r31, 0
beqlr
lis r5, _BOTW_DataLayer_GameData@ha
lwzu r24, _BOTW_DataLayer_GameData@l(r5)
cmpwi r24, 0
beqlr
lis r4, 0x1047
lwz r12, -0x29E8(r4)
lwz r11, 0xC34(r12)
lwz r11, 0x0(r11)
cmpwi r11, 0
beqlr
lwz r6, 0x4(r11) # game_data.sav filesize
lwz r12, 0x920(r12)
addi r11, r12, 12 # First save data memory location
add r12, r12, r6
subi r12, r12, 12 # Last save data memory location
lwz r4, -0x2a50(r4)
cmpwi r4, 0
beqlr
addi r10, r5, 4
stw r10, 0x304(r3)
lwz r4, 0x710(r4)
lwz r4, 0x0(r4)
lwzu r21, 0x4(r5)
cmpwi r21, 0
bne .+0xC # if EXIST(user defined data for the current gamedata to collect) GOTO blt .+0x110
addi r4, r4, 12
b .-0x10 # GOTO lwzu r21, 0x4(r5)
blt .+0x110 # if (current gamedata type to collect==VECTOR) GOTO sub r21, r31, r21
rlwinm r16, r21, 0, 16, 31
srwi r21, r21, 16
lwz r20, 0x8(r4)
slwi r20, r20, 2
lwzu r19, 0xC(r4)
add r20, r20, r19
slwi r21, r21, 3
add r21, r21, r5
lwz r22, 0x4(r5)
lwzu r18, 0x8(r5)
cmpw r19, r20
beqlr
lwzu r23, -0x4(r20)
lwzx r17, r16, r23
cmplw r17, r18
bgt .-0x14 # if (extracted hash r17>expected hash r18) GOTO cmpw r19, r20
beq .+0x24 # if (extracted hash r17==expected hash r18) GOTO cmpwi r22, 0
cmpwi r22, 0
bgelr
sub r23, r10, r16
sub r22, r31, r22
stwux r23, r22, r3
stw r31, 0x4(r22)
addi r20, r20, 4
b .+0x90 # GOTO cmpw r21, r5
cmpwi r22, 0
bge .+0x8 # if (is vanilla gamedata) GOTO stwux r23, r22, r3
sub r22, r31, r22
stwux r23, r22, r3
lwz r7, 0x4(r22)
cmpwi r7, 0
beq .+0x74 # if (savedata pointer init value r7==0) GOTO cmpw r21, r5
lwz r17, 0x0(r11)
cmpw r18, r17
mr r7, r11
beq .+0x60 # if (gamedata hash==first save data hash) GOTO stw r7, 0x4(r22)
lwz r17, 0x0(r12)
cmpw r18, r17
mr r7, r12
beq .+0x40 # if (gamedata hash==last save data hash) GOTO lwzu r17, -0x8(r7)
mr r6, r11
mr r23, r12
sub r7, r23, r6
rlwinm r17, r7, 29, 31, 31
slwi r17, r17, 2
srwi r7, r7, 1
add r7, r7, r17
lwzux r17, r7, r6
cmplw r18, r17
beq .+0x18 # if (gamedata hash==save data hash) GOTO lwzu r17, -0x8(r7)
blt .+0xC # if (gamedata hash<save data hash) GOTO mr r23, r7
mr r6, r7
b .-0x28 # GOTO sub r7, r23, r6
mr r23, r7
b .-0x30 # GOTO sub r7, r23, r6
lwzu r17, -0x8(r7)
cmpw r18, r17
beq .-0x8
addi r7, r7, 8
stw r7, 0x4(r22)
cmpw r21, r5
bne .-0xD4 # if (still user-defined data for the current gamedata) GOTO lwz r22, 0x4(r5)
addic. r24, r24, -1
bne .-0x114 # if (still user-defined gamedata) GOTO lwzu r21, 0x4(r5)
stw r3, 0x0(r3)
stw r24, -0x4(r10)
blr
sub r21, r31, r21
rlwinm r16, r21, 0, 16, 31
srwi r21, r21, 16
lwz r20, 0x8(r4)
slwi r20, r20, 2
lwzu r19, 0xC(r4)
add r20, r20, r19
slwi r21, r21, 3
add r21, r21, r5
cmpw r19, r20
beqlr
lwzu r23, -0x4(r20)
lwz r22, 0x0(r23)
lwz r23, 0xC(r23)
lwzx r17, r16, r23
mr r15, r5
lwzu r18, 0x8(r15)
cmpw r17, r18
beq .+0x10 # if (extracted hash r17==expected hashes[index] r18) GOTO lwz r6, -0x4(r15)
cmpw r15, r21
beq .-0x2C # if ('expected hashes[index] reading loop' end) GOTO cmpw r19, r20
b .-0x14 # GOTO lwzu r18, 0x8(r15)
lwz r6, -0x4(r15)
rlwinm r17, r6, 0, 16, 31
srwi r6, r6, 16
add r6, r6, r3
sth r22, 0x0(r6) # use STHX instruction in the future
stwux r23, r17, r3
lwz r7, 0x4(r17)
cmpwi r7, 0
beq .+0x74 # if (savedata pointer init value r7==0) GOTO addi r5, r5, 8
lwz r22, 0x0(r11)
cmpw r18, r22
mr r7, r11
beq .+0x60 # if (gamedata hash==first save data hash) GOTO stw r7, 0x4(r17)
lwz r22, 0x0(r12)
cmpw r18, r22
mr r7, r12
beq .+0x40 # if (gamedata hash==last save data hash) GOTO lwzu r22, -0x8(r7)
mr r6, r11
mr r23, r12
sub r7, r23, r6
rlwinm r22, r7, 29, 31, 31
slwi r22, r22, 2
srwi r7, r7, 1
add r7, r7, r22
lwzux r22, r7, r6
cmplw r18, r22
beq .+0x18 # if (gamedata hash==save data hash) GOTO lwzu r22, -0x8(r7)
blt .+0xC # if (gamedata hash<save data hash) GOTO mr r23, r7
mr r6, r7
b .-0x28 # GOTO sub r7, r23, r6
mr r23, r7
b .-0x30 # GOTO sub r7, r23, r6
lwzu r22, -0x8(r7)
cmpw r18, r22
beq .-0x8
addi r7, r7, 8
stw r7, 0x4(r17)
addi r5, r5, 8
cmpw r21, r5
beq .-0x108 # GOTO addic. r24, r24, -1
cmpw r5, r15
beq .-0xD8 # GOTO cmpw r19, r20
lwz r22, 0x0(r5)
stw r22, 0x0(r15)
lwz r22, -0x4(r5)
stw r22, -0x4(r15)
b .-0xEC # GOTO cmpw r19, r20

_BOTW_DataLayer_FocusItem:
lwz r16, 0x8(r27)
lwz r3, 0x10(r27)
blr

_BOTW_DataLayer_LookItem:
add r0, r28, r31
cmpwi r16, 7
bne .+0x18
lis r26, _BOTW_DataLayer_MatCount@ha
lwzu r3, _BOTW_DataLayer_MatCount@l(r26)
lhz r24, 0x4(r26)
lwzu r25, -0x8(r26)
b .+0x24
cmpwi r16, 8
beq .+0xC
li r24, 0x3e7
blr
lis r26, _BOTW_DataLayer_FoodCount@ha
lwzu r3, _BOTW_DataLayer_FoodCount@l(r26)
lhz r24, 0x4(r26)
lwzu r25, -0x10(r26)
add r3, r3, r28
cmpw r3, r24
bge .+0x8
mr r24, r3
lwz r16, 0x404(r30)
cmplw r16, r25
bltlr
beq .+0x10
lwz r25, 0x4(r26)
cmpw r25, r16
bnelr
mr r24, r28
blr

_BOTW_DataLayer_LookNewFood:
lis r27, _BOTW_DataLayer_FoodCount@ha
lwzu r24, _BOTW_DataLayer_FoodCount@l(r27)
cmpwi r24, 0
bgt .+0xC
cmpw r3, r3
blr
lwz r25, -0x10(r27)
lwz r26, 0x404(r30)
cmplw r26, r25
blt .+0x14
beq .-0x18
lwz r25, -0xC(r27)
cmpw r25, r26
beq .-0x24
lhz r24, 0x6(r27)
cmpw r3, r24
blr

_BOTW_DataLayer_LookNewMat:
lis r27, _BOTW_DataLayer_MatCount@ha
lwzu r24, _BOTW_DataLayer_MatCount@l(r27)
cmpwi r24, 0
bgt .+0xC
cmpw r3, r3
blr
lwz r25, -0x8(r27)
lwz r26, 0x404(r30)
cmplw r26, r25
blt .+0x14
beq .-0x18
lwz r25, -0x4(r27)
cmpw r25, r26
beq .-0x24
lhz r24, 0x6(r27)
cmpw r3, r24
blr

_BOTW_DataLayer_LootItem:
cmpwi r24, 7
bne .+0x14
lis r5, _BOTW_DataLayer_MatCount@ha
lwzu r3, _BOTW_DataLayer_MatCount@l(r5)
addi r18, r5, -8
b .+0x28
cmpwi r24, 8
beq .+0x14
li r18, 0
li r4, 0x3e7
cmpwi r0, 0x3e7
blr
lis r5, _BOTW_DataLayer_FoodCount@ha
lwzu r3, _BOTW_DataLayer_FoodCount@l(r5)
addi r18, r5, -16
add r3, r3, r12
lhz r4, 0x4(r5)
cmpw r4, r3
ble .+0x8
mr r4, r3
cmpw r0, r4
blr

_BOTW_DataLayer_AddLootItem:
stw r0, 0x10(r10)
cmpwi r18, 0
beqlr
sub r3, r3, r0
stw r3, 0x0(r5)
lwz r5, 0x0(r18)
lwz r3, 0x404(r23)
cmplw r3, r5
bltlr
lwz r4, 0x4(r18)
beq .+0x14
cmpw r3, r4
bnelr
stw r5, 0x4(r18)
blr
cmpw r4, r3
bne .+0x8
li r4, -1
stw r4, 0x0(r18)
blr

0x0322CCC8 = bla _BOTW_DataLayer_BuildDataLayer # Data structure initialization area when (re)start|(re)load a game [li r31, 0]
0x02eaf6f0 = bla _BOTW_DataLayer_FocusItem # Current focused item (material|food|arrow already present in the inventory) area [lwz r3, +0x10(r27)]
0x02eafea8 = bla _BOTW_DataLayer_LookItem # Is focused item (material|food|arrow already present in the inventory) lootable area [add r0, r28, r31]
0x02eafeac = cmpw r0, r24 # [cmpwi r0, 0x3E7]
0x02eb0d9c = bla _BOTW_DataLayer_LootItem # Loot item (material|food|arrow already present in the inventory) area [cmpwi r0, 0x3e7]
0x02eb0da4 = mr r0, r4 # [li r0, 0x3e7]
0x02eb0da8 = bla _BOTW_DataLayer_AddLootItem # [stw r0, +0x10(r10)]
0x02eafdd4 = bla _BOTW_DataLayer_LookNewFood # Is focused food (not present in the inventory) lootable area [cmpwi r3, 0x3C]
0x02eafe20 = bla _BOTW_DataLayer_LookNewMat # Is focused material (not present in the inventory) lootable area [cmpwi r3, 0xa0]