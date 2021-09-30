Attribute VB_Name = "CRC"
Option Explicit

Public Function Crc_CRC32(ByRef strInput As String) As Long
'Usage example with the immediate window: ?Crc_CRC32("Zelda")
Static lngCrc32Table(0 To 255) As Long
Dim i As Integer
Dim iLookup As Integer
Dim intBufferSize As Integer
Dim buffer() As Byte
    If lngCrc32Table(255) = 0 Then
        lngCrc32Table(0) = 0
        lngCrc32Table(1) = 1996959894
        lngCrc32Table(2) = -301047508
        lngCrc32Table(3) = -1727442502
        lngCrc32Table(4) = 124634137
        lngCrc32Table(5) = 1886057615
        lngCrc32Table(6) = -379345611
        lngCrc32Table(7) = -1637575261
        lngCrc32Table(8) = 249268274
        lngCrc32Table(9) = 2044508324
        lngCrc32Table(10) = -522852066
        lngCrc32Table(11) = -1747789432
        lngCrc32Table(12) = 162941995
        lngCrc32Table(13) = 2125561021
        lngCrc32Table(14) = -407360249
        lngCrc32Table(15) = -1866523247
        lngCrc32Table(16) = 498536548
        lngCrc32Table(17) = 1789927666
        lngCrc32Table(18) = -205950648
        lngCrc32Table(19) = -2067906082
        lngCrc32Table(20) = 450548861
        lngCrc32Table(21) = 1843258603
        lngCrc32Table(22) = -187386543
        lngCrc32Table(23) = -2083289657
        lngCrc32Table(24) = 325883990
        lngCrc32Table(25) = 1684777152
        lngCrc32Table(26) = -43845254
        lngCrc32Table(27) = -1973040660
        lngCrc32Table(28) = 335633487
        lngCrc32Table(29) = 1661365465
        lngCrc32Table(30) = -99664541
        lngCrc32Table(31) = -1928851979
        lngCrc32Table(32) = 997073096
        lngCrc32Table(33) = 1281953886
        lngCrc32Table(34) = -715111964
        lngCrc32Table(35) = -1570279054
        lngCrc32Table(36) = 1006888145
        lngCrc32Table(37) = 1258607687
        lngCrc32Table(38) = -770865667
        lngCrc32Table(39) = -1526024853
        lngCrc32Table(40) = 901097722
        lngCrc32Table(41) = 1119000684
        lngCrc32Table(42) = -608450090
        lngCrc32Table(43) = -1396901568
        lngCrc32Table(44) = 853044451
        lngCrc32Table(45) = 1172266101
        lngCrc32Table(46) = -589951537
        lngCrc32Table(47) = -1412350631
        lngCrc32Table(48) = 651767980
        lngCrc32Table(49) = 1373503546
        lngCrc32Table(50) = -925412992
        lngCrc32Table(51) = -1076862698
        lngCrc32Table(52) = 565507253
        lngCrc32Table(53) = 1454621731
        lngCrc32Table(54) = -809855591
        lngCrc32Table(55) = -1195530993
        lngCrc32Table(56) = 671266974
        lngCrc32Table(57) = 1594198024
        lngCrc32Table(58) = -972236366
        lngCrc32Table(59) = -1324619484
        lngCrc32Table(60) = 795835527
        lngCrc32Table(61) = 1483230225
        lngCrc32Table(62) = -1050600021
        lngCrc32Table(63) = -1234817731
        lngCrc32Table(64) = 1994146192
        lngCrc32Table(65) = 31158534
        lngCrc32Table(66) = -1731059524
        lngCrc32Table(67) = -271249366
        lngCrc32Table(68) = 1907459465
        lngCrc32Table(69) = 112637215
        lngCrc32Table(70) = -1614814043
        lngCrc32Table(71) = -390540237
        lngCrc32Table(72) = 2013776290
        lngCrc32Table(73) = 251722036
        lngCrc32Table(74) = -1777751922
        lngCrc32Table(75) = -519137256
        lngCrc32Table(76) = 2137656763
        lngCrc32Table(77) = 141376813
        lngCrc32Table(78) = -1855689577
        lngCrc32Table(79) = -429695999
        lngCrc32Table(80) = 1802195444
        lngCrc32Table(81) = 476864866
        lngCrc32Table(82) = -2056965928
        lngCrc32Table(83) = -228458418
        lngCrc32Table(84) = 1812370925
        lngCrc32Table(85) = 453092731
        lngCrc32Table(86) = -2113342271
        lngCrc32Table(87) = -183516073
        lngCrc32Table(88) = 1706088902
        lngCrc32Table(89) = 314042704
        lngCrc32Table(90) = -1950435094
        lngCrc32Table(91) = -54949764
        lngCrc32Table(92) = 1658658271
        lngCrc32Table(93) = 366619977
        lngCrc32Table(94) = -1932296973
        lngCrc32Table(95) = -69972891
        lngCrc32Table(96) = 1303535960
        lngCrc32Table(97) = 984961486
        lngCrc32Table(98) = -1547960204
        lngCrc32Table(99) = -725929758
        lngCrc32Table(100) = 1256170817
        lngCrc32Table(101) = 1037604311
        lngCrc32Table(102) = -1529756563
        lngCrc32Table(103) = -740887301
        lngCrc32Table(104) = 1131014506
        lngCrc32Table(105) = 879679996
        lngCrc32Table(106) = -1385723834
        lngCrc32Table(107) = -631195440
        lngCrc32Table(108) = 1141124467
        lngCrc32Table(109) = 855842277
        lngCrc32Table(110) = -1442165665
        lngCrc32Table(111) = -586318647
        lngCrc32Table(112) = 1342533948
        lngCrc32Table(113) = 654459306
        lngCrc32Table(114) = -1106571248
        lngCrc32Table(115) = -921952122
        lngCrc32Table(116) = 1466479909
        lngCrc32Table(117) = 544179635
        lngCrc32Table(118) = -1184443383
        lngCrc32Table(119) = -832445281
        lngCrc32Table(120) = 1591671054
        lngCrc32Table(121) = 702138776
        lngCrc32Table(122) = -1328506846
        lngCrc32Table(123) = -942167884
        lngCrc32Table(124) = 1504918807
        lngCrc32Table(125) = 783551873
        lngCrc32Table(126) = -1212326853
        lngCrc32Table(127) = -1061524307
        lngCrc32Table(128) = -306674912
        lngCrc32Table(129) = -1698712650
        lngCrc32Table(130) = 62317068
        lngCrc32Table(131) = 1957810842
        lngCrc32Table(132) = -355121351
        lngCrc32Table(133) = -1647151185
        lngCrc32Table(134) = 81470997
        lngCrc32Table(135) = 1943803523
        lngCrc32Table(136) = -480048366
        lngCrc32Table(137) = -1805370492
        lngCrc32Table(138) = 225274430
        lngCrc32Table(139) = 2053790376
        lngCrc32Table(140) = -468791541
        lngCrc32Table(141) = -1828061283
        lngCrc32Table(142) = 167816743
        lngCrc32Table(143) = 2097651377
        lngCrc32Table(144) = -267414716
        lngCrc32Table(145) = -2029476910
        lngCrc32Table(146) = 503444072
        lngCrc32Table(147) = 1762050814
        lngCrc32Table(148) = -144550051
        lngCrc32Table(149) = -2140837941
        lngCrc32Table(150) = 426522225
        lngCrc32Table(151) = 1852507879
        lngCrc32Table(152) = -19653770
        lngCrc32Table(153) = -1982649376
        lngCrc32Table(154) = 282753626
        lngCrc32Table(155) = 1742555852
        lngCrc32Table(156) = -105259153
        lngCrc32Table(157) = -1900089351
        lngCrc32Table(158) = 397917763
        lngCrc32Table(159) = 1622183637
        lngCrc32Table(160) = -690576408
        lngCrc32Table(161) = -1580100738
        lngCrc32Table(162) = 953729732
        lngCrc32Table(163) = 1340076626
        lngCrc32Table(164) = -776247311
        lngCrc32Table(165) = -1497606297
        lngCrc32Table(166) = 1068828381
        lngCrc32Table(167) = 1219638859
        lngCrc32Table(168) = -670225446
        lngCrc32Table(169) = -1358292148
        lngCrc32Table(170) = 906185462
        lngCrc32Table(171) = 1090812512
        lngCrc32Table(172) = -547295293
        lngCrc32Table(173) = -1469587627
        lngCrc32Table(174) = 829329135
        lngCrc32Table(175) = 1181335161
        lngCrc32Table(176) = -882789492
        lngCrc32Table(177) = -1134132454
        lngCrc32Table(178) = 628085408
        lngCrc32Table(179) = 1382605366
        lngCrc32Table(180) = -871598187
        lngCrc32Table(181) = -1156888829
        lngCrc32Table(182) = 570562233
        lngCrc32Table(183) = 1426400815
        lngCrc32Table(184) = -977650754
        lngCrc32Table(185) = -1296233688
        lngCrc32Table(186) = 733239954
        lngCrc32Table(187) = 1555261956
        lngCrc32Table(188) = -1026031705
        lngCrc32Table(189) = -1244606671
        lngCrc32Table(190) = 752459403
        lngCrc32Table(191) = 1541320221
        lngCrc32Table(192) = -1687895376
        lngCrc32Table(193) = -328994266
        lngCrc32Table(194) = 1969922972
        lngCrc32Table(195) = 40735498
        lngCrc32Table(196) = -1677130071
        lngCrc32Table(197) = -351390145
        lngCrc32Table(198) = 1913087877
        lngCrc32Table(199) = 83908371
        lngCrc32Table(200) = -1782625662
        lngCrc32Table(201) = -491226604
        lngCrc32Table(202) = 2075208622
        lngCrc32Table(203) = 213261112
        lngCrc32Table(204) = -1831694693
        lngCrc32Table(205) = -438977011
        lngCrc32Table(206) = 2094854071
        lngCrc32Table(207) = 198958881
        lngCrc32Table(208) = -2032938284
        lngCrc32Table(209) = -237706686
        lngCrc32Table(210) = 1759359992
        lngCrc32Table(211) = 534414190
        lngCrc32Table(212) = -2118248755
        lngCrc32Table(213) = -155638181
        lngCrc32Table(214) = 1873836001
        lngCrc32Table(215) = 414664567
        lngCrc32Table(216) = -2012718362
        lngCrc32Table(217) = -15766928
        lngCrc32Table(218) = 1711684554
        lngCrc32Table(219) = 285281116
        lngCrc32Table(220) = -1889165569
        lngCrc32Table(221) = -127750551
        lngCrc32Table(222) = 1634467795
        lngCrc32Table(223) = 376229701
        lngCrc32Table(224) = -1609899400
        lngCrc32Table(225) = -686959890
        lngCrc32Table(226) = 1308918612
        lngCrc32Table(227) = 956543938
        lngCrc32Table(228) = -1486412191
        lngCrc32Table(229) = -799009033
        lngCrc32Table(230) = 1231636301
        lngCrc32Table(231) = 1047427035
        lngCrc32Table(232) = -1362007478
        lngCrc32Table(233) = -640263460
        lngCrc32Table(234) = 1088359270
        lngCrc32Table(235) = 936918000
        lngCrc32Table(236) = -1447252397
        lngCrc32Table(237) = -558129467
        lngCrc32Table(238) = 1202900863
        lngCrc32Table(239) = 817233897
        lngCrc32Table(240) = -1111625188
        lngCrc32Table(241) = -893730166
        lngCrc32Table(242) = 1404277552
        lngCrc32Table(243) = 615818150
        lngCrc32Table(244) = -1160759803
        lngCrc32Table(245) = -841546093
        lngCrc32Table(246) = 1423857449
        lngCrc32Table(247) = 601450431
        lngCrc32Table(248) = -1285129682
        lngCrc32Table(249) = -1000256840
        lngCrc32Table(250) = 1567103746
        lngCrc32Table(251) = 711928724
        lngCrc32Table(252) = -1274298825
        lngCrc32Table(253) = -1022587231
        lngCrc32Table(254) = 1510334235
        lngCrc32Table(255) = 755167117
    End If
    buffer = StrConv(strInput, vbFromUnicode)
    Crc_CRC32 = &HFFFFFFFF
    intBufferSize = UBound(buffer)
    For i = LBound(buffer) To intBufferSize
        iLookup = (Crc_CRC32 And &HFF) Xor buffer(i)
        Crc_CRC32 = ((Crc_CRC32 And &HFFFFFF00) \ &H100) And 16777215
        Crc_CRC32 = Crc_CRC32 Xor lngCrc32Table(iLookup)
    Next i
    Crc_CRC32 = Not Crc_CRC32
End Function