@echo off


REM User Input
:options 
	echo ***************************************************************************************************************
	echo * Starting release script. %date% %time%	
	echo ***************************************************************************************************************

	echo
	echo Specifiy input parameters:
	
	set /p OPTION1=Release Num (e.g. R001):
	set /p OPTION2=ssh user name: 
	set /p OPTION3=ssh password: 
	set /p OPTION4=RPD password: 
	set /p OPTION5=Target BI_PLATFORM TNS (e.g. ADWU01): 
	set /p OPTION6=Target BI_PLATFORM user (e.g. OBIEEUAT_BIPLATFORM): 
	set /p OPTION7=Target BI_PLATFORM password (e.g. std): 
	set /p OPTION8=Full(F)/Partial(P) migration: 
	
if "%OPTION1%" == "" ( 
   echo Missing release number...
   Goto options
)
if "%OPTION2%" == "" ( 
   echo Missing ssh user name...
   Goto options
)
if "%OPTION3%" == "" ( 
   echo Missing ssh password...
   Goto options
)	
if "%OPTION4%" == "" ( 
   echo Missing rpd password...
   Goto options
)	
	
:main
	REM set envrionment variables - these need to be adjusted

	if "%OPTION8%" == "F" (
		SET REL_TYPE= F
	) else ( 
		SET REL_TYPE=P
	)	
	SET REL_NUM=%OPTION1%
	SET REL_DIR=C:\Ladbrokes\Release
	SET TGT_REL_DIR=/tmp/Release
	SET SANDBOX_REL_DIR=T:\BIS\ADW\OBIEE\Release
	
	SET RPD_PASS=%OPTION4%
	SET RPD_NAME=Release_ADW
	SET RPD_NAME_OUT=ADW_DEV_20120702_BI0003
	REM SET RPD_NAME_OUT=ADW_UAT_BI0001	
	SET RPD_NAME_SANDBOX=ADW_SANDBOX_BI0001
	SET BI_PLATFORM_TNS=%OPTION5%
	SET BI_PLATFORM_USER=%OPTION6%
	SET BI_PLATFORM_PASS=%OPTION7%
	SET CATALOG_NAME=adw
	SET CATALOG_NAME_TAR=Release_ADW_Webcat

	SET SRC_REL_DIR=/tmp/Release_out
	SET SRC_RES_DIR=/apps/oracle/Middleware/instances/instance1/bifoundation/OracleBIPresentationServicesComponent/coreapplication_obips1/analyticsRes

	SET TGT_CATALOG_DIR=/opt/oracle/obiee/data1/catalog
	SET TGT_RES_DIR=/opt/oracle/obiee/data1/analytcsRes
	SET TGT_DICT_DIR=/opt/oracle/obiee/data1/analyticsRes/DataDictionary
	SET TGT_BI_HOME=/apps/oracle/Middleware/Oracle_BI1
	SET TGT_BI_INSTANCE_HOME=/apps/oracle/Middleware/instances/instance1
	
	SET SANDBOX_CATALOG_DIR=C:\oracle\obiee\instances\instance1\bifoundation\OracleBIPresentationServicesComponent\coreapplication_obips1\catalog
	SET SANDBOX_RES_DIR=C:\oracle\obiee\instances\instance1\bifoundation\OracleBIPresentationServicesComponent\coreapplication_obips1\analyticsRes
	SET SANDBOX_DICT_DIR=C:\oracle\obiee\instances\instance1\bifoundation\OracleBIPresentationServicesComponent\coreapplication_obips1\analyticsRes\DataDictionary
	SET SANDBOX_BI_INSTANCE_HOME=C:\oracle\obiee\instances\instance1
	SET SANDBOX_BI_SERVICE_NAME=OracleProcessManager_instance1
	
	SET BI_TOOLS_DIR=C:\Progra~1\Oracle~1\oraclebi\orahome\bifoundation\server\bin

	SET PUTTY_BASE=C:\Ladbrokes\Software\putty
	SET ZIP_BASE=C:\Progra~1\7-Zip

	REM 
	SET SSH_USER=%OPTION2%
	SET SSH_PASS=%OPTION3%
	SET SRC_HOST=ukrlcfapdev01
	SET TGT_HOST=ukobiuat01

	echo 00. Creating input files
	cd %REL_DIR%
	mkdir %REL_NUM%
	cd %REL_NUM%

	REM creating sftp upload input files
	echo mkdir %TGT_REL_DIR% > psftp_inp.scr
	echo chmod 777 %TGT_REL_DIR% >> psftp_inp.scr
	echo cd %TGT_REL_DIR% >> psftp_inp.scr
	echo put release.sh >> psftp_inp.scr
	echo chmod 777 release.sh >> psftp_inp.scr		
	echo mkdir %REL_NUM% >> psftp_inp.scr
	echo chmod 777 %REL_NUM% >> psftp_inp.scr
	echo cd %REL_NUM% >> psftp_inp.scr
	echo put %CATALOG_NAME_TAR%.tar >> psftp_inp.scr
	echo put %RPD_NAME_OUT%.rpd >> psftp_inp.scr
	echo put %RPD_NAME_OUT%.zip >> psftp_inp.scr

	echo chmod 777 %CATALOG_NAME_TAR%.tar >> psftp_inp.scr
	echo chmod 777 %RPD_NAME_OUT%.rpd >> psftp_inp.scr
	echo chmod 777 %RPD_NAME_OUT%.zip >> psftp_inp.scr
	echo quit >> psftp_inp.scr

	echo cd %SRC_REL_DIR% > psftp_src_inp.scr
	echo get %CATALOG_NAME_TAR%.tar >> psftp_src_inp.scr
	echo get %RPD_NAME%.rpd >> psftp_src_inp.scr
	echo quit >> psftp_src_inp.scr

	REM ******************************************
	REM creating release script file for target host
	REM ******************************************	
	echo cd %TGT_REL_DIR%/%REL_NUM% > release.sh
	echo tar xf %CATALOG_NAME_TAR%.tar >> release.sh
	echo %TGT_BI_INSTANCE_HOME%/bin/opmnctl stopall >> release.sh
	REM backup existing webcat
	echo cp -r %TGT_CATALOG_DIR%/%CATALOG_NAME% %TGT_CATALOG_DIR%/%CATALOG_NAME%_bak_%REL_NUM% >> release.sh
	REM 2 options: full webcat migration or export/import selected folder
	if "%REL_TYPE%" == "P" ( 
		REM archive selected folders from source
		REM echo %TGT_BI_INSTANCE_HOME%/bifoundation/OracleBIPresentationServicesComponent/coreapplication_obips1/catalogmanager/runcat.sh -cmd archive -offline %TGT_REL_DIR%/%REL_NUM%/catalog/%CATALOG_NAME% -outputFile %TGT_REL_DIR%/%REL_NUM%/fieldbook.arc -folder "/shared/field book" >> release.sh
		REM echo %TGT_BI_INSTANCE_HOME%/bifoundation/OracleBIPresentationServicesComponent/coreapplication_obips1/catalogmanager/runcat.sh -cmd archive -offline %TGT_REL_DIR%/%REL_NUM%/catalog/%CATALOG_NAME% -outputFile %TGT_REL_DIR%/%REL_NUM%/customerdevelopmentandacquisition.arc -folder "/shared/customer development and acquisition" >> release.sh
		REM echo %TGT_BI_INSTANCE_HOME%/bifoundation/OracleBIPresentationServicesComponent/coreapplication_obips1/catalogmanager/runcat.sh -cmd archive -offline %TGT_REL_DIR%/%REL_NUM%/catalog/%CATALOG_NAME% -outputFile %TGT_REL_DIR%/%REL_NUM%/hvc.arc -folder /shared/hvc >> release.sh
		REM use delete instead of runcat.sh (delete folders and .atr permission files)
		echo rm -r %TGT_CATALOG_DIR%/%CATALOG_NAME%/root/shared/field+book* >> release.sh
		echo rm -r %TGT_CATALOG_DIR%/%CATALOG_NAME%/root/shared/customer+development+and+acquisition* >> release.sh
		echo rm -r %TGT_CATALOG_DIR%/%CATALOG_NAME%/root/shared/hvc* >> release.sh
		REM restore /users and /shared/training folders
		REM echo %TGT_BI_INSTANCE_HOME%/bifoundation/OracleBIPresentationServicesComponent/coreapplication_obips1/catalogmanager/runcat.sh -cmd unarchive -offline %TGT_CATALOG_DIR%/%CATALOG_NAME% -inputFile %TGT_REL_DIR%/%REL_NUM%/fieldbook.arc -folder /shared -overwrite all -acl createOnlyGroups >> release.sh
		REM echo %TGT_BI_INSTANCE_HOME%/bifoundation/OracleBIPresentationServicesComponent/coreapplication_obips1/catalogmanager/runcat.sh -cmd unarchive -offline %TGT_CATALOG_DIR%/%CATALOG_NAME% -inputFile %TGT_REL_DIR%/%REL_NUM%/customerdevelopmentandacquisition.arc -folder /shared -overwrite all -acl createOnlyGroups >> release.sh
		REM echo %TGT_BI_INSTANCE_HOME%/bifoundation/OracleBIPresentationServicesComponent/coreapplication_obips1/catalogmanager/runcat.sh -cmd unarchive -offline %TGT_CATALOG_DIR%/%CATALOG_NAME% -inputFile %TGT_REL_DIR%/%REL_NUM%/hvc.arc -folder /shared -overwrite all -acl createOnlyGroups >> release.sh
		REM use file copy instead of runcat.sh
		echo cp -r %TGT_REL_DIR%/%REL_NUM%/catalog/%CATALOG_NAME%/root/shared/field+book* %TGT_CATALOG_DIR%/%CATALOG_NAME%/root/shared/ >> release.sh
		echo cp -r %TGT_REL_DIR%/%REL_NUM%/catalog/%CATALOG_NAME%/root/shared/customer+development+and+acquisition* %TGT_CATALOG_DIR%/%CATALOG_NAME%/root/shared/ >> release.sh
		echo cp -r %TGT_REL_DIR%/%REL_NUM%/catalog/%CATALOG_NAME%/root/shared/hvc* %TGT_CATALOG_DIR%/%CATALOG_NAME%/root/shared/ >> release.sh
	)	
	if "%REL_TYPE%" == "F" ( 
		echo rm -r %TGT_CATALOG_DIR%/%CATALOG_NAME% >> release.sh
		echo mv catalog/%CATALOG_NAME% %TGT_CATALOG_DIR% >> release.sh
	)
	REM locate curent .rpd
	echo CURR_RPD_NAME=$(awk '/Star/ {gsub(/,/,""); print $3}' %TGT_BI_INSTANCE_HOME%/config/OracleBIServerComponent/coreapplication_obis1/NQSConfig.INI) >> release.sh	
	echo mv %TGT_BI_INSTANCE_HOME%/bifoundation/OracleBIServerComponent/coreapplication_obis1/repository/$CURR_RPD_NAME %TGT_BI_INSTANCE_HOME%/bifoundation/OracleBIServerComponent/coreapplication_obis1/repository/$CURR_RPD_NAME.bak_%REL_NUM% >> release.sh
	echo cp %RPD_NAME_OUT%.rpd %TGT_BI_INSTANCE_HOME%/bifoundation/OracleBIServerComponent/coreapplication_obis1/repository/$CURR_RPD_NAME >> release.sh
	echo unzip %RPD_NAME_OUT%.zip >> release.sh
	echo mv %TGT_DICT_DIR%/%RPD_NAME_OUT% %TGT_DICT_DIR%/%RPD_NAME_OUT%_bak_%REL_NUM% >> release.sh	
	echo mv %RPD_NAME_OUT% %TGT_DICT_DIR%/%RPD_NAME_OUT% >> release.sh
	echo %TGT_BI_INSTANCE_HOME%/bin/opmnctl startall >> release.sh

	REM crating RPD Update input file - UAT (replaces variables - rpd version, cache_hit, connection strings etc)
	echo ^<?xml version="1.0" encoding="UTF-8" ?^> > ConnVariables.xudml
	echo ^<Repository xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"^> >> ConnVariables.xudml
	echo ^<DECLARE^> >> ConnVariables.xudml
	echo ^<Variable name="CONN_POOL_BI_PLATFORM_TNSNAME" id="3031:17884" uid="27716"^> >> ConnVariables.xudml
	echo ^<Description^>^<![CDATA[RM WK 05/04/2012: TNS Service Name for main Usage Tracking >> ConnVariables.xudml
	echo DEV: ADWD01 >> ConnVariables.xudml
	echo UAT: ADWU01 >> ConnVariables.xudml
	echo ]]^>^</Description^> >> ConnVariables.xudml
	echo ^<Expr^>^<![CDATA['%BI_PLATFORM_TNS%']]^>^</Expr^> >> ConnVariables.xudml
	echo ^</Variable^> >> ConnVariables.xudml
	echo ^<Variable name="CONN_POOL_BI_PLATFORM_USER" id="3031:17883" uid="27715"^> >> ConnVariables.xudml
	echo ^<Description^>^<![CDATA[RM WK 20/12/2011: Schema owner name for Usage Tracking tables.]]^>^</Description^> >> ConnVariables.xudml
	echo ^<Expr^>^<![CDATA['%BI_PLATFORM_USER%']]^>^</Expr^> >> ConnVariables.xudml
	echo ^</Variable^> >> ConnVariables.xudml
	echo ^<Variable name="CONN_POOL_BI_PLATFORM_USER_PASS" id="3031:11792" uid="21627"^> >> ConnVariables.xudml
	echo ^<Description^>^<![CDATA[RM WK 05/04/2012: Usage Tracking user password - used as dynamic variable in all FieldBook connection pools.]]^>^</Description^> >> ConnVariables.xudml
	echo ^<Expr^>^<![CDATA['%BI_PLATFORM_PASS%']]^>^</Expr^> >> ConnVariables.xudml
	echo ^</Variable^> >> ConnVariables.xudml
	echo ^<Variable name="OBIEE_RPD_VER" id="3031:27311" uid="37426"^> >> ConnVariables.xudml
	echo ^<Description^>^<![CDATA[RM WK 21/06/2012: Repository variable indicating release OBIEE repository version.]]^>^</Description^> >> ConnVariables.xudml
	echo ^<Expr^>^<![CDATA['%REL_NUM%']]^>^</Expr^> >> ConnVariables.xudml
	echo ^</Variable^> >> ConnVariables.xudml
	echo ^<Variable name="OBIEE_RPD_NAME" id="3031:27312" uid="37427"^> >> ConnVariables.xudml
	echo ^<Description^>^<![CDATA[RM WK 21/06/2012: Repository variable indicating current working OBIEE repository file name.]]^>^</Description^> >> ConnVariables.xudml
	echo ^<Expr^>^<![CDATA['%RPD_NAME_OUT%']]^>^</Expr^> >> ConnVariables.xudml
	echo ^</Variable^> >> ConnVariables.xudml

	echo ^<InitBlock name="SYS_VARIABLES" id="3033:12290" uid="22119" isSessionVar="true" isDeferredExecution="true"^> >> ConnVariables.xudml
	echo ^<Description^>^<![CDATA[RM WK 17/05/2012: Sets system variables overrides mainly for debugging purpose.]]^>^</Description^> >> ConnVariables.xudml
	echo ^<RefConnectionPool id="3029:22473" uid="32301" qualifiedName="&quot;BI Platform Repository&quot;.&quot;Init Blocks Connection Pool&quot;"/^> >> ConnVariables.xudml
	echo ^<DBMap^> >> ConnVariables.xudml
	echo ^<Item name="DefaultMulDB"^> >> ConnVariables.xudml
	echo ^<Value^>^<![CDATA[SELECT CAST(5 AS NUMBER(1)) AS LOGLEVEL, CAST(1 AS NUMBER(1)) AS DISABLE_CACHE_HIT FROM DUAL]]^>^</Value^> >> ConnVariables.xudml
	echo ^</Item^> >> ConnVariables.xudml
	echo ^</DBMap^> >> ConnVariables.xudml
	echo ^<Variables^> >> ConnVariables.xudml
	echo ^<RefVariable id="3031:12289" uid="22118" qualifiedName="&quot;SYS_VARIABLES&quot;.&quot;LOGLEVEL&quot;"/^> >> ConnVariables.xudml
	echo ^<RefVariable id="3031:22522" uid="32343" qualifiedName="&quot;SYS_VARIABLES&quot;.&quot;DISABLE_CACHE_HIT&quot;"/^> >> ConnVariables.xudml
	echo ^</Variables^> >> ConnVariables.xudml
	echo ^<InitString^>^<![CDATA[SELECT CAST(5 AS NUMBER(1)) AS LOGLEVEL, CAST(1 AS NUMBER(1)) AS DISABLE_CACHE_HIT FROM DUAL]]^>^</InitString^> >> ConnVariables.xudml
	echo ^</InitBlock^> >> ConnVariables.xudml

	echo ^</DECLARE^> >> ConnVariables.xudml
	echo ^</Repository^> >> ConnVariables.xudml	

	REM crating RPD Update input file - SANDBOX
	echo ^<?xml version="1.0" encoding="UTF-8" ?^> > ConnVariablesSandbox.xudml
	echo ^<Repository xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"^> >> ConnVariablesSandbox.xudml
	echo ^<DECLARE^> >> ConnVariablesSandbox.xudml
	echo ^<Variable name="OBIEE_RPD_VER" id="3031:27311" uid="37426"^> >> ConnVariablesSandbox.xudml
	echo ^<Description^>^<![CDATA[RM WK 21/06/2012: Repository variable indicating release OBIEE repository version.]]^>^</Description^> >> ConnVariablesSandbox.xudml
	echo ^<Expr^>^<![CDATA['%REL_NUM%']]^>^</Expr^> >> ConnVariablesSandbox.xudml
	echo ^</Variable^> >> ConnVariablesSandbox.xudml
	echo ^<Variable name="OBIEE_RPD_NAME" id="3031:27312" uid="37427"^> >> ConnVariablesSandbox.xudml
	echo ^<Description^>^<![CDATA[RM WK 21/06/2012: Repository variable indicating current working OBIEE repository file name.]]^>^</Description^> >> ConnVariablesSandbox.xudml
	echo ^<Expr^>^<![CDATA['%RPD_NAME_SANDBOX%']]^>^</Expr^> >> ConnVariablesSandbox.xudml
	echo ^</Variable^> >> ConnVariablesSandbox.xudml
	echo ^</DECLARE^> >> ConnVariablesSandbox.xudml
	echo ^</Repository^> >> ConnVariablesSandbox.xudml	
	
	REM creating DataDictionary input file
	echo Open %RPD_NAME_OUT%.rpd "Witold Kusnierz" %RPD_PASS% > DataDictionary.scr
	echo Hide >> DataDictionary.scr
	echo GenerateMetadataDictionary %REL_DIR%\%REL_NUM% >> DataDictionary.scr
	echo Close >> DataDictionary.scr
	echo Exit >> DataDictionary.scr
	
	REM creating Sandbox release file
	echo echo starting release > release.cmd
	echo NET STOP %SANDBOX_BI_SERVICE_NAME% >> release.cmd
	rem move 
	echo cd %SANDBOX_REL_DIR% >> release.cmd
	echo Backup objects  >> release.cmd
	echo ren %SANDBOX_BI_INSTANCE_HOME%\bifoundation\OracleBIServerComponent\coreapplication_obis1\repository\%RPD_NAME_SANDBOX%.rpd %SANDBOX_BI_INSTANCE_HOME%\bifoundation\OracleBIServerComponent\coreapplication_obis1\repository\%RPD_NAME_SANDBOX%_bak_%REL_NUM%.rpd >> release.cmd
	echo xcopy %RPD_NAME_SANDBOX%.rpd %SANDBOX_BI_INSTANCE_HOME%\bifoundation\OracleBIServerComponent\coreapplication_obis1\repository\%RPD_NAME_SANDBOX%.rpd /Y >> release.cmd
	echo move %SANDBOX_CATALOG_DIR%\%CATALOG_NAME% %SANDBOX_CATALOG_DIR%\%CATALOG_NAME%_bak_%REL_NUM% /Y >> release.cmd
	echo move %SANDBOX_DICT_DIR%\%RPD_NAME_SANDBOX% %SANDBOX_DICT_DIR%\%RPD_NAME_SANDBOX%_bak_%REL_NUM% /Y >> release.cmd
	echo extract webcat and data dictionary >> release.cmd
	echo xcopy %SANDBOX_REL_DIR%\%CATALOG_NAME_TAR%.tar C:\TEMP\ /Y >> release.cmd
	echo xcopy %SANDBOX_REL_DIR%\%RPD_NAME_SANDBOX%.zip C:\TEMP\ /Y >> release.cmd
	echo %ZIP_BASE%\7z x C:\TEMP\%CATALOG_NAME_TAR%.tar >> release.cmd
	echo %ZIP_BASE%\7z x C:\TEMP\%CATALOG_NAME_TAR% >> release.cmd
	echo %ZIP_BASE%\7z x C:\TEMP\%RPD_NAME_SANDBOX%.zip >> release.cmd
	echo move C:\TEMP\catalog\%CATALOG_NAME% %SANDBOX_CATALOG_DIR% /Y >> release.cmd
	echo move C:\TEMP\%RPD_NAME_OUT% %SANDBOX_DICT_DIR% /Y >> release.cmd
	echo ren %SANDBOX_DICT_DIR%\%RPD_NAME_OUT% %SANDBOX_DICT_DIR%\%RPD_NAME_SANDBOX% /Y >> release.cmd	
	echo NET START %SANDBOX_BI_SERVICE_NAME% >> release.cmd


	echo ***************************************************************************************************************	
	echo 01. Executing backup script on source host
	echo Execute backup scripts under privileged account (oracle): /home/oracle/backupOBIEE.sh releaseAll
	pause
	%PUTTY_BASE%\putty.exe -ssh %SSH_USER%@%SRC_HOST% -pw %SSH_PASS%

	echo ***************************************************************************************************************
	echo 02. Downloading regenerated objects into release folder.
	cd %REL_DIR%\%REL_NUM%
	%PUTTY_BASE%\psftp.exe %SSH_USER%@%SRC_HOST% -pw %SSH_PASS% -b psftp_src_inp.scr -bc -be

	echo ***************************************************************************************************************	
	echo 03. Updating RPD
	REM Extract to XUDML
	%BI_TOOLS_DIR%\biserverxmlgen.exe -P %RPD_PASS% -R %REL_DIR%\%REL_NUM%\%RPD_NAME%.rpd -O %REL_DIR%\%REL_NUM%\%RPD_NAME%.xudml -8
	REM Regenerate from XUDML
	REM Later make ConnVariables.xudml dynamic
	%BI_TOOLS_DIR%\biserverxmlexec.exe -P %RPD_PASS% -I %REL_DIR%\%REL_NUM%\ConnVariables.xudml -B %REL_DIR%\%REL_NUM%\%RPD_NAME%.rpd -O %REL_DIR%\%REL_NUM%\%RPD_NAME_OUT%.rpd
	%BI_TOOLS_DIR%\biserverxmlexec.exe -P %RPD_PASS% -I %REL_DIR%\%REL_NUM%\ConnVariablesSandbox.xudml -B %REL_DIR%\%REL_NUM%\%RPD_NAME%.rpd -O %REL_DIR%\%REL_NUM%\%RPD_NAME_SANDBOX%.rpd

	echo ***************************************************************************************************************	
	echo 04. Generating Metadata Dictionary
	
	rem set required Oracle variables based on bi_init.bat file before running Admin Tool
	set ORACLE_HOME=C:\Program Files\Oracle Business Intelligence Enterprise Edition Plus Client\oraclebi\orahome
	set ORACLE_INSTANCE=C:\Program Files\Oracle Business Intelligence Enterprise Edition Plus Client\oraclebi\orainst
	set ORACLE_BI_APPLICATION=coreapplication
	set COMPONENT_NAME=coreapplication
	set PATH=%ORACLE_HOME%\bifoundation\server\bin;%ORACLE_HOME%\bifoundation\web\bin;%ORACLE_HOME%\bin;C:\Program Files\Oracle Business Intelligence Enterprise Edition Plus Client\jre\bin;%windir%;%windir%\system32;%PATH%
		
	cd %REL_DIR%\%REL_NUM%
	%BI_TOOLS_DIR%\admintool.exe /command %REL_DIR%\%REL_NUM%\DataDictionary.scr

	cd %REL_DIR%\%REL_NUM%
	%ZIP_BASE%\7z.exe a -tzip %REL_DIR%\%REL_NUM%\%RPD_NAME_OUT%.zip %REL_DIR%\%REL_NUM%\%RPD_NAME_OUT% > 7z.log
	xcopy %REL_DIR%\%REL_NUM%\%RPD_NAME_OUT%.zip %REL_DIR%\%REL_NUM%\%RPD_NAME_SANDBOX%.zip /Y
	
	echo ***************************************************************************************************************	
	echo 05. Uploading release files to target host.
	cd %REL_DIR%\%REL_NUM%\
	%PUTTY_BASE%\psftp.exe %SSH_USER%@%TGT_HOST% -pw %SSH_PASS% -b psftp_inp.scr -bc -be

	echo ***************************************************************************************************************	
	echo 06. Executing generated release.sh script on target
	REM process uploaded files
	echo Execute release script under privileged account(oracle): /home/oralce/OBIEErelease.sh
	pause
	%PUTTY_BASE%\putty.exe -ssh %SSH_USER%@%TGT_HOST% -pw %SSH_PASS%

	echo ***************************************************************************************************************	
	echo 07. Copying files to Sandbox
	REM Move files to SANDBOX
	REM %SANDBOX_REL_DIR%
	cd %REL_DIR%\%REL_NUM%
	xcopy %RPD_NAME_SANDBOX%.rpd %SANDBOX_REL_DIR% /Y
	xcopy %RPD_NAME_SANDBOX%.zip %SANDBOX_REL_DIR% /Y
	xcopy %CATALOG_NAME_TAR%.tar %SANDBOX_REL_DIR% /Y
	xcopy release.cmd %SANDBOX_REL_DIR% /Y
	echo run %SANDBOX_REL_DIR%\release.cmd on Sandbox
	REM NET START BI Server
	REM sc \\server stop service

	REM cleanup tasts - delete input files, temp release files etd

	echo ***************************************************************************************************************
	echo * Finished execution for Release %OPTION1%. %date% %time%	
	echo ***************************************************************************************************************	
	Goto End

:End
	Pause