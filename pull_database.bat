@echo off
setlocal

REM Local onde o adb.exe está localizado no seu sistema
set adbPath=D:\Android\Sdk\platform-tools\adb.exe

REM Caminho de origem do arquivo no emulador
set sourcePath=/sdcard/Documents/cryptocurrency_database.db

REM Caminho de destino no seu PC
set destPath=D:\Projects\Zenith

REM Execute o comando adb pull
"%adbPath%" pull "%sourcePath%" "%destPath%"

REM Verifique se o comando foi executado com sucesso
if %errorlevel%==0 (
  echo Arquivo copiado com sucesso.
) else (
  echo Ocorreu um erro durante a cópia do arquivo.
)

endlocal
