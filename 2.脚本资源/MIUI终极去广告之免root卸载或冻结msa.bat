@echo off
title MIUI终极去广告之免root卸载/冻结 msa By MIUI论坛-浅蓝的灯
color 2f
mode con lines=33 cols=100
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
ECHO. ===================================================================================
ECHO  MIUI 在很多地方加了广告(比如软件启动时，比如作业帮)，有些是可以关闭的，但有些不能。
echo.
echo  关闭不了的广告大部分是msa推送的，因此我们把它删掉or冻结。
echo.
echo  注意：目前(2019.5.11)还没有删除以后卡米现象，不保证以后没有。删掉后不好恢复，请谨慎
ECHO.
ECHO. 首先我们需要重启adb服务
ECHO.
ECHO. 请退出手机助手类软件，然后按任意键继续
ECHO. ===================================================================================
ECHO.
PAUSE>NUL
cls
ECHO. ====================================================
ECHO.
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

:if1
cls
color 3f
ECHO.
ECHO  ==========选择你的MIUI系统类型,输入对应数字并回车=============
ECHO.
echo             1. 国内版本MIUI
echo             2. 国际版本MIUI
ECHO.
ECHO  ==============================================================
ECHO.
set value1=
set /p value1= 选择:
echo.
IF /I "%value1%"=="1" GOTO home
IF /I "%value1%"=="2" GOTO abroad
cls
color cf
echo.
echo.
echo 选择无效，请重新输入
echo.
ping 127.0.0.1 /n 3 >nul
goto if1

:home
cls
color 3f
ECHO.
ECHO  ============选择你要执行的操作,输入对应数字并回车==============
ECHO.
echo             1. 卸载msa (更彻底)
echo             2. 冻结msa (更安全)
echo             3. 解冻msa 
ECHO.
ECHO  ===============================================================
ECHO.
set value2=
set /p value2= 选择:
IF /I "%value2%"=="1" GOTO homeuninstall
IF /I "%value2%"=="2" GOTO homedisable
IF /I "%value2%"=="3" GOTO homeenable
cls
color cf
echo.
echo.
echo 选择无效，请重新输入
echo.
ping 127.0.0.1 /n 3 >nul
goto home

:homeuninstall
cls
color 3f
echo.
echo.
echo ====================命令执行结果====================
echo.
adb shell pm uninstall --user 0 com.miui.systemAdSolution
echo.
echo ====================================================
echo.
echo.
echo 如果看见 Success 字样即为成功。
echo.
echo 然后尽情享受吧~（万能遥控效果明显）
echo.
echo 按下任意键退出
pause>nul
exit

:homedisable
cls
color 3f
echo.
echo.
echo ====================命令执行结果====================
echo.
adb shell pm disable-user --user 0 com.miui.systemAdSolution
echo.
echo ====================================================
echo.
echo.
echo 如果看见 new state: disabled-user 字样即为成功。
echo.
echo 然后尽情享受吧~（万能遥控效果明显）
echo.
echo 按下任意键退出
pause>nul
exit

:homeenable
cls
color 3f
echo.
echo.
echo ====================命令执行结果====================
echo.
adb shell pm enable com.miui.systemAdSolution
echo.
echo ====================================================
echo.
echo.
echo 如果看见 new state: enable 字样即为成功。
echo.
echo 按下任意键退出
pause>nul
exit


:abroad
cls
color 3f
ECHO.
ECHO  ============选择你要执行的操作,输入对应数字并回车==============
ECHO.
echo             1. 卸载msa (更彻底)
echo             2. 冻结msa (更安全)
echo             3. 解冻msa 
ECHO.
ECHO  ===============================================================
ECHO.
set value3=
set /p value3= 选择:
IF /I "%value3%"=="1" GOTO abroaduninstall
IF /I "%value3%"=="2" GOTO abroaddisable
IF /I "%value3%"=="3" GOTO abroadenable
cls
color cf
echo.
echo.
echo 选择无效，请重新输入
echo.
ping 127.0.0.1 /n 3 >nul
goto abroad

:abroaduninstall
cls
color 3f
echo.
echo.
echo ====================命令执行结果====================
echo.
adb shell pm uninstall --user 0 com.miui.msa.global
echo.
echo ====================================================
echo.
echo.
echo 如果看见 Success 字样即为成功。
echo.
echo 然后尽情享受吧~（万能遥控效果明显）
echo.
echo 按下任意键退出
pause>nul
exit

:abroaddisable
cls
color 3f
echo.
echo.
echo ====================命令执行结果====================
echo.
adb shell pm disable-user --user 0 com.miui.msa.global
echo.
echo ====================================================
echo.
echo.
echo 如果看见 new state: disabled-user 字样即为成功。
echo.
echo 然后尽情享受吧~（万能遥控效果明显）
echo.
echo 按下任意键退出
pause>nul
exit

:abroadenable
cls
color 3f
echo.
echo.
echo ====================命令执行结果==================
echo.
adb shell pm enable com.miui.msa.global
echo.
echo ==================================================
echo.
echo.
echo 如果看见 new state: enable 字样即为成功。
echo.
echo 按下任意键退出
pause>nul
exit