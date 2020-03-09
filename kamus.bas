Dim As String kata,cari,arti,kamus
Print"Default=database.txt"
Line Input"File kamus: ",kamus
If kamus="" Then kamus="database.txt"
Do
	Cls
	Print "Kamus for console (c)2008 Edwin Pelleng"
	Print "L: Lihat daftar kata; Kosong/Blank: Keluar"
	Print
	Line Input"Kata yg dicari: ",kata
	Open kamus For Input As #1
	While Not Eof(1)
		Input #1,cari,arti
		If kata=cari Then
			Print arti
		Else
			If kata="L" Then
				Print cari
				
			EndIf
		EndIf
	Wend
	Print
	Close #1
	If Len(kata)=0 Then Exit Do
	Print "Tekan sembarang tombol..."
	Do While InKey$="":Loop
Loop
