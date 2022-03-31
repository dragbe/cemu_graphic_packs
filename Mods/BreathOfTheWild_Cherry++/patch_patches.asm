[BotwV208]
moduleMatches = 0x6267BFD0

0x02EBBB84 = li r11, 0 # Browse the inventory by skiping the weapons [li r11, 1]
0x02EBBFC0 = nop # Skip the bows and shields [cmpwi r9, 2]
0x02EBBFC4 = nop # [beq 0x02ebbfd0]
0x02EBBFC8 = nop # [cmpwi r9, 4]
0x02EBBFCC = nop # [blt 0x02ebc194]