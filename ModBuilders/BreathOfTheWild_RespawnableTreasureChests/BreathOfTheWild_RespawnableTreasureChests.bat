@ECHO OFF
IF NOT EXIST "Bootup.pack" ECHO Bootup.pack not found & EXIT /B
SET "TREASURECHESTSLIST=TBox_Field_Enemy TBox_Field_Iron TBox_Field_Iron_NoReaction TBox_Field_Iron_NoReaction_Aoc TBox_Field_Iron_NoReaction_Aoc_long TBox_Field_Iron_NoReaction_Collabo TBox_Field_Stone TBox_Field_Stone_NoReaction TBox_Field_Wood"
SET "LINKTAGS=And Or NAnd NOr XOr Count Pulse None"
IF "%~1" EQU "" GOTO :EXITSCRIPT
SETLOCAL EnableDelayedExpansion
FOR %%I IN (%*) DO (
	SET /A ISVALIDTCID=0
	FOR %%A IN (%LINKTAGS%) DO IF %%~I EQU LinkTag%%A SET /A ISVALIDTCID=1
	IF !ISVALIDTCID! EQU 0 (
		FOR %%A IN (%TREASURECHESTSLIST%) DO IF %%~I EQU %%A SET /A ISVALIDTCID=1
		IF !ISVALIDTCID! EQU 0 GOTO :EXITSCRIPT
	)
)
ENDLOCAL
SET "TMPFILENAME=%TMP%\tmp%RANDOM%."
SET TEMPFILENAME="%TMPFILENAME%yml"
SET TMPFILENAME="%TMPFILENAME%tid"
MKDIR "%~n0\content\Pack">NUL 2>&1
MKDIR "%~n0\content\Actor\Pack">NUL 2>&1 || DEL /F /Q "%~n0\content\Actor\Pack\*.sbactorpack">NUL 2>&1
ECHO Extract Bootup.pack
SARC extract "Bootup.pack">NUL 2>&1
ECHO Extract Bootup\GameData\gamedata.ssarc
SARC extract "Bootup\GameData\gamedata.ssarc">NUL 2>&1
ECHO Convert the Bootup\GameData\gamedata\revival_bool_data_X.bgdata files
FOR /L %%Z IN (0,1,7) DO BYML_TO_YML "Bootup\GameData\gamedata\revival_bool_data_%%Z.bgdata">"Bootup\GameData\gamedata\revival_bool_data_%%Z.yml"
:MAKETREASURECHESTSRESPAWNABLE
IF EXIST "%~1.sbactorpack" (
	ECHO Extract %~1.sbactorpack
	SARC extract "%~1.sbactorpack">NUL 2>&1
	ECHO Update %~1\Actor\ActorLink\TBox_Field_Enemy.bxml
	ECHO !io>%TEMPFILENAME%
	FOR /F "skip=1 tokens=1* delims=:" %%I IN ('AAMP_TO_YML "%~1\Actor\ActorLink\TBox_Field_Enemy.bxml"') DO IF "%%J" EQU " RevivalNone" (
		ECHO %%I: RevivalBloodyMoon>>%TEMPFILENAME%
	) ELSE (
		ECHO %%I:%%J>>%TEMPFILENAME%
	)
	YML_TO_AAMP %TEMPFILENAME%>"%~1\Actor\ActorLink\TBox_Field_Enemy.bxml"
	ECHO Rebuild %~n0\content\Actor\Pack\%~1.sbactorpack
	SARC create "%~1" "%~n0\content\Actor\Pack\%~1.sbactorpack" -b>NUL 2>&1
	RMDIR /S /Q "%~1">NUL 2>&1
) ELSE (
	ECHO Optional %~1.sbactorpack file not found (if all the treasure chests %~1 respawn after the blood moon, it makes sense to replace 'RevivalNone' with 'RevivalBloodyMoon' in the file %~1.sbactorpack\\Actor\ActorLink\TBox_Field_Enemy.bxml)
)
SET /P=""<NUL >%TMPFILENAME%
DEL %TEMPFILENAME%>NUL 2>&1
ECHO Read %~1.csv file data
FINDSTR /M /R /C:"^..*;..*;..*$" "%~1.csv">NUL 2>&1
IF ERRORLEVEL 1 (
	ECHO Rebuild %~1.csv file with an additional field (treasure chests uint Id^)
	FOR /F "usebackq tokens=1,2 delims=;" %%I IN ("%~1.csv") DO FOR /F %%A IN ('POWERSHELL -Command "[uint32]""0x%%J"""') DO (
		ECHO %%I;%%J;%%A>>%TEMPFILENAME%
		FOR /F "tokens=1 delims=_" %%Z IN ("%%I") DO ECHO : %%Z_%~1_%%A,>>%TMPFILENAME%
	)
	MOVE /Y %TEMPFILENAME% "%~1.csv">NUL 2>&1
) ELSE (
	FOR /F "usebackq tokens=1,3 delims=;" %%I IN ("%~1.csv") DO FOR /F "tokens=1 delims=_" %%A IN ("%%I") DO ECHO : %%A_%~1_%%J,>>%TMPFILENAME%
)
SETLOCAL EnableDelayedExpansion
FOR /L %%Z IN (0,1,7) DO (
	Set /P="Update Bootup\GameData\gamedata\revival_bool_data_%%Z: "<NUL
	SET /A MATCHESCOUNT=0
	DEL "Bootup\GameData\gamedata\revival_bool_data_%%Z.bgdata">NUL 2>&1
	FOR /F "delims=" %%I IN (%TMPFILENAME%) DO IF %%~zI NEQ 0 (
		FOR /F "tokens=1,3 delims=:," %%I IN ('FINDSTR /N /G:%TMPFILENAME% "Bootup\GameData\gamedata\revival_bool_data_%%Z.yml"') DO (
			SET /A MATCHES[!MATCHESCOUNT!]=%%I+2
			SET /A MATCHESCOUNT+=1
			ECHO :%%J,>>"Bootup\GameData\gamedata\revival_bool_data_%%Z.bgdata"
		)
		IF EXIST "Bootup\GameData\gamedata\revival_bool_data_%%Z.bgdata" (
			FINDSTR /V /G:"Bootup\GameData\gamedata\revival_bool_data_%%Z.bgdata" %TMPFILENAME%>%TEMPFILENAME%
			MOVE /Y %TEMPFILENAME% %TMPFILENAME%>NUL 2>&1
		)
		SET /A MATCHES[!MATCHESCOUNT!]=2147483647
	)
	ECHO !MATCHESCOUNT! match(es^) found
	IF !MATCHESCOUNT! NEQ 0 (
		SET /A MATCHESCOUNT=0
		CALL :GetMatchLineNumber 0
		SET /A LINECOUNT=0
		DEL %TEMPFILENAME%>NUL 2>&1
		FOR /F "usebackq delims=" %%I IN ("Bootup\GameData\gamedata\revival_bool_data_%%Z.yml") DO (
			SET /A LINECOUNT+=1
			IF !LINECOUNT! EQU !GetMatchLineNumber! (
				SET "LINE=%%I"
				ECHO !LINE:~0,-2!1}>>%TEMPFILENAME%
				SET /A MATCHESCOUNT+=1
				CALL :GetMatchLineNumber !MATCHESCOUNT!
			) ELSE (
				ECHO %%I>>%TEMPFILENAME%
			)
		)
		MOVE /Y %TEMPFILENAME% "Bootup\GameData\gamedata\revival_bool_data_%%Z.yml">NUL 2>&1
	)
)
SHIFT /1
IF "%~1" NEQ "" GOTO MAKETREASURECHESTSRESPAWNABLE
ECHO Rebuild the Bootup\GameData\gamedata\revival_bool_data_X.bgdata files
FOR /L %%Z IN (0,1,7) DO (
	YML_TO_BYML "Bootup\GameData\gamedata\revival_bool_data_%%Z.yml">"Bootup\GameData\gamedata\revival_bool_data_%%Z.bgdata"
	DEL "Bootup\GameData\gamedata\revival_bool_data_%%Z.yml">NUL 2>&1
)
DEL %TEMPFILENAME% %TMPFILENAME%>NUL 2>&1
ECHO Rebuild Bootup\GameData\gamedata.ssarc
SARC create "Bootup\GameData\gamedata" "Bootup\GameData\gamedata.ssarc" -b>NUL 2>&1
RMDIR /S /Q "Bootup\GameData\gamedata">NUL 2>&1
ECHO Rebuild %~n0\content\Pack\Bootup.pack
SARC create "Bootup" "%~n0\content\Pack\Bootup.pack" -b>NUL 2>&1
RMDIR /S /Q "Bootup">NUL 2>&1
ECHO Done
EXIT /B

:GetMatchLineNumber
SET "GetMatchLineNumber=!MATCHES[%~1]!"
EXIT /B
ENDLOCAL

:EXITSCRIPT
ECHO.
ECHO "%~nx0" ^<treasure chest IDs list (space as delimiter)^>
ECHO.
ECHO - Treasure chest IDs (=search filters for https://objmap.zeldamods.org^):
FOR %%A IN (%TREASURECHESTSLIST%) DO ECHO %%A
ECHO - Treasure chests CSV files data structure
ECHO ^<Map^>;^<Id (hexadecimal format without 0x prefix^)^>
EXIT /B