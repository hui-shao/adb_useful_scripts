@echo off
title 重启adb服务
mode con lines=30 cols=68
color 8f
REM ________________________________________________________________

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

REM ________________________________________________________________



:A
Rem 删除临时文件
del %TempFile_Name% 1>nul 2>nul
CLS
color 3f
mode con lines=36 cols=80
cd /d %~dp0
ECHO. ==============================================================
ECHO. 重启adb服务
echo.
echo 请务必先退出 手机助手类程序
ECHO.
ECHO. 按任意键继续
ECHO. ==============================================================
ECHO.
PAUSE>NUL
cls
ECHO. ====================================================
ECHO.
ECHO. 正在尝试重启ADB服务~
ECHO.
ECHO. ====================================================
ECHO.
netstat -ano |findstr "5037" > %~dp0plist.txt
start %~dp0plist.txt
echo.
set pid=
set /p pid= 输入LISTENING 后面的数字(没有就空着),然后后回车:
if /i "%pid%"=="" goto T
tasklist|findstr "%pid%"
echo.
taskkill /f /pid %pid%&&goto T||echo.
echo 结束进程失败，请在任务管理器手动结束后按任意键继续……
echo 进程名在“%pid%”的前面,一般为手机助手类&pause >nul

:T
del /f /q %~dp0plist.txt >nul
echo.
taskkill /f /im adb.exe
adb kill-server
adb start-server
ping 127.0.0.1 /n 3 >nul
cls
ECHO.
ECHO  ==============================================================
ECHO.
echo 重启服务完毕，请确保下方设备列表中有你的设备。按任意键继续……
echo.
echo 如果出现：
echo cannot open transport registration socketpair: Invalid argument
echo 请关闭系统自带防火墙（特别是Windows10）
ECHO.
ECHO  ==============================================================
ECHO.
echo 设备列表：
adb devices
echo.
PAUSE >nul
