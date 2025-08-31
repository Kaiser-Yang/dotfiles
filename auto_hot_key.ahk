; Place this file into
; file://{HOME}/AppData/Roaming/Microsoft/Windows/Start\ Menu/Programs/Startup
; Then this file will be started up when booting.
SetTitleMatchMode 2

CapsLock::Send #{Space}
$^n::Send {Esc}

#IfWinNotActive ahk_class CASCADIA_HOSTING_WINDOW_CLASS
$^a::Send {Home}
$^e::Send {End}
$!f::Send ^f
#IfWinNotActive
#If !(WinActive("ahk_class CASCADIA_HOSTING_WINDOW_CLASS") && WinActive("nv"))
$!z::Send ^z
$!x::Send ^x
$!c::Send ^c
$!v::Send ^v
$!a::Send ^a
#IfWinNotActive
