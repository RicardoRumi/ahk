#Persistent
#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

global StartTime := A_TickCount
global LastCheck := StartTime
SetTimer, UpdateTooltip, 1000
SetTimer, CheckForWake, 1000
SetTimer, SuspendComputer, 1800000
return

CheckForWake:
    global LastCheck
    global StartTime
    Elapsed := A_TickCount - LastCheck
    LastCheck := A_TickCount ; Update LastCheck to the current time
    if (Elapsed > 30000) { ; More than 1 second has elapsed, indicating a wake-up
        PerformWakeRoutine()
    }
return

PerformWakeRoutine() {
    global StartTime
    SoundBeep, 400, 500
    Sleep, 5000
    Send, {F5}
    Sleep, 10000
    MouseClick, left, A_ScreenWidth/2, A_ScreenHeight/2
    Sleep, 5000
    Send, f
    MouseMove, A_ScreenWidth, (A_ScreenHeight/2) + 100, 0
    StartTime := A_TickCount ; Update StartTime with the current tick count for the 30-minute interval
}

UpdateTooltip:
    global StartTime
    global LastCheck
    timeLeft := (1800000 - (A_TickCount - StartTime)) // 60000
    Tooltip, % "Time left: " . timeLeft . "m`nLast Check: " . LastCheck . "`nElapsed: " . Elapsed, A_ScreenWidth-50, 600
return

SuspendComputer:
    global StartTime
    ToolTip ; Clear the tooltip
    StartTime := A_TickCount ; Reset StartTime to the current tick count
    LastCheck := StartTime ; Also reset LastCheck to prevent immediate re-triggering on wake
    DllCall("PowrProf.dll\SetSuspendState", "int", 0, "int", 0, "int", 0)
return
