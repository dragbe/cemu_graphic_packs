[BotwV208]
moduleMatches = 0x6267BFD0

.origin = codecave

.int 196387272
.int 2442090605
.int 1535280777
.int 3286432837
.int 1532272583
.int 2372027614
.int 598465132
.int 3007332426
.int 1239682
.int 1389340257
.int 377195081
.int 225004724
.int 29985339
.int 2371431414
.int 14 # Zora Helm possible treasure chests count
.int 10 # Relocated Zora Helm treasure chest EID
.int 2070850062
.int 469170580
.int 306589109
.int 13508045
.int 724255579
.int 3933297202
.int 4111773942
.int 4222398229
.int 2568257269
.int 4046343091
.int 10 # Climbing Boots possible treasure chests count
.int 8 # Relocated Climbing Boots treasure chest EID
.int 217594417
.int 246237684
.int 1965651867
.int 1491795805
.int 141775228
.int 1732323234
.int 3880452204
.int 2958931792
.int 68921327
.int 4011611883
.int 10 # Climbing Gear possible treasure chests count
.int 6 # Relocated Climbing Gear treasure chest EID
.int 2651527466
.int 3064461873
.int 3963465037
.int 3271006069
.int 2009260213
.int 1704474960
.int 2548659108
.int 3593840904
.int 3956041863
.int 1580711597
.int 10 # Climber's Bandanna possible treasure chests count
.int 4 # Relocated Climber's Bandanna treasure chest EID
.int 2074155839
.int 4129291175
.int 1558154797
.int 2493393346
.int 2856675622
.int 3222056974
.int 471032154
.int 3701641776
.int 3486341949
.int 3063385243
.int 946822747
.int 11 # Hylian Trousers possible treasure chests count
.int 2 # Relocated Hylian Trousers treasure chest EID
.int 5 # Relocated treasure chests count

_BOTW_UnexpectedTreasures_LastTreasureChestId:
.int 0
.int -1 # Treasure Chest Id

# Exclusions List
.int 10 # 0 = disables exclusions and relocated treasure chests
# [EID=1] Hylian Trousers treasure chest -> traveler's treasure chest
.int 1313140003 # https://objmap.zeldamods.org/#/map/z5,-736,1866.5?id=MainField,E-6,1313140003
.int 20 # bool data offset (IsGet_Obj_DRStone_Get here). if value=False then (default treasure chest content) else (go to next if)
.int 52 # bool data offset (LastBossGanonBeastGenerateFlag here). if value=True then (randomizes the treasure chest content from its default content) else (go to next if)
.int 8 # conditional game data type (Bool Game Data = 8, S32 Game Data = 12, F32 Game Data = 16)
.int 20 # conditional game data offset (IsGet_Obj_DRStone_Get here)
.int 0 # conditional game data cmp value
.int 0 # conditional game data cmp mode (Less Then = -1, Equal = 0, Greather Then = 1) but ignored for bool data. If value=True then (the treasure chest content=user-defined content) else (randomizes the treasure chest content from the user-defined content)
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 2003792484 # word
.int 1596993585 # _001
.int 0
.int 0
.int 0
.int 0
# [EID=2] Relocated Hylian Trousers treasure chest
.int 0
.int 20 # IsGet_Obj_DRStone_Get
.int 12 # IsGet_Armor_001_Lower
.int 8 # If (bool) IsGet_Obj_DRStone_Get = 1
.int 20
.int 1
.int 0
.int 15
.int 1098018159 # Armo
.int 1918840880 # r_00
.int 828329071 # 1_Lo
.int 2003137024 # wer
.int 0
.int 0
.int 0
.int 0
# [EID=3] Climber's Bandanna treasure chest -> Climber treasure chest
.int 1203109046 # Ree Dahee Shrine (Dungeon047) Static, 0x47b5fcb6
.int 20 # IsGet_Obj_DRStone_Get
.int 52 # LastBossGanonBeastGenerateFlag
.int 8 # If (bool) IsGet_Obj_DRStone_Get = 0
.int 20
.int 0
.int 0
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 2003792484 # word
.int 1596994865 # _051
.int 0
.int 0
.int 0
.int 0
# [EID=4] Relocated Climber's Bandanna treasure chest
.int 0
.int 20 # IsGet_Obj_DRStone_Get
.int 28 # IsGet_Armor_014_Head
.int 8 # If (bool) IsGet_Obj_DRStone_Get = 1
.int 20
.int 1
.int 0
.int 14
.int 1098018159 # Armo
.int 1918840881 # r_01
.int 878659685 # 4_He
.int 1633943552 # ad
.int 0
.int 0
.int 0
.int 0
# [EID=5] Climbing Gear treasure chest -> Climber treasure chest
.int 2231710576 # Chaas Qeta Shrine (Dungeon082) Static, 0x85053370
.int 20 # IsGet_Obj_DRStone_Get
.int 52 # LastBossGanonBeastGenerateFlag
.int 8 # If (bool) IsGet_Obj_DRStone_Get = 0
.int 20
.int 0
.int 0
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 2003792484 # word
.int 1596994865 # _051
.int 0
.int 0
.int 0
.int 0
# [EID=6] Relocated Climbing Gear treasure chest
.int 0
.int 20 # IsGet_Obj_DRStone_Get
.int 60 # IsGet_Armor_014_Upper
.int 8 # If (bool) IsGet_Obj_DRStone_Get = 1
.int 20
.int 1
.int 0
.int 15
.int 1098018159 # Armo
.int 1918840881 # r_01
.int 878663024 # 4_Up
.int 1885696512 # per
.int 0
.int 0
.int 0
.int 0
# [EID=7] Climbing Boots treasure chest -> Climber treasure chest
.int 2231710576 # Tahno O'ah Shrine (Dungeon119) Static, 0xe93ef4d0
.int 20 # IsGet_Obj_DRStone_Get
.int 52 # LastBossGanonBeastGenerateFlag
.int 8 # If (bool) IsGet_Obj_DRStone_Get = 0
.int 20
.int 0
.int 0
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 2003792484 # word
.int 1596994865 # _051
.int 0
.int 0
.int 0
.int 0
# [EID=8] Relocated Climbing Boots treasure chest
.int 0
.int 20 # IsGet_Obj_DRStone_Get
.int 36 # IsGet_Armor_014_Lower
.int 8 # If (bool) IsGet_Obj_DRStone_Get = 1
.int 20
.int 1
.int 0
.int 15
.int 1098018159 # Armo
.int 1918840881 # r_01
.int 878660719 # 4_Lo
.int 2003137024 # wer
.int 0
.int 0
.int 0
.int 0
# [EID=9] Zora Helm treasure chest -> Zora treasure chest
.int 1369310247 # https://objmap.zeldamods.org/#/map/z5,3466.5,-888.75?id=MainField,I-4,1369310247
.int 20 # IsGet_Obj_DRStone_Get
.int 52 # LastBossGanonBeastGenerateFlag
.int 8 # If (bool) IsGet_Obj_DRStone_Get = 0
.int 20
.int 0
.int 0
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 2003792484 # word
.int 1596994103 # _027
.int 0
.int 0
.int 0
.int 0
# [EID=10] Relocated Zora Helm treasure chest
.int 0
.int 20 # IsGet_Obj_DRStone_Get
.int 44 # IsGet_Armor_006_Head
.int 8 # If (bool) IsGet_Obj_DRStone_Get = 1
.int 20
.int 1
.int 0
.int 14
.int 1098018159 # Armo
.int 1918840880 # r_00
.int 912214117 # 6_He
.int 1633943552 # ad
.int 0
.int 0
.int 0
.int 0

_BOTW_UnexpectedTreasures_TreasureChests:
.int 38
# Traveler's treasure chest ID: 38
# Traveler's Sword
.int $TravelerSwordProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 2003792484 # word
.int 1596993585 # _001
.int 0
.int 0
.int 0
.int 0
# Traveler's Spear
.int $TravelerSpearProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1885692274 # pear
.int 1596993585 # _001
.int 0
.int 0
.int 0
.int 0
# Traveler's Claymore
.int $TravelerClaymoreProb
.int 17
.int 1466261872 # Weap
.int 1869504332 # on_L
.int 1937207154 # swor
.int 1683959856 # d_00
.int 822083584 # 1
.int 0
.int 0
.int 0
# Traveler's Bow
.int $TravelerBowProb
.int 14
.int 1466261872 # Weap
.int 1869504322 # on_B
.int 1870094128 # ow_0
.int 808517632 # 01
.int 0
.int 0
.int 0
.int 0
# Traveler's Shield
.int $TravelerShieldProb
.int 17
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1751737708 # hiel
.int 1683959859 # d_03
.int 889192448 # 5
.int 0
.int 0
.int 0
# New Traveler's treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Traveler's treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Traveler's treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Traveler's treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Traveler's treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# Arrow x5 treasure chest ID: 37
# Normal Arrow x5
.int $NormalArrowX5Prob
.int 20
.int 1331849823 # Obj_
.int 1098019439 # Arro
.int 2000844142 # wBun
.int 1684825439 # dle_
.int 1096757297 # A_01
.int 0
.int 0
.int 0
# Fire Arrow x5
.int $FireArrowX5Prob
.int 18
.int 1331849823 # Obj_
.int 1181315685 # Fire
.int 1098019439 # Arro
.int 2002731359 # w_A_
.int 808648704 # 03
.int 0
.int 0
.int 0
# Ice Arrow x5
.int $IceArrowX5Prob
.int 17
.int 1331849823 # Obj_
.int 1231250753 # IceA
.int 1920102263 # rrow
.int 1598119728 # _A_0
.int 855638016 # 3
.int 0
.int 0
.int 0
# Electric Arrow x5
.int $ElectricArrowX5Prob
.int 22
.int 1331849823 # Obj_
.int 1164731747 # Elec
.int 1953655139 # tric
.int 1098019439 # Arro
.int 2002731359 # w_A_
.int 808648704 # 03
.int 0
.int 0
# Bomb Arrow x5
.int $BombArrowX5Prob
.int 18
.int 1331849823 # Obj_
.int 1114598754 # Bomb
.int 1098019439 # Arro
.int 2002731359 # w_A_
.int 808583168 # 02
.int 0
.int 0
.int 0
# Ancient Arrow x3
.int $AncientArrowX3Prob
.int 21
.int 1331849823 # Obj_
.int 1097753449 # Anci
.int 1701737537 # entA
.int 1920102263 # rrow
.int 1598250800 # _C_0
.int 822083584 # 1
.int 0
.int 0
# New Arrow x5 treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Arrow x5 treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Arrow x5 treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Arrow x5 treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# Arrow x10 treasure chest ID: 36
# Normal Arrow x10
.int $NormalArrowX10Prob
.int 20
.int 1331849823 # Obj_
.int 1098019439 # Arro
.int 2000844142 # wBun
.int 1684825439 # dle_
.int 1096757298 # A_02
.int 0
.int 0
.int 0
# Fire Arrow x10
.int $FireArrowX10Prob
.int 18
.int 1331849823 # Obj_
.int 1181315685 # Fire
.int 1098019439 # Arro
.int 2002731359 # w_A_
.int 808583168 # 02
.int 0
.int 0
.int 0
# Ice Arrow x10
.int $IceArrowX10Prob
.int 17
.int 1331849823 # Obj_
.int 1231250753 # IceA
.int 1920102263 # rrow
.int 1598119728 # _A_0
.int 838860800 # 2
.int 0
.int 0
.int 0
# Electric Arrow x10
.int $ElectricArrowX10Prob
.int 22
.int 1331849823 # Obj_
.int 1164731747 # Elec
.int 1953655139 # tric
.int 1098019439 # Arro
.int 2002731359 # w_A_
.int 808583168 # 02
.int 0
.int 0
# Bomb Arrow x10
.int $BombArrowX10Prob
.int 18
.int 1331849823 # Obj_
.int 1114598754 # Bomb
.int 1098019439 # Arro
.int 2002731359 # w_A_
.int 808648704 # 03
.int 0
.int 0
.int 0
# Ancient Arrow x5
.int $AncientArrowX5Prob
.int 21
.int 1331849823 # Obj_
.int 1097753449 # Anci
.int 1701737537 # entA
.int 1920102263 # rrow
.int 1598185264 # _B_0
.int 822083584 # 1
.int 0
.int 0
# New Arrow x10 treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Arrow x10 treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Arrow x10 treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Arrow x10 treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# Gem treasure chest ID: 35
# Amber
.int $AmberProb
.int 10
.int 1232364909 # Item
.int 1599042149 # _Ore
.int 1598423040 # _F
.int 0
.int 0
.int 0
.int 0
.int 0
# Opal
.int $OpalProb
.int 10
.int 1232364909 # Item
.int 1599042149 # _Ore
.int 1598357504 # _E
.int 0
.int 0
.int 0
.int 0
.int 0
# Topaz
.int $TopazProb
.int 10
.int 1232364909 # Item
.int 1599042149 # _Ore
.int 1598291968 # _D
.int 0
.int 0
.int 0
.int 0
.int 0
# Ruby
.int $RubyProb
.int 10
.int 1232364909 # Item
.int 1599042149 # _Ore
.int 1598160896 # _B
.int 0
.int 0
.int 0
.int 0
.int 0
# Sapphire
.int $SapphireProb
.int 10
.int 1232364909 # Item
.int 1599042149 # _Ore
.int 1598226432 # _C
.int 0
.int 0
.int 0
.int 0
.int 0
# New Gem treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Gem treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Gem treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Gem treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Gem treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# Zora treasure chest ID: 34
# Zora Sword
.int $ZoraSwordProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 2003792484 # word
.int 1596994103 # _027
.int 0
.int 0
.int 0
.int 0
# Ceremonial Trident
.int $CeremonialTridentProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1885692274 # pear
.int 1596994617 # _049
.int 0
.int 0
.int 0
.int 0
# Silverscale Spear
.int $SilverscaleSpearProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1885692274 # pear
.int 1596994104 # _028
.int 0
.int 0
.int 0
.int 0
# Zora Spear
.int $ZoraSpearProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1885692274 # pear
.int 1596994103 # _027
.int 0
.int 0
.int 0
.int 0
# Silver Longsword
.int $SilverLongswordProb
.int 17
.int 1466261872 # Weap
.int 1869504332 # on_L
.int 1937207154 # swor
.int 1683959858 # d_02
.int 922746880 # 7
.int 0
.int 0
.int 0
# Silver Bow
.int $SilverBowProb
.int 14
.int 1466261872 # Weap
.int 1869504322 # on_B
.int 1870094128 # ow_0
.int 825491456 # 14
.int 0
.int 0
.int 0
.int 0
# Silver Shield
.int $SilverShieldProb
.int 17
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1751737708 # hiel
.int 1683959858 # d_02
.int 889192448 # 5
.int 0
.int 0
.int 0
# New Zora treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Zora treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Zora treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# Gerudo treasure chest ID: 33
# Moonlight Scimitar
.int $MoonlightScimitarProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 2003792484 # word
.int 1596994352 # _030
.int 0
.int 0
.int 0
.int 0
# Gerudo Scimitar
.int $GerudoScimitarProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 2003792484 # word
.int 1596994105 # _029
.int 0
.int 0
.int 0
.int 0
# Gerudo Spear
.int $GerudoSpearProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1885692274 # pear
.int 1596994105 # _029
.int 0
.int 0
.int 0
.int 0
# Golden Claymore
.int $GoldenClaymoreProb
.int 17
.int 1466261872 # Weap
.int 1869504332 # on_L
.int 1937207154 # swor
.int 1683959858 # d_02
.int 956301312 # 9
.int 0
.int 0
.int 0
# Golden Bow
.int $GoldenBowProb
.int 14
.int 1466261872 # Weap
.int 1869504322 # on_B
.int 1870094128 # ow_0
.int 825556992 # 15
.int 0
.int 0
.int 0
.int 0
# Radiant Shield
.int $RadiantShieldProb
.int 17
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1751737708 # hiel
.int 1683959859 # d_03
.int 905969664 # 6
.int 0
.int 0
.int 0
# Gerudo Shield
.int $GerudoShieldProb
.int 17
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1751737708 # hiel
.int 1683959858 # d_02
.int 905969664 # 6
.int 0
.int 0
.int 0
# New Gerudo treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Gerudo treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Gerudo treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# Rito treasure chest ID: 32
# Feathered Edge
.int $FeatheredEdgeProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 2003792484 # word
.int 1596994353 # _031
.int 0
.int 0
.int 0
.int 0
# Feathered Spear
.int $FeatheredSpearProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1885692274 # pear
.int 1596994354 # _032
.int 0
.int 0
.int 0
.int 0
# Falcon Bow
.int $FalconBowProb
.int 14
.int 1466261872 # Weap
.int 1869504322 # on_B
.int 1870094128 # ow_0
.int 825688064 # 17
.int 0
.int 0
.int 0
.int 0
# Swallow Bow
.int $SwallowBowProb
.int 14
.int 1466261872 # Weap
.int 1869504322 # on_B
.int 1870094128 # ow_0
.int 825622528 # 16
.int 0
.int 0
.int 0
.int 0
# Kite Shield
.int $KiteShieldProb
.int 17
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1751737708 # hiel
.int 1683959860 # d_04
.int 838860800 # 2
.int 0
.int 0
.int 0
# New Rito treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Rito treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Rito treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Rito treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Rito treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# Goron treasure chest ID: 31
# Drillshaft
.int $DrillshaftProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1885692274 # pear
.int 1596994353 # _031
.int 0
.int 0
.int 0
.int 0
# Stone Smasher
.int $StoneSmasherProb
.int 17
.int 1466261872 # Weap
.int 1869504332 # on_L
.int 1937207154 # swor
.int 1683959859 # d_03
.int 922746880 # 7
.int 0
.int 0
.int 0
# Cobble Crusher
.int $CobbleCrusherProb
.int 17
.int 1466261872 # Weap
.int 1869504332 # on_L
.int 1937207154 # swor
.int 1683959859 # d_03
.int 905969664 # 6
.int 0
.int 0
.int 0
# New Goron treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Goron treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Goron treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Goron treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Goron treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Goron treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Goron treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# Yiga treasure chest ID: 30
# Demon Carver
.int $DemonCarverProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 2003792484 # word
.int 1596995379 # _073
.int 0
.int 0
.int 0
.int 0
# Vicious Sickle
.int $ViciousSickleProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 2003792484 # word
.int 1596994867 # _053
.int 0
.int 0
.int 0
.int 0
# Windcleaver
.int $WindcleaverProb
.int 17
.int 1466261872 # Weap
.int 1869504332 # on_L
.int 1937207154 # swor
.int 1683959863 # d_07
.int 872415232 # 4
.int 0
.int 0
.int 0
# Duplex Bow
.int $DuplexBowProb
.int 14
.int 1466261872 # Weap
.int 1869504322 # on_B
.int 1870094128 # ow_0
.int 875560960 # 40
.int 0
.int 0
.int 0
.int 0
# New Yiga treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Yiga treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Yiga treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Yiga treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Yiga treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Yiga treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# Sheikah treasure chest ID: 29
# Eightfold Blade
.int $EightfoldBladeProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 2003792484 # word
.int 1596994609 # _041
.int 0
.int 0
.int 0
.int 0
# Serpentine Spear
.int $SerpentineSpearProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1885692274 # pear
.int 1596994359 # _037
.int 0
.int 0
.int 0
.int 0
# Edge Of Duality
.int $EdgeOfDualityProb
.int 17
.int 1466261872 # Weap
.int 1869504332 # on_L
.int 1937207154 # swor
.int 1683959861 # d_05
.int 889192448 # 5
.int 0
.int 0
.int 0
# Eightfold Longblade
.int $EightfoldLongbladeProb
.int 17
.int 1466261872 # Weap
.int 1869504332 # on_L
.int 1937207154 # swor
.int 1683959860 # d_04
.int 822083584 # 1
.int 0
.int 0
.int 0
# Phrenic Bow
.int $PhrenicBowProb
.int 14
.int 1466261872 # Weap
.int 1869504322 # on_B
.int 1870094128 # ow_0
.int 842596352 # 29
.int 0
.int 0
.int 0
.int 0
# Shield Of The Mind's Eye
.int $ShieldOfTheMindEyeProb
.int 17
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1751737708 # hiel
.int 1683959860 # d_04
.int 822083584 # 1
.int 0
.int 0
.int 0
# New Sheikah treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Sheikah treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Sheikah treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Sheikah treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# Soldier's treasure chest ID: 28
# Soldier's Broadsword
.int $SoldierBroadswordProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 2003792484 # word
.int 1596993586 # _002
.int 0
.int 0
.int 0
.int 0
# Soldier's Spear
.int $SoldierSpearProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1885692274 # pear
.int 1596993586 # _002
.int 0
.int 0
.int 0
.int 0
# Soldier's Claymore
.int $SoldierClaymoreProb
.int 17
.int 1466261872 # Weap
.int 1869504332 # on_L
.int 1937207154 # swor
.int 1683959856 # d_00
.int 838860800 # 2
.int 0
.int 0
.int 0
# Soldier's Bow
.int $SoldierBowProb
.int 14
.int 1466261872 # Weap
.int 1869504322 # on_B
.int 1870094128 # ow_0
.int 808583168 # 02
.int 0
.int 0
.int 0
.int 0
# Soldier's Shield
.int $SoldierShieldProb
.int 17
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1751737708 # hiel
.int 1683959856 # d_00
.int 838860800 # 2
.int 0
.int 0
.int 0
# New Soldier's treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Soldier's treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Soldier's treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Soldier's treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Soldier's treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# Knight's treasure chest ID: 27
# Knight's Broadsword
.int $KnightBroadswordProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 2003792484 # word
.int 1596993587 # _003
.int 0
.int 0
.int 0
.int 0
# Knight's Halberd
.int $KnightHalberdProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1885692274 # pear
.int 1596993587 # _003
.int 0
.int 0
.int 0
.int 0
# Knight's Claymore
.int $KnightClaymoreProb
.int 17
.int 1466261872 # Weap
.int 1869504332 # on_L
.int 1937207154 # swor
.int 1683959856 # d_00
.int 855638016 # 3
.int 0
.int 0
.int 0
# Knight's Bow
.int $KnightBowProb
.int 14
.int 1466261872 # Weap
.int 1869504322 # on_B
.int 1870094128 # ow_0
.int 859111424 # 35
.int 0
.int 0
.int 0
.int 0
# Knight's Shield
.int $KnightShieldProb
.int 17
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1751737708 # hiel
.int 1683959856 # d_00
.int 855638016 # 3
.int 0
.int 0
.int 0
# New Knight's treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Knight's treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Knight's treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Knight's treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Knight's treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# Royal treasure chest ID: 26
# Royal Broadsword
.int $RoyalBroadswordProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 2003792484 # word
.int 1596994100 # _024
.int 0
.int 0
.int 0
.int 0
# Royal Halberd
.int $RoyalHalberdProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1885692274 # pear
.int 1596994100 # _024
.int 0
.int 0
.int 0
.int 0
# Royal Claymore
.int $RoyalClaymoreProb
.int 17
.int 1466261872 # Weap
.int 1869504332 # on_L
.int 1937207154 # swor
.int 1683959858 # d_02
.int 872415232 # 4
.int 0
.int 0
.int 0
# Royal Bow
.int $RoyalBowProb
.int 14
.int 1466261872 # Weap
.int 1869504322 # on_B
.int 1870094128 # ow_0
.int 859176960 # 36
.int 0
.int 0
.int 0
.int 0
# Royal Shield
.int $RoyalShieldProb
.int 17
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1751737708 # hiel
.int 1683959858 # d_02
.int 838860800 # 2
.int 0
.int 0
.int 0
# New Royal treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Royal treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Royal treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Royal treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Royal treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# Royal Guard's treasure chest ID: 25
# Royal Guard's Sword
.int $RoyalGuardSwordProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 2003792484 # word
.int 1596994615 # _047
.int 0
.int 0
.int 0
.int 0
# Royal Guard's Spear
.int $RoyalGuardSpearProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1885692274 # pear
.int 1596994615 # _047
.int 0
.int 0
.int 0
.int 0
# Royal Guard's Claymore
.int $RoyalGuardClaymoreProb
.int 17
.int 1466261872 # Weap
.int 1869504332 # on_L
.int 1937207154 # swor
.int 1683959860 # d_04
.int 922746880 # 7
.int 0
.int 0
.int 0
# Royal Guard's Bow
.int $RoyalGuardBowProb
.int 14
.int 1466261872 # Weap
.int 1869504322 # on_B
.int 1870094128 # ow_0
.int 858980352 # 33
.int 0
.int 0
.int 0
.int 0
# Royal Guard's Shield
.int $RoyalGuardShieldProb
.int 17
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1751737708 # hiel
.int 1683959859 # d_03
.int 855638016 # 3
.int 0
.int 0
.int 0
# New Royal Guard's treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Royal Guard's treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Royal Guard's treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Royal Guard's treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Royal Guard's treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# Electric treasure chest ID: 24
# Lightning Rod
.int $LightningRodProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 2003792484 # word
.int 1596995122 # _062
.int 0
.int 0
.int 0
.int 0
# Thunderstorm Rod
.int $ThunderstormRodProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 2003792484 # word
.int 1596994864 # _050
.int 0
.int 0
.int 0
.int 0
# Thunderblade
.int $ThunderbladeProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 2003792484 # word
.int 1596994357 # _035
.int 0
.int 0
.int 0
.int 0
# Thunderspear
.int $ThunderspearProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1885692274 # pear
.int 1596994357 # _035
.int 0
.int 0
.int 0
.int 0
# Great Thunderblade
.int $GreatThunderbladeProb
.int 17
.int 1466261872 # Weap
.int 1869504332 # on_L
.int 1937207154 # swor
.int 1683959859 # d_03
.int 889192448 # 5
.int 0
.int 0
.int 0
# New Electric treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Electric treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Electric treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Electric treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Electric treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# Forest treasure chest ID: 23
# Forest Dweller's Sword
.int $ForestDwellerSwordProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 2003792484 # word
.int 1596994101 # _025
.int 0
.int 0
.int 0
.int 0
# Forest Dweller's Spear
.int $ForestDwellerSpearProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1885692274 # pear
.int 1596994101 # _025
.int 0
.int 0
.int 0
.int 0
# Forest Dweller's Bow
.int $ForestDwellerBowProb
.int 14
.int 1466261872 # Weap
.int 1869504322 # on_B
.int 1870094128 # ow_0
.int 825425920 # 13
.int 0
.int 0
.int 0
.int 0
# Forest Dweller's Shield
.int $ForestDwellerShieldProb
.int 17
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1751737708 # hiel
.int 1683959858 # d_02
.int 855638016 # 3
.int 0
.int 0
.int 0
# New Forest treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Forest treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Forest treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Forest treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Forest treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Forest treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# Frost treasure chest ID: 22
# Ice Rod
.int $IceRodProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 2003792484 # word
.int 1596995121 # _061
.int 0
.int 0
.int 0
.int 0
# Blizzard Rod
.int $BlizzardRodProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 2003792484 # word
.int 1596994617 # _049
.int 0
.int 0
.int 0
.int 0
# Frostblade
.int $FrostbladeProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 2003792484 # word
.int 1596994356 # _034
.int 0
.int 0
.int 0
.int 0
# Frostspear
.int $FrostspearProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1885692274 # pear
.int 1596994356 # _034
.int 0
.int 0
.int 0
.int 0
# Great Frostblade
.int $GreatFrostbladeProb
.int 17
.int 1466261872 # Weap
.int 1869504332 # on_L
.int 1937207154 # swor
.int 1683959859 # d_03
.int 872415232 # 4
.int 0
.int 0
.int 0
# New Frost treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Frost treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Frost treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Frost treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Frost treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# Fire treasure chest ID: 21
# Fire Rod
.int $FireRodProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 2003792484 # word
.int 1596995120 # _060
.int 0
.int 0
.int 0
.int 0
# Meteor Rod
.int $MeteorRodProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 2003792484 # word
.int 1596994616 # _048
.int 0
.int 0
.int 0
.int 0
# Flameblade
.int $FlamebladeProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 2003792484 # word
.int 1596994355 # _033
.int 0
.int 0
.int 0
.int 0
# Flamespear
.int $FlamespearProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1885692274 # pear
.int 1596994355 # _033
.int 0
.int 0
.int 0
.int 0
# Great Flameblade
.int $GreatFlamebladeProb
.int 17
.int 1466261872 # Weap
.int 1869504332 # on_L
.int 1937207154 # swor
.int 1683959859 # d_03
.int 855638016 # 3
.int 0
.int 0
.int 0
# New Fire treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Fire treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Fire treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Fire treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Fire treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# Climber treasure chest ID: 20
# Boomerang
.int $BoomerangProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 2003792484 # word
.int 1596994865 # _051
.int 0
.int 0
.int 0
.int 0
# Giant Boomerang
.int $GiantBoomerangProb
.int 17
.int 1466261872 # Weap
.int 1869504332 # on_L
.int 1937207154 # swor
.int 1683959861 # d_05
.int 822083584 # 1
.int 0
.int 0
.int 0
# Wooden Shield
.int $WoodenShieldProb
.int 17
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1751737708 # hiel
.int 1683959856 # d_00
.int 822083584 # 1
.int 0
.int 0
.int 0
# New Climber treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Climber treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Climber treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Climber treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Climber treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Climber treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Climber treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# Lynel treasure chest ID: 19
# Lynel Sword
.int $LynelSwordProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 2003792484 # word
.int 1596993846 # _016
.int 0
.int 0
.int 0
.int 0
# Lynel Spear
.int $LynelSpearProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1885692274 # pear
.int 1596993846 # _016
.int 0
.int 0
.int 0
.int 0
# Lynel Crusher
.int $LynelCrusherProb
.int 17
.int 1466261872 # Weap
.int 1869504332 # on_L
.int 1937207154 # swor
.int 1683959857 # d_01
.int 905969664 # 6
.int 0
.int 0
.int 0
# Lynel Bow
.int $LynelBowProb
.int 14
.int 1466261872 # Weap
.int 1869504322 # on_B
.int 1870094128 # ow_0
.int 809041920 # 09
.int 0
.int 0
.int 0
.int 0
# Lynel Shield
.int $LynelShieldProb
.int 17
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1751737708 # hiel
.int 1683959857 # d_01
.int 905969664 # 6
.int 0
.int 0
.int 0
# New Lynel treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Lynel treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Lynel treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Lynel treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Lynel treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# Mighty Lynel treasure chest ID: 18
# Mighty Lynel Sword
.int $MightyLynelSwordProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 2003792484 # word
.int 1596993847 # _017
.int 0
.int 0
.int 0
.int 0
# Mighty Lynel Spear
.int $MightyLynelSpearProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1885692274 # pear
.int 1596993847 # _017
.int 0
.int 0
.int 0
.int 0
# Mighty Lynel Crusher
.int $MightyLynelCrusherProb
.int 17
.int 1466261872 # Weap
.int 1869504332 # on_L
.int 1937207154 # swor
.int 1683959857 # d_01
.int 922746880 # 7
.int 0
.int 0
.int 0
# Mighty Lynel Bow
.int $MightyLynelBowProb
.int 14
.int 1466261872 # Weap
.int 1869504322 # on_B
.int 1870094128 # ow_0
.int 842399744 # 26
.int 0
.int 0
.int 0
.int 0
# Mighty Lynel Shield
.int $MightyLynelShieldProb
.int 17
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1751737708 # hiel
.int 1683959857 # d_01
.int 922746880 # 7
.int 0
.int 0
.int 0
# New Mighty Lynel treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Mighty Lynel treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Mighty Lynel treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Mighty Lynel treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Mighty Lynel treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# Savage Lynel treasure chest ID: 17
# Savage Lynel Sword
.int $SavageLynelSwordProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 2003792484 # word
.int 1596993848 # _018
.int 0
.int 0
.int 0
.int 0
# Savage Lynel Spear
.int $SavageLynelSpearProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1885692274 # pear
.int 1596993848 # _018
.int 0
.int 0
.int 0
.int 0
# Savage Lynel Crusher
.int $SavageLynelCrusherProb
.int 17
.int 1466261872 # Weap
.int 1869504332 # on_L
.int 1937207154 # swor
.int 1683959857 # d_01
.int 939524096 # 8
.int 0
.int 0
.int 0
# Savage Lynel Bow
.int $SavageLynelBowProb
.int 14
.int 1466261872 # Weap
.int 1869504322 # on_B
.int 1870094128 # ow_0
.int 858914816 # 32
.int 0
.int 0
.int 0
.int 0
# Savage Lynel Shield
.int $SavageLynelShieldProb
.int 17
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1751737708 # hiel
.int 1683959857 # d_01
.int 939524096 # 8
.int 0
.int 0
.int 0
# New Savage Lynel treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Savage Lynel treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Savage Lynel treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Savage Lynel treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Savage Lynel treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# Ancient treasure chest ID: 16
# Ancient Short Sword
.int $AncientShortSwordProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 2003792484 # word
.int 1596994099 # _023
.int 0
.int 0
.int 0
.int 0
# Ancient Spear
.int $AncientSpearProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1885692274 # pear
.int 1596994099 # _023
.int 0
.int 0
.int 0
.int 0
# Ancient Bladesaw
.int $AncientBladesawProb
.int 17
.int 1466261872 # Weap
.int 1869504332 # on_L
.int 1937207154 # swor
.int 1683959858 # d_02
.int 855638016 # 3
.int 0
.int 0
.int 0
# Ancient Bow
.int $AncientBowProb
.int 14
.int 1466261872 # Weap
.int 1869504322 # on_B
.int 1870094128 # ow_0
.int 842203136 # 23
.int 0
.int 0
.int 0
.int 0
# Ancient Shield
.int $AncientShieldProb
.int 17
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1751737708 # hiel
.int 1683959859 # d_03
.int 939524096 # 8
.int 0
.int 0
.int 0
# New Ancient treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Ancient treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Ancient treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Ancient treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Ancient treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# Guardian++ treasure chest ID: 15
# Guardian Sword++
.int $GuardianSword2Prob
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 2003792484 # word
.int 1596993845 # _015
.int 0
.int 0
.int 0
.int 0
# Guardian Spear++
.int $GuardianSpear2Prob
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1885692274 # pear
.int 1596993845 # _015
.int 0
.int 0
.int 0
.int 0
# Ancient Battle Axe++
.int $AncientBattleAxe2Prob
.int 17
.int 1466261872 # Weap
.int 1869504332 # on_L
.int 1937207154 # swor
.int 1683959857 # d_01
.int 889192448 # 5
.int 0
.int 0
.int 0
# Guardian Shield++
.int $GuardianShield2Prob
.int 17
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1751737708 # hiel
.int 1683959857 # d_01
.int 889192448 # 5
.int 0
.int 0
.int 0
# New Guardian++ treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Guardian++ treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Guardian++ treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Guardian++ treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Guardian++ treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Guardian++ treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# Guardian+ treasure chest ID: 14
# Guardian Sword+
.int $GuardianSword1Prob
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 2003792484 # word
.int 1596993844 # _014
.int 0
.int 0
.int 0
.int 0
# Guardian Spear+
.int $GuardianSpear1Prob
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1885692274 # pear
.int 1596993844 # _014
.int 0
.int 0
.int 0
.int 0
# Ancient Battle Axe+
.int $AncientBattleAxe1Prob
.int 17
.int 1466261872 # Weap
.int 1869504332 # on_L
.int 1937207154 # swor
.int 1683959857 # d_01
.int 872415232 # 4
.int 0
.int 0
.int 0
# Guardian Shield+
.int $GuardianShield1Prob
.int 17
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1751737708 # hiel
.int 1683959857 # d_01
.int 872415232 # 4
.int 0
.int 0
.int 0
# New Guardian+ treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Guardian+ treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Guardian+ treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Guardian+ treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Guardian+ treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Guardian+ treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# Guardian treasure chest ID: 13
# Guardian Sword
.int $GuardianSwordProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 2003792484 # word
.int 1596993843 # _013
.int 0
.int 0
.int 0
.int 0
# Guardian Spear
.int $GuardianSpearProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1885692274 # pear
.int 1596993843 # _013
.int 0
.int 0
.int 0
.int 0
# Ancient Battle Axe
.int $AncientBattleAxeProb
.int 17
.int 1466261872 # Weap
.int 1869504332 # on_L
.int 1937207154 # swor
.int 1683959857 # d_01
.int 855638016 # 3
.int 0
.int 0
.int 0
# Guardian Shield
.int $GuardianShieldProb
.int 17
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1751737708 # hiel
.int 1683959857 # d_01
.int 855638016 # 3
.int 0
.int 0
.int 0
# New Guardian treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Guardian treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Guardian treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Guardian treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Guardian treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Guardian treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# Best Boko treasure chest ID: 12
# Dragonbone Boko Club
.int $DragonboneBokoClubProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 2003792484 # word
.int 1596993590 # _006
.int 0
.int 0
.int 0
.int 0
# Dragonbone Boko Spear
.int $DragonboneBokoSpearProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1885692274 # pear
.int 1596993590 # _006
.int 0
.int 0
.int 0
.int 0
# Dragonbone Boko Bat
.int $DragonboneBokoBatProb
.int 17
.int 1466261872 # Weap
.int 1869504332 # on_L
.int 1937207154 # swor
.int 1683959856 # d_00
.int 905969664 # 6
.int 0
.int 0
.int 0
# Dragon Bone Boko Bow
.int $DragonBoneBokoBowProb
.int 14
.int 1466261872 # Weap
.int 1869504322 # on_B
.int 1870094128 # ow_0
.int 842465280 # 27
.int 0
.int 0
.int 0
.int 0
# Dragonbone Boko Shield
.int $DragonboneBokoShieldProb
.int 17
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1751737708 # hiel
.int 1683959856 # d_00
.int 905969664 # 6
.int 0
.int 0
.int 0
# New Best Boko treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Best Boko treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Best Boko treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Best Boko treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Best Boko treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# Medium Boko treasure chest ID: 11
# Spiked Boko Club
.int $SpikedBokoClubProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 2003792484 # word
.int 1596993589 # _005
.int 0
.int 0
.int 0
.int 0
# Spiked Boko Spear
.int $SpikedBokoSpearProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1885692274 # pear
.int 1596993589 # _005
.int 0
.int 0
.int 0
.int 0
# Spiked Boko Bat
.int $SpikedBokoBatProb
.int 17
.int 1466261872 # Weap
.int 1869504332 # on_L
.int 1937207154 # swor
.int 1683959856 # d_00
.int 889192448 # 5
.int 0
.int 0
.int 0
# Spiked Boko Bow
.int $SpikedBokoBowProb
.int 14
.int 1466261872 # Weap
.int 1869504322 # on_B
.int 1870094128 # ow_0
.int 808648704 # 03
.int 0
.int 0
.int 0
.int 0
# Spiked Boko Shield
.int $SpikedBokoShieldProb
.int 17
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1751737708 # hiel
.int 1683959856 # d_00
.int 889192448 # 5
.int 0
.int 0
.int 0
# New Medium Boko treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Medium Boko treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Medium Boko treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Medium Boko treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Medium Boko treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# Boko treasure chest ID: 10
# Boko Club
.int $BokoClubProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 2003792484 # word
.int 1596993588 # _004
.int 0
.int 0
.int 0
.int 0
# Boko Spear
.int $BokoSpearProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1885692274 # pear
.int 1596993588 # _004
.int 0
.int 0
.int 0
.int 0
# Boko Bat
.int $BokoBatProb
.int 17
.int 1466261872 # Weap
.int 1869504332 # on_L
.int 1937207154 # swor
.int 1683959856 # d_00
.int 872415232 # 4
.int 0
.int 0
.int 0
# Boko Bow
.int $BokoBowProb
.int 14
.int 1466261872 # Weap
.int 1869504322 # on_B
.int 1870094128 # ow_0
.int 808714240 # 04
.int 0
.int 0
.int 0
.int 0
# Boko Shield
.int $BokoShieldProb
.int 17
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1751737708 # hiel
.int 1683959856 # d_00
.int 872415232 # 4
.int 0
.int 0
.int 0
# New Boko treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Boko treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Boko treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Boko treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Boko treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# Best Lizal treasure chest ID: 9
# Lizal Tri-Boomerang
.int $LizalTriBoomerangProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 2003792484 # word
.int 1596993593 # _009
.int 0
.int 0
.int 0
.int 0
# Forked Lizal Spear
.int $ForkedLizalSpearProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1885692274 # pear
.int 1596993593 # _009
.int 0
.int 0
.int 0
.int 0
# Steel Lizal Bow
.int $SteelLizalBowProb
.int 14
.int 1466261872 # Weap
.int 1869504322 # on_B
.int 1870094128 # ow_0
.int 858783744 # 30
.int 0
.int 0
.int 0
.int 0
# Steel Lizal Shield
.int $SteelLizalShieldProb
.int 17
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1751737708 # hiel
.int 1683959856 # d_00
.int 956301312 # 9
.int 0
.int 0
.int 0
# New Best Lizal treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Best Lizal treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Best Lizal treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Best Lizal treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Best Lizal treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Best Lizal treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# Medium Lizal treasure chest ID: 8
# Lizal Forked Boomerang
.int $LizalForkedBoomerangProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 2003792484 # word
.int 1596993592 # _008
.int 0
.int 0
.int 0
.int 0
# Enhanced Lizal Spear
.int $EnhancedLizalSpearProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1885692274 # pear
.int 1596993592 # _008
.int 0
.int 0
.int 0
.int 0
# Strengthened Lizal Bow
.int $StrengthenedLizalBowProb
.int 14
.int 1466261872 # Weap
.int 1869504322 # on_B
.int 1870094128 # ow_0
.int 825294848 # 11
.int 0
.int 0
.int 0
.int 0
# Reinforced Lizal Shield
.int $ReinforcedLizalShieldProb
.int 17
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1751737708 # hiel
.int 1683959856 # d_00
.int 939524096 # 8
.int 0
.int 0
.int 0
# New Medium Lizal treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Medium Lizal treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Medium Lizal treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Medium Lizal treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Medium Lizal treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Medium Lizal treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# Lizal treasure chest ID: 7
# Lizal Boomerang
.int $LizalBoomerangProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 2003792484 # word
.int 1596993591 # _007
.int 0
.int 0
.int 0
.int 0
# Lizal Spear
.int $LizalSpearProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1885692274 # pear
.int 1596993591 # _007
.int 0
.int 0
.int 0
.int 0
# Lizal Bow
.int $LizalBowProb
.int 14
.int 1466261872 # Weap
.int 1869504322 # on_B
.int 1870094128 # ow_0
.int 808845312 # 06
.int 0
.int 0
.int 0
.int 0
# Lizal Shield
.int $LizalShieldProb
.int 17
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1751737708 # hiel
.int 1683959856 # d_00
.int 922746880 # 7
.int 0
.int 0
.int 0
# New Lizal treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Lizal treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Lizal treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Lizal treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Lizal treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Lizal treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# Best Moblin treasure chest ID: 6
# Dragonbone Moblin Spear
.int $DragonboneMoblinSpearProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1885692274 # pear
.int 1596993842 # _012
.int 0
.int 0
.int 0
.int 0
# Dragonbone Moblin Club
.int $DragonboneMoblinClubProb
.int 17
.int 1466261872 # Weap
.int 1869504332 # on_L
.int 1937207154 # swor
.int 1683959857 # d_01
.int 838860800 # 2
.int 0
.int 0
.int 0
# New Best Moblin treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Best Moblin treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Best Moblin treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Best Moblin treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Best Moblin treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Best Moblin treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Best Moblin treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Best Moblin treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# Medium Moblin treasure chest ID: 5
# Spiked Moblin Spear
.int $SpikedMoblinSpearProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1885692274 # pear
.int 1596993841 # _011
.int 0
.int 0
.int 0
.int 0
# Spiked Moblin Club
.int $SpikedMoblinClubProb
.int 17
.int 1466261872 # Weap
.int 1869504332 # on_L
.int 1937207154 # swor
.int 1683959857 # d_01
.int 822083584 # 1
.int 0
.int 0
.int 0
# New Medium Moblin treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Medium Moblin treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Medium Moblin treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Medium Moblin treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Medium Moblin treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Medium Moblin treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Medium Moblin treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Medium Moblin treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# Moblin treasure chest ID: 4
# Moblin Spear
.int $MoblinSpearProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1885692274 # pear
.int 1596993840 # _010
.int 0
.int 0
.int 0
.int 0
# Moblin Club
.int $MoblinClubProb
.int 17
.int 1466261872 # Weap
.int 1869504332 # on_L
.int 1937207154 # swor
.int 1683959857 # d_01
.int 805306368 # 0
.int 0
.int 0
.int 0
# New Moblin treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Moblin treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Moblin treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Moblin treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Moblin treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Moblin treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Moblin treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Moblin treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# Rusty treasure chest ID: 3
# Rusty Broadsword
.int $RustyBroadswordProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 2003792484 # word
.int 1596994097 # _021
.int 0
.int 0
.int 0
.int 0
# Rusty Halberd
.int $RustyHalberdProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1885692274 # pear
.int 1596994097 # _021
.int 0
.int 0
.int 0
.int 0
# Rusty Claymore
.int $RustyClaymoreProb
.int 17
.int 1466261872 # Weap
.int 1869504332 # on_L
.int 1937207154 # swor
.int 1683959858 # d_02
.int 805306368 # 0
.int 0
.int 0
.int 0
# Rusty Shield
.int $RustyShieldProb
.int 17
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1751737708 # hiel
.int 1683959858 # d_02
.int 822083584 # 1
.int 0
.int 0
.int 0
# New Rusty treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Rusty treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Rusty treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Rusty treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Rusty treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# New Rusty treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# Survival treasure chest ID: 2
# Fishing Harpoon
.int $FishingHarpoonProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1885692274 # pear
.int 1596994360 # _038
.int 0
.int 0
.int 0
.int 0
# Throwing Spear
.int $ThrowingSpearProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1885692274 # pear
.int 1596994352 # _030
.int 0
.int 0
.int 0
.int 0
# Farmer's Pitchfork
.int $FarmerPitchforkProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1885692274 # pear
.int 1596994098 # _022
.int 0
.int 0
.int 0
.int 0
# Woodcutter's Axe
.int $WoodcutterAxeProb
.int 17
.int 1466261872 # Weap
.int 1869504332 # on_L
.int 1937207154 # swor
.int 1683959859 # d_03
.int 838860800 # 2
.int 0
.int 0
.int 0
# Iron Sledgehammer
.int $IronSledgehammerProb
.int 17
.int 1466261872 # Weap
.int 1869504332 # on_L
.int 1937207154 # swor
.int 1683959859 # d_03
.int 822083584 # 1
.int 0
.int 0
.int 0
# Double Axe
.int $DoubleAxeProb
.int 17
.int 1466261872 # Weap
.int 1869504332 # on_L
.int 1937207154 # swor
.int 1683959859 # d_03
.int 805306368 # 0
.int 0
.int 0
.int 0
# Wooden Bow
.int $WoodenBowProb
.int 14
.int 1466261872 # Weap
.int 1869504322 # on_B
.int 1870094128 # ow_0
.int 859308032 # 38
.int 0
.int 0
.int 0
.int 0
# Fisherman's Shield
.int $FishermanShieldProb
.int 17
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1751737708 # hiel
.int 1683959859 # d_03
.int 838860800 # 2
.int 0
.int 0
.int 0
# Hunter's Shield
.int $HunterShieldProb
.int 17
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1751737708 # hiel
.int 1683959859 # d_03
.int 822083584 # 1
.int 0
.int 0
.int 0
# New Survival treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
# Legendary treasure chest ID: 1
# Hylian Shield
.int $HylianShieldProb
.int 17
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1751737708 # hiel
.int 1683959859 # d_03
.int 805306368 # 0
.int 0
.int 0
.int 0
# Sea-Breeze Boomerang
.int $SeaBreezeBoomerangProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 2003792484 # word
.int 1596994873 # _059
.int 0
.int 0
.int 0
.int 0
# Hero's Shield
.int $HeroShieldProb
.int 17
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 1751737708 # hiel
.int 1683959861 # d_05
.int 922746880 # 7
.int 0
.int 0
.int 0
# Sword
.int $SwordProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 2003792484 # word
.int 1596994872 # _058
.int 0
.int 0
.int 0
.int 0
# Biggoron's Sword
.int $BiggoronSwordProb
.int 17
.int 1466261872 # Weap
.int 1869504332 # on_L
.int 1937207154 # swor
.int 1683959861 # d_05
.int 956301312 # 9
.int 0
.int 0
.int 0
# Sword of the Six Sages
.int $SwordOfTheSixSagesProb
.int 17
.int 1466261872 # Weap
.int 1869504332 # on_L
.int 1937207154 # swor
.int 1683959861 # d_05
.int 922746880 # 7
.int 0
.int 0
.int 0
# Twilight Bow
.int $TwilightBowProb
.int 14
.int 1466261872 # Weap
.int 1869504322 # on_B
.int 1870094128 # ow_0
.int 926023680 # 72
.int 0
.int 0
.int 0
.int 0
# Goddess Sword
.int $GoddessSwordProb
.int 16
.int 1466261872 # Weap
.int 1869504339 # on_S
.int 2003792484 # word
.int 1596994871 # _057
.int 0
.int 0
.int 0
.int 0
# Fierce Deity Sword
.int $FierceDeitySwordProb
.int 17
.int 1466261872 # Weap
.int 1869504332 # on_L
.int 1937207154 # swor
.int 1683959862 # d_06
.int 805306368 # 0
.int 0
.int 0
.int 0
# New Legendary treasure
.int -1
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0
.int 0

_BOTW_UnexpectedTreasures_OpenChest:
lwz r3, 0x3c(r30)
lwz r17, 0x408(r29)
lis r28, _BOTW_UnexpectedTreasures_LastTreasureChestId@ha
lwzu r20, _BOTW_UnexpectedTreasures_LastTreasureChestId@l(r28)
cmpw r17, r20
beqlr
rlwinm r8, r30, 24, 8, 31
stw r17, 0x0(r28)
lbz r27, 0x1b(r29)
cmpwi r27, 69
subi r27, r30, 1800
bne .+0x8
addi r27, r27, 420
mr r22, r28
lwzu r20, 0x8(r22)
cmpwi r20, 0
beq .+0x150
lis r21, $DataLayerMemoryBase
lwz r19, 0x0(r21)
cmpw r21, r19
bne .+0x140
addi r22, r22, -60
lwz r16, -0x4(r28)
cmpwi r16, 0
beq .+0x48
mr r15, r28
mtctr r16
li r16, 0
stwu r16, -0x4(r15)
lwz r9, -0x4(r15)
slwi r9, r9, 6
lwzu r16, -0x8(r15)
divw r19, r8, r16
mullw r19, r19, r16
sub r18, r19, r8
addi r18, r18, -1
slwi r18, r18, 2
lwzx r18, r18, r15
stwx r18, r9, r22
slwi r16, r16, 2
sub r15, r15, r16
bdnz .-0x30
lwzu r16, 0x40(r22)
cmpw r17, r16
bne .+0xD4
lwz r16, 0x4(r22)
lwzx r16, r16, r21
lbz r16, 0x7(r16)
cmpwi r16, 0
beqlr
lwz r16, 0x8(r22)
lwzx r16, r16, r21
lbz r16, 0x7(r16)
cmpwi r16, 0
bne .+0xB8
lwz r16, 0xC(r22)
lwz r15, 0x10(r22)
lwzx r15, r15, r21
lwzu r18, 0x18(r22)
cmpwi r16, 16
beq .+0x50
lwz r19, -0x4(r22)
cmpwi r16, 8
bne .+0x18
lbz r16, 0x7(r15)
cmpw r16, r19
beq .+0x134
addi r14, r22, 8
b .+0x84
lwz r16, 0x14(r15)
sub r16, r16, r19
rlwinm r19, r16, 1, 31, 31
li r15, 0
sub r16, r15, r16
rlwinm r16, r16, 1, 31, 31
sub r16, r19, r16
cmpw r16, r18
beq .+0x108
addi r14, r22, 8
b .+0x58
lfs f16, 0x14(r15)
lfs f17, -0x4(r22)
fcmpu f16, f17
blt .+0x18
bgt .+0x24
cmpwi r18, 0
beq .+0xE4
addi r14, r22, 8
b .+0x34
cmpwi r18, -1
beq .+0xD4
addi r14, r22, 8
b .+0x24
cmpwi r18, 1
beq .+0xC4
addi r14, r22, 8
b .+0x14
subi r20, r20, 1
cmpwi r20, 0
bne .-0xE4
mr r14, r27
lis r22, _BOTW_UnexpectedTreasures_TreasureChests@ha
lwzu r20, _BOTW_UnexpectedTreasures_TreasureChests@l(r22)
mr r17, r22
li r21, 0
lwzu r18, 0x4(r17)
cmpwi r18, 0
blt .+0xCC
lwz r18, 0x4(r17)
addi r17, r17, 8
lwzx r16, r14, r18
stwx r16, r17, r18
li r16, 0
stbx r16, r17, r18
lwzx r15, r17, r16
lwzx r19, r14, r16
cmpw r15, r19
bne .+0x94
addi r16, r16, 4
cmpw r16, r18
ble .-0x18
li r19, 100
lwz r16, 0x4(r28)
cmpwi r16, 0
bge .+0x10
divw r18, r8, r19
mulli r18, r18, 100
sub r16, r8, r18
mulli r16, r16, 61
addi r16, r16, 37
divw r18, r16, r19
mulli r18, r18, 100
sub r16, r16, r18
stw r16, 0x4(r28)
addi r16, r16, 1
subi r22, r22, 36
addi r21, r22, 400
lwzu r17, 0x28(r22)
cmpwi r17, 0
bltlr
sub r16, r16, r17
cmpwi r16, 0
bgt .+0x24
lwzu r17, 0x4(r22)
li r19, 0
lwzu r16, 0x4(r22)
stwx r16, r19, r27
addi r19, r19, 4
cmpw r19, r17
ble .-0x10
blr
cmpw r22, r21
bne .-0x3C
blr
addi r21, r21, 40
add r17, r22, r21
cmpwi r21, 400
bne .-0xD0
addi r20, r20, -1
addi r22, r22, 400
cmpwi r20, 0
bne .-0xE8
blr

0x0293CE4C = bla _BOTW_UnexpectedTreasures_OpenChest # Open chest action area [lwz r3, +0x3c(r30)]