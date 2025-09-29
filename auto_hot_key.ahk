; Place this file into
; file://{HOME}/AppData/Roaming/Microsoft/Windows/Start\ Menu/Programs/Startup
; Then this file will be started up when booting.
SetTitleMatchMode 2

CapsLock::Send #{Space}
$^a::Send {Home}
$^e::Send {End}
$^n::Send {Esc}

$!z::Send ^z
$!x::Send ^x
$!y::Send ^y
$!c::Send ^c
$!v::Send ^v
$!a::Send ^a
$!f::Send ^f
$!/::Send ^/

#If WinActive("ahk_class CASCADIA_HOSTING_WINDOW_CLASS")
$^a::Send ^a
$^e::Send ^e
$!f::Send !f
$!c::Send ^{Insert}
$!v::Send +{Insert}
$!y::Send !y
$!/::Send !/
#If

#If WinActive("ahk_class CASCADIA_HOSTING_WINDOW_CLASS") && WinActive("nv")
$!z::Send !z
$!x::Send !x
$!c::Send !c
$!v::Send !v
$!a::Send !a
#If
