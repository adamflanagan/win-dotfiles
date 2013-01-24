# Profile setup for the console host shell
# Will not be loaded by other hosts (e.g. VS11 Package Manager)

# Helper functions for user/computer session management
function Invoke-UserLogout { shutdown /l /t 0 }
function Invoke-SystemShutdown { shutdown /s /t 5 }
function Invoke-SystemReboot { shutdown /r /t 5 }
function Invoke-SystemSleep { RunDll32.exe PowrProf.dll,SetSuspendState }
function Invoke-TerminalLock { RunDll32.exe User32.dll,LockWorkStation }

# Aliases
set-alias logout Invoke-UserLogout
set-alias halt Invoke-SystemShutdown
set-alias restart Invoke-SystemReboot
if (test-path alias:\sleep) { remove-item alias:\sleep -force }
set-alias sleep Invoke-SystemSleep -force
set-alias lock Invoke-TerminalLock