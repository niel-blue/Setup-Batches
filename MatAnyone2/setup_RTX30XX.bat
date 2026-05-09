@echo off
chcp 65001 > NUL

:: Version
set PY_VERSION=3.10.11
set PY_MINOR=310
set CUDA_VERSION=c121

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

:: URL
set PY_URL=https://www.nuget.org/api/v2/package/python/%PY_VERSION%
set GIT_URL=https://github.com/git-for-windows/git/releases/download/v2.44.0.windows.1/PortableGit-2.44.0-64-bit.7z.exe
set FFMPEG_URL=https://github.com/GyanD/codexffmpeg/releases/download/7.0/ffmpeg-7.0-essentials_build.zip


echo.
echo  ==================================================
echo  Portable Installer : %APP_DIR%
echo  Python %PY_VERSION% / CUDA
echo  ==================================================
echo.



:: STEP 1 : Python
if exist "%TOOLS%\python" goto :DLGit

echo [STEP 1] Downloading Full Python %PY_VERSION% ...
echo.

%PS% -Command "Invoke-WebRequest -Uri '%PY_URL%' -OutFile 'python_full.zip'"
if exist "%TOOLS%\python" rd /s /q "%TOOLS%\python"
%PS% -Command "Expand-Archive -Path 'python_full.zip' -DestinationPath '%TOOLS%\python' -Force"

xcopy "%TOOLS%\python\tools\*.*" "%TOOLS%\python\" /E /I /Y > NUL
rd /s /q "%TOOLS%\python\tools"
rd /s /q "%TOOLS%\python\_rels"
rd /s /q "%TOOLS%\python\package"
del "%TOOLS%\python\[Content_Types].xml"
del "%TOOLS%\python\python.nuspec"
del python_full.zip

%PY% -m ensurepip --upgrade --default-pip
%PY% -m pip install --upgrade pip setuptools wheel --no-warn-script-location
%PY% -m pip install uv --no-warn-script-location

echo [STEP 1] Downloading FFmpeg ...

%PS% -Command "Invoke-WebRequest -Uri '%FFMPEG_URL%' -OutFile 'ffmpeg.zip'"
%PS% -Command "Expand-Archive -Path 'ffmpeg.zip' -DestinationPath '%TOOLS%\temp_ffmpeg' -Force"
for /d %%i in ("%TOOLS%\temp_ffmpeg\ffmpeg-*") do move "%%i" "%TOOLS%\ffmpeg"
rd /s /q "%TOOLS%\temp_ffmpeg"
del ffmpeg.zip
rmdir /s /q Microsoft

echo.
echo [STEP 1] Done.
echo.



:: STEP 2 : PortableGit
:DLGit
if exist "%TOOLS%\PortableGit" goto :Gitclone

echo [STEP 2] Downloading PortableGit ...
echo.

%PS% -Command "Invoke-WebRequest -Uri '%GIT_URL%' -OutFile %TOOLS%\Git.exe"
%TOOLS%\Git.exe -y
del %TOOLS%\Git.exe

echo.
echo [STEP 2] Done.
echo.



:: STEP 3 : Git clone
:Gitclone
echo [STEP 3] Cloning %REPO_URL% ...
echo.

git lfs install
git config --global advice.detachedHead false
git clone "%REPO_URL%" "%APP_DIR%"

echo.
echo [STEP 3] Done.
echo.



:: STEP 4 : Installing packages
echo [STEP 4] Installing packages ...
echo.

cd "%APP_DIR%"
%PY% -m venv venv
call venv\Scripts\activate.bat

python -m pip install --upgrade pip setuptools wheel

pip install -e .
pip3 install -r hugging_face/requirements.txt

pip uninstall -y torch torchvision torchaudio
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/%CUDA_VERSION%

echo.
echo [STEP 4] Done.
echo.



:: STEP 5 : Launch Application
echo [STEP 5] Launching %APP_DIR% ...
echo.

start http://127.0.0.1:7860

python hugging_face\app.py %*


echo.
echo.
pause
exit
