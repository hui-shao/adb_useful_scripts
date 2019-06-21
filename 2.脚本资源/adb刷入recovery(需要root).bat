@ECHO OFF
TITLE adb 刷入 recovery 工具
color 3f

:MENU
CLS
ECHO. =================================================
ECHO. 
ECHO. =================================================
ECHO.
ECHO.   你要做什么操作?
ECHO.
ECHO.   1、刷入recovery 【需要ROOT权限】
ECHO.   2、进入recovery模式
ECHO.
ECHO.
ECHO. =================================================
ECHO.

:CHO
set choice=
set /p choice= 选择你要进行的操作:
IF NOT "%Choice%"=="" SET Choice=%Choice:~0,1%
if /i "%choice%"=="1" goto FLASHRECOVERY
if /i "%choice%"=="2" goto RECOVERYEND
echo 选择无效，请重新输入
echo.
goto MENU

:FLASHRECOVERY
CLS
echo.
echo 请在下方输入recovery镜像的文件名。
echo 文件名应含后缀，且不包含通配符。例如：demo.img
set filename=
set /p filename= 输入文件名:
CLS
COLOR E0
ECHO. =================================================
echo.
echo   正在等待你的手机正确连接到电脑
echo.
echo     --请正确安装驱动！
echo.
echo     --先ROOT机器！
echo.
echo     --在手机上开启USB调试【设置-开发人员选项-勾选USB调试】
echo.
echo     --然后将手机通过USB连线连接到电脑
echo     
echo     温馨提示：如果你刷入失败一定是因为第三方软件助手导致
echo.   （如360助手/QQ管家/豌豆荚等），建议它们后再尝试。
ECHO. =================================================
adb.exe wait-for-device >NUL 2>NUL
CLS
COLOR E0
echo ***************************************************************************
echo *                                                                         *
echo *                                                                         *
echo *                   手机正在刷入Recovery......                            *
echo *                   请保持手机通过USB线连接到电脑                         *
echo *                   如果长时间无反应，请关闭此窗口后重试                  *
echo *                                                                         *
echo *                                                                         *
echo ***************************************************************************
adb.exe push %filename% /data/local/tmp/recovery.img
adb.exe push busybox /data/local/tmp/busybox
adb.exe shell chmod 777 /data/local/tmp/busybox
adb shell su -c "/data/local/tmp/busybox mount -o remount,rw /system"
adb shell su -c "rm /system/etc/install-recovery.sh"
adb shell su -c "rm /system/recovery-from-boot.p"
adb.exe shell su -c "/data/local/tmp/busybox dd if=/data/local/tmp/recovery.img of=/dev/block/platform/msm_sdcc.1/by-name/recovery"
adb.exe shell su -c "rm -r /data/local/tmp/recovery.img"
goto RECOVERYEND

:RECOVERYEND
CLS
COLOR E0
echo ***************************************************************************
echo *                                                                         *
echo *                                                                         *
echo *                   手机正在进入recovery模式......                        *
echo *                   请保持手机通过USB线连接到电脑                         *
echo *                   如果长时间无反应，请关闭此窗口后重试                  *
echo *                                                                         *
echo *                                                                         *
echo ***************************************************************************
adb.exe wait-for-device >NUL 2>NUL
adb.exe reboot recovery
pause >nul
CLS

:END
EXIT
