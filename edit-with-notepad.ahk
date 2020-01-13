#SingleInstance force
#NoEnv
#Warn
SendMode Input
SetWorkingDir %A_ScriptDir%
~#j::Reload



#If ""
	. "" || WinActive("ahk_class #32770") && focusedControl() == "DirectUIHWND2" || ""
	. "" || WinActive("ahk_class EVERYTHING") && focusedControl() == "SysListView321"
+^Enter::Run % "C:\windows\notepad.exe " . quoteWrap(clipGetSelection())

#If ""
	. "" || WinActive("ahk_class Progman") || ""
	. "" || WinActive("ahk_class WorkerW") && focusedControl() == "SysListView321" || ""
	. "" || WinActive("ahk_class ExploreWClass") || ""
	. "" || WinActive("ahk_class CabinetWClass") && focusedControl() == "DirectUIHWND2"
+^Enter::Run % "C:\windows\notepad.exe " . quoteWrap(explorerGetSelection())

#If ""
	. "" || WinActive("ahk_class WinRarWindow") && focusedControl() == "SysListView321" || ""
	. "" || WinActive("ahk_exe 7zFM.exe") && focusedControl() == "SysListView321"
+^Enter::MsgBox % "not supported"
#If



focusedControl() {
	ControlGetFocus focused, A
	return focused
}

clipGetSelection() {
	clip0 := ClipboardAll
	Clipboard := ""
	while (Clipboard != "") {
		Sleep, 10
		Clipboard := ""
	}
	
	Send ^c
	ClipWait  0.3, 1
	if (ErrorLevel || Clipboard == "") {
		Clipboard := clip0
		;could fail non-silently here too if we weren't confident there are no bugs :^)
		;MsgBox % "Copying path of selected file(s) to clipboard failed."
		exit 0
	}

	paths := Clipboard
	Clipboard := clip0
	return paths
}

;from https://stackoverflow.com/questions/49966688/autohotkey-copy-file-name-without-path-and-extension
explorerGetSelection(hwnd="") {
	WinGet, process, processName, % "ahk_id" hwnd := hwnd? hwnd:WinExist("A")
	WinGetClass class, ahk_id %hwnd%
	ToReturn := ""
	if (process = "explorer.exe")
		if (class ~= "Progman|WorkerW") {
			ControlGet, files, List, Selected Col1, SysListView321, ahk_class %class%
			Loop, Parse, files, `n, `r
			ToReturn .= A_Desktop "\" A_LoopField "`n"
	} else if (class ~= "(Cabinet|Explore)WClass") {
		for window in ComObjCreate("Shell.Application").Windows
			if (window.hwnd==hwnd)
				sel := window.Document.SelectedItems
		for item in sel
			ToReturn .= item.path "`n"
	}
	if (ToReturn == "") {
		;MsgBox % "Getting path of selected file(s) failed."
		exit 0
	}
	return ToReturn
}

quoteWrap(linelist) {
	return RegExReplace(RegExReplace(linelist,"`am)^.","""$0"),"`am).$","$0""")
}
