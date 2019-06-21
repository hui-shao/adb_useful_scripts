@echo off
title MIUI冻结系统更新(需要root) By MIUI论坛-浅蓝的灯
color 8f
mode con lines=30 cols=68
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
cd /d %~dp0
ECHO. ==============================================================
ECHO  有些米粉不太喜欢更新系统，但是看见推送总觉得不舒服
echo.
echo  因为卸载系统更新会卡米，我们可以试试把他冻结(需要root)
echo.
ECHO. ==============================================================
ECHO.
PAUSE

:if1
cls
color 3f
ECHO.
ECHO  ==========选择你的要进行的操作,输入对应数字并回车=============
ECHO.
echo             1. 重启adb服务(推荐先执行)
echo             2. 冻结(需要root)
echo             3. 解冻
echo             4. 退出
ECHO.
ECHO  ==============================================================
ECHO.
set value1=
set /p value1= 选择:
echo.
IF /I "%value1%"=="1" GOTO restart
IF /I "%value1%"=="2" GOTO hide
IF /I "%value1%"=="3" GOTO unhide
IF /I "%value1%"=="4" exit
cls
color cf
echo.
echo.
echo 选择无效，请重新输入
echo.
ping 127.0.0.1 /n 3 >nul
goto if1

:restart
cls
ECHO. ====================================================
echo.
ECHO  我们即将重启adb服务
ECHO.
ECHO. 请退出手机助手类软件，然后按任意键继续
echo.
ECHO ====================================================
pause>nul

cls
echo.
echo ====================================================
echo.
ECHO. 正在尝试重启ADB服务~
ECHO.
ECHO. ====================================================
ECHO.
echo.
adb kill-server
ping 127.0.0.1 /n 2 >nul
adb start-server
cls
ECHO.
ECHO  ==============================================================
ECHO.
echo  重启服务完毕，请确保下方设备列表中有你的设备。按任意键继续……
ECHO.
ECHO  ==============================================================
ECHO.
echo 设备列表：
adb devices
echo.
PAUSE >nul
goto if1


:hide
cls
color 3f
echo.
echo.
echo ====================命令执行结果==================
echo.
adb root
adb shell pm hide com.android.updater
echo.
echo ==================================================
echo.
echo.
echo 如果看见 “hidden state: true” 字样即为成功。
echo.
echo 然后尽情享受吧~
echo.
echo 按下任意键返回
pause>nul
goto if1

:unhide
cls
color 3f
echo.
echo.
echo ====================命令执行结果==================
echo.
adb shell pm unhide com.android.updater
echo.
echo ==================================================
echo.
echo.
echo 如果看见 “hidden state: false” 字样即为成功。
echo.
echo 然后尽情享受吧~
echo.
echo 按下任意键返回
pause>nul
goto if1