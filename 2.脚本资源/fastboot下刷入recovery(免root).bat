@echo off
TITLE FASTBOOT导入Recovery程序
color 3f
echo.
ECHO. =================================================
echo.
echo     你即将导入的是recovery中文恢复系统
echo.
echo.
echo     --如果不想导入recovery请关闭此窗口！
echo.
echo     --否则按任意键继续
echo.
ECHO. =================================================
pause >nul
cls

echo.
echo 请在下方输入recovery镜像的文件名。
echo 文件名应含后缀，且不包含通配符。例如：demo.img
set filename=
set /p filename= 输入文件名:

CLS
ECHO. =================================================
echo.
echo   按下面所述步骤进入fastboot模式：
echo.
echo.    1.首先你需要安装官方的USB驱动，并关闭手机
echo.
echo.    2.同时按住音量下+开机键开机
echo       按住不放直到显示米兔画面后松手
echo.
echo     3.屏幕会始终停留在米兔LOGO界面
echo.
echo.    4.完成上述步骤，将手机连接到电脑,按任意键继续
echo.
echo     --如果不想导入recovery请关闭此窗口！
echo.
ECHO. =================================================
pause >nul
COLOR CF
CLS
ECHO. =================================================
echo.
echo.
echo    是否看见如下提示：
echo.
echo.
echo         xxxxxx fastboot
echo.
echo.
echo    如果看到以上提示，证明手机与电脑连接正常，按任意键正式开始导入
echo.
echo    否则请关闭此窗口，并检查驱动是否正确安装，手机是否正确连接
echo.
echo    导入recovery时，请一定保证手机和电脑的连接正常
echo.
ECHO. =================================================
echo.
echo.
fastboot.exe devices
pause >nul
CLS
ECHO. =================================================
echo.
echo.
echo    是否看见 类似 如下提示
echo.
echo.
echo.   sending 'recovery' (13526 KB)...
echo.   OKAY [  0.840s]	
echo.   writing 'recovery'...
echo.   OKAY [  1.615s]
echo.   finished. total time: 2.455s
echo.
echo    如果看到以上提示，按任意键正式开始导入
ECHO. =================================================
echo.
echo.
fastboot.exe flash recovery %filename%
pause >nul
CLS
ECHO. =================================================
echo.
echo.
echo    是否看见 类似 如下提示,
echo.
echo.   downloading 'boot.img'...
echo.   OKAY [  0.838s]
echo.   booting...
echo.   OKAY [  0.025s]
echo.   finished. total time: 0.864s
echo.
echo    如果看到以上提示，证明导入成功，按任意键重启
echo.
echo    此时千万不要关闭此窗口
echo.
echo.
ECHO. =================================================
echo.
echo.
fastboot.exe boot %filename%
pause >nul
CLS
ECHO. =================================================
echo.
echo.
echo    恭喜你成功导入了recovery！！
echo.
echo    耐心稍等片刻，手机会自动重启，按任意键关闭此窗口
echo.
echo.
ECHO. =================================================
echo.
echo.
pause >nul
