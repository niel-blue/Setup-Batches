@echo off
chcp 65001 > NUL

:: Python version
set PY_VERSION=3.10.11
set PY_MINOR=310

:: Repository
set REPO_URL=https://github.com/pq-yang/MatAnyone2
set APP_DIR=MatAnyone2

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


echo Launching %APP_DIR% ...
echo.

start http://127.0.0.1:7860

cd "%APP_DIR%"
call venv\Scripts\activate.bat

python hugging_face\app.py %*

echo.
echo.
pause
exit
