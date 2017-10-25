@echo off
set/p daily=��������־��Ϣ(���ջس��˳�):
if "%daily%"=="" exit
git.exe add -A
git.exe commit -m "%daily%"
git.exe push --progress "origin" master:master
echo.