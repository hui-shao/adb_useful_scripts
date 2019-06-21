@echo off
color 8f
mode con lines=30 cols=68
title 在当前目录打开命令行(As 管理员身份)
REM __________________以下是请求管理员身份_________________________

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

if '%errorlevel%' NEQ '0' (

    echo 请求管理员权限...

    goto UACPrompt

) else ( goto gotAdmin )

:UACPrompt

    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"

    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
exit /B

:gotAdmin

    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"
	goto A

REM ___________________________以上是请求管理员身份_______________________________



:A
Rem 删除临时文件
del %TempFile_Name% 1>nul 2>nul
CLS
Rem 下面这条是打开窗口用的
start cmd.exe|cd /d %~dp0
