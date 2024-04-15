@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo Arquivos disponíveis:
dir /b *.txt | findstr /i "ficha"

echo.

set /p "file=Digite o nome do arquivo que deseja verificar: "

echo.

set "totalAttributes=0"
set "totalSkills=0"
set "inAttributes=0"
set "inSkills=0"
set "strength=0"
set "vigor=0"

for /f "tokens=* delims=" %%a in (%file%) do (
    set "line=%%a"

    if "!line:~0,1!"=="[" (
        if "!line!"=="[Atributos]" (
            set "inAttributes=1"
            set "inSkills=0"
        ) else if "!line!"=="[Perícias]" (
            set "inAttributes=0"
            set "inSkills=1"
        )
    ) else if "!line:~0,5!"=="Nome:" (
        echo !line!
    ) else if "!inAttributes!"=="1" (
        for /f "tokens=1,* delims=: " %%b in ("!line!") do (
            if "%%b"=="Força" (
                set /a "strength=%%c"
            ) else if "%%b"=="Vigor" (
                set /a "vigor=%%c"
            )
            set /a "totalAttributes+=%%c"
        )
    ) else if "!inSkills!"=="1" (
        for /f "tokens=1,* delims=: " %%b in ("!line!") do (
            set /a "totalSkills+=%%c"
        )
    )
)

set /a "chromes=(strength + vigor - 2) + 1"
if %chromes% lss 1 (
    set "chromes=1"
)

set /a "inventorySlots=strength * 10"
if %inventorySlots% lss 1 (
    set "inventorySlots=2"
)

echo Total de Atributos: %totalAttributes%
echo Total de Perícias: %totalSkills%
echo Cromos: %chromes%
echo Slots de Inventário: %inventorySlots%

endlocal
pause