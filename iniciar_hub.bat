@echo off
title Skills & MCP Dynamic Hub (Golang)
echo ========================================================
echo    Iniciando Skills & MCP Dynamic Hub (Golang Native)
echo ========================================================
echo.
cd /d "%~dp0"
start "" skills-mcp-hub.exe
timeout /t 1 /nobreak >nul
start http://localhost:54321
exit
