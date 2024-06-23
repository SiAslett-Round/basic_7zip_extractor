@echo off
setlocal enabledelayedexpansion

set "sevenZipPath=C:\Program Files\7-Zip\7z.exe"  REM Set the path to 7-Zip executable
set "rootDir=C:\Your\Root\Directory"  REM Set the root directory where you want to start the operation

echo Script started at:
date /t
time /t

cd /d "%rootDir%"

for /d %%d in (*) do (
    echo Checking folder: %%d
    set "rarFound=0"
    for %%f in ("%%d\*.rar") do (
        if exist "%%f" (
            set "rarFound=1"
            echo Extracting "%%f"...
            "%sevenZipPath%" x "%%f" -o"%%d"
            if !errorlevel! equ 0 (
                echo Extraction successful: "%%f"
                echo Deleting .rar and .rXX files in %%d...
                for %%x in ("%%d\*.rar" "%%d\*.r??") do (
                    echo Deleting "%%x"
                    del /q "%%x"
                )
            ) else (
                echo Failed to extract "%%f".
            )
        )
    )
    if exist "%%d\Sample" (
        echo Deleting Sample folder in %%d...
        rd /s /q "%%d\Sample"
    )
    if !rarFound! equ 0 (
        echo No .rar files found in %%d
    )
)

echo Operation completed at:
date /t
time /t

pause
