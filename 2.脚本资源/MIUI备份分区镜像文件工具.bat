@echo off
title MIUI备份分区镜像文件工具  by MIUI论坛_浅蓝的灯
color 8f
mode con lines=20 cols=50
REM ________________________________________________________________

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

if '%errorlevel%' NEQ '0' (
    echo.
    echo    请求管理员权限...

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
mode con lines=42 cols=78
cd /d %~dp0

:menu
cls
ECHO. ==============================================================
ECHO. MIUI备份分区镜像文件工具  by MIUI论坛_浅蓝的灯
ECHO.
ECHO. 手机需开启USB调试并与电脑连接，电脑需正确安装好adb驱动
ECHO.
echo  尽量关闭所有助手类软件(建议在任务管理器结束进程)
ECHO.
echo  本次操作可能需要root，因机型而异
echo.
echo.
echo  ----------------------请选择(序号)----------------------------
echo.
echo            1.重启adb服务(建议先执行)
echo            2.直接开始备份
echo            3.退出
echo. 
ECHO. ==============================================================
ECHO.
set input=
set /p input= 选择:
echo.
IF /I "%input%"=="1" GOTO restart
IF /I "%input%"=="2" GOTO begin
IF /I "%input%"=="3" exit
cls
color cf
echo.
echo.
echo 选择无效，请重新输入
echo.
ping 127.0.0.1 /n 3 >nul
goto menu

:restart
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
taskkill /f /im adb.exe
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
goto menu

:begin
cls
echo.
echo 现在开始读取手机分区列表
echo.
adb shell "ls -al /dev/block/platform/*/*/by-name > /sdcard/list.txt
echo.
adb pull /sdcard/list.txt ./
echo.
echo 如果不出意外，分区信息已保存为 %~dp0list.txt & start %~dp0list.txt
echo.
echo 说明:
echo 例如 system -^> /dev/block/sde43 ,说明 system 分区在分区表中 名为 sde43
echo 因此，如果要备份system，需要输入的应为 sde43，而不是system
echo.
echo Tip:在文本文档里边打开的分区信息较乱，可以使用 Ctrl+F 进行搜索~
echo.
pause

:RETURN
cls
ECHO.
ECHO  请在下方输入需要备份的分区名，例如：nameblk0p7或sde43
ECHO  然后设置输出文件名(不含.img)，如：system 然后回车继续
ECHO.
set name=
set /p name= 分区序号名:
echo.
set outname=
set /p outname= 输出文件名:
ECHO. 
ECHO  ==============================================================
ECHO    开始从手机复制分区二进制数据到 /sdcard
echo.
echo    在分隔符下方是否看见 类似 如下提示,
echo.
echo    1024+0 records in
echo    1024+0 records out
echo    4194304 bytes transferred in 0.218 secs ^<19239926 bytes/sec^>
echo. 
echo    如果看到以上提示，证明复制成功，按任意键继续。
echo. 
echo    如果看到 Permission denied 则是权限不足，请确保手机已经root
echo.
ECHO ===============================================================
echo.

:rootif
color 3f
set input1=
set /p input1=您的手机是否root？(y/n):
IF /I "%input1%"=="y" GOTO 1
IF /I "%input1%"=="Y" GOTO 1
IF /I "%input1%"=="n" GOTO 2
IF /I "%input1%"=="N" GOTO 2
color cf
echo.
echo 选择无效，请重新输入
echo.
ping 127.0.0.1 /n 3 >nul
goto rootif

:1
adb shell su -c "dd if=/dev/block/%name% of=/sdcard/%outname%.img bs=4096"
echo.
pause
GOTO save

:2
adb shell "dd if=/dev/block/%name% of=/sdcard/%outname%.img bs=4096" || (
	echo 获取失败，正在尝试无root方法2 & ping 127.0.0.1 /n 2 >nul
	echo.
	adb shell "cat /dev/block/%name% > /sdcard/%outname%.img"||(
		echo.
		echo 仍然失败，建议获取root后重试,按任意键回到root选择页面 & pause>nul
		cls & goto rootif

		)
)
echo.
pause
GOTO save


:save
cls
ECHO. 
echo  下面把分区备份文件保存到 %~dp0
echo.
ECHO. ==============================================================
echo.
echo    在分隔符下方是否看见 类似 如下提示,
echo.
echo    2573 KB/s ^<4194304 bytes in 2.146s^>
echo    或者
echo    [100%] /sdcard/xxx.img
echo    又或者
echo    /sdcard/xxx.img: 1 file pulled. 12.4 MB/s (67108864 bytes in 5.150s)
echo.
echo    如果看到以上提示，证明导出成功，按任意键继续。
echo.
ECHO. ==============================================================
echo.
echo.
adb pull /sdcard/%outname%.img ./
pause >nul
cls
ECHO. ===========================================================
ECHO.
echo 请检查 %~dp0 下否有文件生成，3s后自动返回
ECHO.
ECHO. ===========================================================
ping 127.0.0.1 /n 3 >nul
GOTO menu
