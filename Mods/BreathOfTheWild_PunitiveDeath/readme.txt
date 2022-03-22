Non-essential items loss after death

NOTES
- Not compatible with mods where WeaponPorchStockNum>60 or|and BowPorchStockNum>54 or|and ShieldPorchStockNum>60
- Data Layer mod (last version) required for the rupees and mons support
- Browse to your Cemu folder and delete mlc01\usr\save\00050000\101C9[3|4|5]00 folder content if you want to remove all existing game saves
- To disable autosave, append the following line in the patch_patches.asm file: 0x02e3eec4 = cmpw r3, r3
- To keep the rupees, comment the following line in the patch_patches.asm file: #stw r16, 0x14(r10) # CurrentRupee...
- To keep the mons, comment the following line in the patch_patches.asm file: #stw r16, 0x14(r10) # CurrentMamo...

INSTALLATION INSTRUCTIONS
- browse to your Cemu folder
- open the graphicPacks folder
- store the BreathOfTheWild_PunitiveDeath folder in this directory
- enable the Punitive Death graphic pack in Cemu

https://gamebanana.com/mods/49880
