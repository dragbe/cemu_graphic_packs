[BotwV208]
moduleMatches = 0x6267BFD0

0x026E52A4 = lis r26, $DataLayerMemoryBase # CanPlayerOpenDoor check area [bl 0x02C4FE90]
0x026E52A8 = lwz r26, $SmallKeyNumGameDataPointerOffset(r26) # [li r4, 0]
0x026E52AC = lwz r26, 0x14(r26) # [bl 0x02E1C478]
0x026E52BC = cmpwi r26, 0 # [mr. r26, r3]
0x026E54DC = lis r3, $DataLayerMemoryBase # [bl 0x02C4FE90]
0x026E54E0 = lwz r3, $SmallKeyNumGameDataPointerOffset(r3) # [li r4, 0]
0x026E54E4 = lwz r3, 0x14(r3) # [bl 0x02E1C478]
0x02FA6DB0 = lis r3, $DataLayerMemoryBase # 'KeyNum Gamedata loop read' for UI [bl 0x02C4FE90]
0x02FA6DB4 = lwz r3, $SmallKeyNumGameDataPointerOffset(r3) # [li r4, 0]
0x02FA6DB8 = lwz r3, 0x14(r3) # [bl 0x02E1C478]

0x02E1C708 = lis r8, $DataLayerMemoryBase # Inside sub to set 'KeyNum Gamedata' (s32_array_data.SmallKey, Remains*_SmallKeyNum) [stwu r1, -0x68(r1)]
0x02E1C70C = lwz r9, ($SmallKeyNumGameDataPointerOffset+4)(r8) # [mflr r0]
0x02E1C710 = cmpwi r9, 0 # [stmw r24, +0x48(r1)]
0x02E1C714 = beqlr # if NOT EXIST(Dungeon_SmallKeyNum gamedata) EXITSUB # [mr r27, r4]
0x02E1C718 = lwz r8, $SmallKeyNumGameDataPointerOffset(r8) # [mr r28, r5]
0x02E1C71C = lwz r7, 0x14(r8) # [stw r0, +0x6C(r1)]
0x02E1C720 = add r7, r7, r4 # [mr r31, r3]
0x02E1C724 = stw r7, 0x14(r8) # [bl 0x02E1C3B0]
0x02E1C728 = stw r7, 0x4(r9) # [lis r29, 0x1026]
0x02E1C72C = blr # [cmpwi r3, 0]

0x026E522C = nop # KeyNum Gamedata update (-1) area [bl 0x02C4FE90]
0x026E5234 = nop # [mr r5, r30]
0x02B76BA4 = nop # KeyNum Gamedata update (+1) area [bl 0x02C4FE90]
0x02B76BA8 = nop # (code area executed only if IsGet_KeySmall==true?) [li r5, 0]
0x02B770A8 = nop # KeyNum Gamedata update (+1) area [bl 0x02C4FE90]
0x02B770AC = nop # (code area executed only if IsGet_KeySmall==false?, r7="KeySmall" string memory location) [li r5, 0]

#0x030576F4 b .+0x40 # GOTO 0x03057734 To disable KeyNum_00 UI [lwz r12, +0x0(r26)]

#New free codecaves
#0x02E1C478-0x02E1C708(164)
#0x02E1C730-0x02E1C9AC(159)
#0x02E1C144-0x02E1C400(175)
#0x02E159F0-0x02E15A98(42)

#bl 0x02E1C3B0 = isRemainDungeon()
#bl 0x02C4FE90 = bl 0x0338C614 = getCurrentDungeonName()
#bl 0x02E1C144 = getCurrentDungeonId() return -1 or cint(right("DungeonXXX",3))
#bl 0x030B3E18 = bl 0x030B5E38 = kind of parseInt(string,10) conversion function
#bl 0x02E1C478 Sub to get 'KeyNum Gamedata' (s32_array_data.SmallKey, Remains*_SmallKeyNum)