@echo off
cd /d %~dp0
del classes.dex
java -Xmx512M -jar smali-1.3.2.jar dexout/