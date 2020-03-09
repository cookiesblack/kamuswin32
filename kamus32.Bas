'compile dengan perintah: fbc -s gui dialog.rc dialog.bas


#Include Once "windows.bi"
#Include Once "win/commctrl.bi"
#Include Once "win/windef.bi"
#include once "win/shellapi.bi"
#include once "win/richedit.bi"

#Include "kamus32.bi"

Declare Function DlgProc(ByVal hWnd As HWND, ByVal uMsg As UINT, ByVal wParam As WPARAM, ByVal lParam As LPARAM) As Integer

'''
''' Program start
'''

''
'' Create the Dialog
''
LoadLibrary("riched32.dll")
initcommoncontrols

hinstance=GetModuleHandle(NULL)
DialogBoxParam(hinstance, Cast(ZString*32,"MAIN"), NULL, @DlgProc, NULL)



''
'' Program has ended
''

ExitProcess(0)
End

'''
''' Program end
'''
Sub konfig(hwin As HWND)
#Define path ExePath+"\"+"config.ini"

GetPrivateProfileString("CONFIG","titel",0,titel,100,path)
GetPrivateProfileString("CONFIG","kamus1",0,kamus1,100,path)
GetPrivateProfileString("CONFIG","kamus2",0,kamus2,100,path)
GetPrivateProfileString("CONFIG","file1",0,file1,100,path)
GetPrivateProfileString("CONFIG","file2",0,file2,100,path)
GetPrivateProfileString("CONFIG","info",0,info,100,path)
GetPrivateProfileString("CONFIG","mutex",0,mutex,100,path)
'---------------------------------------------------------
SetWindowText(hwin,"Kamus "+titel)
SendDlgItemMessage(hwin,1014,CB_ADDSTRING,0,Cast(lparam,@kamus1))
SendDlgItemMessage(hwin,1014,CB_ADDSTRING,0,Cast(lparam,@kamus2))
SetDlgItemText(hwin,1008,"{\rtf1\ansi\ansicpg1252\deff0\deflang1033{\fonttbl{\f0\fswiss\fcharset0 Arial;}}{\colortbl ;\red128\green0\blue0;\red255\green0\blue0;\red0\green0\blue255;\red0\green0\blue0;\red0\green0\blue128;\red0\green128\blue0;}{\*\generator Msftedit 5.41.15.1507;}\viewkind4\uc1\pard\cf1\b\f0\fs24 Welcome to Kamus32\cf0\b0\fs20\par\cf2\b\i (c)2008 Edwin Pelleng\cf0\b0\i0\par\cf3\ul e-mail: ewin_p@telkom.net\par\cf4                                        \cf3\par\par\cf5\ulnone\b Information:\cf6  "+info+"}")
kamus=file1
If lstrlen(file2)=0 Then EnableWindow(GetDlgItem(hwin,1014),FALSE) Else EnableWindow(GetDlgItem(hwin,1014),TRUE)
End Sub

Function Tentang(ByVal hWin As HWND,ByVal uMsg As UINT,ByVal wParam As WPARAM,ByVal lParam As LPARAM) As Integer
	Dim As Long id, Event, x, y
	Dim hBtn As HWND
	Dim rect As RECT
	

	
	
	Select Case uMsg
		case WM_CTLCOLORSTATIC
			SetTextColor(Cast(HDC,wParam),&HFF0000)
			SetBkColor(Cast(HDC,wParam),&H00C0FFFF)
			SetBkMode(Cast(HDC,wParam),TRANSPARENT)
			return Cast(integer,Brush1)
			return 0
		case WM_CTLCOLORDLG
			SetBkMode(Cast(HDC,wParam),TRANSPARENT)
			return Cast(integer, Brush1)
			return 0

		Case WM_INITDIALOG
			Dim As ZString *255 user,computer
			Static As Integer Panjang=255
  			Brush1 = CreateSolidBrush(orange)
  			GetUserName(User, @Panjang)
			GetComputerName(computer,@panjang)
			SetdlgitemText(hwin,1102,"Username: "+User)
			SetdlgitemText(hwin,1103,"Computer : "+computer)
			
			'--------------------------------
			SetDlgItemText(hwin,1101,"{\rtf1\ansi\ansicpg1252\deff0\deflang1033{\fonttbl{\f0\fswiss\fcharset0 Arial;}}{\colortbl ;\red0\green0\blue255;}\viewkind4\uc1\pard\cf1\b\f0\fs20 "+info+"\cf0\b0\par}")
		Case WM_COMMAND
			id=LoWord(wParam)
			Event=HiWord(wParam)
			Select Case id
				Case 1002
					EndDialog(hWin, 0)
			
			End Select
		Case Else
			Return FALSE
			'
	End Select
	Return TRUE

End Function

Function kesalahan(code As Integer) As String
select Case code
	Case 1:Return "Illegal function call"
	Case 2:Return "File not found signal"
	Case 3:Return "File I/O error"
	Case 4:Return "Out of memory"
	Case 5:Return "Illegal resume"
	Case 6:Return "Out of bounds array access"
	Case 7:Return "Null Pointer Access"
	Case 8:Return "No privileges"
	Case 9:Return "interrupted signal"
	Case 10:Return "illegal instruction signal"
	Case 11:Return "floating point error signal"
	Case 12:Return "segmentation violation signal"
	Case 13:Return "Termination request signal"
	Case 14:Return "abnormal termination signal"
	Case 15:Return "quit request signal"
	Case Else 
		Return "Unknown error"
End Select
End Function

Sub mutex32
Dim hMutexOfSrv32 As HANDLE
Dim error_code As Integer

hMutexOfSrv32=CreateMutex(null,false,mutex)
error_code=GetLastError()
If error_code=ERROR_ALREADY_EXISTS Or error_code=ERROR_ACCESS_DENIED Then TerminateProcess(GetCurrentProcess,0)
End Sub

Declare Function LoggedUser() As String

Function DlgProc(ByVal hWin As HWND,ByVal uMsg As UINT,ByVal wParam As WPARAM,ByVal lParam As LPARAM) As Integer
	Dim As Long id, Event
	Dim hBtn As HWND
	Dim rect As RECT
	Dim As ZString*1024 kata,arti
	Dim x As Integer
	Dim s As ZString*1024
	
	Select Case uMsg
		Case WM_CTLCOLORLISTBOX
			listbox_brush=CreateSolidBrush(&H00D8EDF5)
			SetTextColor(Cast(HDC,wParam),&HFF0000)
			SetBkMode(Cast(HDC,wParam),TRANSPARENT)
			return Cast(integer,listbox_brush)
			return 0
		case WM_CTLCOLORSTATIC
			If GetDlgItem(hWin,1002)=lParam Then
				
			SetTextColor(Cast(HDC,wParam),&HFF0000)
			SetBkMode(Cast(HDC,wParam),TRANSPARENT)
			return Cast(integer,Brush2)
			return 0
			EndIf
			if (GetDlgItem(hWin,1011)=lParam)or(GetDlgItem(hWin,1013)=lParam) Then
				
			SetTextColor(Cast(HDC,wParam),&H000000C0)
			SetBkMode(Cast(HDC,wParam),TRANSPARENT)
			return Cast(integer,Brush2)
			'return 0
			EndIf
		case WM_CTLCOLORDLG
			SetBkMode(Cast(HDC,wParam),TRANSPARENT)
			return Cast(integer, Brush2)
			return 0
		Case WM_INITDIALOG
			Dim buff as zstring*1024
			konfig(hwin)
			mutex32
			brush2=CreateSolidBrush(orange)
			'--------------------------------
			SendMessage(hwin,WM_SETICON,0,Cast(lparam,LoadIcon(hinstance,"MAINICON")))
			
			alfabet(hwin,1010)
			SetTimer(hwin,10,10,NULL)
			SendDlgItemMessage(hwin,1010,CB_SETCURSEL,0,0)
			SendDlgItemMessage(hwin,1014,CB_SETCURSEL,0,0)
			initkata(kamus,hwin,1007,1010,"A")
		Case WM_TIMER
			SetWindowLong(hwin,GWL_EXSTYLE,&h00000008)

			if (GetKeyState(VK_MENU)<0)and(GetKeyState(VK_K)<0) Then
				Shell_NotifyIcon (NIM_DELETE,@note)
				ShowWindow(hwin,SW_SHOW)
			EndIf
			if GetKeyState(VK_F1)<0 then WinHelp(hwin,"kamus.hlp",HELP_CONTENTS,0)
			If Err Then 
				ShowWindow(hwin,SW_HIDE)
				KillTimer(hwin,10)
				MessageBox(0,kesalahan(Err),"Error code: "+Str(Err),MB_ICONEXCLAMATION)
				TerminateProcess(GetCurrentProcess,0)
			EndIf
/'
		Case WM_LBUTTONDOWN
			Dim cpos As POINT
			GetCursorPos(@cpos)
			SetWindowText(hwin,Str(cpos.x))
			MoveWindow(hwin,cpos.x-200,cpos.y-160,459,388,false)
'/
		Case WM_CLOSE
			WinHelp(hwin,"kamus.hlp",HELP_QUIT,0)
			EndDialog(hWin, 0)
			'
		Case WM_COMMAND
			id=LoWord(wParam)
			Event=HiWord(wParam)
			Select Case id
				Case IDC_BTN1
					ShowWindow(hwin,SW_HIDE)
					trayit(hwin)
					ShowMessage("Program di minimize di tray."+Chr(13)+"Tekan Alt+K untuk merestore","Kamus "+titel,1)
					Sleep(2000)
					HideMessage()
				Case 1004
					
					GetDlgItemText(hwin,1003,kata,100)
					SetDlgItemText(hwin,1008,terjemahkan(kamus,lCase(kata)))
					x=Asc(UCase(kata),1)
					s=Chr(x)
					'MessageBox(0,s,NULL,MB_OK)
					If lstrlen(kata)>1 Then initkata(kamus,hwin,1007,1010,s)
					SendDlgItemMessage(hwin,1010,CB_SELECTSTRING,0,Cast(lparam,@s))
					If SendDlgItemMessage(hWin,1007,LB_SELECTSTRING,0,Cast(lparam,@kata))<0 Then MessageBox(hwin,"Kata tidak ditemukan",NULL,MB_OK)
				Case 1005
					SendDlgItemMessage(hwin,1003,WM_PASTE,0,0)
				Case 1007
					Dim ix As Integer
					Dim txt As ZString*1024
					ix=SendDlgItemMessage(hWin,1007,LB_GETCURSEL,0,0)
					SendDlgItemMessage(hWin,1007,LB_GETTEXT,ix,Cast(lparam,@txt))
					'MessageBox(0,txt,NULL,MB_OK)
					SetDlgItemText(hwin,1008,terjemahkan(kamus,txt))
				Case 1010
					Dim ix As Integer
					Dim As ZString*1024 txt,txt2
					SendDlgItemMessage(hWin,1007,LB_GETTEXT,0,Cast(lparam,@txt2))
					x=Asc(UCase(txt2),1)
					s=Chr(x)
					
					ix=SendDlgItemMessage(hWin,1010,CB_GETCURSEL,0,0)
					SendDlgItemMessage(hWin,1010,CB_GETLBTEXT,ix,Cast(lparam,@txt))
					If s<>txt Then initkata(kamus,hwin,1007,1010,txt)
				Case 1014
					Dim ix As Integer
					ix=SendDlgItemMessage(hWin,1014,CB_GETCURSEL,0,0)
					If ix=0 Then kamus=file1 Else If ix=1 Then kamus=file2
					initkata(kamus,hwin,1007,1010,"A")
				Case 1015	
					SendDlgItemMessage(hwin,1008,WM_COPY,0,0)
					ShowWindow(hwin,SW_MINIMIZE)
				Case 1016
					DialogBoxParam(hinstance, Cast(ZString*32,"INFO"), hwin, @Tentang, NULL)
				Case 1017
					WinHelp(hwin,"kamus.hlp",HELP_CONTENTS,0)
				Case 101
	            Shell_NotifyIcon (NIM_DELETE,@note)
					ShowWindow(hwin,SW_SHOW)
				Case 102
	            Shell_NotifyIcon (NIM_DELETE,@note)
	            EndDialog(hwin,0)
			End Select
		Case WM_SHELLNOTIFY
			trays(hwin,lparam)
		Case Else
			Return FALSE
			'
	End Select
	Return TRUE

End Function

