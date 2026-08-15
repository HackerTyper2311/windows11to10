@echo off
net session >nul 2>&1 || (powershell start-process cmd -ArgumentList '/c "%~f0"' -Verb runAs && exit)
powershell -NoProfile -ExecutionPolicy Bypass -Command "iex (irm 'https://raw.githubusercontent.com/HackerTyper2311/windows11to10/refs/heads/main/gui.ps1')"
