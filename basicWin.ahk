#SingleInstance, force
; #: win
; !: alt
; ^: ctrl
; +: shift

; Remap Windows key to Ctrl
; LWin::LCtrl
; RWin::LCtrl

; Remap Alt key to Windows key
; LAlt::LWin
; RAlt::LWin

; Remap Ctrl key to Alt
LCtrl::LAlt
LAlt::LCtrl

;#q::Send {Alt down}{F4 down}{F4 up}{Alt up}
#q:: Send "!{F4}"


PgUp::Home
PgDn::End
Pause::Delete
Delete::Pause





;$F1:: AltTab()
;$F2:: AltTabMenu()
^Tab:: 
    DisplayMenu()
    Send {LCtrl up}


; AltTabMenu-replacement for Windows 8:
DisplayMenu(){
    Send {LCtrl up}
    
    list := ""
    Menu, windows, Add
    Menu, windows, deleteAll
    WinGet, id, list
    Loop, %id%
    {
        this_ID := id%A_Index%
        WinGetTitle, title, ahk_id %this_ID%
        If (title = "")
            continue            
        If (!IsWindow(WinExist("ahk_id" . this_ID))) 
            continue
        Menu, windows, Add, %title%, ActivateTitle      
        WinGet, Path, ProcessPath, ahk_id %this_ID%
        Try 
            Menu, windows, Icon, %title%, %Path%,, 0
        Catch 
            Menu, windows, Icon, %title%, %A_WinDir%\System32\SHELL32.dll, 3, 0 
    }
    CoordMode, Mouse, Screen
    ;MouseMove, (0.4*A_ScreenWidth), (0.35*A_ScreenHeight)
    CoordMode, Menu, Screen
    Xm := (0.4*A_ScreenWidth)
    Ym := (0.4*A_ScreenHeight)
    Menu, windows, Show, %Xm%, %Ym%


}

ActivateTitle:
    SetTitleMatchMode 3
    WinActivate, %A_ThisMenuItem%
return

;-----------------------------------------------------------------
; Check whether the target window is activation target
;-----------------------------------------------------------------
IsWindow(hWnd){
    WinGet, dwStyle, Style, ahk_id %hWnd%
    if ((dwStyle&0x08000000) || !(dwStyle&0x10000000)) {
        return false
    }
    WinGet, dwExStyle, ExStyle, ahk_id %hWnd%
    if (dwExStyle & 0x00000080) {
        return false
    }
    WinGetClass, szClass, ahk_id %hWnd%
    if (szClass = "TApplication") {
        return false
    }
    return true
}




!1:: SendUser()
!2:: SendStaffID()
!`:: SendPassword()


SendUser(){
    Send thientoan.tran@health.nsw.gov.au
    return True
}

SendStaffID(){
    Send 60345241
    return True
}







