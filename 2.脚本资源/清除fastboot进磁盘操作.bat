@ECHO OFF
color 3f
mode con lines=28 cols=64
cd /d %~dp0
ECHO. =====================================================
ECHO. 此操作会清除fastboot，进入深度刷机。表现为手机黑屏无反应，但是不要拔线。
ECHO.
ECHO. 请谨慎操作避免风险！请备份好重要的资料，USB连接电脑后端
ECHO.
ECHO. 另外电脑上如果弹出格式化，一律 取消 
ECHO.
ECHO. 按任意键继续操作或直接关闭窗口终止操作
ECHO. =====================================================
PAUSE>nul
fastboot erase aboot
fastboot reboot
echo 请勿动手机（不要手贱把手机拔下来啊！），接着可以开始重分区操作。
echo 按任意键关闭窗口
PAUSE>nul