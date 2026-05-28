@echo off
setlocal EnableExtensions

cd /d "%~dp0"

if not exist .venv-ai\Scripts\python.exe (
    echo [ReadSeek] .venv-ai not found.
    echo [ReadSeek] Please run scripts\setup-bge-m3-ai-env.bat first.
    pause
    exit /b 1
)

REM ============================================================
REM Hugging Face cache path
REM Move model cache from C drive to E drive.
REM ============================================================

if "%READSEEK_MODEL_HOME%"=="" (
    set READSEEK_MODEL_HOME=E:\AIModels\readseek\huggingface
)

set HF_HOME=%READSEEK_MODEL_HOME%
set HF_HUB_CACHE=%READSEEK_MODEL_HOME%\hub
set HF_XET_CACHE=%READSEEK_MODEL_HOME%\xet
set TRANSFORMERS_CACHE=%READSEEK_MODEL_HOME%\transformers

REM ============================================================
REM Download stability settings
REM ============================================================

set HF_HUB_DOWNLOAD_TIMEOUT=300
set HF_HUB_ETAG_TIMEOUT=60
set HF_HUB_DISABLE_SYMLINKS_WARNING=1
set HF_HUB_DISABLE_XET=1
set HF_HUB_VERBOSITY=info

if not exist "%HF_HOME%" mkdir "%HF_HOME%"
if not exist "%HF_HUB_CACHE%" mkdir "%HF_HUB_CACHE%"
if not exist "%HF_XET_CACHE%" mkdir "%HF_XET_CACHE%"
if not exist "%TRANSFORMERS_CACHE%" mkdir "%TRANSFORMERS_CACHE%"

echo [ReadSeek] Model cache: %HF_HOME%
echo [ReadSeek] Hub cache: %HF_HUB_CACHE%
echo [ReadSeek] Starting BGE-M3 AI service on http://127.0.0.1:8001
echo [ReadSeek] Embedding model: BAAI/bge-m3
echo [ReadSeek] Reranker model: BAAI/bge-reranker-v2-m3
echo.

.venv-ai\Scripts\python.exe -u ai-service\server_bge_m3.py --model BAAI/bge-m3 --dimensions 1024 --max-length 512 --reranker-model BAAI/bge-reranker-v2-m3 --reranker-max-length 512

endlocal