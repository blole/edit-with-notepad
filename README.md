# edit-with-notepad
Open selected files in notepad for editing, even if their file type is not associated with notepad.
![demo video](https://user-images.githubusercontent.com/651644/72284378-22a16c80-3641-11ea-9290-5f7e36eb8d7e.gif)

| Hotkey  | Action |
| ------- | ------ |
| `ctrl+shift+enter` | Open selected files in `C:\windows\notepad.exe` for editing. |
| `win+j`            | Reload the script, which is useful when editing it. |

I can highly recommend using [Notepad Replacer](https://www.binaryfortress.com/NotepadReplacer/)
for changing out notepad to notepad++ system wide.

## Supported file browsers
Extensible, currently supports opening file(s) from:
* Windows desktop
* Windows File Explorer
* Everything https://www.voidtools.com/
* Standard Open/Save As-dialogs

Should be pretty easy to add support for opening from any file browser which allows using `ctrl+c` for copying selected files.
