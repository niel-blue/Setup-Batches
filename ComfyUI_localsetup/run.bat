@echo off
chcp 65001 > NUL

:: Python version
set PY_VERSION=3.10.11
set PY_MINOR=310

:: Repository
set REPO_URL=https://github.com/Comfy-Org/ComfyUI.git
set APP_DIR=ComfyUI

:: Internal variables
set TOOLS=%~dp0dev_tools
set USERPROFILE=%TOOLS%
set PS=PowerShell -ExecutionPolicy Bypass
set PYTHONPATH=%TOOLS%\python;
set PY="%TOOLS%\python\python.exe"
set PIP_CACHE_DIR=%TOOLS%\pip
set FFMPEG_PATH=%TOOLS%\ffmpeg\bin

:: PATH
set PATH=%TOOLS%\PortableGit\bin;%TOOLS%\python;%TOOLS%\python\Scripts;%FFMPEG_PATH%;%PATH%

:: URL
set PY_URL=https://www.nuget.org/api/v2/package/python/%PY_VERSION%
set GIT_URL=https://github.com/git-for-windows/git/releases/download/v2.44.0.windows.1/PortableGit-2.44.0-64-bit.7z.exe
set FFMPEG_URL=https://github.com/GyanD/codexffmpeg/releases/download/7.0/ffmpeg-7.0-essentials_build.zip


echo.
echo  ==================================================
echo  %APP_DIR%
echo  Python %PY_VERSION% / CUDA 12.9
echo  ==================================================
echo.


cd /d "%~dp0%APP_DIR%"
python.exe -s main.py --windows-standalone-build --fast fp16_accumulation


pause
exit