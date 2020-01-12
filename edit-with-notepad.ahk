#NoEnv
#Persistent
#SingleInstance

; ----- Auto-execute section ---------------------------------------

;Menu, Tray, Icon, shell32.dll, 13
Menu, Tray, Icon, CtrlOpen.ico
Menu, Tray, Tip, CtrlOpen
Menu, Tray, NoStandard
Menu, Tray, Add, Edit CtrlOpen.ini, EditIni
Menu, Tray, Add
Menu, Tray, Default, Edit CtrlOpen.ini
Menu, Tray, Standard

global MyIniPath
MyIniPath = %A_ScriptDir%\CtrlOpen.ini

; ------------------------------------------------------------------

#IfWinActive ahk_class CabinetWClass
^Enter::CtrlOpen()
#IfWinActive

#IfWinActive ahk_class Progman
^Enter::CtrlOpen()
#IfWinActive

#IfWinActive ahk_class WorkerW
^Enter::CtrlOpen()
#IfWinActive

; ------ Ctrl Open -------------------------------------------------

CtrlOpen()
{
	IsClipEmpty := (Clipboard = "") ? 1 : 0
	if !IsClipEmpty {
		ClipboardBackup := Clipboard
		While !(Clipboard = "") {
			Clipboard =
			Sleep, 10
		}
	}
	Send, ^c
	ClipWait, 0.1
	Path := Clipboard, Clipboard := ClipboardBackup
	if !IsClipEmpty
	ClipWait, 0.5, 1
	StringGetPos, Pos, Path, ., R
	ext := SubStr(Path, Pos+2)
	FileRead, FullINI, %MyIniPath%

	Loop, Parse, FullINI,`r,`n
	{
		RegExMatch(A_LoopField, "\[(.*)]$",Section)
		If (Section1 <> "")
			Sections .= "|" Section1
	}
	StringTrimLeft, Sections, Sections, 1
	StringSplit, Sections, Sections, |

	Loop
	{
		CurSection := Sections%A_Index%
		IniRead, ExtVar,  %MyIniPath%, %CurSection%, Extensions
		IniRead, PathVar, %MyIniPath%, %CurSection%, Application
		StringSplit, ExtArr, ExtVar, `,

		Loop
		{
			if (ExtArr%A_Index% = ext)
			{
				Run, %PathVar% "%Path%"
				Goto, ExitLoops
			}
		} Until A_Index = ExtArr0

	} Until A_Index = Sections0

	ExitLoops:
	Return
}

EditIni:
Run, C:\windows\notepad.exe %MyIniPath%
Return
