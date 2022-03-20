[BotwV208]
moduleMatches = 0x6267BFD0

0x02A21974 = lfs f0, 0x1898(r27) # Day duration: 360.0 [stwu r1, -0x30(r1)]
0x02A21978 = lwz r4, 0x4(r5) # [stfd f31, +0x20(r1)]
0x02A2197C = lbz r4, 0x7(r4) # [ps_merge10 f31, f31, f31]
0x02A21980 = cmpwi r4, 0 # [stfs f31, +0x28(r1)]
0x02A21984 = beq .+0xC # if (WM_NighttimeFlag==OFF) GOTO fmr f1, f0 [mflr r0]
0x02A21988 = lfs f1, 0xd94(r31) # Master Sword SearchEvilDist: 70.0 [stmw r26, +0x8(r1)]
0x02A2198C = blr # [stw r0, +0x34(r1)]
0x02A21990 = fmr f1, f0 # [mr r29, r4]
0x02A21994 = blr # [lis r4, 0x1018]

0x02a2a880 = lis r5, $DataLayerMemoryBase # Master sword power update area (enabled if specific enemies proximity) [li r4, 0]
0x02a2a884 = lis r27, 0x1030 # [bl 0x02a21974]
0x02a2a888 = bl .-0x8F14 # [lfs f0, +0xd94(r31)]