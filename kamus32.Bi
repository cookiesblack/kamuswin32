#Define IDD_DLG1 1000
#Define IDD_DLG2 1100
#Define IDC_BTN1 1001
#Define VK_K &H4B
#define ECM_FIRST &h1500
#define EM_SHOWBALLOONTIP (ECM_FIRST + 3)

#Define biru_muda &H00F9AEB3
#Define kuning_gading &H00D1FCF7
#Define orange &H00B3DAF4

Dim Shared hinstance As HINSTANCE
Dim Shared hwindow As HWND

Dim Shared As HBRUSH brush1,brush2,listbox_brush

Dim shared As ZString*1024 titel,kamus1,kamus2,file1,file2,info,mutex
Const WM_SHELLNOTIFY = WM_USER + 5
Dim shared as NOTIFYICONDATA note
Dim Shared kamus As ZString*32

Sub alfabet(hwin As HWND,id As Integer)
	Dim i As Integer
	Dim huruf As ZString*1024
	For i=65 To 90
		huruf=Chr(i)
		SendDlgItemMessage(hwin,id,CB_ADDSTRING,0,Cast(lparam,@huruf))
	Next
End Sub
Function initkata(database As String,hwin As HWND,id As Integer,alfa As Integer,huruf As string) As Boolean
	Dim As ZString*1024 kata,arti
	Dim i As Integer
	i=0
	SendDlgItemMessage(hwin,id,LB_RESETCONTENT,0,0)
	Close #1
	Open database For Input As #1
	While Not Eof(1)
		Input #1,kata,arti
		'MessageBox(hwin,txt,NULL,MB_OK)
			If (Asc(huruf,1)=Asc(UCase(kata),1)) Then SendDlgItemMessage(hwin,id,LB_ADDSTRING,0,Cast(lparam,@kata))
		'If i>100 Then Exit while
		i=i+1
	Wend
	Close #1
	i=0
If Err Then Return FALSE Else Return TRUE
End Function
Function terjemahkan(database As String,kata As String) As String
	Dim As ZString*1024 cari,arti
	Close #1
	Open database For Input As #1
	While Not Eof(1)
		Input #1,cari,arti
		If kata=cari Then
			Return arti
			SendDlgItemMessage(getactivewindow,1007,LB_ADDSTRING,0,Cast(lparam,@kata))			
			Exit While
		EndIf
	Wend
	Close #1
End Function
'------------------------------------------------------------------------

sub trayit(ByVal hdlg As HWND)
		  
		  Shell_NotifyIcon (NIM_DELETE,@note)
		  note.cbSize = sizeof (NOTIFYICONDATA)
        note.hWnd = hdlg
        note.hIcon = LoadIcon(hinstance, "MAINICON")
        note.uFlags = NIF_ICON Or NIF_TIP Or NIF_MESSAGE
        note.uCallbackMessage = WM_SHELLNOTIFY
        note.szTip = "Kamus32 by Edwin Pelleng (c)2008"
				
        Shell_NotifyIcon (NIM_ADD, @note)
				
End Sub

Public Enum ttIconType 
    NoIcon = 0 
    IconInfo = 1 
    IconWarning = 2 
    IconError = 3 
End Enum 


Public Sub ShowMessage(Message As String, Title As String, Icon As tticontype)
    Dim lTipStyle As Long 
    lTipStyle = NIF_ICON Or NIF_MESSAGE Or NIF_TIP 
    lTipStyle = lTipStyle Or NIF_INFO 
    note.uFlags = lTipStyle 
    note.szInfo = Message & Chr(0) 
    note.szInfoTitle = Title & Chr(0) 
    note.dwInfoFlags = Icon 
    Shell_NotifyIcon(NIM_MODIFY, @note)
End Sub 

Public Sub HideMessage() 
    note.szInfo = "" & Chr(0) 
    note.szInfoTitle = "" & Chr(0) 
    Shell_NotifyIcon( NIM_MODIFY, @note)
End Sub 

function trays(hwin As HWND,lparam As LPARAM) As Integer
      Dim FileMenu As HANDLE	
		Dim MainMenu As HANDLE
		Dim gambar As HBITMAP
		
      Static pt As Point
		Function = 0
        
        MainMenu = CreateMenu ()
        FileMenu = CreateMenu ()
        gambar=LoadBitmap(hinstance,"BMENU")
        
        AppendMenu (FileMenu, MF_STRING, 101, "&Kembalikan	Alt+K")
        AppendMenu (FileMenu,MF_SEPARATOR,0,NULL)
        AppendMenu (FileMenu, MF_STRING, 102, "Keluar")
        SetMenuDefaultItem(FileMenu,101,false)
        SetMenuItemBitmaps(FileMenu,101,MF_BYCOMMAND,gambar,gambar)
        InsertMenu (MainMenu, 0, MF_POPUP, FileMenu, "tray_menu")
                            
            If lParam = WM_RBUTTONDOWN Then
            	GetCursorPos (@pt)
               SetForegroundWindow (hWin)
               TrackPopupMenuEx (Filemenu,0, pt.x, pt.y, hwin, NULL)
               PostMessage (hwin, WM_NULL, 0, 0)	
      
            EndIf
            If lParam = WM_LBUTTONDBLCLK Then 
            Shell_NotifyIcon (NIM_DELETE,@note)
            ShowWindow(hwin,SW_SHOW)
            EnableWindow(hwin,TRUE)
            EndIf	
End Function











