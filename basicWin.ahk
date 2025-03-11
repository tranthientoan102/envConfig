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
;Delete::Pause

;---------------------------


CapsLock::
    if toggle := !toggle
        SplashImage,,% "X" A_ScreenWidth/2 " Y50 B0 FM20 CTFFFFFF CW000000",, hit capslock - FN:ON
    else
        SplashImage, off
        Loop, 0xFF
        ; release all key
        IF GetKeyState(Key:=Format("VK{:X}",A_Index))
            SendInput, {%Key% up}
return

#if toggle
Esc::`
+Esc::Send ~
1::Send {F1}
2::Send {F2}
3::Send {F3}
4::Send {F4}
5::Send {F5}
6::Send {F6}
7::Send {F7}
8::Send {F8}
9::Send {F9}
0::Send {F10}
-::Send {F11}
=::Send {F12}

#if


;-------------------------------



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
;------------------------------------
;------------------------------------



; Define hotkey Alt + `
; Alt + ` (backtick) will trigger the menu
!`::
{
    Menu, SubMenuU, Add, Email, SendUser
    Menu, SubMenuU, Add, StaffID, SendStaffID 

    Menu, SubMenuP, Add, Stafflink, SendPassword
    Menu, SubMenuP, Add, GitHealth, SendGitHealthToken

    Menu, SubMenuCombo, Add, Login, SendUPLogin
    Menu, SubMenuCombo, Add, Login with Enter, SendUPLogin_enter



    Menu, MyMenu, Add, U, :SubMenuU   ; Add 'u' as a main menu item
    Menu, MyMenu, Add, P, :SubMenuP   ; Add 'p' as a main menu item;
    Menu, MyMenu, Add
    Menu, MyMenu, Add, Combo, :SubMenuCombo

    Menu, MyMenu, Show

    Send {LAlt up}
    Send {LAlt up}
    Send {LAlt up}

}




SendUser(){
    Send thientoan.tran@health.nsw.gov.au
}

SendStaffID(){
    Send 60345241
}



SendUPLogin(){
    SendStaffID()
    Send {Tab}
    SendPassword()
    Send {Enter}

}

SendUPLogin_enter(){
    SendStaffID()
    Send {Enter}
    Sleep, 1000
    SendPassword()
    Send {Enter}

}
