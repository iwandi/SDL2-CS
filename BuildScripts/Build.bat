@echo off
setlocal EnableDelayedExpansion

set SLN="..\SDL2-CS.sln"
set OUTDIR="bin\Release"

set MSBUILDVER=%2
if "%MSBUILDVER%"=="" set MSBUILDVER=14
echo:MsBuild version: %MSBUILDVER%

echo:
echo:Building %SLN% into %OUTDIR% . . .

for /f "tokens=2*" %%S in ('reg query HKLM\SOFTWARE\Wow6432Node\Microsoft\MSBuild\ToolsVersions\%MSBUILDVER%.0 /v MSBuildToolsPath') do (

	if exist "%%T" (

		echo:
		echo:Using MSBuild from "%%T"

		"%%T\MSBuild.exe" %SLN% /t:Rebuild /v:minimal /m /fl /flp:LogFile=MSBuild.log ^
   			/p:OutDir=%OUTDIR% ^
   			/p:GenerateProjectSpecificOutputFolder=false ^
   			/p:Configuration=Release ^ 
   			/p:RestorePackages=false ^ 
			/p:BuildInParallel=true 

		find /C "Build succeeded." MSBuild.log
    )
)

endlocal
if not "%1"=="-nopause" pause