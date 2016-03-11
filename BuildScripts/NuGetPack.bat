@echo off
pushd ".."

set NUGET=".nuget\NuGet.exe"
set PACKAGEDIR="bin\NuGetPackages"

echo:
echo:Packing NuGet packages into %PACKAGEDIR% . . .

if exist %PACKAGEDIR% rd /s /q %PACKAGEDIR%
md %PACKAGEDIR% 

echo:
call :ParseVersion "Properties\AssemblyInfo.cs"
echo:DryIoc v%VER%
echo:================
%NUGET% pack "NuGet\SDL2-CS.nuspec" -Version %VER% -OutputDirectory %PACKAGEDIR% -NonInteractive
%NUGET% pack "NuGet\SDL2-CS.dll.nuspec" -Version %VER% -OutputDirectory %PACKAGEDIR% -NonInteractive -Symbols

echo: 
echo:Packaging succeeded.
popd

if not "%1"=="-nopause" pause 
goto:eof

:ParseVersion
set VERFILE=%~1
for /f "usebackq tokens=2,3 delims=:() " %%A in ("%VERFILE%") do (
	if "%%A"=="AssemblyInformationalVersion" set VER=%%~B
)
exit /b