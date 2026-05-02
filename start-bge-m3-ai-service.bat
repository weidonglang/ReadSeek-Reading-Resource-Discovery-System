@echo off
setlocal

cd /d "%~dp0"

if not exist .venv-ai\Scripts\python.exe (
    echo [ReadSeek] .venv-ai not found.
    echo [ReadSeek] Please run scripts\setup-bge-m3-ai-env.bat first.
    pause
    exit /b 1
)

if "%READSEEK_MODEL_HOME%"=="" (
    set READSEEK_MODEL_HOME=%USERPROFILE%\.cache\readseek\huggingface
)

set HF_HOME=%READSEEK_MODEL_HOME%
set TRANSFORMERS_CACHE=%READSEEK_MODEL_HOME%\transformers

echo [ReadSeek] Model cache: %HF_HOME%
echo [ReadSeek] Starting BGE-M3 AI service on http://127.0.0.1:8001
echo [ReadSeek] Reranker model: BAAI/bge-reranker-v2-m3
echo.

.venv-ai\Scripts\python.exe ai-service\server_bge_m3.py --model BAAI/bge-m3 --dimensions 1024 --max-length 512 --reranker-model BAAI/bge-reranker-v2-m3 --reranker-max-length 512

endlocal
