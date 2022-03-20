[BotwV208]
moduleMatches = 0x6267BFD0

#[NO NEW ITEM NOTIFICATIONS]
#Looked item name display decision area
0x02fb5EC0 = li r3, 1 # [lwz r7, +0x22b0(r29)]
0x02fb5EC4 = slwi r4, r4, 2 # [stw r31, +0x94(r1)]
0x02fb5EC8 = lwzx r4, r12, r4 # [lis r5, 0x1024]
0x02fb5ECC = stb r3, 0x7(r4) # [stw r30, +0x98(r1)]
0x02fb5ED0 = b .-0x74 # [lwz r3, +0xc(r7)]
#Looted item notification display decision area
0x02B78414 = bne .+0xD0 # [bne 0x02b784bc]
0x02B78444 = bne .+0xA0 # [bne 0x02b784bc]
0x02B78474 = bne .+0x70 # [bne 0x02b784bc]
0x02B784A4 = bne .+0x40 # [bne 0x02b784bc]
0x02B784B8 = bne .+0x14 # [bne 0x02b784dc]
0x02B784BC = li r3, 1 # [lis r12, 0x1047]
0x02B784C0 = slwi r4, r4, 2 # [lwz r12, -0x2C54(r12)]
0x02B784C4 = lwzx r4, r12, r4 # [cmpwi r12, 0]
0x02B784C8 = stb r3, 0x7(r4) # [beq 0x02b784FC]
0x02B784CC = li r3, 0 # [addis r7, r12, 1]
0x02B784D0 = lmw r29, 0xc(r1) # [lbz r0, +0x74b4(r7)]
0x02B784D4 = lwz r0, 0x1c(r1) # [cmpwi r0, 0]
0x02B784D8 = mtlr r0 # [beq 0x02b784fc]
0x02B784DC = addi r1, r1, 0x18 # [lwz r29, +0xc(r1)]
0x02B784E0 = blr # [lwz r0, +0x1c(r1)]
0x02B784E4 = lis r12, 0x1047 # [lwz r30, +0x10(r1)]
0x02B784E8 = lwz r12, -0x2C54(r12) # [mtlr r0]
0x02B784EC = cmpwi r12, 0 # [lwz r31, +0x14(r1)]
0x02B784F0 = beq .+0x14 # [addi r1, r1, 0x18]
0x02B784F4 = addis r7, r12, 1 # [li r3, 0]
0x02B784F8 = lbz r0, +0x74b4(r7) # [blr]
0x02B784FC = cmpwi r0, 0 # [li r6, 0]
0x02B78500 = bne .-0x34 # [li r4, 1]
0x02B78504 = li r6, 0 # [mr r5, r30]
0x02B78508 = li r4, 1 # [mr r3, r29]
0x02B7850c = mr r5, r30 # [bl 0x02b78260]
0x02B78510 = mr r3, r29 # [li r3, 1]
0x02B78514 = bl 0x02b78260 # [lwz r29, +0xc(r1)]
0x02B78518 = li r3, 1 # [lwz r0, +0x1c(r1)]
0x02B7851C = b .-0x4C # [lwz r30, +0x10(r1)]
#[New free codecaves]
#0x02fb5ED4-0x02fb5F1C(18)
#0x02B78520-0x02B78530(4)

#[INIT QUICK SWITCH MENU ITEM SHORTCUTS INDEXES AREA]
0x02FC8D5C = b .+0x7C # bge 0x02fc8d78
0x02FC8DA0 = b .+0x38 # bge 0x02fc8dbc
#New free codecaves
#0x02FC8D60-0x02FC8D90(12)
#0x02FC8DA4-0x02FC8DD4(12)

#[DAMAGE REACTION MANAGEMENT AREA]
0x02D911B4 = beq .+0x98 # [beq 0x02d911E8]
0x02D911D4 = beq .+0x78 # [beq 0x02d911E8]
0x02D911DC = beq .+0x70 # [beq 0x02d911E8]
0x02d911E8 = b .+0x64 # [stw r29, +0x14(r1)]
0x02d9124C = stw r29, 0x2c(r1) # [stb r0, +0x2E(r1)]
0x02d91250 = stb r29, 0x2b(r1) # [stb r0, +0x21(r1)]
0x02d91254 = sth r29, 0x30(r1) # [mr r29, r0]
0x02d91258 = stw r29, 0x18(r1) # [stb r29, +0x31(r1)]
#New free codecaves
#0x02d911EC-0x02d9124C(24)