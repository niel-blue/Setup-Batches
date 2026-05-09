@echo off
rem ** Save this file in Shift_JIS encoding (Japanese-language version) **
cd /d %~dp0

echo ** このバッチファイルの説明 **
echo ComfyUI をインストールします．
echo.
echo Git と Python が実行できるようになっている必要があります（チェックは行いません）．
echo PyTorch は 【Stable版（CUDA 13.0）】をインストールします．
echo.

if exist ".\ComfyUI\" (
  call :ErrorExit ".\ComfyUI\ のフォルダが存在するので、バッチファイルの実行を中止します．" "フォルダのリネームまたは削除を行ってください．"
)

echo ** message **
echo はじめに、ComfyUI のダウンロードを行います．
echo.
pause
echo.

echo ** ComfyUI のダウンロード **
@echo on
git clone https://github.com/comfyanonymous/ComfyUI
@echo off
echo.

echo ** message **
echo エラーが出ている場合は内容を確認して、バッチファイルの実行を中止してください．
echo.
echo ** message **
echo 次に、PyTorch のインストールを行います（少しかかります）．
echo この後、画面の表示が消去されますが正常な動作です．
echo.

cd .\ComfyUI
pause
echo.

echo ** 仮想環境の準備 **
@echo on
python -m venv .\venv
@echo off
call .\venv\Scripts\activate.bat
if not defined VIRTUAL_ENV (
  echo.
  call :ErrorExit "仮想環境の有効化に失敗したので、バッチファイルの実行を中止します．"
)

echo.
echo ** message **
echo 仮想環境が有効化されました．
@echo on
python -m pip install --upgrade pip
@echo off
echo.

echo ** PyTorch のインストール **
@echo on
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu130
@echo off
echo.

echo ** message **
echo エラーが出ている場合は内容を確認して、バッチファイルの実行を中止してください．
echo 次に、必要なパッケージのインストールを行います（少しかかります）．
echo.
pause
echo.

echo ** パッケージのインストール **
@echo on
pip install -r requirements.txt
@echo off
echo.

echo ** message **
echo ComfyUI のインストール処理が終わりました．
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
