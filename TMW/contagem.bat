@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: Exibe uma lista de arquivos disponíveis
echo Arquivos disponíveis:
dir /b *.txt | findstr /i "ficha"
echo.

:: Solicita ao usuário o nome do personagem
echo Por favor, digite o nome do personagem:
set /p "file=Nome do personagem: "
set "file=ficha_%file%.txt"
echo.

:: Solicita ao usuário o nível do personagem
echo Por favor, digite o nível do personagem:
set /p "level=Nível do personagem: "
echo.

:: Inicializa as variáveis
set "totalAttributes=0"
set "totalSkills=0"
set "inAttributes=0"
set "inSkills=0"
set "strength=0"
set "vigor=0"
set "intelligence=0"
set "arts=0"

:: Limpa a tela
cls

:: Processa o arquivo de personagem
for /f "tokens=* delims=" %%a in (%file%) do (
    set "line=%%a"

    :: Verifica se a linha é um cabeçalho de seção
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
        :: Processa a seção de atributos
        for /f "tokens=1,* delims=: " %%b in ("!line!") do (
            if "%%b"=="Força" (
                set /a "strength=%%c"
            ) else if "%%b"=="Vigor" (
                set /a "vigor=%%c"
            ) else if "%%b"=="Inteligência" (
                set /a "intelligence=%%c"
            )
            set /a "totalAttributes+=%%c"
        )
    ) else if "!inSkills!"=="1" (
        :: Processa a seção de habilidades
        for /f "tokens=1,* delims=: " %%b in ("!line!") do (
            if "%%b"=="Magia-Arcana" (
                set /a "arts=%%c"
            )
            set /a "totalSkills+=%%c"
        )
    )
)

:: Calcula os cromos, slots de inventário e pontos de artes
set /a "chromes=(strength + vigor - 2) + 1"
if %chromes% lss 1 (
    set "chromes=1"
)
set /a "inventorySlots=strength * 5"
if %inventorySlots% lss 1 (
    set "inventorySlots=2"
)
set /a "arts_points=arts * 5"

:: Calcula os pontos de habilidade corretos
set /a "correctSkillPoints=3*%level% + (intelligence * 2)*6"
set /a "difference=totalSkills - correctSkillPoints"

:: Exibe os resultados
echo Total de Atributos: %totalAttributes%
echo Total de Perícias: %totalSkills%
echo.
echo Cromos: %chromes%
echo Slots de Inventário: %inventorySlots%
echo Pontos de Artes: %arts_points%
echo.
echo Pontos de Perícia Necessários: %correctSkillPoints%
if %difference% lss 0 (
    echo Você tem !difference! pontos de perícia a menos do que o correto.
) else if %difference% gtr 0 (
    echo Você tem !difference! pontos de perícia a mais do que o correto.
) else (
    echo Você tem a quantidade correta de pontos de perícia.
)
echo.

endlocal
pause