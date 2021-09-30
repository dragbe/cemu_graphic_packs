@ECHO OFF
IF "%~2" EQU "" (
	SET "GAMEPATCHESFOLDER=BreathOfTheWild"
	SET "RPXMD5HASH=55 51 4b 38 ac 65 37 52 da bb 76 2f 32 32 92 d4"
) ELSE (
	SET "GAMEPATCHESFOLDER=%~1"
	SET "RPXMD5HASH=%~2"
)
FOR %%I IN ("%GAMEPATCHESFOLDER%\*.rpx") DO SET "GAMERPXFILENAME=%%~nI"
IF DEFINED GAMERPXFILENAME (
	ECHO [DATA CONTROL]
	ECHO Check %~dp0%GAMEPATCHESFOLDER%\%GAMERPXFILENAME%.rpx file MD5 hash...
	FOR /F "delims=" %%A IN ('CERTUTIL -hashfile "%GAMEPATCHESFOLDER%\%GAMERPXFILENAME%.rpx" MD5^|FINDSTR /B /R /C:".. .. .. .. .. .. .. .. .. .. .. .. .. .. .. .."') DO (
		ECHO Computed: %%A
		ECHO Expected: %RPXMD5HASH%
		IF "%%A" EQU "%RPXMD5HASH%" (
			ECHO [PRE-PROCESSING]
			ECHO Decompress %~dp0%GAMEPATCHESFOLDER%\%GAMERPXFILENAME%.rpx...
			WIIURPXTOOL -d "%GAMEPATCHESFOLDER%\%GAMERPXFILENAME%.rpx" "%GAMEPATCHESFOLDER%\%GAMERPXFILENAME%.drpx">NUL
			FOR /D %%A IN ("%GAMEPATCHESFOLDER%\*") DO (
				ECHO [%%~nxA PATCH(ES^)]
				FOR %%Z IN ("%%A\????????-????????????????????????????????.bin") DO INJECT2BIN "%GAMEPATCHESFOLDER%\%GAMERPXFILENAME%.drpx" "%%Z"
			)
			ECHO [POST-PROCESSING]
			ECHO Rebuild the %~dp0%GAMERPXFILENAME%.rpx (modded BOTW WiiU executable^)...
			WIIURPXTOOL -c "%GAMEPATCHESFOLDER%\%GAMERPXFILENAME%.drpx" "%GAMERPXFILENAME%.rpx">NUL
		) ELSE (
			ECHO Unexpected MD5 hash for %~dp0%GAMEPATCHESFOLDER%\%GAMERPXFILENAME%.rpx file
		)
	)
) ELSE (
	ECHO Game RPX file not found in the %~dp0%GAMEPATCHESFOLDER%\ folder
)
PAUSE
EXIT