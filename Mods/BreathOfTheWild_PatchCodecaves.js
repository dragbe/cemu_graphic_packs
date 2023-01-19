var arrPatchCodecaves=[[33672268,33672268,"No Enemy Awareness UI","Shows Molduga awareness UI area [b 0x0201CC70]"],[33672288,33672288,"No Enemy Awareness UI","[b 0x0201CC70]"],[33672296,33672300,"No Enemy Awareness UI","[stw r0, +0xa90(r30)]"],[33856196,33856196,"Guardian Stalker I","Reset Guardian Awareness area [lwz r7, +0xf38(r29)]"],[33860572,33860572,"Byakugan","Handle the guardian parent component stasis status [cmpwi r8, 0]"],[33881596,33881596,"Byakugan","Propagate the guardian stasis status on all its elements [rlwinm. r0, r0, 0, 27, 27]"],[33881604,33881608,"Byakugan","[mr r3, r30]"],[35355868,35355868,"Don't Starve","Restore health after sleep area for all beds [bl 0x02D49D38]"],[37359700,37359700,"Shrine Replacements","Inside AIDef:Action/SetCurrentDungeonClearFlag with r5=MakeSaveFlag, r3=SaveFlag, r4=SaveFlagOnOffType in this area [li r5, 0]"],[37368664,37368664,"Don't Starve","Restore health after sleep area for beds with yellow hearts bonus [cmpwi r0, 0]"],[37929804,37929804,"Shrine Replacements","Shrine entrance area (Demo008_1) [lis r28, 0x1026]"],[38407668,38407668,"Durability UI","Low durability warning check area related to the Master Sword [bl 0x0249E2E0]"],[38414784,38414784,"Hereditary Powers","Before weapon inventory durability update area [lwz r4, +0x0(r3)]"],[38417792,38417792,"Durability UI","Low durability check when you loot a weapon [bl 0x0249E2E0]"],[38455940,38455940,"Durability UI","Low durability warning check area when taking the equipped weapons [bl 0x0249e2e0]"],[38474636,38474636,"Durability UI","Low durability warning check area after a weapon durability update [bl 0x0249e2e0]"],[39652320,39652320,"No Enemy Awareness UI","Shows enemy Detect something UI area [cmpwi r3, 0]"],[39848960,39848960,"No Enemy Awareness UI","Shows enemy Full awareness UI area [cmpwi r3, 0]"],[39852588,39852588,"No Enemy Awareness UI","Shows enemy awareness gauge area [cmpwi r29, 0]"],[39852852,39852856,"No Enemy Awareness UI","[mtspr spr9, r6]"],[39852864,39852864,"No Enemy Awareness UI","[bctrl]"],[40560660,40560660,"No Enemy Awareness UI","Shows Octorok Detect something UI area [li r4, 2]"],[40561892,40561892,"No Enemy Awareness UI","Shows afraid Octorok Full awareness UI area [li r4, 4]"],[41203052,41203068,"No Enemy Awareness UI","Shows Lynel Full awareness UI area [lwz r12, +0xe8(r3)]"],[41802880,41802880,"No Enemy Awareness UI","[cmpwi r4, 0]"],[41802888,41802888,"No Enemy Awareness UI","[mtctr r0]"],[41804436,41804436,"No Enemy Awareness UI","Shows Octorok Full awareness UI area [li r4, 1]"],[43241036,43241036,"Unexpected Treasures","Open chest action area [lwz r3, +0x3c(r30)]"],[43540516,43540532,"No Enemy Awareness UI","Shows Wizzrobe Full awareness UI area [lwz r12, +0xe8(r3)]"],[44177780,44177900,"Bloody Moon Master Sword<br>Dark Master Sword","[stwu r1, -0x30(r1)]"],[44177780,44177812,"Dark Master Sword","Day duration: 360.0 [stwu r1, -0x30(r1)]"],[44214400,44214408,"Bloody Moon Master Sword<br>Dark Master Sword","Master sword power update area (enabled if specific enemies proximity) [li r4, 0]"],[44214412,44214412,"Basic Master Sword","Master sword power update area [fcmpu cr0, f1, f0]"],[44220940,44220940,"Guardian Stalker I","Set Rune Crosshair Target's ID area [lwz r3, +0x8(r1)]"],[44221760,44221760,"Bomb Bag","[addi r3, r3, 0x22C]"],[44283404,44283404,"Byakugan","Target guardian with stasis area [mr r3, r28]"],[45573500,45573500,"Fake Rupees","Rupee update on loot area [mr r31, r3]"],[45573508,45573508,"Fake Rupees","[li r3, 1]"],[45575016,45575024,"Fake Rupees","Loot rupee (treasure chest, mini game, rewards, ...) area [lis r3, 0x1047]"],[45581332,45581332,"UKing Tweaks","[bne 0x02b784bc]"],[45581380,45581380,"UKing Tweaks","[bne 0x02b784bc]"],[45581428,45581428,"UKing Tweaks","[bne 0x02b784bc]"],[45581476,45581476,"UKing Tweaks","[bne 0x02b784bc]"],[45581496,45581596,"UKing Tweaks","[bne 0x02b784dc]"],[45581600,45581612,"UKing Tweaks","4"],[45699560,45699560,"Dynamic FPS<br>Static FPS 30+<br>Static FPS 60+","[lwz r4, +0x190(r31)]"],[45699568,45699568,"Dynamic FPS<br>Static FPS 30+<br>Static FPS 60+","[lfs f11, +0x0(r4)]"],[45699640,45699640,"Dynamic FPS<br>Static FPS 30+<br>Static FPS 60+","[lis r7, 0x101b]"],[45699648,45699648,"Dynamic FPS<br>Static FPS 30+<br>Static FPS 60+","[lfs f9, +0x2d34(r7)]"],[46311188,46311188,"Shrine Replacements","After the PlayerPosMapType and PlayerPosMapName updates at the beginning of the loading screen (OpenWorldStage_Custom, IndoorStage_Custom, ...) [lis r3, 0x1048]"],[46392116,46392116,"Shrine Replacements","Go outside shrine area (Demo008_4) [lmw r22, +0x118(r1)]"],[46540208,46540212,"No Flurry Rush","Start BackJump flurry rush area [lfs f0, +0x0(r6)]"],[46577884,46577888,"Dynamic FPS<br>Static FPS 30+<br>Static FPS 60+","[lwz r9, +0x0(r30)]"],[46577896,46577900,"Dynamic FPS<br>Static FPS 30+<br>Static FPS 60+","[stfs f1, +0x1AE4(r9)]"],[46577908,46577908,"Dynamic FPS<br>Static FPS 30+<br>Static FPS 60+","[lfs f13, +0x1B18(r31)]"],[46577916,46577936,"Dynamic FPS<br>Static FPS 30+<br>Static FPS 60+","[bge 0x02C6B914]"],[46991388,46991396,"No Flurry Rush","Start SideStep flurry rush area, also executed when shield+jump (f12=1.0) [lfs f12, +0x0(r6)]"],[46991404,46991404,"No Flurry Rush","[stfs f31, +0x1304(r5)]"],[47068956,47068960,"Hereditary Powers","(MaxSpeedF) [lwz r11, +0x14(r29)]"],[47069056,47069060,"Hereditary Powers","(MaxSpeedB) [lwz r4, +0x1C(r29)]"],[47069148,47069152,"Hereditary Powers","(MaxSpeedS) [lwz r5, +0x18(r29)]"],[47073820,47073820,"Hereditary Powers","Swim move area [lwz r10, +0x24(r30)]"],[47073828,47073828,"Hereditary Powers","[lfs f1, +0x0(r10)]"],[47277356,47277356,"Bomb Bag","[lwz r3, +0x0(r30)]"],[47279280,47279280,"Punitive Death","Link death [li r5, 0]"],[47414388,47414388,"Hunger Wheel<br>Raw Stamina","Full stamina restore area [mr r3, r31]"],[47469220,47469220,"Life Extension","Hearts update area [stw r31, +0x0(r28)]"],[47488484,47488484,"Raw Stamina","Full stamina restore or load saved stamina area [stfs f1, +0x68(r31)]"],[47551324,47551324,"Hunger Wheel<br>Raw Stamina","UI stamina gauge reset area [mr r3, r31]"],[47551736,47551736,"Hereditary Powers","Sand move bonus update area [stb r12, +0x1AA4(r29)]"],[47551772,47551772,"Hereditary Powers","Snow move bonus update area [stb r5, +0x1AA5(r29)]"],[47551844,47551844,"Climbing In The Rain<br>Hereditary Powers","Lateral climbing bonus update area [addi r3, r29, 0x1D94]"],[47576664,47576664,"Dynamic FPS<br>Static FPS 30+<br>Static FPS 60+","[lis r6, 0x101E]"],[47576672,47576680,"Dynamic FPS<br>Static FPS 30+<br>Static FPS 60+","[lis r12, 0x101E]"],[47576688,47576692,"Dynamic FPS<br>Static FPS 30+<br>Static FPS 60+","[lfs f29, +0x5364(r12)]"],[47576780,47576784,"Dynamic FPS<br>Static FPS 30+<br>Static FPS 60+","[lwz r9, +0x83C(r30)]"],[47576840,47576840,"Dynamic FPS<br>Static FPS 30+<br>Static FPS 60+","[lfs f31, +0x423C(r5)]"],[47576892,47576900,"Dynamic FPS<br>Static FPS 30+<br>Static FPS 60+","[lwz r7, +0x39C(r30)]"],[47576908,47576908,"Dynamic FPS<br>Static FPS 30+<br>Static FPS 60+","[lwz r6, +0x244(r12)]"],[47576916,47576928,"Dynamic FPS<br>Static FPS 30+<br>Static FPS 60+","[addi r6, r6, 0x54]"],[47667540,47667540,"No Pause In Combat","Exit the inventory|quick|map menu area [addi r6, r1, 0x80]"],[47698648,47698648,"No Pause In Combat","Can lock enemy area [cmpwi r3, 0]"],[47774692,47774704,"Don't Starve","Heart auto recover area [lwz r12, +0xe8(r31)]"],[47774816,47774820,"Don't Starve","Reset heart auto recover interval area [lwz r10, +0x0(r11)]"],[47774964,47774964,"Don't Starve","Apply heart auto recover area [lwz r12, +0x0(r10)]"],[47774972,47774972,"Don't Starve","[lfs f11, +0x1ec(r12)]"],[47777912,47777912,"Hunger Wheel","UI extra stamina gauge update area"],[47778824,47778824,"Hunger Wheel<br>Stamina Depletion","Stamina update area [fcmpu cr0, f30, f31]"],[47778988,47778988,"Don't Starve","Update stamina area [li r29, 1]"],[47779004,47779044,"Raw Stamina<br>Hunger Wheel<br>Staminax","Stamina update area [bl 0x02d49dc0]"],[47779008,47779040,"Hunger Wheel<br>Staminax","stamina update area [fadds f29, f1, f30]"],[47779024,47779024,"Staminax","Yellow stamina update area [fadds f13, f12, f29]"],[47779116,47779120,"Dynamic FPS<br>Static FPS 30+<br>Static FPS 60+","[lis r10, 0x101e]"],[47779204,47779204,"Hunger Wheel<br>Raw Stamina","Stamina auto recover area [lfs f9, +0x12C(r10)]"],[47779208,47779212,"Dynamic FPS<br>Static FPS 30+<br>Static FPS 60+","[lis r10, 0x101e]"],[47779268,47779268,"Hunger Wheel<br>Raw Stamina","UI stamina gauge update area [fcmpu cr0, f29, f1]"],[47780276,47780276,"UKing Tweaks","[beq 0x02d911E8]"],[47780308,47780308,"UKing Tweaks","[beq 0x02d911E8]"],[47780316,47780316,"UKing Tweaks","[beq 0x02d911E8]"],[47780328,47780328,"UKing Tweaks","[stw r29, +0x14(r1)]"],[47780332,47780424,"UKing Tweaks","24"],[47780428,47780440,"UKing Tweaks","[stb r0, +0x2E(r1)]"],[47815080,47815088,"Bomb Bag","On take cube bomb [li r4, 0]"],[47815328,47815336,"Bomb Bag","On take spherical bomb [li r4, 0]"],[47815984,47815992,"Bomb Bag","On drop or detonate a cube bomb when the player is not on the ground (paraglider, fall, ...) [lwz r3, +0x0(r30)]"],[47816096,47816104,"Bomb Bag","On drop or detonate a spherical bomb when the player is not on the ground (paraglider, fall, ...) -> take or detonate bomb animations canceled [li r4, 0]"],[47816172,47816172,"Bomb Bag","[mr r30, r3]"],[47816320,47816320,"Bomb Bag","[lis r0, 0x101F]"],[47816332,47816332,"Bomb Bag","[addic r0, r0, -0x7FBC]"],[47816508,47816508,"Bomb Bag","[lis r29, 0x101F]"],[47816528,47816532,"Bomb Bag","[subi r29, r29, 0x7FAC]"],[47816620,47816620,"Bomb Bag","On detonate a cube bomb [lwz r3, +0x0(r28)]"],[47817108,47817108,"Bomb Bag","On detonate a spherical bomb [lwz r3, +0x0(r28)]"],[47830460,47830460,"Hunger Wheel<br>Raw Stamina<br>Staminax","Yellow stamina update on inventory close or on NPC rewards [lfs f13, +0x20(r30)]"],[47830480,47830480,"Hunger Wheel","Extra stamina bonus update area [fcmpu cr0, f0, f31]"],[48397012,48397012,"No Pause In Combat","Enter location area [lwz r11, +0xe44(r29)]"],[48397360,48397360,"No Pause In Combat","Leave location area [li r5, 1]"],[48501592,48501592,"Punitive Death","Game save process area [li r7, 1]"],[48694620,48694652,"No Low Health Blinking Effect","Manages low health effect area [lhz r12, +0x24(r10)]"],[48694660,48694660,"No Low Health Blinking Effect","[beq 0x02E705C0]"],[48700068,48700068,"More Weapon Slots","Call 'LoadItemShortcuts' sub [mr r3, r31]"],[48701124,48701124,"No Pause In Combat","Open quick menu area [mr r3, r29]"],[48799172,48799172,"Life Extension","Inventory golden hearts update area [add r10, r3, r12]"],[48953072,48953072,"Data Layer","Current focused item (material|food|arrow already present in the inventory) area [lwz r3, +0x10(r27)]"],[48954836,48954836,"Data Layer","Is focused food (not present in the inventory) lootable area [cmpwi r3, 0x3C]"],[48954912,48954912,"Data Layer","Is focused material (not present in the inventory) lootable area [cmpwi r3, 0xa0]"],[48955048,48955052,"Data Layer","Is focused item (material|food|arrow already present in the inventory) lootable area [add r0, r28, r31]"],[48955424,48955424,"Weapon Limiter","Is focused weapon lootable [mr r28, r3]"],[48955524,48955524,"Weapon Limiter","Is focused shield lootable [mr r28, r3]"],[48955624,48955624,"Weapon Limiter","Is focused bow lootable [mr r28, r3]"],[48955844,48955844,"Item Limiter","Cook food area [cmpwi r0, 0x3C]"],[48958876,48958876,"Data Layer","Loot item (material|food|arrow already present in the inventory) area [cmpwi r0, 0x3e7]"],[48958884,48958888,"Data Layer","[li r0, 0x3e7]"],[48958892,48958892,"Hereditary Powers","Loot item (material|food|arrow|keyitem already present in the inventory) area [lwz r4, +0x4(r23)]"],[48963276,48963276,"Hereditary Powers","Durability initialization area for new weapon [stw r25, +0x10(r31)]"],[48963340,48963340,"Hereditary Powers","Durability initialization area for new bow [stw r25, +0x10(r31)]"],[48963404,48963404,"Hereditary Powers","Durability initialization area for new shield [stw r25, +0x10(r31)]"],[48963464,48963464,"Item Limiter","Quantity initialization area for a new material slot [cmpwi r11, 0x3e7]"],[48963472,48963476,"Item Limiter","[li r11, 0x3e7]"],[48963560,48963560,"Item Limiter","Quantity initialization area for a new food slot [cmpwi r12, 0x3e7]"],[48963568,48963572,"Item Limiter","[li r12, 0x3e7]"],[48964924,48964924,"Hereditary Powers","Quantity initialization area for a new key item slot [stw r25, +0x10(r31)]"],[48970744,48970744,"More Weapon Slots","Used to load|save shield modifiers [cmpwi r23, 0x14]"],[48970808,48970808,"More Weapon Slots","Used to load|save bow modifiers [cmpwi r25, 0xe]"],[48970872,48970872,"More Weapon Slots","Used to load|save shield modifiers [cmpwi r24, 0x14]"],[48979188,48979188,"Hereditary Powers","Equip new looted weapon|item area via the inventory [li r0, 1]"],[48980884,48980884,"Item Limiter","Update resurrection fairy quantity area (PouchDelete) [lwz r9, +0x10(r27)]"],[48982128,48982128,"Hereditary Powers","Weapon inventory durability update area [addis r6, r28, 4]"],[48988916,48988916,"Item Limiter","Item (material|food) quantity update area for the NPC request (when forge champion weapons for example) [subf. r23, r29, r8]"],[48997904,48997904,"Item Limiter","Material quantity update area for the hold action (PouchTrash) [stw r0, +0x10(r27)]"],[48999156,48999156,"Item Limiter","Item (material|food) quantity update area for the eat action (PouchUse) [stw r0, +0x10(r30)]"],[48999160,48999160,"Life Extension","Item (material|food) quantity update area for the eat action [mr r3, r28]"],[49003396,49003396,"Cherry++","Browse the inventory by skiping the weapons [li r11, 1]"],[49004172,49004172,"Item Limiter","Material quantity update area when upgrade armor with the great fairies [subf. r6, r0, r8]"],[49004480,49004492,"Cherry++","Skip the bows and shields [cmpwi r9, 2]"],[49004828,49004828,"Item Limiter","Material|arrow quantity update area when craft with Cherry [subf. r6, r7, r8]"],[49006348,49006348,"More Weapon Slots","Init item shortcuts area [mr. r28, r4]"],[49006368,49006368,"More Weapon Slots","[mr r4, r28]"],[49006376,49006376,"More Weapon Slots","[cmplwi r12, 0x14]"],[49006384,49006384,"More Weapon Slots","[mr r5, r4]"],[49006408,49006412,"More Weapon Slots","[cmpwi r12, 0x14]"],[49006536,49006536,"More Weapon Slots","Used by the arrow quick menu [cmplwi r30, 0x14]"],[49006620,49006620,"More Weapon Slots","[cmpwi r30, 0x14]"],[49006676,49006676,"More Weapon Slots","Used by the weapon|bow|shield quick menu [cmplwi r30, 0x14]"],[49006760,49006760,"More Weapon Slots","[cmpwi r30, 0x14]"],[49006956,49006956,"Hereditary Powers","Equip weapon area via the quick menu [li r0, 1]"],[49008048,49008048,"Item Limiter","Material quantity update area for the restore action [lwz r12, +0x10(r7)]"],[49016972,49016972,"Item Limiter","Item (material|uncooked food) quantity update area for the sell action [lwz r8, +0x10(r31)]"],[49017020,49017020,"Item Limiter","Item (armor|cooked food) equipped state update area for the sell action [mr r3, r30]"],[49018872,49018872,"More Weapon Slots","[cmpwi r30, 0x14]"],[49018932,49018932,"More Weapon Slots","[cmpwi r30, 0x14]"],[49018992,49018992,"More Weapon Slots","[cmpwi r30, 0xE]"],[49019032,49019032,"More Weapon Slots","[cmpwi r30, 6]"],[49019192,49019192,"Item Limiter","Check if new food can be stored in the inventory [cmpwi r30, 0x3c]"],[49687356,49687360,"Dynamic FPS<br>Static FPS 30+<br>Static FPS 60+","[lis r12, 0x1023]"],[50003496,50003496,"Byakugan","Enemy life gauge hidden status update area [li r28, 0]"],[50003524,50003524,"Byakugan","[li r28, 0]"],[50028224,50028240,"UKing Tweaks","[lwz r7, +0x22b0(r29)]"],[50028244,50028312,"UKing Tweaks","18"],[50105080,50105080,"More Weapon Slots","[li r9, 0x14]"],[50105088,50105088,"More Weapon Slots","[stw r30, +0x1cd0(r31)]"],[50105096,50105096,"More Weapon Slots","[addi r11, r31, 0x1c74]"],[50105112,50105116,"More Weapon Slots","[lwz r0, +0x1cd0(r31)]"],[50105124,50105124,"More Weapon Slots","Call 'SetItemShortcuts' sub for the weapons [addi r30, r31, 0x1c78]"],[50105136,50105136,"More Weapon Slots","[mr r4, r30]"],[50105156,50105156,"More Weapon Slots","Call 'SetItemShortcuts' sub for the shields [addi r30, r31, 0x1c78]"],[50105168,50105168,"More Weapon Slots","[mr r4, r30]"],[50105188,50105188,"More Weapon Slots","Call 'SetItemShortcuts' sub for the bows [addi r30, r31, 0x1c78]"],[50105200,50105200,"More Weapon Slots","[mr r4, r30]"],[50105248,50105248,"More Weapon Slots","Quick menu management area [li r10, 0x14]"],[50105256,50105256,"More Weapon Slots","[stw r30, +0x1cd0(r31)]"],[50105264,50105264,"More Weapon Slots","[addi r8, r31, 0x1c74]"],[50105280,50105284,"More Weapon Slots","[lwz r0, +0x1cd0(r31)]"],[50105292,50105292,"More Weapon Slots","Call 'SetItemShortcuts' sub for the arrows [addi r30, r31, 0x1c78]"],[50105304,50105304,"More Weapon Slots","[mr r4, r30]"],[50105344,50105348,"More Weapon Slots","[li r12, 0x14]"],[50105360,50105360,"More Weapon Slots","[addi r11, r31, 0x1c74]"],[50105368,50105368,"More Weapon Slots","With r30 always = 0 normally [stwu r0, +0x4(r11)]"],[50105428,50105428,"More Weapon Slots","With r30 [4389806c] (computed from r31+0x1C??) = important memory address data [cmplwi r10, 0x14]"],[50105464,50105464,"More Weapon Slots","[cmplwi r10, 0x14]"],[50105580,50105580,"More Weapon Slots","[mr r31, r3]"],[50105652,50105652,"More Weapon Slots","[li r0, 0x15]"],[50105660,50105660,"More Weapon Slots","[addi r7, r31, 0x1cdc]"],[50105688,50105688,"More Weapon Slots","Set item shortcut indexes area [cmplwi r11, 0x15]"],[50105692,50105692,"UKing Tweaks","bge 0x02fc8d78"],[50105696,50105740,"UKing Tweaks","12"],[50105756,50105756,"More Weapon Slots","[cmplwi r11, 0x15]"],[50105760,50105760,"UKing Tweaks","bge 0x02fc8dbc"],[50105764,50105808,"UKing Tweaks","12"],[50105812,50105812,"More Weapon Slots","[cmplwi r11, 0x15]"],[50105904,50105908,"More Weapon Slots","[lis r28, 0x1026]"],[50106216,50106216,"More Weapon Slots","[lis r30, 0x1026]"],[50106336,50106336,"Durability UI","Selected quick menu rune shortcut management area [lwz r3, +0x0(r9)]"],[50106468,50106472,"More Weapon Slots","[cmplwi r0, 0x14]"],[50106532,50106536,"More Weapon Slots","[cmplwi r0, 0x14]"],[50106552,50106552,"Durability UI","Selected quick menu weapon shortcut management area [lwz r12, +0x0(r11)]"],[50106956,50106956,"More Weapon Slots","Call 'SetItemShortcutIndexes' sub for the key items [mr r3, r31]"],[50106988,50106988,"More Weapon Slots","Call 'SetItemShortcutIndexes' sub for the weapons [mr r3, r31]"],[50107080,50107080,"More Weapon Slots","[addi r6, r31, 0x1cdc]"],[50107096,50107096,"More Weapon Slots","Loop until active item area (Set quick menu item shortcuts) [cmplwi r12, 0x15]"],[50107160,50107160,"More Weapon Slots","[cmpwi r12, 0x15]"],[50108304,50108308,"More Weapon Slots","On unequiped via quick menu [cmplwi r0, 0x14]"],[50108324,50108324,"More Weapon Slots","[cmplwi r0, 0x14]"],[50108344,50108344,"More Weapon Slots","[cmplwi r0, 0x14]"],[50108512,50108516,"More Weapon Slots","[cmplwi r4, 0x14]"],[50108760,50108760,"More Weapon Slots","(Un)equip via quick menu area [mr r31, r3]"],[50109472,50109472,"More Weapon Slots","[mr r28, r3]"],[50109496,50109496,"More Weapon Slots","[cmplwi r27, 0x15]"],[50109524,50109528,"More Weapon Slots","[addi r9, r28, 0x1cdc]"],[50109548,50109548,"More Weapon Slots","[lwz r25, +0x0(r9)]"],[50109740,50109744,"More Weapon Slots","[cmplwi r25, 0x14]"],[50109760,50109760,"More Weapon Slots","[lwz r8, +0x0(r11)]"],[50110792,50110796,"More Weapon Slots","[cmplwi r25, 0x14]"],[50110812,50110812,"More Weapon Slots","[lwz r25, +0x0(r10)]"],[50111476,50111476,"More Weapon Slots","On quick menu selection change [mr r31, r3]"],[50111484,50111484,"More Weapon Slots","[cmplwi r4, 0x15]"],[50111504,50111508,"More Weapon Slots","[cmplwi r4, 0x15]"],[50206584,50206584,"Hunger Wheel<br>Raw Stamina<br>Staminax","Inventory yellow stamina preview update area [fcmpu cr0, f13, f1]"],[50206596,50206596,"Hunger Wheel<br>Raw Stamina<br>Staminax","[bge 0x02fe17cc]"],[50207664,50207664,"Life Extension","Read selected item data area [lwz r20, +0x8(r28)]"],[50217876,50217876,"Hunger Wheel<br>Raw Stamina","Inventory stamina update area by eating foods with yellow stamina bonus [stfs f12, +0x1d2c(r30)]"],[50217976,50217976,"Hunger Wheel<br>Raw Stamina","Inventory stamina update area [stfs f12, +0x1d2c(r30)]"],[50227184,50227184,"Hunger Wheel<br>Raw Stamina","Inventory stamina initialization area [stfs f1, +0x1d2c(r31)]"],[50227200,50227200,"Stamina Depletion","Init inventory golden stamina area [stfs f1, +0x1D34(r31)]"],[50259564,50259564,"More Weapon Slots","Inventory Arrow|bow page management area [bne 0x02FEE764]"],[50271692,50271696,"Hunger Wheel<br>Raw Stamina<br>Staminax","Inventory yellow stamina update area by eating cooked foods [lfs f1, +0x18(r1)]"],[50697356,50697356,"Shrine Replacements","Inside sub (probably used by AIDef:Action/ToCDungeon) to find near location marker string id [mr r25, r4]"],[50697656,50697656,"Shrine Replacements","[lwz r9, +0x4(r25)]"],[50697668,50697668,"Shrine Replacements","[mr r3, r25]"],[50697680,50697680,"Shrine Replacements","[li r30, 1]"],[50876540,50876540,"Life Extension","Golden hearts preview update area [rlwinm r0, r3, 2, 0, 29]"],[50887160,50887160,"Durability UI","Low durability warning check area related to the flashing red icons in the inventory [bl 0x0249e2e0]"],[50974744,50974744,"Dynamic FPS<br>Static FPS 30<br>Static FPS 30+<br>Static FPS 60+","[mflr r0]"],[50974748,50974820,"Static FPS 30","19"],[51219264,51219264,"No Pause In Combat","Gamepad + button pressed area [ori r10, r10, 0xc00]"],[51219276,51219276,"No Pause In Combat","Gamepad - button pressed area [ori r10, r10, 0x1200]"],[51221900,51221904,"No Pause In Combat","Pro controller + button pressed area [extrwi. r8, r4, 1, 19]"],[51221928,51221932,"No Pause In Combat","Pro controller - button pressed area [extrwi. r11, r4, 1, 20]"],[52406652,52406652,"Dynamic FPS<br>Static FPS 30<br>Static FPS 30+<br>Static FPS 60+","[stw r0, +0x78(r30)]"],[52406992,52407012,"Accurate Fence","[addi r3, r31, 0x388]"],[52407016,52407016,"Performance Fence","Make sure GPU is never more than 1 second? ahead) [lwz r0, +0x388(r31)]"],[52407020,52407036,"Accurate Fence","[subf r10, r10, r12]"],[52407040,52407040,"Fence Skip","No waiting on GPU [bla gx2.GX2SetGPUFence]"],[52407492,52407492,"Dynamic FPS<br>Static FPS 30<br>Static FPS 30+<br>Static FPS 60+","[mflr r0]"],[52407496,52407556,"Static FPS 30","16"],[52408840,52408840,"Accurate Fence","[mr r31, r3]"],[52408856,52408856,"Accurate Fence","[beq 0x031fb258]"],[52408868,52408868,"Accurate Fence","[beq 0x031fb258]"],[52408908,52408928,"Accurate Fence","[stb r0, +0x35(r31)]"],[52436700,52436700,"Don't Starve","Update flag area related to samemgr|gamedatamgr when start sleep or open map|inventory|ingame weapons+runes selector (and briefly in other cases) [stb r11, +0x2f8(r12)]"],[52436828,52436828,"Don't Starve","Update flag area related to samemgr|gamedatamgr when stop sleep or close map|inventory|weapons|ingame weapons+runes selector (and briefly in other cases) [stb r0, +0x2f8(r12)]"],[52612296,52612296,"Data Layer","Data structure initialization area when (re)start|(re)load a game [li r31, 0]"],[52612340,52612340,"Raw Stamina","Data structure initialization area when (re)start|(re)load a game [lwz r10, +0x10(r30)]"],[52612344,52612344,"Life Extension","Data structure initialization area when (re)start|(re)load a game [li r31, 0]"],[52612388,52612388,"Item Limiter","Data structure initialization area when (re)start|(re)load a game [lwz r4, +0x1c(r30)]"],[52612392,52612392,"No Pause In Combat","Data structure initialization area when (re)start|(re)load a game [li r31, 0]"],[52612440,52612440,"Stamina Depletion","Data structure initialization area when (re)start|(re)load a game [li r31, 0]"],[52771788,52771788,"Punitive Death","Bool array game data loading area [lwz r10, +0x92C(r31)]"],[52771972,52771972,"Punitive Death","S32 array game data loading area [lwz r10, +0x92C(r31)]"],[52772524,52772524,"Punitive Death","String array game data loading area [lwz r10, +0x92C(r31)]"],[52776764,52776764,"Punitive Death","Game save loading completed area [lmw r24, +0x10(r1)]"],[52776860,52776860,"Item Limiter","Game save loading completed area [mr r3, r31]"],[53000512,53000512,"Hereditary Powers","Read armor defense stat area [lbz r10, +0x3A00(r11)]"],[53013404,53013404,"Climbing In The Rain<br>Hereditary Powers","Init armor set bonus area [mr r31, r3]"],[53755200,53755200,"Climbing In The Rain<br>Hereditary Powers","Climbing in the rain check area [cmpwi r3, 0]"],[53873112,53873112,"Dynamic FPS<br>Static FPS 30+<br>Static FPS 60+","[lis r6, 0x102b]"],[53873120,53873120,"Dynamic FPS<br>Static FPS 30+<br>Static FPS 60+","[lfs f0, +0x4F48(r6)]"],[54139428,54139428,"Hereditary Powers","Enable Desert Voe armor set bonus (0x2) area [stw r7, +0x0(r29)]"],[54139748,54139748,"Hereditary Powers","Enable snowquill armor set bonus (0x8) area [stw r7, +0x0(r29)]"],[54140548,54140548,"Climbing In The Rain<br>Hereditary Powers","Enable climbing armor set bonus area [stw r9, +0x0(r29)]"],[54142692,54142692,"Hereditary Powers","Enable {zora|salvager} armor set bonus {0x1|0x1} area [stw r0, +0x0(r29)]"],[54614980,54614980,"Dynamic FPS<br>Static FPS 30<br>Static FPS 30+<br>Static FPS 60+","[slwi r9, r3, 2]"],[54614984,54615072,"Static FPS 30","23"],[54615076,54615076,"Dynamic FPS<br>Static FPS 30<br>Static FPS 30+<br>Static FPS 60+","[lfs f0, +0x1dd4(r12)]"],[54615084,54615084,"Dynamic FPS<br>Static FPS 30<br>Static FPS 30+<br>Static FPS 60+","[fmuls f0, f13, f0]"],[55782616,55782616,"No Pause In Combat","Fixed guardians lose target area [stw r0, +0x138(r31)]"],[55783080,55783080,"No Pause In Combat","Fixed guardians lock target area [addi r3, r31, 0x13c]"],[55783292,55783292,"No Pause In Combat","Fixed guardians relock target area (after stasis for example) [addi r3, r31, 0x13c]"],[55797632,55797632,"No Pause In Combat","Guardians lose target area [stw r0, +0x138(r31)]"],[55798168,55798168,"No Pause In Combat","Guardians lock target area [addi r3, r31, 0x13c]"],[55798496,55798496,"No Pause In Combat","Guardians relock target area (after stasis for example) [addi r3, r31, 0x13c]"],[57014800,57014800,"Hunger Wheel<br>Stamina Depletion","Time of day update after sleep (campfire included) area [lis r9, 0x1030]"],[57053164,57053164,"Weather Forecast","Update weather area [stb r26, +0x18(r30)]"],[58274588,58274588,"Dynamic FPS<br>Static FPS 30<br>Static FPS 30+<br>Static FPS 60+","[beq 0x03793324]"],[58274596,58274596,"Dynamic FPS<br>Static FPS 30<br>Static FPS 30+<br>Static FPS 60+","[cmpwi r31, 0]"],[58274600,58274704,"Static FPS 30","27"],[58274708,58274716,"Dynamic FPS<br>Static FPS 30<br>Static FPS 30+<br>Static FPS 60+","[lfs f1, +0x28(r30)]"],[58274724,58274732,"Dynamic FPS<br>Static FPS 30<br>Static FPS 30+<br>Static FPS 60+","[fcmpu cr0, f0, f1]"],[58573660,58573664,"Dynamic FPS<br>Static FPS 30+<br>Static FPS 60+","[lis r12, 0x1032]"],[61049652,61049652,"Durability UI","Set UI string area (length computing included) [srwi r4, r3, 1]"],[268552984,268552984,"Static FPS 30<br>Static FPS 30+<br>Static FPS 60+","[0.5]"],[268553388,268553388,"Static FPS 30<br>Static FPS 30+<br>Static FPS 60+","[30.0]"],[268924332,268924332,"Dynamic FPS<br>Static FPS 30+<br>Static FPS 60+","Thunderblight ganon yeet fix [-1.0]"],[271704768,271704768,"Dynamic FPS<br>Static FPS 30+<br>Static FPS 60+","[1.0]"],[0,0,"",""]];