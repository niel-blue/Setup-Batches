@echo off
chcp 65001 > NUL

:: Repository
set REPO_URL=https://github.com/Aratako/Irodori-TTS.git
set APP_DIR=Irodori-TTS

:: Version
set PY_VERSION=3.10.11
set PY_MINOR=310

:: Internal variables
set TOOLS=%~dp0dev_tools
set USERPROFILE=%TOOLS%
set PS=PowerShell -ExecutionPolicy Bypass
set PATH=%TOOLS%\PortableGit\bin;%TOOLS%\python;%TOOLS%\python\Scripts;%PATH%
set PYTHONPATH=%TOOLS%\python;
set PY="%TOOLS%\python\python.exe"
set PIP_CACHE_DIR=%TOOLS%\pip
set UV_CACHE_DIR=%TOOLS%\uv

:: URL
set PY_URL=https://www.python.org/ftp/python/%PY_VERSION%/python-%PY_VERSION%-embed-amd64.zip
set GIT_URL=https://github.com/git-for-windows/git/releases/download/v2.44.0.windows.1/PortableGit-2.44.0-64-bit.7z.exe


echo.
echo  ==================================================
echo  Portable Installer : %APP_DIR%
echo  Python %PY_VERSION% / CUDA
echo  ==================================================
echo.

:: STEP 1 : Python
if exist "%TOOLS%\python" goto :DLGit

echo [STEP 1] Downloading Python %PY_VERSION% ...
echo.

%PS% -Command "Invoke-WebRequest -Uri '%PY_URL%' -OutFile 'python.zip'"
%PS% -Command "Expand-Archive -Path 'python.zip' -DestinationPath '%TOOLS%\python'"
del python.zip

(
  echo python%PY_MINOR%.zip
  echo .
  echo.
  echo # Uncomment to run site.main^(^) automatically
  echo import site
) > "%TOOLS%\python\python%PY_MINOR%._pth"

%PS% -Command "Invoke-WebRequest -Uri 'https://bootstrap.pypa.io/get-pip.py' -OutFile '%TOOLS%\python\get-pip.py'"
%PY% "%TOOLS%\python\get-pip.py" --no-warn-script-location
del "%TOOLS%\python\get-pip.py"

%PY% -m pip install uv --no-warn-script-location

echo.
echo [STEP 1] Done.
echo.

:: STEP 2 : PortableGit
:DLGit
if exist "%TOOLS%\PortableGit" goto :Gitclone

echo [STEP 2] Downloading PortableGit ...
%PS% -Command "Invoke-WebRequest -Uri '%GIT_URL%' -OutFile %TOOLS%\Git.exe"
%TOOLS%\Git.exe -y
del %TOOLS%\Git.exe
rmdir /s /q Microsoft

echo.
echo [STEP 2] Done.


:: STEP 3 : Git clone
:Gitclone

echo [STEP 3] Cloning %REPO_URL% ...
echo.

git lfs install
git config --global advice.detachedHead false
git clone "%REPO_URL%" "%APP_DIR%"

echo.
echo [STEP 3] Done.


echo [STEP 4] Installing packages ...
echo.

cd "%APP_DIR%"

uv sync --python "%PY%"

echo.
echo [STEP 4] Done.
echo.
echo.
echo  セットアップは無事終了しました。
echo.
echo  　■ボイスデザインを行う場合
echo  　→　run_VoiceDesign.bat
echo.
echo  　■作成したボイスを元にテキストから音声を作成する場合
echo  　→　run_webui.bat
echo.
pause
exit
