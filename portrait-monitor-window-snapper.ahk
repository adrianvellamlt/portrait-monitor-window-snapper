; ^ is ctrl
; # is windows
; ! is alt
; + is shift

ResizeWin(dir = 0)
{
    padding := 7

    activeMonitor := GetMonitor()
    
    SysGet, MonitorWorkArea, MonitorWorkArea, %activeMonitor%
    
    width := (MonitorWorkAreaRight - MonitorWorkAreaLeft) + (padding * 2)
    height := ((MonitorWorkAreaBottom - MonitorWorkAreaTop) / 2)

    MonitorWorkAreaLeft := MonitorWorkAreaLeft - padding

    if (dir == 1) ; bottom
        _top := MonitorWorkAreaBottom - height
    else if (dir == -1) ; top
        _top := MonitorWorkAreaTop
        
    height := height + padding

    if (dir != 0)
        WinMove,A,, %MonitorWorkAreaLeft%, %_top%, %width%, %height%
}

; Source: https://autohotkey.com/board/topic/94735-get-active-monitor/
GetMonitor() {
    WinGetActiveStats, winTitle, winW, winH, winX, winY

	SysGet, numDisplays, MonitorCount
	SysGet, idxPrimary, MonitorPrimary

	Loop %numDisplays%
	{	SysGet, mon, MonitorWorkArea, %a_index%
	; Left may be skewed on Monitors past 1
		if (a_index > 1)
			monLeft -= 10
	; Right overlaps Left on Monitors past 1
		else if (numDisplays > 1)
			monRight -= 10
	; Tracked based on X. Cannot properly sense on Windows "between" monitors
		if (winX >= monLeft && winX < monRight)
			return %a_index%
	}
    ; Return Primary Monitor if can't sense
	return idxPrimary
}

; windows + alt + up = bottom
^#!Up::ResizeWin(-1)
; windows + alt + down = top
^#!Down::ResizeWin(1)