@echo off
rem ** Save this file in Shift_JIS encoding (Japanese-language version) **
cd /d %~dp0

echo ** このバッチファイルの説明 **
echo ComfyUI Manager をインストールします．
echo.
echo ComfyUI のインストールが完了している必要があります（ポータブル版は不可）．
echo この後、画面の表示が消去されますが正常な動作です．
echo.

if not exist ".\ComfyUI\custom_nodes\" (
  call :ErrorExit ".\ComfyUI\custom_nodes\ のフォルダが存在しないので、バッチファイルの実行を中止します．"
)

if exist ".\ComfyUI\custom_nodes\ComfyUI-Manager\" (
  call :ErrorExit ".\ComfyUI\custom_nodes\ComfyUI-Manager\ のフォルダが存在するので、バッチファイルの実行を中止します．"
)

if not exist ".\ComfyUI\venv\Scripts\activate.bat" (
  call :ErrorExit ".\ComfyUI\venv\Scripts\activate.bat のファイルが存在しないので、バッチファイルの実行を中止します．"
)

cd .\ComfyUI
pause
echo.

call .\venv\Scripts\activate.bat
if not defined VIRTUAL_ENV (
  echo.
  call :ErrorExit "仮想環境の有効化に失敗したので、バッチファイルの実行を中止します．"
)

echo.
echo ** message **
echo 仮想環境が有効化されました．
echo.

echo ** ComfyUI Manager のダウンロード **
cd .\custom_nodes
@echo on
git clone https://github.com/Comfy-Org/ComfyUI-Manager
@echo off
echo.

echo ** message **
echo エラーが出ている場合は内容を確認して、バッチファイルの実行を中止してください．
echo 次に、必要なパッケージのインストールを行います．
echo.
pause

echo.
echo ** パッケージのインストール **
@echo on
pip install -r .\ComfyUI-Manager\requirements.txt
@echo off
echo.

echo ** message **
echo ComfyUI Manager のインストール処理が終わりました．
echo.
echo バッチファイルの実行を終了します．
echo エラーが出ている場合は内容を確認してください．
echo.
pause

goto :EOF

:ErrorExit
echo ** ERROR **
echo %~1
if not "%~2"=="" echo %~2
echo.
pause

exit
