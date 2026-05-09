chcp 65001 > NUL
@echo off

:: Python version
set PY_VERSION=3.10.11
set PY_MINOR=310

:: Repository
set REPO_URL=https://github.com/Aratako/Irodori-TTS.git
set APP_DIR=Irodori-TTS

:: Internal variables
set TOOLS=%~dp0dev_tools
set USERPROFILE=%TOOLS%

set PS=PowerShell -ExecutionPolicy Bypass
set PATH=%TOOLS%\PortableGit\bin;%TOOLS%\python;%TOOLS%\python\Scripts;%PATH%
set PYTHONPATH=%TOOLS%\python;
set PY="%TOOLS%\python\python.exe"
set PIP_CACHE_DIR=%TOOLS%\pip
set PY_URL=https://www.python.org/ftp/python/%PY_VERSION%/python-%PY_VERSION%-embed-amd64.zip
set GIT_URL=https://github.com/git-for-windows/git/releases/download/v2.44.0.windows.1/PortableGit-2.44.0-64-bit.7z.exe
set GIT_EXE=%TOOLS%\PortableGit-2.44.0-64-bit.7z.exe


echo.
echo Launching %APP_DIR%
echo.


cd %APP_DIR%
start http://127.0.0.1:7860
.venv\Scripts\python.exe gradio_app_voicedesign.py --server-name 0.0.0.0 --server-port 7860

echo.
echo.
pause
exit
