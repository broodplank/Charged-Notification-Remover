@echo off
cd /d %~dp0
move SystemUI.apk SystemUI.zip
7za.exe x -y SystemUI.zip *.dex