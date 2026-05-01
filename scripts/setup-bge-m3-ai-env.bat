@echo off
setlocal

cd /d "%~dp0\.."

echo [ReadSeek] Checking Python 3.11...
py -3.11 --version
if errorlevel 1 (
    echo [ReadSeek] Python 3.11 is required. Please install Python 3.11 and try again.
    pause
    exit /b 1
)

if exist .venv-ai (
    echo [ReadSeek] .venv-ai already exists, skip creating.
) else (
    echo [ReadSeek] Creating Python 3.11 virtual environment...
    py -3.11 -m venv .venv-ai
)

call .venv-ai\Scripts\activate.bat

echo [ReadSeek] Upgrading pip...
python -m pip install --upgrade pip

echo [ReadSeek] Installing PyTorch CUDA 12.8...
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu128

echo [ReadSeek] Installing BGE-M3 dependencies...
pip install -r ai-service\requirements-bge-m3.txt

echo.
echo [ReadSeek] BGE-M3 AI environment setup completed.
echo [ReadSeek] You can now run start-bge-m3-ai-service.bat
echo.

endlocal
pause
