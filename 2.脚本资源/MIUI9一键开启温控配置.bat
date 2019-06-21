@echo off
title MIUI9一键开启温控配置 By MIUI论坛-浅蓝的灯
color 8f
mode con lines=30 cols=68

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
goto start

REM ___________________________以上是请求管理员身份____________________

:start
Rem 删除临时文件
del %TempFile_Name% 1>nul 2>nul
CLS
color 3f
mode con lines=32 cols=85
goto server

:server
cd /d %~dp0
ECHO. ==============================================================
ECHO. 首先我们需要重启adb服务
ECHO.
ECHO. 请退出手机助手类软件，然后按任意键继续
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
netstat -ano |findstr "5037"
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
echo.
adb kill-server
adb start-server
ping 127.0.0.1 /n 3 >nul
cls
ECHO.
ECHO  ==============================================================
ECHO.
echo 重启服务完毕，请确保下方设备列表中有你的设备。按任意键继续……
ECHO.
ECHO  ==============================================================
ECHO.
echo 设备列表：
adb devices
echo.
PAUSE >nul
cls
color 3f
echo.
echo.
echo ====================命令执行结果==================
echo.
adb shell am broadcast --user 0 -a update_profile com.miui.powerkeeper/com.miui.powerkeeper.cloudcontrol.CloudUpdateReceiver
echo.
echo ==================================================
echo.
echo.
echo 如果看见 Broadcast completed: result=0 字样即为成功。
echo.
echo 然后建议回到手机无障碍内开启 perfdump (没有可忽略)
echo.
echo 按下任意键退出
pause>nul
