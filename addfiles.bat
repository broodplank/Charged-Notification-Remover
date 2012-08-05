@echo off
cd /d %~dp0
move out.dex classes.dex
7za.exe u SystemUI.zip classes.dex
move SystemUI.zip finished_apks/SystemUI.apk
del classes.dex