@echo off
title SYMBIONT - Local AI Orchestration & Tooling Fabric
echo ========================================================
echo    Iniciando SYMBIONT (Golang Native Standalone)
echo ========================================================
echo.
cd /d "%~dp0"
start "" skills-mcp-hub.exe
timeout /t 1 /nobreak >nul
start http://127.0.0.1:54321
exit

