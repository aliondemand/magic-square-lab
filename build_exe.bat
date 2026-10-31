@echo off
cd /d "%~dp0"
echo Installing PyInstaller...
py -m pip install pyinstaller
echo Building MagicSquare.exe ...
py -m PyInstaller --noconfirm --onefile --windowed --name MagicSquare --icon icon.ico --hidden-import gui.app main.py
if not exist dist\MagicSquare.exe (
    echo BUILD FAILED - copy the error text above and send it to get help.
    pause
    exit /b 1
)
echo Putting a shortcut on your Desktop...
powershell -NoProfile -Command "$s=(New-Object -ComObject WScript.Shell).CreateShortcut([Environment]::GetFolderPath('Desktop')+'\Magic Square.lnk'); $s.TargetPath='%~dp0dist\MagicSquare.exe'; $s.WorkingDirectory='%~dp0dist'; $s.IconLocation='%~dp0icon.ico'; $s.Save()"
echo.
echo Done. App: dist\MagicSquare.exe  (shortcut "Magic Square" is on your Desktop)
pause
