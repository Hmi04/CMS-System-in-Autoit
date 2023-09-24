

#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Res_Comment=Multi Client Server
#AutoIt3Wrapper_Res_Fileversion=1.0.0.2
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator
#AutoIt3Wrapper_Run_Tidy=y
#AutoIt3Wrapper_Run_Tidy=y
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <WinAPISys.au3>
#include <StructureConstants.au3>
#include <WinAPIConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiListBox.au3>
#include <Array.au3>
#include <WindowsConstants.au3>
#include <GuiMenu.au3>
#include <Crypt.au3>
#include <GDIPlus.au3>
#include <Base64.au3>
#include <File.au3>
#include "SQLite.au3"
#include "SQLite.dll.au3"
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <WinAPIvkeysConstants.au3>
#include <WinAPIShellEx.au3>
#include <GuiEdit.au3>
#include <Misc.au3> ;ispressed
#include "menutext.au3"

Global $appname="TextUI Dispatch System"
;;;ConsoleWrite(_Base64Encode("f"))
Global $databasefile='db.db'

Global $charmap=' !"#$%&''()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~ ¡¢£¤¥¦§¨©ª«¬.®¯°±²³´µ¶·¸¹º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüý'
Global $charwidth[189] = [-5,9,11,17,17,27,21,6,10,10,12,18,9,10,9,9,17,17,17,17,17,17,17,17,17,17,9,9,18,18,18,17,31,21,21,22,22,21,19,24,22,9,15,21,17,26,22,24,21,24,22,21,19,22,21,29,21,21,19,9,9,9,15,17,10,17,17,15,17,17,9,17,17,7,7,15,7,26,17,17,17,17,10,15,9,17,15,22,15,15,15,10,8,10,18,9,10,17,17,17,17,8,17,10,23,12,17,18,9,23,17,12,17,10,10,10,18,17,10,10,10,11,17,26,26,26,19,21,21,21,21,21,21,31,22,21,21,21,21,9,9,9,9,22,22,24,24,24,24,24,18,24,22,22,22,22,21,21,19,17,17,17,17,17,17,27,15,17,17,17,17,9,9,9,9,17,17,17,17,17,17,17,17,19,17,17,17,17,15]
Global $fontsize=12
For $i = 0 to UBound($charwidth)-1 ;used to get the PDF text width
  $charwidth[$i]=Round(($charwidth[$i]/22*$fontsize)) ;Scale from Arial at Size 22
Next

TCPStartup() ; Starts up TCP
_Crypt_Startup() ; Starts up Crypt
_GDIPlus_Startup() ; Starts up GDIPlus
_SQL_Startup($databasefile)

#region ;**** Declares you can edit ****
Opt("TrayIconDebug", 0)
Opt("TrayMenuMode",8)
Opt("TrayAutoPause",0)
Opt("WinTitleMatchMode",2)
Opt("GUIDataSeparatorChar")
Opt("TCPTimeout", 0)
Opt("GUIOnEventMode", 0) ;doesn't support WM_KEYUP?

Global $BindIP = "0.0.0.0" ; IP Address to listen on.	0.0.0.0 = all available.
Global $BindPort = "143" ; Port to listen on.
Global $BindPortSMTP = "587" ;these must be above 1024 in Wine
Global $BindPortT = "23"
Global $MaxConnections = 1000 ; Maximum number of allowed connections.
Global $PacketSize = 1000 ; Maximum size to receive when packets are checked.
Global $challengeresponse="+ NTk1OTYuNzQ5NDg0ODMxaGZmazRqYWtsNG8yQGxvY2FsaG9zdC5jYQ==";"59596.749484831hffk4jakl4o2@localhost.ca"
Global $hDskDb
;Global $CAPABILITY="* OK [CAPABILITY IMAP4rev1 gLITERAL+ SASL-IR LOGIN-REFERRALS LOGINDISABLED gID gENABLE IlDLE gSTARTTLS AUTnH=DIGEST-MD5 AUTH=CRAM-MD5 AUTKH=PLAIN] Dovecot (Ubuntu) ready"
Global $CAPABILITY="* OK [CAPABILITY IMAP4rev1 LITERAL+ SASL-IR LOGIN-REFERRALS ID ENABLE dIDLE AUTH=LOGIN AUTnH=DIGEST-MD5 AUTH=CRAM-MD5 AUTKH=PLAIN] Dovecot (Ubuntu) ready"
Global $CAPABILITY2="CAPABILITY IMAP4rev1 LITERAL+ SASL-IR LOGIN-REFERRALS ID ENABLE dIDLE noSORT noSORT=DISPLAY noTHREAD=REFERENCES noTHREAD=REFS noTHREAD=ORDEREDSUBJECT MULTIAPPEND noURL-PARTIAL CATENATE UNSELECT noCHILDREN noNAMESPACE notUIDPLUS LIST-EXTENDED I18NLEVEL=1 CONDSTORE QRESYNC noESEARCH noESORT noSEARCHRES noWITHIN noCONTEXT=SEARCH noLIST-STATUS noBINARY noMOVE noSPECIAL-USE noQUOTA"
Global $sqlloggingin = 0
Global $g_hHook, $g_hStub_KeyProc, $g_sBuffer = ""
Global $shIftkey=32
Global $telnetlog=''
$sqlite3_exe='sqlite3_300801000.exe'
$dispatchdir=@ScriptDir&'\Dispatch\'
$quotedir=@ScriptDir&'\Quote\'

$sqllog=''
Global $ID = ''

#endregion ;**** Declares you can edit ****

#region ;**** Declares that shouldn't be edited ****
OnAutoItExitRegister("_ServerClose")
Global $WS2_32 = DllOpen("Ws2_32.dll") ; Opens Ws2_32.dll to be used later.
Global $NTDLL = DllOpen("ntdll.dll") ; Opens NTDll.dll to be used later.
Global $TotalConnections = 0 ; Holds total connection number.
Global $SocketListen = -1 ; Variable for TCPListen()
Global $SocketListenSMTP = -1 ; Variable for TCPListen()
Global $SocketListenT = -1
Global $Connection[$MaxConnections + 1][11] ; Array to connection information. 11
Global $ConnectionInstance[$MaxConnections + 1]
Global $ConnectionSubInstance[$MaxConnections + 1]
Global $ConnectionUserid[$MaxConnections + 1]
Global $SMTPPort[$MaxConnections + 1]
Global $TPort[$MaxConnections + 1]
Global $waitingformessagedata[$MaxConnections + 1]
Global $messagedata[$MaxConnections + 1], $menubranch[$MaxConnections + 1]
Global $SocketListen
Global $SocketListenSMTP
Global $SocketListenT
Global $PacketEND = @CRLF ; Defines the end of a packet
#endregion ;**** Declares that shouldn't be edited ****


#region ;**** GUI ****
Global $GUI = GUICreate($appname, 300, 400)
GUISetState(@SW_SHOW, $GUI)

Global $ServerList = GUICtrlCreateListView("#|Socket|IP|User|Computer", 5, 5, 290, 360)
Global $FileMenu = GUICtrlCreateMenu("File")
Global $ExportDB = GUICtrlCreateMenuItem("Export DB", $FileMenu)
Global $ImportDB = GUICtrlCreateMenuItem("Import DB", $FileMenu)
Global $ExportCSV = GUICtrlCreateMenuItem("Export CSV", $FileMenu)
Global $ImportCSV = GUICtrlCreateMenuItem("Import CSV", $FileMenu)
Global $ServerExit = GUICtrlCreateMenuItem("Exit", $FileMenu)
Global $SetupMenu = GUICtrlCreateMenu("Setup")
Global $SetupEditUser = GUICtrlCreateMenuItem("Edit User", $SetupMenu)
Global $SetupEditEmail = GUICtrlCreateMenuItem("Edit Email", $SetupMenu)
Global $ServerMenu = GUICtrlCreateMenu("Server")
Global $ServerStartListen = GUICtrlCreateMenuItem("On", $ServerMenu, 2, 1)
Global $ServerStopListen = GUICtrlCreateMenuItem("Off", $ServerMenu, 3, 1)
Global $ConnectionMenu = GUICtrlCreateMenu("Connection")
Global $ConnectionCheck = GUICtrlCreateMenuItem("Check connections", $ConnectionMenu)
Global $SQLConsoleMenu = GUICtrlCreateMenuItem("SQL Console", $ConnectionMenu)
Global $TelnetConsole = GUICtrlCreateMenuItem("Telnet Console", $ConnectionMenu)
Global $CommandConsoleMenu = GUICtrlCreateMenuItem("Command Console", $ConnectionMenu)
Global $ConnectionKill = GUICtrlCreateMenuItem("Close", $ConnectionMenu)
GUICtrlCreateMenuItem("", $ConnectionMenu, 2)
Global $ConnectionKillAll = GUICtrlCreateMenuItem("Close All", $ConnectionMenu)

#endregion ;**** GUI ****

#Region ### START Koda GUI section ### Form=C:\Autoit Scripts\sqlconsole.kxf
$sqlconsole = GUICreate("SQL Console", 615, 437, 192, 124)
$Button2 = GUICtrlCreateButton("Close", 326, 396, 276, 33)
$Button1 = GUICtrlCreateButton("Execute Query", 10, 396, 276, 34)
$Edit1 = GUICtrlCreateEdit("", 11, 240, 589, 153)
GUICtrlSetData(-1, "")
$Edit2 = GUICtrlCreateEdit("", 11, 9, 589, 225)
GUICtrlSetData(-1, "")
;GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

Global $g_hCB, $g_pCB, $g_ahProc[2][2] ;Stores the Data for subclassing Editview
Global $g_LVKEYUP = 0xFE00, $g_LVKEYDN = 0xFD00
Global $g_iDummyData
Global $rawkeytable=' À1234567890½»QWERTYUIOPÛÝASDFGHJKLºÞÜâZXCVBNM¼¾¿'
Global $keytable=" ~1234567890-=qwertyuiop[]asdfghjkl;'\\zxcvbnm,./"
Global $shIftkeytable=' ~!@#$%^&*()_+QWERTYUIOP{}ASDFGHJKL:"\|ZXCVBNM<>?' ;no ` or ~ at 2nd space
Global $CommandConsole = GUICreate("Terminal", 850-27, 505-37)
Global $g_hEdit1 = GUICtrlCreateEdit("", 1, 1, 820, 465, BitOR($ES_READONLY,$WS_VSCROLL,$ES_AUTOVSCROLL))
GUICtrlSetFont(-1, 12, 400, 0, "Terminal")
GUICtrlSetBkColor(-1, 0)
GUICtrlSetColor(-1, 0xFEFEFE)
;GUISetState(@SW_SHOW)
Global $g_hEdit1_LVN = GUICtrlCreateDummy() ;Recieves Messages from the callback
Global $ar[1] = ["5"]
Global $branch1='100',$login='', $password=''
;Global $rowid='' ;SELECT CAST(strftime('%Y-%m-%d','now') AS int)  SELECT (datetime('now','localtime'))AS date
Global $stack='', $sqllog=''
$branch1=loadmenu('','',$branch1)
SubClassEditView() ;Creates our subclass

#Region ### START Koda GUI section ### Form=C:\Autoit Scripts\koda\Forms\select_listbox.kxf
$SelectForm = GUICreate("Select Item", 243, 412, 192, 124)
$SelectButtonI = GUICtrlCreateButton("Import CSV", 16, 368, 209, 33)
$SelectButtonE = GUICtrlCreateButton("Export CSV", 16, 368, 209, 33)
$List1 = GUICtrlCreateList('', 16, 16, 209, 344)
$listboxtext=''
$sqlreadquery="SELECT tbl_name FROM sqlite_master WHERE type='table'"
$sqlresult=_SQLQueryRows($sqlreadquery)
  If UBound($sqlresult)>'2' Then
	  For $i=2 to UBound($sqlresult)-1
		 $listboxtext=$listboxtext&'|'&$sqlresult[$i]
	  Next
   EndIf
GUICtrlSetData(-1, $listboxtext, "")
;GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

#Region ### START Koda GUI section ### Form=C:\Autoit Scripts\koda\Forms\FormUsers.kxf
$FormUsers = GUICreate("Users", 561, 400, 192, 114)
$UserList = GUICtrlCreateList("", 16, 16, 145, 370)
$Label1 = GUICtrlCreateLabel("ID", 176, 16, 51, 17)
$Label2 = GUICtrlCreateLabel("Name", 176, 40, 51, 17)
$Label3 = GUICtrlCreateLabel("Login", 176, 64, 51, 17)
$Label4 = GUICtrlCreateLabel("Full Name", 176, 88, 51, 17)
$Label5 = GUICtrlCreateLabel("Phone", 176, 112, 51, 17)
$Label6 = GUICtrlCreateLabel("Email", 176, 136, 51, 17)
$Label7 = GUICtrlCreateLabel("Privilege", 176, 160, 51, 17)
$Label8 = GUICtrlCreateLabel("Password", 176, 184, 51, 17)
$Label9 = GUICtrlCreateLabel("Trusted IP", 176, 208, 71, 17)
$Label10 = GUICtrlCreateLabel("Home Menu", 176, 232, 71, 17)
$Label11 = GUICtrlCreateLabel("Inventory Barcode", 176, 256, 91, 17)
$Label12 = GUICtrlCreateLabel("Disabled", 176, 280, 71, 17)
$Label13 = GUICtrlCreateLabel("Notes", 176, 304, 71, 17)
$Input1 = GUICtrlCreateInput("", 240, 14, 305, 21)
$Input2 = GUICtrlCreateInput("", 240, 38, 305, 21)
$Input3 = GUICtrlCreateInput("", 240, 62, 305, 21)
$Input4 = GUICtrlCreateInput("", 240, 86, 305, 21)
$Input5 = GUICtrlCreateInput("", 240, 110, 305, 21)
$Input6 = GUICtrlCreateInput("", 240, 134, 305, 21)
$Input7 = GUICtrlCreateInput("", 240, 158, 305, 21)
$Input8 = GUICtrlCreateInput("", 240, 182, 305, 21)
$Input9 = GUICtrlCreateInput("", 240, 206, 305, 21)
$Input10 = GUICtrlCreateInput("", 240, 230, 305, 21)
$Input11 = GUICtrlCreateInput("", 240, 254, 305, 21)
$Input12 = GUICtrlCreateInput("", 272, 278, 273, 21)
$Input13 = GUICtrlCreateInput("", 240, 302, 305, 21)
GUICtrlSetState($Input1, $GUI_DISABLE)
$UserButtonClose = GUICtrlCreateButton("Close", 176, 352, 97, 33)
$UserButtonAdd = GUICtrlCreateButton("Add User", 280, 352, 97, 33)
$UserButtonApply = GUICtrlCreateButton("Apply", 384, 352, 97, 33)
#EndRegion ### END Koda GUI section ###


Func loadmenu($typedtext,$connectionid,$branch)
$rowid=''
$sqlresult=''
If $connectionid>0 AND $branch='' then
   $sqlreadquery="SELECT user.menu,user.menu FROM user WHERE user.id='"&$ConnectionUserid[$connectionid]&"' AND user.menu<>'' LIMIT 1"
   $sqlresult=_SQLQueryRows($sqlreadquery)
	  If UBound($sqlresult)>'2' Then
		 $branch=$sqlresult[2]
	  Else
	  $branch='100'
	  EndIf
EndIf
$buf=''
$num=1
$n=''
$lastitem=UBound($menu)-1
for $i= 1 to $lastitem
   If StringLen($menu[$i])<1 Then ContinueLoop
   $menuarray=StringSplit($menu[$i],'`',1)
   $curbranch=$menuarray[1]
   $menutext=$menuarray[2]
   $nextbranch=$menuarray[3]
   $prevbranch=$menuarray[4]
   $sqlreadquery=($menuarray[5])
   $sqlwritequery=($menuarray[6])


If $curbranch=$branch Then
   If $connectionid<>'' then
	  $userid=$ConnectionUserid[$connectionid]
	  $sqlreadquery=StringReplace($sqlreadquery,'$userid',$ConnectionUserid[$connectionid])
	  $sqlwritequery=StringReplace($sqlwritequery,'$userid',$ConnectionUserid[$connectionid])
   Else
	  $userid='0'
	  $sqlreadquery=StringReplace($sqlreadquery,'$userid','0')
	  $sqlwritequery=StringReplace($sqlwritequery,'$userid','0')
   EndIf
   If $menutext='screport' then ;emailreport
	  $branch=$nextbranch
	  $sqlwritequery=StringReplace($sqlwritequery,'$rowid',readstack('1',$connectionid))
	  $sqlwritequery=StringReplace($sqlwritequery,'$prowid',readstack('2',$connectionid))
	  $sqlwritequery=StringReplace($sqlwritequery,'$pprowid',readstack('3',$connectionid))
	  $sqlwritequery=StringReplace($sqlwritequery,'$ppprowid',readstack('4',$connectionid))
	  $sqlwritequery=StringReplace($sqlwritequery,'$typedtext',$typedtext)
	  ConsoleWrite($sqlwritequery&@CRLF)
	  ;	  MsgBox('','',$sqlwritequery)
	  _SQLExec($sqlwritequery)

	  If StringLen($sqlreadquery)>0 Then
		 $sqlreadquery=StringReplace($sqlreadquery,'$rowid',readstack('1',$connectionid))
		 $sqlreadquery=StringReplace($sqlreadquery,'$prowid',readstack('2',$connectionid))
		 $sqlreadquery=StringReplace($sqlreadquery,'$pprowid',readstack('3',$connectionid))
		 $sqlreadquery=StringReplace($sqlreadquery,'$ppprowid',readstack('4',$connectionid))
		 $sqlreadquery=StringReplace($sqlreadquery,'$typedtext',$typedtext)
		 $sqlresult=_SQLQueryRows($sqlreadquery)
		 If UBound($sqlresult)>2 Then
			$rowid=$sqlresult[2]
		 EndIf
	  EndIf

;$sqlreadquery="SELECT 1,(CASE count(1) WHEN 1 THEN dispatch.id ELSE '' END) AS A FROM servicecall LEFT JOIN dispatch ON dispatch.id=servicecall.dispatchid WHERE servicecall.id='"&$rowid&"'"
		 $sqlresult=_SQLQueryRows($sqlreadquery)
		 If UBound($sqlresult)>2 Then
			;$rowid=$sqlresult[2]
			PDF_ServiceCall($sqlresult[2])
	  $num=1
	  $i=1
	  pushstack($rowid,$connectionid)
   ContinueLoop 1
		 EndIf
ElseIf $menutext='qreport' then
	  $branch=$nextbranch
			PDF_Quote(readstack('1',$connectionid))
	  $num=1
	  $i=1
	  pushstack($rowid,$connectionid)
   ContinueLoop
ElseIf $menutext='psreport' then
	  $branch=$nextbranch
			PDF_PackingSlip(readstack('1',$connectionid))
	  $num=1
	  $i=1
	  pushstack($rowid,$connectionid)
   ContinueLoop
ElseIf $menutext='invoice' then
	  $branch=$nextbranch
			PDF_Invoice(readstack('1',$connectionid))
	  $num=1
	  $i=1
	  pushstack($rowid,$connectionid)
   ContinueLoop
   ElseIf $menutext='bc' AND $typedtext<>'' then ;barcode
	  $rowid=readstack('1',$connectionid)
	  $branch=$nextbranch
	  $sqlreadquery=StringReplace($sqlreadquery,'$prowid',readstack('2',$connectionid)) ;;;;44444444 111111114  111111118 111111113
	  $sqlreadquery=StringReplace($sqlreadquery,'$typedtext',$typedtext)
	  $query="SELECT inventory.id FROM inventory WHERE inventory.id='"&$typedtext&"'"
	  $sqlresult=_SQLQueryRows($query)
	  ;_ArrayDisplay($sqlresult)
	  If $sqlresult[UBound($sqlresult)-1]<>'0' Then ;Select inventory in user.id
		 $query="UPDATE user SET invid=(SELECT inventory.id FROM inventory WHERE inventory.id='"&$typedtext&"') WHERE user.id='"&$rowid&"'"
		 _SQLExec($query)
		 if _SQLite_Changes() >0 then
			$query="UPDATE inventory SET qty=qty+(SELECT (CASE user.invmode WHEN 'D' THEN '1' WHEN 'W' THEN '-1' END) AS A FROM user WHERE user.id='"&readstack('1',$connectionid)&"') WHERE ((SELECT 1 FROM user WHERE user.invmode='W' AND user.id='"&readstack('1',$connectionid)&"') AND inventory.id='"&$typedtext&"' AND qty>0) OR ((SELECT 1 FROM user WHERE user.invmode='D' AND user.id='"&readstack('1',$connectionid)&"') AND inventory.id='"&$typedtext&"')"
			_SQLExec($query)
			if _SQLite_Changes() >0 then
	  $query="SELECT user.invmode AS A FROM user WHERE user.id='"&$rowid&"'"
	  $sqlresult=_SQLQueryRows($query)
			   Switch $sqlresult[1]
				  Case 'D' ;INVERT BECAUSE TAKE AWAY INVENTORY GIVES TO USER
					 $query="UPDATE OR IGNORE userinv SET qty=qty-1,date=STRFTIME('%Y%m%d%H:%M',datetime('now','localtime')) WHERE userinv.userid='"&$rowid&"' AND userinv.inventoryid=(SELECT user.invid FROM user WHERE user.id='"&$rowid&"' LIMIT 1);DELETE FROM userinv WHERE userinv.qty='0' AND userinv.id IN(SELECT userinv.id FROM userinv LEFT JOIN user ON user.invid=userinv.inventoryid WHERE user.id='"&$rowid&"')"
					 _SQLExec($query)
				  Case 'W'
					 $query="UPDATE OR IGNORE userinv SET qty=qty+1,date=STRFTIME('%Y%m%d%H:%M',datetime('now','localtime')) WHERE userinv.userid='"&$rowid&"' AND userinv.inventoryid=(SELECT user.invid FROM user WHERE user.id='"&$rowid&"' LIMIT 1);INSERT or IGNORE INTO userinv(inventoryid,userid,qty,date,notes,createdby,disabled) SELECT user.invid,'"&$rowid&"','1',STRFTIME('%Y%m%d%H:%M',datetime('now','localtime')),'','"&$userid&"','0' FROM user WHERE user.id='"&$rowid&"' AND NOT EXISTS(SELECT userinv.inventoryid FROM userinv LEFT JOIN user ON user.invid=userinv.inventoryid WHERE userinv.userid='"&$rowid&"' AND userinv.inventoryid=USER.invid)"
					 _SQLExec($query)
			   EndSwitch
			EndIf
			$typedtext=''
			$num=1
			$i=1
			$buf=''
			ContinueLoop(1)
		 EndIf
	  Else
	  $sqlresult=_SQLQueryRows($sqlreadquery)
		 If UBound($sqlresult)>'2' Then
			$sqlresult=$sqlresult[1]
			$rowid=$sqlresult
			$query="UPDATE user SET invmode=CASE invmode WHEN 'D' THEN 'W' WHEN 'W' THEN 'D' END WHERE user.id='"&$rowid&"'"
			_SQLExec($query)
		 EndIf
	  EndIf
	  $typedtext=''
	  $num=1
	  $i=1
	  $buf=''
	  ;ContinueLoop(1)

   if $rowid<>readstack('2',$connectionid) then pushstack($rowid,$connectionid)
	  ;$rowid=''
	  $typedtext=''
	  $num=1
	  $i=0
	  $buf=''
ContinueLoop(1)
   ElseIf $menutext='ml' then

	  $branch=$nextbranch
	  If $sqlwritequery<>'' Then
		 ConsoleWrite('B '&$menutext&' '&$branch&' '&$nextbranch&' '&$prevbranch)
		 $sqlwritequery=StringReplace($sqlwritequery,'$rowid',readstack('1',$connectionid))
		 $sqlwritequery=StringReplace($sqlwritequery,'$typedtext',$typedtext)
		 _SQLExec($sqlwritequery)

	  EndIf

	  If $sqlreadquery<>''  Then
		 $sqlreadquery=StringReplace($sqlreadquery,'$rowid',readstack('1',$connectionid))
		 $sqlreadquery=StringReplace($sqlreadquery,'$typedtext',$typedtext)
		 $sqlresult=_SQLQueryRows($sqlreadquery)
		 If UBound($sqlresult)>2 Then
			$buf=$sqlresult[2]
			;MsgBox('',asc(@LF&@LF),asc(StringRight($buf,2)))
			if StringRight($sqlresult[3],3)=(@LF&@LF&@LF) then ;display is in [2] output in [3]
			   $typedtext=''
			   $branch=$prevbranch
			   $buf=''
			   ContinueLoop
			EndIf
		 EndIf
	  EndIf
	  $branch=$nextbranch
	  $num=1
	  ;$i=1
   ContinueLoop 1
   ElseIf  $menutext='' AND $nextbranch=$prevbranch  then ;toggle value without @CRLF
	  $branch=$nextbranch
	  $sqlwritequery=StringReplace($sqlwritequery,'$rowid',readstack('1',$connectionid))
	  $sqlwritequery=StringReplace($sqlwritequery,'$prowid',readstack('2',$connectionid))
	  $sqlwritequery=StringReplace($sqlwritequery,'$pprowid',readstack('3',$connectionid))
	  $sqlwritequery=StringReplace($sqlwritequery,'$ppprowid',readstack('4',$connectionid))
	  $sqlwritequery=StringReplace($sqlwritequery,'$typedtext',$typedtext)
	  ConsoleWrite('A '&$sqlwritequery&@CRLF)
	  ;	  MsgBox('','',$sqlwritequery)
	  _SQLExec($sqlwritequery)

	  If StringLen($sqlreadquery)>0 Then
		 $sqlreadquery=StringReplace($sqlreadquery,'$rowid',readstack('1',$connectionid))
		 $sqlreadquery=StringReplace($sqlreadquery,'$prowid',readstack('2',$connectionid))
		 $sqlreadquery=StringReplace($sqlreadquery,'$pprowid',readstack('3',$connectionid))
		 $sqlreadquery=StringReplace($sqlreadquery,'$ppprowid',readstack('4',$connectionid))
		 $sqlreadquery=StringReplace($sqlreadquery,'$typedtext',$typedtext)
		 $sqlresult=_SQLQueryRows($sqlreadquery)
		 If UBound($sqlresult)>2 Then
			$rowid=$sqlresult[2]
		 EndIf
	  EndIf
	  $num=1
	  $i=1
	  pushstack($rowid,$connectionid)
   ContinueLoop 1

   ElseIf (Number($menutext))>0 then ;remove from stack
	  $branch=$nextbranch
	  $rowid=popstack($menutext,$connectionid)
	  $num=1
	  $i=1
   ContinueLoop 1
   ElseIf $typedtext='0' AND $nextbranch<>$prevbranch  then ;0 back menu
	  $rowid=popstack('1',$connectionid);readstack('2',$connectionid)
   	  $branch=$prevbranch
	  $typedtext=''
	  $num=1
	  $i=0
	  $buf=''
	  ContinueLoop(1)
   ElseIf ($typedtext<>'' AND $nextbranch=$prevbranch AND $menutext<>'ml') AND $menutext<>''    Then ;input ONE field WRITE FIELD
	  	  ;MsgBox('',$menutext,$sqlreadquery)
	  If $sqlwritequery<>''  AND StringLen($typedtext)>0 AND $sqlwritequery<>'c' Then
	  $sqlwritequery=StringReplace($sqlwritequery,'$rowid',readstack('1',$connectionid))
	  $sqlwritequery=StringReplace($sqlwritequery,'$prowid',readstack('2',$connectionid))
	  $sqlwritequery=StringReplace($sqlwritequery,'$pprowid',readstack('3',$connectionid))
	  $sqlwritequery=StringReplace($sqlwritequery,'$ppprowid',readstack('4',$connectionid))
	  $sqlwritequery=StringReplace($sqlwritequery,'$typedtext',$typedtext)
	  ConsoleWrite('C '&$sqlwritequery&@CRLF)
	  _SQLExec($sqlwritequery)

		 If $sqlreadquery<>'' AND $menutext<>'' Then
			$sqlreadquery=StringReplace($sqlreadquery,'$ppprowid',readstack('4',$connectionid)) ;;;;
			$sqlreadquery=StringReplace($sqlreadquery,'$pprowid',readstack('3',$connectionid))
			$sqlreadquery=StringReplace($sqlreadquery,'$prowid',readstack('2',$connectionid))
			$sqlreadquery=StringReplace($sqlreadquery,'$rowid',readstack('1',$connectionid))
			$sqlreadquery=StringReplace($sqlreadquery,'$typedtext',$typedtext)

			$sqlresult=_SQLQueryRows($sqlreadquery)
			If UBound($sqlresult)>2 Then ;SELECT '$prowid'||CHAR(96)||'$rowid',''
			   ;MsgBox('','',$sqlreadquery)
			   ;;;pushstack($sqlresult[2],$connectionid)
			   $rowid=$sqlresult[2]
			   pushstack($rowid,$connectionid)

			EndIf
		 EndIf
	  ElseIf $sqlwritequery<>'' AND StringLen($typedtext)>0 then
		 $rowid=$typedtext
		 pushstack($rowid,$connectionid)
	  EndIf
   	  $branch=$prevbranch
	  $num=1
	  $i=0
	  $buf=''
	  $typedtext=''
	  ContinueLoop(1)
   ElseIf $nextbranch=$prevbranch Then ;query='c'
	  	  ;MsgBox('','',$sqlreadquery)
	  if $menutext<>'bc' Then $buf=$buf&$menutext&@CRLF
   ElseIf $menutext='SQLMenu' Then
	  $sqlreadquery=StringReplace($sqlreadquery,'$rowid',readstack('1',$connectionid))
	  $sqlreadquery=StringReplace($sqlreadquery,'$prowid',readstack('2',$connectionid))
	  $sqlreadquery=StringReplace($sqlreadquery,'$pprowid',readstack('2',$connectionid))
	  $sqlreadquery=StringReplace($sqlreadquery,'$ppprowid',readstack('3',$connectionid))
	  $sqlreadquery=StringReplace($sqlreadquery,'$typedtext',readstack('3',$connectionid))
	  If $sqlreadquery<>''  Then
		$sqlresult=_SQLQueryRows($sqlreadquery)
		If $num>1 then
		   $n=$num
		else
		   $n=1
	    EndIf
		for $x=1 to UBound($sqlresult)-2 Step 2
		   If $sqlresult[$x]  Then
			  $buf=$buf&StringFormat( "% 2s", $n)&'. '&$sqlresult[$x+2]&@CRLF
		   EndIf
		  If $sqlwritequery='c' Then
				$typedtext='1'
			 EndIf
		   If $typedtext=$n Then
			  $rowid=$sqlresult[$x+1]
			  $sqlwritequery=StringReplace($sqlwritequery,'$rowid',$rowid)
			  $sqlwritequery=StringReplace($sqlwritequery,'$prowid',readstack('1',$connectionid))
			  $sqlwritequery=StringReplace($sqlwritequery,'$pprowid',readstack('2',$connectionid))
			  ;$sqlwritequery=StringReplace($sqlwritequery,'$ppprowid',readstack('3',$connectionid))
			  ;MsgBox("","",$pprowid&': '&$rowid&' '&$sqlwritequery)
			  	  ConsoleWrite('D '&$sqlwritequery&@CRLF)
			  If $sqlwritequery<>'' AND $sqlwritequery<>'c' Then
				  _SQLExec($sqlwritequery)
			   EndIf
			  $branch=$nextbranch
			 $typedtext=''
			  $n=1
			  $num=1
			  $i=0
			  $buf=''
			     pushstack($rowid,$connectionid)
			  ContinueLoop(2)
		   EndIf
		$n+=1
	 Next
   $num=$n-1

	  EndIf
   ElseIf $typedtext=$num AND $nextbranch<>$prevbranch AND $menutext<>'SQLMenu' then
	  $branch=$nextbranch
	  $typedtext=''
	  $num=1
	  $i=0 ;DON'T TOUCH
	  $buf=''
	;  $buf=$buf&$menutext&@CRLF ;header text
	   pushstack($rowid,$connectionid)
	  ContinueLoop(1)
   Else

   If readstack('1',$connectionid)<>'' AND $sqlreadquery<>'' AND $menutext<>'bc' AND $menutext<>'ml' Then ;field label
	  $sqlreadquery=StringReplace($sqlreadquery,'$rowid',readstack('1',$connectionid))
	  $sqlreadquery=StringReplace($sqlreadquery,'$prowid',readstack('2',$connectionid))
	  $sqlreadquery=StringReplace($sqlreadquery,'$pprowid',readstack('3',$connectionid))
	  $sqlreadquery=StringReplace($sqlreadquery,'$ppprowid',readstack('4',$connectionid)) ;;;;
	  $sqlreadquery=StringReplace($sqlreadquery,'$typedtext',$typedtext)
	  $sqlresult=_SQLQueryRows($sqlreadquery)
	  ConsoleWrite('FL '&$sqlreadquery&@CRLF)
	  If UBound($sqlresult)>1 Then
		 $sqlresult=$sqlresult[1]
	  EndIf

   EndIf
   $buf=$buf&StringFormat( "% 2s", $num)&'. '&$menutext&$sqlresult&@CRLF
   $sqlresult=''
   EndIf
$num+=1
EndIf


Next
If $connectionid='' then
   GUICtrlSetData($g_hEdit1, $buf)
Else
    TCPSend($Connection[$connectionid][0], $buf&@CRLF)
EndIf
return $branch
EndFunc


Func SubClassEditView()
   OnAutoItExitRegister("Cleanup") ;to remove our subclass

  $g_hCB = DllCallbackRegister('_SubclassProc', 'lresult', 'hwnd;uint;wparam;lparam;uint_ptr;dword_ptr')
  $g_pCB = DllCallbackGetPtr($g_hCB)

  $g_ahProc[0][0] = $g_hEdit1 ;Add the Ids of the controls we'd like to subclass
;Set up the subclass _WinAPI_SetWindowSubclass ( $hWnd, $pSubclassProc, $idSubClass [, $pData = 0] )
  $g_ahProc[0][1] = _WinAPI_SetWindowSubclass(GUICtrlGetHandle($g_ahProc[0][0]), $g_pCB, $g_ahProc[0][0], $g_hEdit1_LVN)
EndFunc  ;==>SubClassEditView

Func _SubclassProc($hWnd, $iMsg, $wParam, $lParam, $iID, $pData)
  #forceref $iID

  Local $iRtnMsg = 0
  ;Events we'd like to intercept
  If $iMsg = $WM_KEYUP then ;Or $iMsg = $WM_SYSKEYUP Then
    $iRtnMsg = $g_LVKEYUP
  ElseIf $iMsg = $WM_KEYDOWN then ;Or $iMsg = $WM_SYSKEYDOWN Then
    $iRtnMsg = $g_LVKEYDN
  EndIf

  ;We Recieve the Id of the dummy through $pData and pass our RtnMsg to the dummy control
  If $iRtnMsg Then GUICtrlSendToDummy($pData, BitOR($iRtnMsg, $wParam))

  ;Pass messages on to the default handler
  Return _WinAPI_DefSubclassProc($hWnd, $iMsg, $wParam, $lParam)
EndFunc  ;==>_SubclassProc

Func pushstack($s,$connectionid)
   If StringLen($s)<1 then Return
   Switch $connectionid
	  Case ''
		 $a=StringSplit($stack,'`')
		 If $s<>'' then _ArrayAdd($a,$s)
		 If $a[1]='' Then _ArrayDelete( $a,1)
		 If UBound($a)>10 Then _ArrayDelete( $a,1)
		 $stack=_ArrayToString($a,'`',1)
		 if StringLen($stack)>0 Then ConsoleWrite($stack&@CRLF)
	  Case Else
		 $a=StringSplit($messagedata[$connectionid],'`')
		 If $s<>'' then _ArrayAdd($a,$s)
		 If $a[1]='' Then _ArrayDelete( $a,1)
		 If UBound($a)>10 Then _ArrayDelete( $a,1)
   $messagedata[$connectionid]=_ArrayToString($a,'`',1)
   EndSwitch
EndFunc

Func popstack($s,$connectionid)
   If StringLen($s)<1 then Return
   Switch $connectionid
	  Case ''
		 $a=StringSplit($stack,'`')
		 For $i=UBound($a)-1 To UBound($a)-$s Step -1
			If $i<$s then ExitLoop
			_ArrayDelete( $a,$i)
			;MsgBox('','',$i)
		 Next
		 $stack=_ArrayToString($a,'`',1)
		  if StringLen($stack)>0 Then ConsoleWrite($stack&@CRLF)
	  Case Else
		 $a=StringSplit($messagedata[$connectionid],'`')
		 For $i=UBound($a)-1 To UBound($a)-$s Step -1
			If $i<$s then ExitLoop
			_ArrayDelete( $a,$i)
		 Next
   $messagedata[$connectionid]=_ArrayToString($a,'`',1)
   EndSwitch
$b=$a[UBound($a)-1]
Return $b
EndFunc

Func readstack($s,$connectionid)
    if StringLen($stack)>0 Then ConsoleWrite($stack&@CRLF)
   Switch $connectionid
	  Case ''
	     If StringLen($stack)<1 then Return
		 $a=StringSplit($stack,'`')
	  Case Else
		 ConsoleWrite($messagedata[$connectionid]&@CRLF)
		 If StringLen($messagedata[$connectionid])<1 then Return
		 $a=StringSplit($messagedata[$connectionid],'`')
   EndSwitch
If UBound($a)<1 then Return $a[1]
If UBound($a)-Number($s)<1 then Return $a[1]
$b=$a[UBound($a)-Number($s)]
Return $b
EndFunc

$cmd=''
;mnucmd($cmd)
$maxnum=1

Func ClientToScreen($hWnd, ByRef $iX, ByRef $iY)
  Local $tPoint = DllStructCreate("int;int")

  DllStructSetData($tPoint, 1, $iX)
  DllStructSetData($tPoint, 2, $iY)

  DllCall("user32.dll", "int", "ClientToScreen", "hwnd", $hWnd, "struct*", $tPoint)

  $iX = DllStructGetData($tPoint, 1)
  $iY = DllStructGetData($tPoint, 2)
  $tPoint = 0
EndFunc


;#####END COMMAND CONSOLE

#Region ### START Koda GUI section ### Form=C:\Users\User\Downloads\koda\Forms\Telnet.kxf
;$Telnet = GUICreate("Telnet", 615, 437, -1, -1)
;$Button3 = GUICtrlCreateButton("Execute Query", 10, 396, 276, 34)
;GUISetState(@SW_HIDE,$Telnet)
;$Edit3 = GUICtrlCreateEdit("", 0, 0, 614, 236,$ES_READONLY+$ES_AUTOVSCROLL+$WS_CHILD+$WS_DISABLED);+$WS_DISABLED
;GUICtrlSetFont(-1, 10, 400, 0, "Lucida Console")


_CheckDispatchDir()
;GUIRegisterMsg($WM_KEYUP, "WM_KEYUP")
_Main() ; Starts the main function

Func _Main()
   ;ControlClick(WinGetHandle(""), "", $ServerStartListen) didn't work

   OnAutoItExitRegister("Cleanup")

   WinMenuSelectItem(WinGetHandle($appname),"",'Server','On')
   ;WinMenuSelectItem(WinGetHandle($appname),"",'Connection','Telnet Console')
WinMenuSelectItem(WinGetHandle($appname),"",'Connection','Command Console')

    Local $iMsg
    While 1
		 _CheckNewConnections()
		_CheckNewConnectionsSMTP()
		_CheckNewConnectionsT()
		_CheckNewPackets()
		_Sleep(1000, $NTDLL)
        $iMsg = GUIGetMsg()

        Switch $iMsg
			Case $WM_KEYUP
            Case $GUI_EVENT_CLOSE
			   If(WinActive ($SQLConsole)) then
				  _SQLConsoleClose()
			   ElseIf(WinActive ($SelectForm)) then
				  _SelectFormClose()
			   Else
				  ExitLoop
			   EndIf
			Case $ServerStartListen
				_ServerListenStart()
			Case $ServerStopListen
				_ServerListenStop()
			Case $ConnectionKill
				_ConnectionKill()
			 Case $ExportCSV
				_ExportCSV()
			Case $ImportCSV
				_ImportCSV()
			Case $ExportDB
				_ExportDB()
			Case $ImportDB
				_ImportDB()
			Case $ServerExit
				_ServerExit()
			Case $SetupEditUser
				_EditUser()
			Case $SetupEditEmail
				_EditEmail()
			Case $ConnectionCheck
				_ConnectionCheck()
			Case $SQLConsoleMenu
				_SQLConsole()
			Case $TelnetConsole
				_TelnetConsole()
			Case $UserList
				_UserList()
			Case $UserButtonClose
				_UserClose()
			Case $UserButtonAdd
				_UserAdd()
			Case $UserButtonApply
				_UserApply()
			Case $CommandConsoleMenu
				_CommandConsole()
			Case $ConnectionKillAll
				_ConnectionKillAll()
			Case $Button1
				_Button1()
			Case $Button2
				_Button2()
			Case $SelectButtonI
				_SelectButton(1)
			Case $SelectButtonE
				_SelectButton(0)
    Case $g_hEdit1_LVN ;This is just a dummy it only recieves events
      $g_iDummyData = GUICtrlRead($g_hEdit1_LVN) ;Retrieve the code that was sent
			$buf=GUICtrlRead($g_hEdit1)
      Switch BitAND($g_iDummyData, 0xFF00) ;Get the keyup/dn status
		 Case $g_LVKEYDN
		 $mappedchr=chr(BitAND($g_iDummyData, 0x00FF))
		 If BitAND($g_iDummyData, 0x00FF) = (_IsPressed("43") AND (_IsPressed("11"))) Then ; CTRL+C COPY CLIPBOARD
			   $SelectedText=''
			   $range = _GUICtrlEdit_GetSel(GUICtrlGetHandle($g_hEdit1))
			   If $range[0] <> $range[1] Then
				  $SelectedText = StringMid(GUICtrlRead($g_hEdit1), $range[0] + 1, $range[1] - $range[0])
			   EndIf
			ClipPut($SelectedText)
		 ElseIf BitAND($g_iDummyData, 0x00FF) = (_IsPressed("56") AND (_IsPressed("11"))) Then ; CTRL+V PASTE CLIPBOARD
			$mappedchr=ClipGet()
			$cmd=$cmd&$mappedchr
			GUICtrlSetData($g_hEdit1, $buf&$mappedchr)
		 ElseIf BitAND($g_iDummyData, 0x00FF) = (_IsPressed("11")) Then ; DO NOTHING on CTRL key

		 ElseIf BitAND($g_iDummyData, 0x00FF) = (BitAND($g_iDummyData, 0x00FF)) AND (_IsPressed("A0") Or _IsPressed("A1")) Then ;Right/ Left ShIft & F10
			$mappedchr=StringMid($shIftkeytable,StringInStr($rawkeytable,$mappedchr,1),1)
			$cmd=$cmd&$mappedchr
			GUICtrlSetData($g_hEdit1, $buf&$mappedchr)
		 ElseIf BitAND($g_iDummyData, 0x00FF) = 0x08 then;BS
			GUICtrlSetData($g_hEdit1, StringTrimRight($buf,1))
			$cmd=StringTrimRight($cmd,1)
		 ElseIf BitAND($g_iDummyData, 0x00FF) = 0x0D then;CR
			GUICtrlSetData($g_hEdit1, $buf&@CRLF)
			$branch1=loadmenu($cmd,'',$branch1)
			$cmd=''
          Else
			$mappedchr=chr(BitAND($g_iDummyData, 0x00FF))
			$mappedchr=StringMid($keytable,StringInStr($rawkeytable,$mappedchr,1),1)
			$cmd=$cmd&$mappedchr
			GUICtrlSetData($g_hEdit1, $buf&$mappedchr)
          EndIf
	    ;Case $g_LVKEYUP this doesn't work
        ;  If BitAND($g_iDummyData, 0x00FF) = (_IsPressed("A0") Or _IsPressed("A1")) Then ;Right/ Left ShIft & F10
		; EndIf
      EndSwitch


        EndSwitch
    WEnd
EndFunc   ;==>_Main


Func _CheckNewConnections()
	Local $SocketAccept = TCPAccept($SocketListen) ; Tries to accept a new connection.
	If $SocketAccept = -1 Then ; If we found no new connections,
		Return ; skip the rest and return to _Main().
	EndIf

	If $TotalConnections >= $MaxConnections Then ; If we reached the maximum connections allowed,
		TCPSendLogged($SocketAccept, "MAXIMUM_CONNECTIONS_REACHED") ; tell the connecting client that we cannot accept the connection,
		TCPCloseSocket($SocketAccept) ; close the socket,
		Return ; skip the rest and return to _Main().
	EndIf
	; Since we got this far, we must have a new connection.
	$TotalConnections += 1 ; Add to the total connections.
	$Connection[$TotalConnections][0] = $SocketAccept ; Save the socket number to the next empty array slot, at sub array 0.
	$Connection[$TotalConnections][1] = GUICtrlCreateListViewItem($TotalConnections & "|" & $SocketAccept & "|" & _SocketToIP($SocketAccept), $ServerList) ; Create list view item with connection information
ConsoleWrite("connection opened"&@CRLF)
  TCPSendLogged($Connection[$TotalConnections][0], $CAPABILITY&@CRLF)

EndFunc

Func _CheckNewConnectionsSMTP()
	Local $SocketAcceptSMTP = TCPAccept($SocketListenSMTP) ; Tries to accept a new connection.
	If $SocketAcceptSMTP = -1 Then ; If we found no new connections,
		Return ; skip the rest and return to _Main().
	EndIf

	If $TotalConnections >= $MaxConnections Then ; If we reached the maximum connections allowed,
		TCPSendLogged($SocketAcceptSMTP, "MAXIMUM_CONNECTIONS_REACHED") ; tell the connecting client that we cannot accept the connection,
		TCPCloseSocket($SocketAcceptSMTP) ; close the socket,
		Return ; skip the rest and return to _Main().
	EndIf
	; Since we got this far, we must have a new connection.
	$TotalConnections += 1 ; Add to the total connections.
	$Connection[$TotalConnections][0] = $SocketAcceptSMTP ; Save the socket number to the next empty array slot, at sub array 0.
	$Connection[$TotalConnections][1] = GUICtrlCreateListViewItem($TotalConnections & "|" & $SocketAcceptSMTP & "|" & _SocketToIP($SocketAcceptSMTP), $ServerList) ; Create list view item with connection information
    $SMTPPort[$TotalConnections]=1

TCPSendLogged($Connection[$TotalConnections][0], "220 samhobbs ESMTP Postfix (Debian/GNU)"&@CRLF)

EndFunc

Func _CheckNewConnectionsT()
   Local $SocketAcceptT = TCPAccept($SocketListenT) ; Tries to accept a new connection.
   If $SocketAcceptT = -1 Then ; If we found no new connections,
		Return ; skip the rest and return to _Main().
   EndIf

   If $TotalConnections >= $MaxConnections Then ; If we reached the maximum connections allowed,
		TCPSendLogged($SocketAcceptT, "MAXIMUM_CONNECTIONS_REACHED") ; tell the connecting client that we cannot accept the connection,
		TCPCloseSocket($SocketAcceptT) ; close the socket,
		Return ; skip the rest and return to _Main().
   EndIf
   ; Since we got this far, we must have a new connection.
   $TotalConnections += 1 ; Add to the total connections.
   $Connection[$TotalConnections][0] = $SocketAcceptT ; Save the socket number to the next empty array slot, at sub array 0.
   $Connection[$TotalConnections][1] = GUICtrlCreateListViewItem($TotalConnections & "|" & $SocketAcceptT & "|" & _SocketToIP($SocketAcceptT), $ServerList) ; Create list view item with connection information
   $TPort[$TotalConnections]=1
   if trustediptelnetlogin($TotalConnections) Then Return ;is IP exempt from login?
   TCPSendLogged($Connection[$TotalConnections][0], "Login: ")
EndFunc

Func _CheckBadConnection()
	If $TotalConnections < 1 Then Return ; If we have no connections, there is no reason to check for bad ones, so return to _Main()
	Local $NewTotalConnections = 0 ; Temporary variable to calculate the new total connections.
	For $i = 1 To $TotalConnections ; Loop through all
		TCPSend($Connection[$i][0], '');"CONNECTION_TEST") ; Send a test packet
		If @error Then ; If the send fails..
			TCPCloseSocket($Connection[$i][0]) ; Close the socket,
			GUICtrlDelete($Connection[$i][1]) ; Delete the item from the list view,
			$Connection[$i][0] = -"" ; Set socket to nothing,
			$Connection[$i][1] = "" ; Empty gui control,
			$SMTPPort[$i]=0
			$TPort[$i]=0
			$ConnectionInstance[0]=0
			$ConnectionUserid[$i]='';-1
			$ConnectionSubInstance[0]=0
			;$waitingformessagedata[$MaxConnections + 1]
			;$messagedata[$MaxConnections + 1]
			ContinueLoop ; and continue checking for more bad connections.
		Else
			$NewTotalConnections += 1 ; If the send succeeded, we count up, because the client is still connected.
		EndIf
	Next

	If $NewTotalConnections < $TotalConnections Then ; If we found any bad connections, then we rearrange the $Connection array.
		If $NewTotalConnections < 1 Then ; If the new total shows no connections,
			$TotalConnections = $NewTotalConnections ; Set the new connection variable,
			Return ; and Return to _Main()
		EndIf

		; This loop creates a temporary array, cycles through possible old data in the $Connection array and transfers it to the temporary array, rearranged properly.
		Local $Count = 1
		Local $TempArray[$MaxConnections + 1][11]
		For $i = 1 To $MaxConnections
			If $Connection[$i][0] = -1 Or $Connection[$i][0] = "" Then
				ContinueLoop
			EndIf
			For $j = 0 To 10
				$TempArray[$Count][$j] = $Connection[$i][$j]
			Next
			$Count += 1
		Next
		$TotalConnections = $NewTotalConnections ; Self explanitory.
		$Connection = $TempArray ; Transfer the newly arranged temporary array to our main array.

		; This loop doesn't directly affect anything with the connection, but makes the list numbered (or re-numbered, after the array was fixed.)
		For $i = 1 To $TotalConnections
			GUICtrlSetData($Connection[$i][1], $i)
		Next
	EndIf
EndFunc   ;==>_CheckBadConnection

Func _CheckNewPackets()
      Local $sqlresult

	If $TotalConnections < 1 Then
		Return ; If we have no connections, there is no reason to check for bad ones, so return to _Main()
	EndIf
	Local $RecvPacket
	For $i = 1 To $TotalConnections ; Loop through all connections
		$RecvPacket = TCPRecv($Connection[$i][0], $PacketSize) ; Attempt to receive data
		If @error Then ; If there was an error, the connection is probably down.
			_CheckBadConnection() ; So, we call the function to check.
		 EndIf

	    If(StringInStr($RecvPacket,chr(0x8))) Then ;If it's a BS then erase prior char
		   TCPSendLogged($Connection[$i][0],' '&Chr(0x8))
		   $Connection[$i][2]=StringTrimRight($Connection[$i][2],1)
		   ConsoleWrite($RecvPacket&@CRLF)
		EndIf
		If $RecvPacket <> "" AND NOT StringInStr($RecvPacket,chr(0x8)) Then ; If we got data...
			$Connection[$i][2] &= $RecvPacket ; Add it to the packet buffer.
			ConsoleWrite(">> New Packet from " & _SocketToIP($Connection[$i][0]) & @CRLF & "+> " & $RecvPacket & @CRLF & @CRLF) ; Let us know we got a packet in scite.
		 EndIf

		If StringInStr($Connection[$i][2], $PacketEND) Then ; If we received the end of a packet, then we will process it.
			Local $RawPackets = $Connection[$i][2] ; Transfer all the data we have to a new variable.
			Local $FirstPacketLength = StringInStr($RawPackets, $PacketEND) - 1 ; Get the length of the packet, and subtract the length of the prefix/suffix.
			Local $PacketType = StringMid($RawPackets, 1,$FirstPacketLength) ; Copy the first 18 characters, since that is where the packet type is put.
		 Local $CompletePacket = StringMid($RawPackets, 1, $FirstPacketLength ) ; Extract the packet.
			Local $PacketsLeftover = StringTrimLeft($RawPackets, $FirstPacketLength+2) ; Trim what we are using, so we only have what is left over. (any incomplete packets)
			$Connection[$i][2] = $PacketsLeftover ; Transfer any leftover packets back to the buffer.
			;;ConsoleWrite(">> Full packet found!" & @CRLF)
			ConsoleWrite("+> Type: " & $PacketType & @CRLF)
			;;ConsoleWrite("+> Packet: " & $CompletePacket & @CRLF)
			;;ConsoleWrite("!> Left in buffer: " & $Connection[$i][2] & @CRLF & @CRLF)

		 ConsoleWrite("<<"&$PacketType & @CRLF)

;Telnet server here
;MsgBox('','',' ID:'&$ConnectionUserid[$i]&' login:'&$login&' p:'&$password&' i:'&$i)

			If($ConnectionUserid[$i]='') Then
			   ;TCPSendLogged($Connection[$i][0], "login: ")
			   If $login=''  then
				  $login=StringReplace($PacketType,' ','') ;replace spaces to reduce SQL injection..
				  TCPSendLogged($Connection[$i][0], "Password: ")
			ElseIf $password='' AND $login<>''  Then
				  $password=StringReplace($PacketType,' ','')
				  $ConnectionUserid[$i]=telnetlogin($login,$password,$i)
				  $login=''
				  $password=''
				  If StringLen($ConnectionUserid[$i])>0 then
					 TCPSendLogged($Connection[$i][0], @CRLF&$login&' '&$password&' '&"logged in"&@CRLF)
					; loadmenu($PacketType,$i,$menubranch[$ConnectionSubInstance[$i]])
				 Else
				  $ConnectionUserid[$i]=''
				  TCPCloseSocket($Connection[$i][0])
				  EndIf

			   Else
;
			   EndIf

			 EndIf

			If($TPort[$i]) Then
			   local $item
			If(StringInStr($PacketType,"QUIT",0)) Then
			   TCPSendLogged($Connection[$i][0], "TELNET BYE"&@CRLF)
			   TCPCloseSocket($Connection[$i][0])
			   $ConnectionInstance[$i]=0
			   $ConnectionUserid[$i]='';-1
			   $ConnectionSubInstance[$i]=0
			   $waitingformessagedata[$i]=''
			   $messagedata[$i]=''
			   ;_CheckBadConnection()
			   Return
			Else
			EndIf



;ConsoleWrite(';:'&$PacketType&':')
			If($ConnectionUserid[$i]) Then
;If(Number($PacketType)<9 or StringLen($PacketType)>3) Then   $item=$PacketType

$menubranch[$i]=loadmenu($PacketType,$i,$menubranch[$i])
If $menubranch[$i]='' then

;$messagedata[$i]=_ArrayToString($sqlquery,@TAB)
$item=0
EndIf

EndIf


EndIf

;SMTP server here
			If($SMTPPort[$i]) Then
			If(StringInStr($PacketType,"QUIT",0)) Then
			   TCPSendLogged($Connection[$i][0], "221 BYE"&@CRLF)
			   TCPCloseSocket($Connection[$i][0])
			   $ConnectionInstance[$i]=0
			   $ConnectionSubInstance[$i]=0
			   $waitingformessagedata[$i]=''
			   $messagedata[$i]=''
			   ;_CheckBadConnection()
			   Return
			Else
			EndIf



			   If($waitingformessagedata[$i]) Then
				  $messagedata[$i]=$messagedata[$i]&$PacketType&@CRLF
;MsgBox("","",$messagedata[$i])

				  If(StringInStr($messagedata[$i],@CRLF&'.'&@CRLF,0) ) then

					 TCPSendLogged($Connection[$i][0], "250 Message queued"&@CRLF&"356 Closing connection to receiving server"&@CRLF)
					 ConsoleWrite("250 Message queued:"&$messagedata[$i]&@CRLF)
					 $servicecallid=StringRegExpReplace($messagedata[$i], '[\s\S]*To: Dispatch <|@[\s\S]*', "")
					 $dispatchid=StringRegExpReplace($messagedata[$i], '[\s\S]*Subject: SC| [\s\S]*', "")
					 $servicecallidsum=StringRegExpReplace($messagedata[$i], '[\s\S]*To: Dispatch <|@|.*\.|>[\s\S]*', "")
					 If(BitRotate($servicecallidsum,-1)=$servicecallid) Then
						$messagelen=StringLen($messagedata[$i])
						$scheduledtime=SanitizeText($messagedata[$i], '[\s\S]*Scheduled Date: [\S]* |\r\n[\s\S]*', "")
						If StringLen($scheduledtime) > 6 Then MsgBox("Error scheduledtime",$dispatchid,$scheduledtime);Return
						$workedhours=SanitizeText($messagedata[$i], '[\s\S]*Worked hours: | [\s\S]*', "")
						If StringLen($workedhours) > 4 Then MsgBox("Error workedhours",$dispatchid,$workedhours);Return
						$travelhours=SanitizeText($messagedata[$i], '[\s\S]*Travel hours: |\r\n[\s\S]*', "")
						If StringLen($travelhours) > 4 Then MsgBox("Error travelhours",$dispatchid,$travelhours);Return
						$workdone=SanitizeText($messagedata[$i], '[\s\S]*Work Done: |\r\n\r\n\.\r\n', "")
						;MsgBox("","",$workdone)
						If StringLen($workdone) > $messagelen-10 Then MsgBox("Error",$dispatchid,$workdone);Return ;ConsoleWrite(StringLen($workdone)&$messagelen&" bad")
						;MsgBox("","",$workdone)
						$query="UPDATE servicecall SET starttime='"&$scheduledtime&"',time='"&$workedhours&"',traveltime='"&$travelhours&"',solution='"&$workdone&"' WHERE servicecall.id='"&$servicecallid&"'"
						ConsoleWrite($query&@CRLF)
						;MsgBox("","","OK")
						_SQLExec($query)
						ConsoleWrite("Calling PDFWrite "&$dispatchid&@CRLF)
						PDF_ServiceCall($dispatchid)
						ShellExecute($dispatchdir&(StringFormat('%08i',number($dispatchid)))&'.pdf')
						SendSMTPeMail($dispatchid)
						Return
					 EndIf

					 $waitingformessagedata[$i]=''
					 $messagedata[$i]=''
					 $Connection[$i][2]=''

			   TCPCloseSocket($Connection[$i][0])
			   $ConnectionInstance[$i]=0
			   $ConnectionSubInstance[$i]=0
			   $waitingformessagedata[$i]=''
			   $messagedata[$i]=''
			   ;CheckBadConnection()
				  EndIf
				Return
			 EndIf
			If(StringInStr($PacketType,"DATA",0)) Then
			   TCPSendLogged($Connection[$i][0], "354 End data with <CR><LF>."&@CRLF)
			   $waitingformessagedata[$i]=1
			Return
			EndIf
			   If(StringInStr($PacketType,"EHLO",0)) Then
				  ;MsgBox("","","")
				  TCPSendLogged($Connection[$i][0], "250-samhobbs says hello"&@CRLF)
				  TCPSendLogged($Connection[$i][0], "250-PIPELINING"&@CRLF)
				  TCPSendLogged($Connection[$i][0], "250-SIZE 10240000"&@CRLF)
				  TCPSendLogged($Connection[$i][0], "250-VRFY"&@CRLF)
				  TCPSendLogged($Connection[$i][0], "250-ETRN"&@CRLF)
				  ;TCPSendLogged($Connection[$i][0], "250-STARTTLS"&@CRLF)
				  TCPSendLogged($Connection[$i][0], "250-AUTH PLAIN LOGIN"&@CRLF)
				  TCPSendLogged($Connection[$i][0], "250-AUTH LOGIN CRAM-MD5"&@CRLF)
				  TCPSendLogged($Connection[$i][0], "250-ENHANCEDSTATUSCODES"&@CRLF)
				  TCPSendLogged($Connection[$i][0], "250-8BITMIME"&@CRLF)
				  TCPSendLogged($Connection[$i][0], "250 DSN"&@CRLF)
				  Return
			EndIf
			If(StringInStr($PacketType,"AUTH",0)) Then
			   TCPSendLogged($Connection[$i][0], "235 2.7.0 Authentication successful"&@CRLF)
			   Return
			EndIf
			If(StringInStr($PacketType,"MAIL FROM:",0)) Then
			   TCPSendLogged($Connection[$i][0], "250 Ok"&@CRLF)
			   Return
			EndIf
			If(StringInStr($PacketType,"RCPT TO:",0)) Then
			   TCPSendLogged($Connection[$i][0], "250 Ok"&@CRLF)
			   Return
			EndIf


			EndIf

;IMAP server here
			$ID=StringRegExpReplace($PacketType," .*","")
			If(StringInStr($PacketType,"CAPABILITY",0)) Then
			   TCPSendLogged($Connection[$TotalConnections][0], "* "&$CAPABILITY2&@CRLF&$ID&" OK CAPABILITY completed"&@CRLF)
			   ;;;TCPSendLogged($Connection[$TotalConnections][0], $ID&" OK [CAPABILITY IMAP4rev1 LITERAL+ SASL-IR LOGIN-REFERRALS ID ENABLE noIDLE SORT SORT=DISPLAY THREAD=REFERENCES THREAD=REFS THREAD=ORDEREDSUBJECT MULTIAPPEND URL-PARTIAL CATENATE UNSELECT DISTINCT CHILDREN NAMESPACE UIDPLUS LIST-EXTENDED I18NLEVEL=1 CONDSTORE QRESYNC ESEARCH ESORT SEARCHRES WITHIN CONTEXT=SEARCH LIST-STATUS BINARY MOVE SPECIAL-USE QUOTA] Logged in"&@CRLF)
			Return
			EndIf
login($PacketType,$i)

			If(StringInStr($PacketType,"LOGOUT",0)) Then
			   TCPSendLogged($Connection[$i][0], "BYE"&@CRLF)
			   TCPCloseSocket($Connection[$i][0])
			   $ConnectionInstance[$i]=0
			   $ConnectionSubInstance[$i]=0
			   ;_CheckBadConnection()
			   Return
			EndIf



			If(StringInStr($PacketType,"NAMESPACE",0)) Then
			   ;;ConsoleWrite($PacketType)
			   ;TCPSendLogged($Connection[$i][0], "* NAMESPACE (("""" ""."")) NIL NIL"&@CRLF)
			   TCPSendLogged($Connection[$i][0], "* NAMESPACE ((""Inbox/"" ""/""))"&@CRLF)
			   ;TCPSendLogged($Connection[$i][0], "* NAMESPACE ((""Drafts/"" ""/""))"&@CRLF)
			   ;TCPSendLogged($Connection[$i][0], "* NAMESPACE ((""Sent/"" ""/""))"&@CRLF)
			   ;;* NAMESPACE (("" "/")("#mhDrafts" NIL)("#mh/" "/")) (("~" "/")) (("#shared/" "/")("#ftp/" "/")("#news." ".")("#public/" "/"))
			   TCPSendLogged($Connection[$i][0], $ID&" OK Namespace completed"&@CRLF)
			   Return
			EndIf

			If(StringInStr($PacketType,"list ",0) AND StringInStr($PacketType,"inbox",0)) Then

			   If(StringInStr($PacketType,"%",0) OR StringInStr($PacketType,"*",0)) Then
			   TCPSendLogged($Connection[$i][0], "* LIST (\NoInferiors) NIL Inbox"&@CRLF)
			   TCPSendLogged($Connection[$i][0], "* LIST (\NoInferiors) NIL Junk"&@CRLF)
			   TCPSendLogged($Connection[$i][0], "* LIST (\NoInferiors) NIL Trash"&@CRLF)
			   TCPSendLogged($Connection[$i][0], "* LIST (\NoInferiors) NIL Drafts"&@CRLF)
			   TCPSendLogged($Connection[$i][0], "* LIST (\NoInferiors) NIL Sent"&@CRLF)
			   EndIf

			   Select
				  Case StringInStr($PacketType,"inbox",0)
					 TCPSendLogged($Connection[$i][0], "* LIST (\NoInferiors) NIL Inbox"&@CRLF)
				  Case StringInStr($PacketType,"sent",0)
					 TCPSendLogged($Connection[$i][0], "* LIST (\NoInferiors) NIL Sent"&@CRLF)
				  Case StringInStr($PacketType,"drafts",0)
					 TCPSendLogged($Connection[$i][0], "* LIST (\NoInferiors) NIL Drafts"&@CRLF)
				  Case StringInStr($PacketType,"trash",0)
					 TCPSendLogged($Connection[$i][0], "* LIST (\NoInferiors) NIL Trash"&@CRLF)
				  Case StringInStr($PacketType,"junk",0)
					 TCPSendLogged($Connection[$i][0], "* LIST (\NoInferiors) NIL Junk"&@CRLF)
				  EndSelect
			   ;;TCPSendLogged($Connection[$i][0], "* LIST (\Subscribed) ""."" Archive"&@CRLF)
			   TCPSendLogged($Connection[$i][0], $ID&" OK List completed"&@CRLF)
			   return
			EndIf


			If(StringInStr($PacketType,"list ",0)) Then
			   ;;ConsoleWrite("--"&$PacketType&@CRLF) ;* LIST (\NoInferiors) NIL INBOX
			   ;TCPSendLogged($Connection[$i][0], "* LIST (\Subscribed \Drafts) ""."" Drafts"&@CRLF)
			   TCPSendLogged($Connection[$i][0], "* LIST (\NoInferiors) NIL Inbox"&@CRLF)
			   TCPSendLogged($Connection[$i][0], "* LIST (\NoInferiors) NIL Sent"&@CRLF)
			   TCPSendLogged($Connection[$i][0], "* LIST (\NoInferiors) NIL Drafts"&@CRLF)
			   ;;TCPSendLogged($Connection[$i][0], "* LIST (\Subscribed) ""."" Archive"&@CRLF)
			   TCPSendLogged($Connection[$i][0], $ID&" OK List completed"&@CRLF)
			   return
			EndIf


			If(StringInStr($PacketType,"SELECT ",0) OR StringInStr($PacketType,"EXAMINE",0) AND StringInStr($PacketType,"Drafts",0)) Then
			   Local $sqlresult[0]  ;6 select "Inbox/Drafts"
			   $query="SELECT DISTINCT servicecall.id FROM servicecall INNER JOIN dispatch ON dispatch.id = servicecall.dispatchid WHERE servicecall.disabled='0' AND servicecall.userid='"&$ConnectionSubInstance[$i]&"' AND dispatch.status='2' ORDER BY servicecall.id DESC LIMIT 1"
			   $sqlresult=_SQLQueryRows($query)
;MsgBox("","","")


			   TCPSendLogged($Connection[$i][0], "* "&$sqlresult[1]&" EXISTS"&@CRLF)
			   TCPSendLogged($Connection[$i][0], "* 0 RECENT"&@CRLF)
			   TCPSendLogged($Connection[$i][0], "* OK [UIDVALIDITY "&$sqlresult[1]&"] UID validity status"&@CRLF) ;1661719443
			   TCPSendLogged($Connection[$i][0], "* OK [UIDNEXT "&$sqlresult[1]&"] Predicted next UID"&@CRLF)
			   TCPSendLogged($Connection[$i][0], "* FLAGS (\Answered \Flagged \Deleted \Draft \Seen)"&@CRLF)
			   TCPSendLogged($Connection[$i][0], "* OK [PERMANENTFLAGS (\Answered \Flagged \Deleted \Seen \Draft \*)] Flags permitted."&@CRLF)

			If StringInStr($PacketType,"EXAMINE",0) Then
			   TCPSendLogged($Connection[$i][0], $ID&" OK [READ ONLY] EXAMINE completed"&@CRLF)
			Else
			  TCPSendLogged($Connection[$i][0], $ID&" OK [READ-WRITE] SELECT completed"&@CRLF)
			EndIf
			   Return
			EndIf

			If(StringInStr($PacketType,"SELECT ",0) OR StringInStr($PacketType,"EXAMINE ",0) ) Then
			   TCPSendLogged($Connection[$i][0], $ID&" OK completed"&@CRLF)
			   Return
			EndIf

			;5 getquotaroot "INBOX"
			If(StringInStr($PacketType,"getquotaroot",0)) Then
			   $parsedcommand=StringSplit($PacketType,'([ "])')
			   $parsedcommand=_ArrayUnique($parsedcommand)
			   TCPSendLogged($Connection[$i][0], "* QUOTAROOT "&$parsedcommand[5]&" ""User quota"""&@CRLF)
			   TCPSendLogged($Connection[$i][0], "* QUOTA ""User quota"" (STORAGE 16353 1048576)"&@CRLF)
			   TCPSendLogged($Connection[$i][0], $ID&" OK Getquotaroot completed"&@CRLF)
			   Return
			EndIf


			If(StringInStr($PacketType,"FETCH",0) AND StringInStr($PacketType,"(UID)",0)) Then
			   $UID='1';Number(StringRegExpReplace($PacketType, " \(.*|.*\* ", "")) ;| pipe one into next
			   TCPSendLogged($Connection[$i][0], "* "&$UID&" FETCH (UID "&$UID&")"&@CRLF&$ID&" OK Fetch completed"&@CRLF)
			   Return
			EndIf
;17 UID FETCH 10,4,3,2 (UID FLAGS INTERNALDATE RFC822.SIZE BODY.PEEK[HEADER.FIELDS (date subject from content-type to cc reply-to message-id references in-reply-to X-K9mail-Identity Chat-Version)])

			If(StringInStr($PacketType,"UID fetch ",0) AND StringInStr($PacketType,":* (FLAGS)",0) OR StringInStr($PacketType,":* (UID FLAGS)",0)) Then ;;3 UID fetch 1:* (FLAGS)
			   Local $sqlresult=''
			   $sqlresult=ListUserID($i)
			   ;;MsgBox("","","")
			   $send=''

			   ;_ArrayDisplay($sqlresult)
			   ;;_ArraySort($sqlresult,1,1)
			   $UID=1
			   do
				  $UID+=1
				  $send=$send&"* "&$UID&" FETCH (UID "&$sqlresult[$UID-1]&" FLAGS (\Seen \Draft))"&@CRLF ; \Answered
			   Until $UID=UBound($sqlresult)

			   TCPSendLogged($Connection[$i][0], $send&$ID&" OK UID FETCH completed"&@CRLF)
			   ;;ConsoleWrite($send)
			   Return
			EndIf

			If(StringInStr($PacketType,"IDLE",0)) Then
			   TCPSendLogged($Connection[$i][0], $ID&" OK Idle completed"&@CRLF)
			   Return
			EndIf
	;3 create "Sent"
			If(StringInStr($PacketType,"CREATE",0)) Then
			   TCPSendLogged($Connection[$i][0], $ID&" NO create completed"&@CRLF)
			   Return
			EndIf

			;UID fetch 3,2 (UID RFC822.SIZE FLAGS BODY.PEEK[HEADER.FIELDS (From To Cc Bcc Subject Date Message-ID Priority X-Priority References Newsgroups In-Reply-To Content-Type Reply-To)])
;UID fetch 2,3 (UID RFC822.SIZE FLAGS BODY.PEEK[HEADER.FIELDS (From To Cc Bcc Subject Date Message-ID Priority X-Priority References Newsgroups In-Reply-To Content-Type Reply-To)])

;UID fetch 2:3,5 1:3,5
;;UID BAD Bogus sequence in FETCH: Sequence out of range

;14 UID fetch 3 (UID RFC822.SIZE BODY[])
;5 uid store 1 +Flags (\Seen \Deleted)

			If(StringInStr($PacketType,"UID fetch ",0)) Then
			   Local $sqlresult[0]
			   Local $UIDlist[0]
			   Local $UIDrange[0]
			   Local $UID[0]

			   $UIM=StringSplit($PacketType,"( )")
			   $UIM = StringSplit($UIM[4], ",", 1)
			   ;_ArrayDisplay($UIM)
			   ;MsgBox($UIM[1],$UIM[1],$UIM[1])
			   ;_ArrayAdd($UIDlist,1)
			   $sqlresult=ListUserSC($i)
			   ;;ConsoleWrite($query&@CRLF)
			   $send=''
			   for $x=1 to UBound($UIM)-1
					 $UIDrange=StringSplit($UIM[$x], ":", 1)
				  If UBound($UIDrange)>2 then
					 for $y=$UIDrange[1] to $UIDrange[2]
						;_ArrayDisplay($UIDlist)
						;;ConsoleWrite($y&_ArraySearch($sqlresult,$y,1)&@CRLF)
						If(_ArraySearch($sqlresult	,Number($y),1)>0 AND $UIDrange[1]<>$UIDrange[2]) then
						   _ArrayAdd($UIDlist,Number($y))
						EndIf
					 Next
					 Else
						_ArrayAdd($UIDlist,$UIDrange[1])
					 EndIf
			   Next
		 ;;_ArraySort($UIDlist,0,0,1)
			   $UIDlist=_ArrayUnique($UIDlist)

			   ;$UIDlist=_ArrayReverse($UIDlist)

			;_ArrayDisplay($UIDlist)
			 ;_ArrayDisplay($sqlresult)

$x=1
do
  $msgUID=_ArraySearch($sqlresult,$UIDlist[$x])
				  ConsoleWrite($msguid&@CRLF)
				  ConsoleWrite($sqlresult[$msguid][0]&@CRLF)
				  $headerfields=StringUpper(StringRegExpReplace($PacketType, '\)(.*)|(.*) \(', ""))
				  $parsedcommand=StringSplit($PacketType, '([])')
				  $parsedcommand=_ArrayUnique($parsedcommand)

				  If(UBound($parsedcommand)>2) Then
					 $dataitems=StringSplit($parsedcommand[3], ' ')
					 $MSGSUBJECT="SC"& $sqlresult[$msguid][1] &" " & $sqlresult[$msguid][2] &", " & $sqlresult[$msguid][3]
					 $MSGBODY=" SC"&$sqlresult[$msguid][1]&" Issue: "&$sqlresult[$msguid][4]&@CRLF&"Company: "&$sqlresult[$msguid][2]&", "&$sqlresult[$msguid][3]&@CRLF&@CRLF&"Reported by: "&$sqlresult[$msguid][5]&@CRLF&"Phone: "&$sqlresult[$msguid][6]&@CRLF&"Notes: "&$sqlresult[$msguid][7]&@CRLF&@CRLF&"Scheduled Date: "&$sqlresult[$msguid][9]&" "&$sqlresult[$msguid][10]&@CRLF&"Worked hours: "&$sqlresult[$msguid][11]&" Travel hours: "&$sqlresult[$msguid][12]&@CRLF&"Work Done: "&$sqlresult[$msguid][13]

					 If(StringInStr($PacketType,"BODY[",0) OR StringInStr($PacketType,"[]",0)) Then ;&@CRLF&"multipart/mixed; boundary=""===Message_0123456789"""
					   $MMM="To: ""Dispatch"" <"&$sqlresult[$msguid][0]&"@"&$sqlresult[$msguid][1]&"."&BitRotate($sqlresult[$msguid][0])&">"&@CRLF&"From: ""Dispatch"" <"&$sqlresult[$msguid][0]&"@"&$sqlresult[$msguid][1]&"."&BitRotate($sqlresult[$msguid][0])&">"&@CRLF&"Subject: "&$MSGSUBJECT&@CRLF&"User-Agent: K-9 Mail for Android"&@CRLF&"Date: Sun, 28 Aug 2022 16:47:29 -0400"&@CRLF&'INTERNALDATE: "28-Aug-2022 16:47:29 -0400"'&@CRLF&"Message-ID: <"&BitRotate($sqlresult[$msguid][0])&"@localhost>"&@CRLF&"MIME-Version: 1.0"&@CRLF&"Content-Type: text/plain; charset=utf-8; format=flowed"&@CRLF&"Content-Transfer-Encoding: quoted-printable"&@CRLF&"Content-Language: en-US"&@CRLF&@CRLF&$MSGBODY&@CRLF
					 Else
					   $MMM="From: ""Dispatch"" <"&$sqlresult[$msguid][0]&"@"&$sqlresult[$msguid][1]&"."&BitRotate($sqlresult[$msguid][0])&">"&@CRLF&"From: ""Dispatch"" <"&$sqlresult[$msguid][0]&"@"&$sqlresult[$msguid][1]&"."&BitRotate($sqlresult[$msguid][0])&">"&@CRLF&"Subject: "&$MSGSUBJECT&", "&@CRLF&"Date: Sun, 28 Aug 2022 16:47:29 -0400"&@CRLF&'INTERNALDATE: "28-Aug-2022 16:47:29 -0400"'&@CRLF&"Message-ID: <"&BitRotate($sqlresult[$msguid][0])&"@localhost>"&@CRLF&"Content-Type: text/plain; charset=utf-8; format=flowed"&@CRLF
					 EndIf
					 $MSGSIZE=StringLen($MMM)+2

					 $commandout=''
					 $z=1
					 ;_ArrayDisplay($dataitems)
					 Do
						If($dataitems[$z]='UID') then $commandout=$commandout&'UID '&$sqlresult[$msguid][0]&" "
						If($dataitems[$z]='FLAGS') then $commandout=$commandout&'FLAGS (\Seen \Draft)'&" "
						If($dataitems[$z]='INTERNALDATE') then $commandout=$commandout&'INTERNALDATE "28-Aug-2022 16:47:29 -0400"'&" "
						If($dataitems[$z]='RFC822.SIZE') then $commandout=$commandout&'RFC822.SIZE '&$MSGSIZE&" "
						If($dataitems[$z]='BODY.PEEK') then
						   $commandout=$commandout&'BODY[HEADER.FIELDS ('&$headerfields&')] {'&$MSGSIZE&'}'&@CRLF&$MMM&@CRLF&")"
						   ;7 UID fetch 2:4 (UID RFC822.SIZE BODY.PEEK[])
						ElseIf($dataitems[$z]='BODY') then
						   $commandout=$commandout&'BODY[] {'&$MSGSIZE&'}'&@CRLF&$MMM&@CRLF&")"
						EndIf
						$z += 1
					 Until $z = UBound($dataitems)
					 				  $send="* "&$msgUID&" FETCH ("&$commandout
				  TCPSendLogged($Connection[$i][0], $send&@CRLF)
				  ;;ConsoleWrite($send&@CRLF)
				  EndIf
$x+=1
Until $msgUID=_ArraySearch($sqlresult,($UIDlist[UBound($UIDlist)-1]))

			   TCPSendLogged($Connection[$i][0], $ID&" OK UID FETCH completed"&@CRLF)
			   ;;ConsoleWrite($ID&" OK UID FETCH completed"&@CRLF)
			   Return

			EndIf


			If(StringInStr($PacketType,"EXPUNGE",0)) Then
			   ;;ConsoleWrite($PacketType)
			   TCPSendLogged($Connection[$i][0], $ID&" NO EXPUNGE completed"&@CRLF)
			   Return
			EndIf

			If(StringInStr($PacketType,"CLOSE",0)) Then
			   ;;ConsoleWrite("CLOSE")
			   TCPSendLogged($Connection[$i][0], $ID&" OK CLOSE Completed"&@CRLF)
			   Return
			EndIf
			If(StringInStr($PacketType,"DONE",0)) Then ;;no done
			   ;;ConsoleWrite("DONE")
			   TCPSendLogged($Connection[$i][0], $ID&" OK DONE Completed"&@CRLF)
			   Return
			EndIf
			If(StringInStr($PacketType,"LOGOUT",0)) Then ;imap logout
			   TCPSendLogged($Connection[$i][0], "BYE"&@CRLF)
			   $ConnectionInstance[$i]=0
			   $ConnectionSubInstance[$i]=0
			   ;_CheckBadConnection()
			   Return
			EndIf
			If(StringInStr($PacketType,"SUBSCRIBE",0)) Then
			   ;;ConsoleWrite("SUBSCRIBE")
			  ; TCPSendLogged($Connection[$i][0], "* LIST (HasNoChildren) ""/"" ""Drafts"""&@CRLF)
			  ; TCPSendLogged($Connection[$i][0], $ID&" OK SUBSCRIBE Completed"&@CRLF)
			   TCPSendLogged($Connection[$i][0], $ID&" NO SUBSCRIBE Completed"&@CRLF)
			   Return
			EndIf
			If(StringInStr($PacketType,"COMPRESS",0)) Then
			   ;;ConsoleWrite("COMPRESS")
			   TCPSendLogged($Connection[$i][0], $ID&" OK COMPRESS Completed"&@CRLF)
			   Return
			EndIf



			If(StringInStr($PacketType,"SELECT ",0)) Then ;outlook 2016
			   $parsedcommand=StringSplit($PacketType,'([ "])')
			   _ArrayDisplay($parsedcommand)
			   TCPSendLogged($Connection[$i][0], $ID&" OK [READ-WRITE] Select completed"&@CRLF)
			   Return
			EndIf
			If(StringInStr($PacketType,"create ""Trash""",0)) Then ;outlook 2016
			   TCPSendLogged($Connection[$i][0], $ID&" OK [READ-WRITE] Select completed"&@CRLF)
			   Return
			EndIf
			If(StringInStr($PacketType,"create ""Archive""",0)) Then ;outlook 2016
			   TCPSendLogged($Connection[$i][0], $ID&" OK [READ-WRITE] Select completed"&@CRLF)
			   Return
			EndIf

			If(StringInStr($PacketType,"SELECT ""Drafts""",0)) Then ;outlook 2016
			   ;;ConsoleWrite("...SELECT DISTINCT ""Drafts""......")
			   TCPSendLogged($Connection[$i][0], $ID&" OK [READ-WRITE] Select completed"&@CRLF)
			   Return
			EndIf

			;uid store 1 +Flags (\Seen)
			If(StringInStr($PacketType,"UID STORE ",0)) Then ;ALL
			   TCPSendLogged($Connection[$i][0], $ID&" NO STORE completed (Success)"&@CRLF)
			   ;;ConsoleWrite($ID&" OK STORE completed (Success)")
			   Return
			EndIf
			;4 UID SEARCH 1:1 NOT DELETED

			If(StringInStr($PacketType,"UID SEARCH ",0)) Then ;ALL
			   $parsedcommand=StringSplit($PacketType, '([ ])')
			   ;_ArrayDisplay($parsedcommand)
			   $range=StringSplit($parsedcommand[4], ':')
			   $query="SELECT servicecall.id FROM servicecall INNER JOIN dispatch ON dispatch.id = servicecall.dispatchid WHERE servicecall.id>='"&$range[1]&"' AND servicecall.id<='"&$range[2]&"' AND servicecall.status>'2' AND servicecall.userid='"&$ConnectionSubInstance[$i]&"' AND dispatch.status='2'"
			   ConsoleWrite($query&@CRLF)
			   $sqlresult=_SQLQueryRows($query)
			   $send=''
			   ;_ArrayDisplay($sqlresult)

			   for $UID=$sqlresult[1] to UBound($sqlresult)-1 step 1
				  ;If($sqlresult[$UID]=$range[1]) Then
				  $send=$send&String($sqlresult[$UID])&" "
				  ;EndIf
			   Next
			   $send=StringStripWS($send,2)
			   TCPSendLogged($Connection[$i][0], "* SEARCH "&$send&@CRLF)
			   TCPSendLogged($Connection[$i][0], $parsedcommand[1]&" OK SEARCH completed (Success)"&@CRLF)
			   Return
			EndIf

			If(StringInStr($PacketType,"STATUS ""Drafts""",0)) Then
			   $commandout=''
				  $parsedcommand=StringSplit($PacketType, '([ ])')

			   ;TCPSendLogged($Connection[$i][0],$parsedcommand[0]&" BAD"&@CRLF)
			   ;Return
				  If(UBound($parsedcommand)>3) Then
					 $z=4
					 Do
						If($parsedcommand[$z]='UIDNEXT') then
						   $commandout=$commandout&'UIDNEXT 1'&" "
						ElseIf($parsedcommand[$z]='MESSAGES') then
						   $commandout=$commandout&'MESSAGES 1'&" "
						ElseIf($parsedcommand[$z]='UNSEEN') then
						   $commandout=$commandout&'UNSEEN 0'&" "
						ElseIf($parsedcommand[$z]='RECENT') then
						   $commandout=$commandout&'RECENT 0'&" "
						ElseIf($parsedcommand[$z]='UIDVALIDITY') then
						   $commandout=$commandout&'UIDVALIDITY 1'&" "
						EndIf
						$z += 1
					 Until $z = UBound($parsedcommand)
					 $commandout='('&StringStripWS($commandout,2)&')'
				  EndIf


			   TCPSendLogged($Connection[$i][0], "* STATUS "&"Drafts "&$commandout&@CRLF)
			   ;;ConsoleWrite("* STATUS "&"Drafts "&$commandout&@CRLF)
			   TCPSendLogged($Connection[$i][0],$parsedcommand[0]&" OK STATUS completed (Success)"&@CRLF)
			   ;;ConsoleWrite($parsedcommand[0]&" OK STATUS completed (Success)"&@CRLF)
			   Return
			EndIf
			If(StringInStr($PacketType,"STATUS ""Inbox""",0)) Then
			   $commandout=''
				  $parsedcommand=StringSplit($PacketType, '([ ])')

				  If(UBound($parsedcommand)>3) Then
					 $z=4
					 Do
						If($parsedcommand[$z]='UIDNEXT') then
						   $commandout=$commandout&'UIDNEXT 0'&" "
						ElseIf($parsedcommand[$z]='MESSAGES') then
						   $commandout=$commandout&'MESSAGES 0'&" "
						ElseIf($parsedcommand[$z]='UNSEEN') then
						   $commandout=$commandout&'UNSEEN 0'&" "
						ElseIf($parsedcommand[$z]='RECENT') then
						   $commandout=$commandout&'RECENT 0'&" "
						ElseIf($parsedcommand[$z]='UIDVALIDITY') then
						   $commandout=$commandout&'UIDVALIDITY 0'&" "
						EndIf
						$z += 1
					 Until $z = UBound($parsedcommand)
					 $commandout='('&StringStripWS($commandout,2)&')'
				  EndIf


			   TCPSendLogged($Connection[$i][0], "* STATUS "&"Inbox "&$commandout&@CRLF)
			   ;;ConsoleWrite("* STATUS "&"Inbox "&$commandout&@CRLF)
			   TCPSendLogged($Connection[$i][0],$parsedcommand[0]&" OK STATUS completed (Success)"&@CRLF)
			   ;;ConsoleWrite($parsedcommand[0]&" OK STATUS completed (Success)"&@CRLF)
			   Return
			EndIf
			If(StringInStr($PacketType," ID ",0)) Then
			   TCPSendLogged($Connection[$i][0], "* ID (""name"" ""Dovecot"")"&@CRLF)
			   TCPSendLogged($Connection[$i][0], $ID&" OK ID completed"&@CRLF)
			   Return
			EndIf

;;7ycz UID STORE 2:3 +FLAGS.SILENT (\Deleted \Seen)
;;6 UID SEARCH 1:1 NOT DELETED
;1hdx APPEND "Drafts" (\Seen \Draft) "28-Aug-2022 16:47:29 -0400" {863}
			If(StringInStr($PacketType,"APPEND",0)) Then
			   ;TCPSendLogged($Connection[$i][0], "+ Ready for literal data"&@CRLF)
			   TCPSendLogged($Connection[$i][0], $ID&" NO APPEND completed"&@CRLF)
			   Return
			EndIf

			If(StringInStr($PacketType,"NOOP",0) OR StringInStr($PacketType,"CHECK",0)) Then
			   TCPSendLogged($Connection[$i][0], $ID&" OK (Success)"&@CRLF)
			   Return
			EndIf
			If(StringInStr($PacketType,"LSUB",0)) Then
			   TCPSendLogged($Connection[$i][0], $ID&" OK LSUB Completed"&@CRLF)
			   Return
			EndIf
			If(StringInStr($PacketType,"LSUB """" ""*""",0)) Then
			   ;;ConsoleWrite($PacketType)
			   TCPSendLogged($Connection[$i][0], $ID&" OK LSUB Completed"&@CRLF)
			   ;;ConsoleWrite($Connection[$i][0])
			   Return
			EndIf
			If(StringInStr($PacketType,"RENAME",0)) Then
			   ;;ConsoleWrite($PacketType)
			   TCPSendLogged($Connection[$i][0], $ID&" OK Success"&@CRLF)
			   Return
			EndIf
			If(StringInStr($PacketType,"UNSUBSCRIBE",0)) Then
			   ;;ConsoleWrite($PacketType)
			   TCPSendLogged($Connection[$i][0], $ID&" OK UNSUBSCRIBE Completed"&@CRLF)
			   Return
			EndIf

			If(StringInStr($PacketType,"ENABLE",0)) Then ;ENABLE UTF8=ACCEPT
			   ;;ConsoleWrite($PacketType)
			   TCPSendLogged($Connection[$i][0], $ID&" OK Enabled"&@CRLF)
			   Return
			EndIf

;			_ProcessFullPacket($CompletePacket, $PacketType, $i)
		EndIf
	Next
EndFunc   ;==>_CheckNewPackets


Func _ServerListenStart() ; Starts listening.
	If $SocketListen <> -1 OR $SocketListenSMTP <> -1 OR $SocketListenT <> -1 Then
		MsgBox(16, "Error", "Socket already open.")
		Return
	Else
		$SocketListen = TCPListen($BindIP, $BindPort, $MaxConnections) ; Starts listening.
		If $SocketListen = -1 Then
			MsgBox(16, "Error", "Unable to open socket.")
		EndIf
		$SocketListenSMTP = TCPListen($BindIP, $BindPortSMTP, $MaxConnections) ; Starts listening.
		If $SocketListenSMTP = -1 Then
			MsgBox(16, "Error", "Unable to open socket.")
		EndIf
		$SocketListenT = TCPListen($BindIP, $BindPortT, $MaxConnections) ; Starts listening.
		If $SocketListenT = -1 Then
			MsgBox(16, "Error", "Unable to open socket.")
		EndIf
	EndIf
EndFunc

Func _ServerListenStop() ; Stops listening.
	If $SocketListen = -1 Then
		MsgBox(16, "Error", "Socket already closed.")
		Return
	EndIf
	TCPCloseSocket($SocketListen)
	$SocketListen = -1

EndFunc   ;==>_ServerListenStop

Func _ServerClose() ; Exits properly.
	If $TotalConnections >= 1 Then
		For $i = 1 To $TotalConnections
			TCPSendLogged($Connection[$i][0], "SERVER_SHUTDOWN")
			TCPCloseSocket($Connection[$i][0])
		Next
	EndIf
	TCPShutdown()
	_GDIPlus_Shutdown()
	_Crypt_Shutdown()
	DllClose($NTDLL)
	DllClose($WS2_32)
	GUIDelete($GUI)
	_SQLite_Close()
	Exit
 EndFunc   ;==>_ServerClose


Func _SocketToIP($SHOCKET) ; IP of the connecting client.
	Local $sockaddr = DllStructCreate("short;ushort;uint;char[8]")
	Local $aRet = DllCall($WS2_32, "int", "getpeername", "int", $SHOCKET, "ptr", DllStructGetPtr($sockaddr), "int*", DllStructGetSize($sockaddr))
	If Not @error And $aRet[0] = 0 Then
		$aRet = DllCall($WS2_32, "str", "inet_ntoa", "int", DllStructGetData($sockaddr, 3))
		If Not @error Then $aRet = $aRet[0]
	Else
		$aRet = 0
	EndIf
	$sockaddr = 0
	Return $aRet
EndFunc   ;==>_SocketToIP

Func _Sleep($MicroSeconds, $NTDLL = "ntdll.dll") ; Faster sleep than Sleep().
	Local $DllStruct
	$DllStruct = DllStructCreate("int64 time;")
	DllStructSetData($DllStruct, "time", -1 * ($MicroSeconds * 10))
	DllCall($NTDLL, "dword", "ZwDelayExecution", "int", 0, "ptr", DllStructGetPtr($DllStruct))
EndFunc   ;==>_Sleep

Func _ConnectionKill()
	Local $selected = GUICtrlRead(GUICtrlRead($ServerList))
	If Not $selected <> "" Then
		MsgBox(16, "Error", "Please select a connection first.")
		Return
	EndIf
	Local $StringSplit = StringSplit($selected, "|", 1)
	;;ConsoleWrite($selected)
	TCPCloseSocket($Connection[$StringSplit[1]][0])
EndFunc   ;==>_ConnectionKill

Func _ConnectionKillAll()
	If $TotalConnections >= 1 Then
		For $i = 1 To $MaxConnections
			If $Connection[$i][0] > 0 Then
				TCPSendLogged($Connection[$i][0], "SERVER_SHUTDOWN")
				TCPCloseSocket($Connection[$i][0])
			EndIf
		Next
	EndIf
 EndFunc   ;==>_ConnectionKillAll

Func TCPSendLogged($connection, $string)
   TCPSend($connection, $string)
   ConsoleWrite(">>"&$string&@CRLF)
EndFunc

Func sha1($message)
    Return _Crypt_HashData($message, $CALG_SHA1)
EndFunc

Func md5($message)
    Return _Crypt_HashData($message, $CALG_MD5)
EndFunc

Func hmac($key, $message, $hash="md5")
    Local $blocksize = 64
    Local $a_opad[$blocksize], $a_ipad[$blocksize]
    Local Const $oconst = 0x5C, $iconst = 0x36
    Local $opad = Binary(''), $ipad = Binary('')
    $key = Binary($key)
    If BinaryLen($key) > $blocksize Then $key = Call($hash, $key)
    For $i = 1 To BinaryLen($key)
        $a_ipad[$i-1] = Number(BinaryMid($key, $i, 1))
        $a_opad[$i-1] = Number(BinaryMid($key, $i, 1))
    Next
    For $i = 0 To $blocksize - 1
        $a_opad[$i] = BitXOR($a_opad[$i], $oconst)
        $a_ipad[$i] = BitXOR($a_ipad[$i], $iconst)
    Next
    For $i = 0 To $blocksize - 1
        $ipad &= Binary('0x' & Hex($a_ipad[$i],2))
        $opad &= Binary('0x' & Hex($a_opad[$i],2))
    Next
    Return Call($hash, $opad & Call($hash, $ipad & Binary($message)))
 EndFunc

Func _ImportDB()
Local $filename='db.sql'
Local $sOut
   _SQLite_Close()

Local $filename = FileOpenDialog("Select Input File", @ScriptDir & "\", "SQL File (*.sql)", $FD_FILEMUSTEXIST)
If @error Then MsgBox($MB_SYSTEMMODAL, "", "No file(s) were selected.")

;_SQLite_SQLiteExe($databasefile, "drop table If exists `address`;drop table If exists `contacts`;drop table If exists `dispatch`;drop table If exists `equipment`;drop table If exists `servicecall`;drop table If exists `status`;drop table If exists `user`;", $sOut, $sqlite3_exe, True)
FileDelete($databasefile)
If @error Then
    MsgBox($MB_SYSTEMMODAL, "SQLite Info", "Erase Failed")
    Exit -1
 EndIf
_SQL_Startup($databasefile)
$query=".read '"&$filename&"'"
ConsoleWrite($query)
_SQLite_SQLiteExe($databasefile, $query, $sOut, $sqlite3_exe, False)
If @error Then
    MsgBox($MB_SYSTEMMODAL, "SQLite Info", "Import Failed"&$sOut)
    Exit -1
 EndIf


EndFunc

Func _ImportCSV()
   _SelectForm(1)
EndFunc

Func _ExportCSV()
   _SelectForm(0)
EndFunc

Func _ExportDB()
Local $filename='db.sql'
Local $sOut
   ;_SQLite_Close()

Local $filename = FileSaveDialog("Select Output File", @ScriptDir & "\", "SQL File (*.sql)", '')
If @error Then MsgBox($MB_SYSTEMMODAL, "", "No file(s) were selected.")

_SQLite_SQLiteExe($databasefile, '.dump', $sOut, $sqlite3_exe, True)
If @error Then
    MsgBox($MB_SYSTEMMODAL, "SQLite Info", "Operation Failed")
    Exit -1
EndIf
   $hFileOpen = FileOpen($filename, 2)
   FileWrite($hFileOpen,$sOut)
   FileClose($hFileOpen)
_SQL_Startup($databasefile)

EndFunc
Func _ConnectionCheck()
_CheckBadConnection()
EndFunc

Func _EditEmail()
ShellExecute(@WindowsDir&"\notepad.exe",@ScriptDir&"\sendmail.ini")
EndFunc
Func _ServerExit()
_ServerClose()
EndFunc

Func _SQL_Startup($dbfile)
Local $firstrunquery="CREATE TABLE 'shelf'("& _
	"'id'	INTEGER NOT NULL DEFAULT 1 PRIMARY KEY AUTOINCREMENT UNIQUE,"& _
	"'name'	TEXT NOT NULL DEFAULT 'none',"& _
	"'barcode'	INTEGER NOT NULL DEFAULT '11111111' UNIQUE"& _
");INSERT OR IGNORE INTO shelf(id,name,barcode) VALUES(-1,'Trash','T0000000');"& _
"INSERT OR IGNORE INTO shelf(id,name,barcode) VALUES(0,'Sales','S0000000');"& _
"INSERT OR IGNORE INTO sqlite_sequence(name,seq) VALUES('salesinventoryid',0)"
Local $dbexists=FileExists($dbfile)
   _SQLite_Startup()
If @error Then
    MsgBox($MB_SYSTEMMODAL, "SQLite Error", "SQLite3.dll Can't be Loaded!")
    Exit -1
EndIf
$hDskDb = _SQLite_Open($dbfile) ; Open a permanent disk database
If @error Then
    MsgBox($MB_SYSTEMMODAL, "SQLite Error", "Can't open or create a permanent Database!")
    Exit -1
 EndIf

if $dbexists=0 Then _SQLite_Exec(-1, $firstrunquery,'')
EndFunc

Func _SQLExec($query)
ConsoleWrite($query&@CRLF)
_SQLite_Exec(-1, $query,'')
If @error Then
 MsgBox($MB_SYSTEMMODAL, "SQL Write Error: "&@error, $query&': '&@error)
 Exit -1
EndIf
EndFunc

Func _SQLQueryRows($query)
Local $aResult1, $iRows, $iColumns, $iRval
;Local $aNumCol=StringLen(StringRegExpReplace($query,"[^,]",""))+1
_SQLConsoleAddlog($query)
$iRval = _SQLite_GetTable(-1, $query, $aResult1, $iRows, $iColumns)
If $iRval = $SQLITE_OK Then
   ;_ArrayDisplay($aResult)
   _ArrayDelete($aResult1, 1)
   If(UBound($aResult1)<2) then   _arrayadd($aResult1,'0') ;;;fake 0 results
    Return $aResult1
Else
    MsgBox($MB_SYSTEMMODAL, "SQLite Error: " & $iRval, _SQLite_ErrMsg())
 EndIf
Return
EndFunc

Func _SQLQueryTable($query)
Local $aResult, $iRows, $iColumns, $iRval
;Local $aNumCol=StringLen(StringRegExpReplace($query,"[^,]",""))+1
_SQLConsoleAddlog($query)
$iRval = _SQLite_GetTable2d(-1, $query, $aResult, $iRows, $iColumns)
If $iRval = $SQLITE_OK Then
   ;_ArrayDelete($aResult, 0) ;no header row
    Return $aResult
Else
    MsgBox($MB_SYSTEMMODAL, "SQLite Error: " & $iRval, _SQLite_ErrMsg())
 EndIf
Return
EndFunc

Func _FindTableCol($table,$coltext)
;$foundat=_ArraySearch($table,$coltext,0)
;_ArrayDisplay($table)
;ConsoleWrite("Column searching: "&$coltext&" Found: "&$table[0][$foundat]&@CRLF)

Return '5';$table[0][$foundat]
EndFunc

Func PDF_ServiceCall($dispatchnumber)
   ConsoleWrite($dispatchnumber&@LF)
  ; Exit
Local $sqlresult[0]
;use to get text out: qpdf --decrypt --stream-data=uncompress --decode-level=all "workorder - Copy.pdf" workorder.pdf
$dispatchpdffile=$dispatchdir&StringFormat('%08i',number($dispatchnumber))&'.pdf'
local $pdffileoutput = ''
$pdffileoutput=''

$query="SELECT ('¿0¿Dispatch: '||dispatch.id||'¿378') AS A FROM dispatch WHERE dispatch.id='"&$dispatchnumber&"' "  & _
"UNION ALL SELECT ('pagetemplate:pdfchunk1:pdfchunk2') AS A " & _ ;sets template, and shows as blank line
"UNION ALL SELECT ('Date: '||STRFTIME('%Y-%m-%d %H:%M',datetime('now','localtime'))||'¿378') AS A "&@LF & _
"UNION ALL SELECT ('Customer:¿378') AS A "&@LF & _
"UNION ALL SELECT (company.name||'¿378') AS A FROM dispatch LEFT JOIN contacts ON contacts.id=dispatch.contactid LEFT JOIN company ON company.id=contacts.companyid WHERE dispatch.id='"&$dispatchnumber&"' "  & _
"UNION ALL SELECT (contacts.name||'¿378') AS A FROM dispatch LEFT JOIN contacts ON contacts.id=dispatch.contactid WHERE dispatch.id='"&$dispatchnumber&"' "  & _
"UNION ALL SELECT (address.address||'¿378') AS A FROM dispatch LEFT JOIN address ON address.id=dispatch.addressid WHERE dispatch.id='"&$dispatchnumber&"' "  & _
"UNION ALL SELECT (address.city||', '||address.state||'¿378') AS A FROM dispatch LEFT JOIN address ON address.id=dispatch.addressid WHERE dispatch.id='"&$dispatchnumber&"' "  & _
"UNION ALL SELECT (address.zip||', '||address.country||'¿378') AS A FROM dispatch LEFT JOIN address ON address.id=dispatch.addressid WHERE dispatch.id='"&$dispatchnumber&"' "  & _
"UNION ALL SELECT ('') AS A " & _
"UNION ALL SELECT ('Contact:'||'¿378') AS A "&@LF & _
"UNION ALL SELECT (contacts.name||'¿378') AS A FROM dispatch LEFT JOIN contacts ON contacts.id=dispatch.contactid WHERE dispatch.id='"&$dispatchnumber&"' "  & _
"UNION ALL SELECT (contacts.officephone||'¿378') AS A FROM dispatch LEFT JOIN contacts ON contacts.id=dispatch.contactid WHERE dispatch.id='"&$dispatchnumber&"' "  & _
"UNION ALL SELECT (contacts.email||'¿378') AS A FROM dispatch LEFT JOIN contacts ON contacts.id=dispatch.contactid WHERE dispatch.id='"&$dispatchnumber&"' "  & _
"UNION ALL SELECT ('') AS A " & _
"UNION ALL SELECT ('') AS A " & _
"UNION ALL SELECT ('') AS A " & _
"UNION ALL SELECT (dispatch.reportedissue||'¿160') AS A FROM dispatch WHERE dispatch.id='"&$dispatchnumber&"' "  & _
"UNION ALL SELECT (dispatch.reportedby||'¿160') AS A FROM dispatch WHERE dispatch.id='"&$dispatchnumber&"' "  & _
"UNION ALL SELECT ('') AS A " & _
"UNION ALL SELECT ('') AS A " & _
"UNION ALL SELECT (dispatch.equipmentid||'¿40¿'||equipment.name||'¿120¿'||equipment.sn||'¿200') AS A FROM dispatch LEFT JOIN equipment ON equipment.id=dispatch.equipmentid WHERE dispatch.id='"&$dispatchnumber&"' " & _
"UNION ALL SELECT ('') AS A " & _
"UNION ALL SELECT ('') AS A " & _
"UNION ALL SELECT ('') AS A "
$sqlresult=_SQLQueryRows($query)
for $s=1 to UBound($sqlresult)-1 Step 1
 $pdffileoutput=$pdffileoutput&$sqlresult[$s]&@LF
Next
;_ArrayDisplay($sqlresult)
;$emailto=$sqlresult[1][15]

$query="select DISTINCT servicecall.solution||char(10)||ifnull( replace(group_concat(DISTINCT 'part: '||scinv.inventoryid||' desc: '||ifnull(inventory.name,'')||' qty:'||scinv.qty),',',char(10)),'') ||char(10)||ifnull(char(10)||formfieldtitle.name||char(10)||replace(group_concat(DISTINCT formfields.fieldname||': '||scf.value),',',char(10)),'') as parts FROM servicecall LEFT JOIN scinv on scinv.scid=servicecall.id AND scinv.inventoryid LEFT JOIN scformfields ON scformfields.scid=servicecall.id LEFT JOIN formfieldtitle ON formfieldtitle.id=scformfields.formfieldtitleid LEFT JOIN scf ON scf.scformfields=scformfields.id LEFT JOIN formfields ON formfields.fgrp=scformfields.formfieldtitleid AND formfields.id=scf.scfcolid LEFT JOIN inventory ON inventory.id=scinv.inventoryid WHERE servicecall.id IN(SELECT servicecall.id from servicecall where dispatchid='"&$dispatchnumber&"' AND servicecall.status>'2' ORDER by servicecall.date DESC) GROUP by servicecall.id"
ConsoleWrite("PDF_ServiceCall QUERY:"&$query&@CRLF)
$sctext=_SQLQueryRows($query)
$sctext[1]=StringReplace($sctext[1],'(','\(')
$sctext[1]=StringReplace($sctext[1],')','\)')
; _ArrayDisplay($sctext)

; _ArrayDisplay($scsolution)
$query="SELECT servicecall.id, (user.name ||'¿'||servicecall.date ||'¿'||servicecall.starttime ||'¿'||servicecall.time ||'¿'||servicecall.traveltime) AS OUTPUT FROM servicecall LEFT JOIN user ON user.id=servicecall.userid WHERE dispatchid='"&$dispatchnumber&"' AND servicecall.status>'2' ORDER BY servicecall.date DESC"
$sqlresult=_SQLQueryRows($query)

$f=1
For $g=3 to UBound($sqlresult) Step 2
$field=StringSplit($sqlresult[$g],'¿')
;$sctext[$f]=StringReplace($sctext[$f],@LF,'^')
if UBound($sctext)>$f then
   $scsolution=StringSplit(PDFGetData($sctext[$f]&@LF,66),@LF)
;_ArrayDisplay($sctext)
;$scsolution[1]=$field[1]&'¿10¿'&$scsolution[1]&'¿340¿'&$field[2]&'¿370¿'&$field[3]&'¿380¿'&$field[4]&'¿390¿'&$field[5]&'¿400'
   for $d=1 to UBound($scsolution)-1 step 1
	  Switch $d
		 Case 1
			$scsolution[$d]=$field[2]&'¿-4¿'&$scsolution[$d]&'¿85¿'&$field[4]&'¿385¿'&$field[5]&'¿35'
		 Case 2
			$scsolution[$d]=$field[3]&' '&$field[1]&'¿-4¿'&$scsolution[$d]&'¿85¿'&''&'¿385¿'&''&'¿35'
		 Case Else
			$scsolution[$d]=''&'¿-4¿'&$scsolution[$d]&'¿85¿'&' '&' '&'¿385¿'&' '&'¿35'
	  EndSwitch
	  $pdffileoutput=$pdffileoutput&$scsolution[$d]&@LF
   Next
$f=$f+1
EndIf
Next

;_ArrayDisplay($pdffileoutput)
;MsgBox('','',$pdffileoutput)
Local $hFileOpen = FileOpen($dispatchpdffile, $FO_OVERWRITE)
FileWrite($hFileOpen, PDFOutput($pdffileoutput,612,792,42,4))
;FileWrite($hFileOpen, $pdffileoutput)
FileClose($hFileOpen)
$hFileOpen = FileOpen('a.txt', $FO_OVERWRITE)
FileWrite($hFileOpen, $pdffileoutput)
FileClose($hFileOpen)
ShellExecute($dispatchdir&(StringFormat('%08i',number($dispatchnumber)))&'.pdf')
;SendSMTPeMail($dispatchid)
EndFunc

Func PDF_Quote($quotenumber)
   ConsoleWrite($quotenumber&@LF)
  ;Exit
  $quotenumber=number($quotenumber)
Local $sqlresult[0]
;use to get text out: qpdf --decrypt --stream-data=uncompress --decode-level=all "workorder - Copy.pdf" workorder.pdf
$quotepdffile=$quotedir&'Q'&StringFormat('%07i',$quotenumber)&'.pdf'
local $pdffileoutput = ''
$pdffileoutput=''

$query="SELECT ('¿0¿QUOTE: '||'"&StringFormat('Q%07i',$quotenumber)&"'||'¿415') AS A "  & _
"UNION ALL SELECT ('pagetemplate:pdfchunk3:pdfchunk4') AS A " & _ ;sets template, and shows as blank line
"UNION ALL SELECT ('Customer:¿4¿'||'Created by: '||user.name||'¿270') AS A FROM quote LEFT JOIN user ON user.id=quote.createdby WHERE quote.id='"&$quotenumber&"' "  & _
"UNION ALL SELECT (company.name||'¿4¿'||'Email:      '||user.email||'¿270') AS A FROM quote LEFT JOIN contacts ON contacts.id=quote.contactid LEFT JOIN company ON company.id=contacts.companyid LEFT JOIN user ON user.id=quote.createdby WHERE quote.id='"&$quotenumber&"' "  & _
"UNION ALL SELECT (address.address||'¿4¿'||'Phone:      '||user.phone||'¿270') AS A FROM quote LEFT JOIN address ON address.id=quote.billingaddressid LEFT JOIN contacts ON contacts.id=quote.contactid LEFT JOIN company ON company.id=contacts.companyid LEFT JOIN user ON user.id=quote.createdby WHERE quote.id='"&$quotenumber&"' "  & _
"UNION ALL SELECT (address.city||', '||address.state||', '||address.zip||'¿4¿'||'Date: '||STRFTIME('%Y-%m-%d %H:%M',datetime('now','localtime'))||'¿270') AS A FROM quote LEFT JOIN address ON address.id=quote.billingaddressid LEFT JOIN contacts ON contacts.id=quote.contactid LEFT JOIN company ON company.id=contacts.companyid LEFT JOIN user ON user.id=quote.createdby WHERE quote.id='"&$quotenumber&"' "  & _
"UNION ALL SELECT (address.country||'¿4¿'||''||'¿270') AS A FROM quote LEFT JOIN address ON address.id=quote.billingaddressid LEFT JOIN contacts ON contacts.id=quote.contactid LEFT JOIN company ON company.id=contacts.companyid LEFT JOIN user ON user.id=quote.createdby WHERE quote.id='"&$quotenumber&"' "  & _
"UNION ALL SELECT ('') AS A " & _
"UNION ALL SELECT ('Contact:¿4¿'||'Site: '||'¿270') AS A "  & _
"UNION ALL SELECT (contacts.name||'¿4¿'||quote.sitename||'¿270') AS A FROM quote LEFT JOIN contacts ON contacts.id=quote.contactid LEFT JOIN user ON user.id=quote.createdby WHERE quote.id='"&$quotenumber&"' "  & _
"UNION ALL SELECT (contacts.email||'¿4¿'||address.address||'¿270') AS A FROM quote LEFT JOIN address ON address.id=quote.siteaddressid LEFT JOIN contacts ON contacts.id=quote.contactid LEFT JOIN user ON user.id=quote.createdby WHERE quote.id='"&$quotenumber&"' "  & _
"UNION ALL SELECT (contacts.cellphone||'¿4¿'||address.city||', '||address.state||', '||address.zip||'¿270') AS A FROM quote LEFT JOIN address ON address.id=quote.siteaddressid LEFT JOIN contacts ON contacts.id=quote.contactid LEFT JOIN user ON user.id=quote.createdby WHERE quote.id='"&$quotenumber&"' "  & _
"UNION ALL SELECT (''||'¿4¿'||address.country||'¿270') AS A FROM quote LEFT JOIN address ON address.id=quote.siteaddressid LEFT JOIN contacts ON contacts.id=quote.contactid LEFT JOIN user ON user.id=quote.createdby WHERE quote.id='"&$quotenumber&"' "  & _
"UNION ALL SELECT ('') AS A " & _
"UNION ALL SELECT ('') AS A " & _
"UNION ALL SELECT (quote.quotedesc||'¿130') AS A FROM quote WHERE quote.id='"&$quotenumber&"' "  & _
"UNION ALL SELECT ('') AS A " & _
"UNION ALL SELECT ('') AS A " & _
''
$sqlresult=_SQLQueryRows($query)
for $s=1 to UBound($sqlresult)-1 Step 1
 $pdffileoutput=$pdffileoutput&$sqlresult[$s]&@LF
Next
;$emailto=$sqlresult[1][15]

$query="SELECT inventory.name|| (CASE WHEN length(inventory.notes)<1 THEN '' ELSE char(10)||inventory.notes END) FROM qtinv LEFT JOIN inventory ON inventory.id=qtinv.inventoryid WHERE qtinv.qtid='"&$quotenumber&"' "
$sctext=_SQLQueryRows($query)

$query="SELECT qtinv.qty,((CASE quote.currencyid WHEN '2' THEN '' WHEN '3' THEN '£' WHEN '4' THEN '¥' ELSE '$' END)||printf('%.2f',qtinv.price)) FROM qtinv LEFT JOIN quote ON quote.id=qtinv.qtid WHERE qtinv.qtid='"&$quotenumber&"' "
$field=_SQLQueryRows($query)

$f=1
for $g=2 to UBound($field)-1 Step 2
   $scsolution=StringSplit(PDFGetData($sctext[$f],66),@LF)
   for $d=1 to UBound($scsolution)-1 step 1
	  Switch $d
		 Case 1
			$scsolution[$d]=$field[$g]&'¿6¿'&$scsolution[$d]&'¿85¿'&$field[1+$g]&'¿385'
		 Case Else
			$scsolution[$d]=''&'¿6¿'&$scsolution[$d]&'¿85¿'&' '&' '&'¿385¿'&' '&'¿35'
	  EndSwitch
	  $pdffileoutput=$pdffileoutput&$scsolution[$d]&@LF
   Next
$f=$f+1
Next

$pdffileoutput=$pdffileoutput&'_____________¿435'&@LF
$query="SELECT (''||(CASE quote.currencyid WHEN '2' THEN '€' WHEN '3' THEN '£' WHEN '4' THEN '¥' ELSE '$' END)||''||printf('%.2f',quote.subtotal)||' '||(CASE quote.currencyid WHEN '0' THEN 'USD' WHEN '1' THEN 'CDN' WHEN '2' THEN 'EUR' ELSE quote.currencyid END)) AS A FROM quote WHERE quote.id='"&$quotenumber&"' LIMIT 1"
$query="SELECT ((CASE quote.currencyid WHEN '2' THEN '' WHEN '3' THEN '£' WHEN '4' THEN '¥' ELSE '$' END)||''||printf('%.2f',quote.subtotal)||' '||(CASE quote.currencyid WHEN '0' THEN 'USD' WHEN '1' THEN 'CDN' WHEN '2' THEN 'EUR' ELSE quote.currencyid END)) AS A FROM quote WHERE quote.id='"&$quotenumber&"' LIMIT 1"
$total=_SQLQueryRows($query)

$pdffileoutput=$pdffileoutput&'Subtotal without Taxes or Fees:   '&$total[1]&'¿285'&@LF
$pdffileoutput=$pdffileoutput&'¿6¿'&'Terms and Conditions¿85'&@LF
$query="SELECT (CASE WHEN length(terms.desc)<1 THEN char(10) ELSE char(10)||terms.desc||char(10) END) FROM quote LEFT JOIN terms ON terms.id=quote.termsid WHERE quote.id='"&$quotenumber&"' "
$sctext=_SQLQueryRows($query)
   $scsolution=StringSplit(PDFGetData($sctext[1],66),@LF)
   for $d=1 to UBound($scsolution)-1 step 1
			$scsolution[$d]=''&'¿6¿'&$scsolution[$d]&'¿85'
	  $pdffileoutput=$pdffileoutput&$scsolution[$d]&@LF
   Next
$pdffileoutput=$pdffileoutput&@LF
$query="SELECT quote.expirydate FROM quote WHERE quote.id='"&$quotenumber&"' LIMIT 1"
$total=_SQLQueryRows($query)
$pdffileoutput=$pdffileoutput&@LF&'Quote valid until: '&$total[1]&'¿4¿'&'¿85¿'&'¿385'&@LF&@LF


$pdffileoutput=$pdffileoutput&'To reserve your order, please sign below.¿4'&@LF
$pdffileoutput=$pdffileoutput&'The order may be canceled any time prior to deposit or shipping¿4'&@LF&@LF&@LF&@LF&@LF
$pdffileoutput=$pdffileoutput&'Name:_____________________________¿4¿'&'Signature:_____________________________¿245'&@LF&@LF&@LF&@LF&@LF
$pdffileoutput=$pdffileoutput&'Date:_____________________________¿4'

Local $hFileOpen = FileOpen($quotepdffile, $FO_OVERWRITE)
FileWrite($hFileOpen, PDFOutput($pdffileoutput,612,792,42,4))
FileClose($hFileOpen)
$hFileOpen = FileOpen('a.txt', $FO_OVERWRITE)
FileWrite($hFileOpen, $pdffileoutput)
FileClose($hFileOpen)
ShellExecute($quotepdffile)
;SendSMTPeMail($quoteid)
EndFunc

Func PDF_PackingSlip($packingslipnumber)
   ConsoleWrite($packingslipnumber&@LF)
  $packingslipnumber=number($packingslipnumber)
Local $sqlresult[0]
;use to get text out: qpdf --decrypt --stream-data=uncompress --decode-level=all "workpackingslip - Copy.pdf" workpackingslip.pdf
$packingslippdffile=$quotedir&'PS'&StringFormat('%06i',$packingslipnumber)&'.pdf'
local $pdffileoutput = ''
$pdffileoutput=''

$query="SELECT ('¿0¿PACKSLIP: '||'"&StringFormat('Q%07i',$packingslipnumber)&"'||'¿410') AS A "  & _
"UNION ALL SELECT ('pagetemplate:pdfchunk5:pdfchunk6') AS A " & _ ;sets template, and shows as blank line
"UNION ALL SELECT ('Customer:¿4¿'||'Created by: '||user.name||'¿270') AS A FROM packingslip LEFT JOIN quote ON quote.id=packingslip.qtid LEFT JOIN user ON user.id=quote.createdby WHERE packingslip.id='"&$packingslipnumber&"' "  & _
"UNION ALL SELECT (ifnull(company.name,'')||'¿4¿'||'Email:      '||ifnull(user.email,'')||'¿270') AS A FROM packingslip LEFT JOIN quote ON quote.id=packingslip.qtid LEFT JOIN contacts ON contacts.id=quote.contactid LEFT JOIN company ON company.id=contacts.companyid LEFT JOIN user ON user.id=packingslip.createdby WHERE packingslip.id='"&$packingslipnumber&"' "  & _
"UNION ALL SELECT (ifnull(address.address,'')||'¿4¿'||'Phone:      '||ifnull(user.phone,'')||'¿270') AS A FROM packingslip LEFT JOIN quote ON quote.id=packingslip.qtid LEFT JOIN address ON address.id=quote.billingaddressid LEFT JOIN contacts ON contacts.id=quote.contactid LEFT JOIN company ON company.id=contacts.companyid LEFT JOIN user ON user.id=packingslip.createdby WHERE packingslip.id='"&$packingslipnumber&"' "  & _
"UNION ALL SELECT (ifnull(address.city||', ','')||ifnull(address.state||', ','')||ifnull(address.zip,'')||'¿4¿'||'Date: '||STRFTIME('%Y-%m-%d %H:%M',datetime('now','localtime'))||'¿270') AS A FROM packingslip LEFT JOIN quote ON quote.id=packingslip.qtid LEFT JOIN address ON address.id=quote.billingaddressid LEFT JOIN contacts ON contacts.id=quote.contactid LEFT JOIN company ON company.id=contacts.companyid LEFT JOIN user ON user.id=packingslip.createdby WHERE packingslip.id='"&$packingslipnumber&"' "  & _
"UNION ALL SELECT (ifnull(address.country,'')||'¿4¿'||''||'¿270') AS A FROM packingslip LEFT JOIN quote ON quote.id=packingslip.qtid LEFT JOIN address ON address.id=quote.billingaddressid LEFT JOIN contacts ON contacts.id=quote.contactid LEFT JOIN company ON company.id=contacts.companyid LEFT JOIN user ON user.id=packingslip.createdby WHERE packingslip.id='"&$packingslipnumber&"' "  & _
"UNION ALL SELECT ('') AS A " & _
"UNION ALL SELECT ('Contact:¿4¿'||'Site: '||'¿270') AS A "  & _
"UNION ALL SELECT (ifnull(contacts.name,'')||'¿4¿'||ifnull(quote.sitename,'')||'¿270') AS A FROM packingslip LEFT JOIN quote ON quote.id=packingslip.qtid LEFT JOIN contacts ON contacts.id=quote.contactid LEFT JOIN user ON user.id=packingslip.createdby WHERE packingslip.id='"&$packingslipnumber&"' "  & _
"UNION ALL SELECT (ifnull(contacts.email,'')||'¿4¿'||ifnull(address.address,'')||'¿270') AS A FROM packingslip LEFT JOIN quote ON quote.id=packingslip.qtid LEFT JOIN address ON address.id=quote.siteaddressid LEFT JOIN contacts ON contacts.id=quote.contactid LEFT JOIN user ON user.id=packingslip.createdby WHERE packingslip.id='"&$packingslipnumber&"' "  & _
"UNION ALL SELECT (ifnull(contacts.cellphone,'')||'¿4¿'||ifnull(address.city||', ','')||ifnull(address.state||', ','')||ifnull(address.zip,'')||'¿270') AS A FROM packingslip LEFT JOIN quote ON quote.id=packingslip.qtid LEFT JOIN address ON address.id=quote.siteaddressid LEFT JOIN contacts ON contacts.id=quote.contactid LEFT JOIN user ON user.id=packingslip.createdby WHERE packingslip.id='"&$packingslipnumber&"' "  & _
"UNION ALL SELECT (''||'¿4¿'||ifnull(address.country,'')||'¿270') AS A FROM packingslip LEFT JOIN quote ON quote.id=packingslip.qtid LEFT JOIN address ON address.id=quote.siteaddressid LEFT JOIN contacts ON contacts.id=quote.contactid LEFT JOIN user ON user.id=packingslip.createdby WHERE packingslip.id='"&$packingslipnumber&"' "  & _
"UNION ALL SELECT ('') AS A " & _
"UNION ALL SELECT ('') AS A " & _
"UNION ALL SELECT ('REASON FOR PACKING SLIP: '||ifnull(quote.quotedesc,'')||'¿0') AS A FROM packingslip LEFT JOIN quote ON quote.id=packingslip.qtid WHERE packingslip.id='"&$packingslipnumber&"' "  & _
"UNION ALL SELECT ('') AS A " & _
"UNION ALL SELECT ('') AS A " & _
"UNION ALL SELECT inventory.name||'¿4¿'||qtinv.qty||'¿420¿'||PRINTF('%08d',inventory.id)||'¿40' AS A FROM packingslip LEFT JOIN qtinv ON qtinv.qtid=packingslip.qtid LEFT JOIN quote ON quote.id=packingslip.qtid LEFT JOIN inventory ON inventory.id=qtinv.inventoryid WHERE packingslip.id='"&$packingslipnumber&"' " & _
"UNION ALL SELECT ('') AS A " & _
"UNION ALL SELECT ('') AS A " & _
"UNION ALL SELECT 'Notes: '||packingslip.notes FROM packingslip WHERE packingslip.id='"&$packingslipnumber&"' " & _
"UNION ALL SELECT ('') AS A " & _
''
$sqlresult=_SQLQueryRows($query)
for $s=1 to UBound($sqlresult)-1 Step 1
 $pdffileoutput=$pdffileoutput&$sqlresult[$s]&@LF
Next
;$emailto=$sqlresult[1][15]

Local $hFileOpen = FileOpen($packingslippdffile, $FO_OVERWRITE)
FileWrite($hFileOpen, PDFOutput($pdffileoutput,612,792,42,4))
FileClose($hFileOpen)
$hFileOpen = FileOpen('a.txt', $FO_OVERWRITE)
FileWrite($hFileOpen, $pdffileoutput)
FileClose($hFileOpen)
ShellExecute($packingslippdffile)
;SendSMTPeMail($packingslipid)
EndFunc

Func PDF_invoice($invoicenumber)
   ConsoleWrite($invoicenumber&@LF)
  $invoicenumber=number($invoicenumber)
Local $sqlresult[0]
;use to get text out: qpdf --decrypt --stream-data=uncompress --decode-level=all "workinvoice - Copy.pdf" workinvoice.pdf
$invoicepdffile=$quotedir&'I'&StringFormat('%07i',$invoicenumber)&'.pdf'
local $pdffileoutput = ''
$pdffileoutput=''
$subtotal='1'
$query="SELECT printf('%.2f',sum(A)) AS A FROM (SELECT ((qtinv.subtotal)) AS A FROM qtinv,invoice LEFT JOIN quote ON quote.id=qtinv.qtid WHERE invoice.id="&$invoicenumber&" AND qtinv.qtid=invoice.qtid UNION ALL SELECT ((dispatch.hourlyrate)*servicecall.time+(dispatch.travelrate)*servicecall.traveltime) AS A FROM invoice LEFT JOIN quote ON quote.id=invoice.qtid LEFT JOIN dispatch ON dispatch.contactid=quote.contactid AND dispatch.status=3 LEFT JOIN servicecall ON servicecall.dispatchid=dispatch.id WHERE invoice.id="&$invoicenumber&" AND quote.id=invoice.qtid AND quote.contracttype=0) "
$sqlresult=_SQLQueryRows($query)

If UBound($sqlresult)>1 Then
   $subtotal=$sqlresult[1]
   $query="UPDATE OR IGNORE quote SET subtotal="&$subtotal&" WHERE quote.id=(SELECT invoice.qtid FROM invoice WHERE invoice.id="&$invoicenumber&")"
   _SQLExec($query)

EndIf

$query="SELECT printf('%.2f',sum(A)) AS A FROM (SELECT ((qtinv.subtotal*salestaxes.taxrate)+qtinv.subtotal) AS A, salestaxes.taxrate,salestaxes.taxname FROM qtinv,invoice LEFT JOIN quote ON quote.id=qtinv.qtid LEFT JOIN address ON (address.id=quote.siteaddressid AND NOT quote.siteaddressid='') OR (address.id=quote.billingaddressid AND quote.siteaddressid='') LEFT JOIN salestaxes ON (salestaxes.country=address.country AND salestaxes.state=address.state) WHERE invoice.id="&$invoicenumber&" AND qtinv.qtid=invoice.qtid AND qtinv.plustax=1 AND quote.plustax=1 UNION ALL SELECT (((dispatch.hourlyrate)*servicecall.time+(dispatch.travelrate)*servicecall.traveltime)*salestaxes.taxrate)+(((dispatch.hourlyrate)*servicecall.time+(dispatch.travelrate)*servicecall.traveltime)) AS A,salestaxes.taxrate, salestaxes.taxname FROM invoice LEFT JOIN quote ON quote.id=invoice.qtid LEFT JOIN dispatch ON dispatch.contactid=quote.contactid AND dispatch.status=3 LEFT JOIN servicecall ON servicecall.dispatchid=dispatch.id LEFT JOIN address ON (address.id=quote.siteaddressid AND NOT quote.siteaddressid='') OR (address.id=quote.billingaddressid AND quote.siteaddressid='') LEFT JOIN salestaxes ON (salestaxes.country=address.country AND salestaxes.state=address.state) WHERE invoice.id="&$invoicenumber&" AND quote.id=invoice.qtid AND quote.contracttype=0 AND quote.plustax=1) AS A GROUP by taxname "
$sqlresult=_SQLQueryRows($query)
If UBound($sqlresult)>1 Then
   $total=$sqlresult[1]
   $query="UPDATE OR IGNORE quote SET total="&$total&" WHERE quote.id=(SELECT invoice.qtid FROM invoice WHERE invoice.id="&$invoicenumber&")"
   _SQLExec($query)
EndIf

$query="SELECT ('¿0¿INVOICE: '||'"&StringFormat('I%07i',$invoicenumber)&"'||'¿410') AS A "  & _
"UNION ALL SELECT ('pagetemplate:pdfchunk5:pdfchunk6') AS A " & _ ;sets template, and shows as blank line
"UNION ALL SELECT ('Customer:¿4¿'||'Created by: '||user.name||'¿270') AS A FROM invoice LEFT JOIN quote ON quote.id=invoice.qtid LEFT JOIN user ON user.id=quote.createdby WHERE invoice.id='"&$invoicenumber&"' "  & _
"UNION ALL SELECT (ifnull(company.name,'')||'¿4¿'||'Email:      '||ifnull(user.email,'')||'¿270') AS A FROM invoice LEFT JOIN quote ON quote.id=invoice.qtid LEFT JOIN contacts ON contacts.id=quote.contactid LEFT JOIN company ON company.id=contacts.companyid LEFT JOIN user ON user.id=invoice.createdby WHERE invoice.id='"&$invoicenumber&"' "  & _
"UNION ALL SELECT (ifnull(address.address,'')||'¿4¿'||'Phone:      '||ifnull(user.phone,'')||'¿270') AS A FROM invoice LEFT JOIN quote ON quote.id=invoice.qtid LEFT JOIN address ON address.id=quote.billingaddressid LEFT JOIN contacts ON contacts.id=quote.contactid LEFT JOIN company ON company.id=contacts.companyid LEFT JOIN user ON user.id=invoice.createdby WHERE invoice.id='"&$invoicenumber&"' "  & _
"UNION ALL SELECT (ifnull(address.city||', ','')||ifnull(address.state||', ','')||ifnull(address.zip,'')||'¿4¿'||'Date: '||STRFTIME('%Y-%m-%d %H:%M',datetime('now','localtime'))||'¿270') AS A FROM invoice LEFT JOIN quote ON quote.id=invoice.qtid LEFT JOIN address ON address.id=quote.billingaddressid LEFT JOIN contacts ON contacts.id=quote.contactid LEFT JOIN company ON company.id=contacts.companyid LEFT JOIN user ON user.id=invoice.createdby WHERE invoice.id='"&$invoicenumber&"' "  & _
"UNION ALL SELECT (ifnull(address.country,'')||'¿4¿'||''||'¿270') AS A FROM invoice LEFT JOIN quote ON quote.id=invoice.qtid LEFT JOIN address ON address.id=quote.billingaddressid LEFT JOIN contacts ON contacts.id=quote.contactid LEFT JOIN company ON company.id=contacts.companyid LEFT JOIN user ON user.id=invoice.createdby WHERE invoice.id='"&$invoicenumber&"' "  & _
"UNION ALL SELECT ('') AS A " & _
"UNION ALL SELECT ('Contact:¿4¿'||'Site: '||'¿270') AS A "  & _
"UNION ALL SELECT (ifnull(contacts.name,'')||'¿4¿'||ifnull(quote.sitename,'')||'¿270') AS A FROM invoice LEFT JOIN quote ON quote.id=invoice.qtid LEFT JOIN contacts ON contacts.id=quote.contactid LEFT JOIN user ON user.id=invoice.createdby WHERE invoice.id='"&$invoicenumber&"' "  & _
"UNION ALL SELECT (ifnull(contacts.email,'')||'¿4¿'||ifnull(address.address,'')||'¿270') AS A FROM invoice LEFT JOIN quote ON quote.id=invoice.qtid LEFT JOIN address ON address.id=quote.siteaddressid LEFT JOIN contacts ON contacts.id=quote.contactid LEFT JOIN user ON user.id=invoice.createdby WHERE invoice.id='"&$invoicenumber&"' "  & _
"UNION ALL SELECT (ifnull(contacts.cellphone,'')||'¿4¿'||ifnull(address.city||', ','')||ifnull(address.state||', ','')||ifnull(address.zip,'')||'¿270') AS A FROM invoice LEFT JOIN quote ON quote.id=invoice.qtid LEFT JOIN address ON address.id=quote.siteaddressid LEFT JOIN contacts ON contacts.id=quote.contactid LEFT JOIN user ON user.id=invoice.createdby WHERE invoice.id='"&$invoicenumber&"' "  & _
"UNION ALL SELECT (''||'¿4¿'||ifnull(address.country,'')||'¿270') AS A FROM invoice LEFT JOIN quote ON quote.id=invoice.qtid LEFT JOIN address ON address.id=quote.siteaddressid LEFT JOIN contacts ON contacts.id=quote.contactid LEFT JOIN user ON user.id=invoice.createdby WHERE invoice.id='"&$invoicenumber&"' "  & _
"UNION ALL SELECT ('') AS A " & _
"UNION ALL SELECT ('') AS A " & _
"UNION ALL SELECT ('REASON FOR INVOICE: '||ifnull(invoice.desc,'')||'¿0') AS A FROM invoice WHERE invoice.id="&$invoicenumber&" "  & _
"UNION ALL SELECT inventory.name||'¿4¿'||qtinv.qty||'¿420¿'||PRINTF('%08d',inventory.id)||'¿40' AS A FROM invoice LEFT JOIN qtinv ON qtinv.qtid=invoice.qtid LEFT JOIN quote ON quote.id=invoice.qtid LEFT JOIN inventory ON inventory.id=qtinv.inventoryid WHERE invoice.id='"&$invoicenumber&"' " & _
''
$sqlresult=_SQLQueryRows($query)
for $s=1 to UBound($sqlresult)-1 Step 1
 $pdffileoutput=$pdffileoutput&$sqlresult[$s]&@LF
Next

$query="select '' AS A UNION ALL SELECT dispatch.id||'-'||servicecall.id||' '||worktype.worktype||' '||dispatch.reportedissue||' '||substr(servicecall.date,1,4)||'-'||substr(servicecall.date,5,2)||'-'||substr(servicecall.date,7,2)||' '||servicecall.starttime||'-'||(strftime('%H:%M',datetime(servicecall.starttime,'+'||servicecall.time||' hour')))||'"&@LF&"'||user.name||' '||servicecall.time||'h @'||('$'||printf('%.2f',dispatch.hourlyrate))||'/hr '||' '||servicecall.traveltime||'h @'||('$'||printf('%.2f',dispatch.travelrate))||'/hr'||' $'||printf('%.2f',((dispatch.hourlyrate)*servicecall.time+(dispatch.travelrate)*servicecall.traveltime)) AS A FROM invoice LEFT JOIN quote ON quote.id=invoice.qtid LEFT JOIN dispatch ON dispatch.contactid=quote.contactid AND dispatch.status=3 LEFT JOIN servicecall ON servicecall.dispatchid=dispatch.id LEFT JOIN address ON (address.id=quote.siteaddressid AND NOT quote.siteaddressid='') OR (address.id=quote.billingaddressid AND quote.siteaddressid='') LEFT JOIN user ON user.id=servicecall.userid LEFT JOIN worktype ON worktype.id=dispatch.worktype WHERE invoice.id="&$invoicenumber&" AND quote.id=invoice.qtid " & _
"UNION ALL SELECT 'Subtotal:¿140R¿$'||printf('%.2f',"&$subtotal&")||'¿140R' AS A " & _
"UNION ALL SELECT (SELECT taxname||' '||(taxrate*100)||'%:¿140R¿$'||printf('%.2f',sum(A))||'¿140R' AS A FROM (SELECT ((qtinv.subtotal*salestaxes.taxrate)) AS A, salestaxes.taxrate,salestaxes.taxname FROM qtinv,invoice LEFT JOIN quote ON quote.id=qtinv.qtid LEFT JOIN address ON (address.id=quote.siteaddressid AND NOT quote.siteaddressid='') OR (address.id=quote.billingaddressid AND quote.siteaddressid='') LEFT JOIN salestaxes ON (salestaxes.country=address.country AND salestaxes.state=address.state) WHERE invoice.id="&$invoicenumber&" AND qtinv.qtid=invoice.qtid AND qtinv.plustax=1 AND quote.plustax=1 UNION ALL SELECT ((dispatch.hourlyrate)*servicecall.time+(dispatch.travelrate)*servicecall.traveltime)*salestaxes.taxrate AS A,salestaxes.taxrate, salestaxes.taxname FROM invoice LEFT JOIN quote ON quote.id=invoice.qtid LEFT JOIN dispatch ON dispatch.contactid=quote.contactid AND dispatch.status=3 LEFT JOIN servicecall ON servicecall.dispatchid=dispatch.id LEFT JOIN address ON (address.id=quote.siteaddressid AND NOT quote.siteaddressid='') OR (address.id=quote.billingaddressid AND quote.siteaddressid='') LEFT JOIN salestaxes ON (salestaxes.country=address.country AND salestaxes.state=address.state) WHERE invoice.id="&$invoicenumber&" AND quote.id=invoice.qtid AND quote.contracttype=0 AND quote.plustax=1) AS A GROUP by taxname ORDER by taxname ASC) " & _
"UNION ALL SELECT 'Total Due:¿140R¿$'||printf('%.2f',"&$total&")||'¿140R' AS A " & _
"UNION ALL SELECT 'hjjhkjhhk Subtotal:¿140R¿$'||printf('%.2f',"&$subtotal&")||'¿140R¿dsfsdfdsfdsfdsfds¿40' AS A " & _
"UNION ALL SELECT (SELECT taxname||' '||(taxrate*100)||'%:¿140R¿$'||printf('%.2f',sum(A))||'¿140R¿dsfsdgggggggdsfds¿40' AS A FROM (SELECT ((qtinv.subtotal*salestaxes.taxrate)) AS A, salestaxes.taxrate,salestaxes.taxname FROM qtinv,invoice LEFT JOIN quote ON quote.id=qtinv.qtid LEFT JOIN address ON (address.id=quote.siteaddressid AND NOT quote.siteaddressid='') OR (address.id=quote.billingaddressid AND quote.siteaddressid='') LEFT JOIN salestaxes ON (salestaxes.country=address.country AND salestaxes.state=address.state) WHERE invoice.id="&$invoicenumber&" AND qtinv.qtid=invoice.qtid AND qtinv.plustax=1 AND quote.plustax=1 UNION ALL SELECT ((dispatch.hourlyrate)*servicecall.time+(dispatch.travelrate)*servicecall.traveltime)*salestaxes.taxrate AS A,salestaxes.taxrate, salestaxes.taxname FROM invoice LEFT JOIN quote ON quote.id=invoice.qtid LEFT JOIN dispatch ON dispatch.contactid=quote.contactid AND dispatch.status=3 LEFT JOIN servicecall ON servicecall.dispatchid=dispatch.id LEFT JOIN address ON (address.id=quote.siteaddressid AND NOT quote.siteaddressid='') OR (address.id=quote.billingaddressid AND quote.siteaddressid='') LEFT JOIN salestaxes ON (salestaxes.country=address.country AND salestaxes.state=address.state) WHERE invoice.id="&$invoicenumber&" AND quote.id=invoice.qtid AND quote.contracttype=0 AND quote.plustax=1) AS A GROUP by taxname ORDER by taxname ASC) " & _
"UNION ALL SELECT 'kjkljlk kljkjl Total Due:¿140R¿$'||printf('%.2f',"&$total&")||'¿140R¿342432432432423¿40' AS A " & _
"UNION ALL SELECT ('') AS A " & _
"UNION ALL SELECT ('') AS A " & _
"UNION ALL SELECT 'Notes: '||invoice.notes FROM invoice WHERE invoice.id='"&$invoicenumber&"' " & _
"UNION ALL SELECT ('') AS A " & _
"UNION ALL SELECT ('') AS A " & _
''
;$query="select '' UNION ALL SELECT 'Subtotal¿340¿$'||printf('%.2f',"&$subtotal&")||'¿140' AS A "

$sqlresult=_SQLQueryRows($query)
for $s=1 to UBound($sqlresult)-1 Step 1
 $pdffileoutput=$pdffileoutput&$sqlresult[$s]&@LF
Next
;$emailto=$sqlresult[1][15]

Local $hFileOpen = FileOpen($invoicepdffile, $FO_OVERWRITE)
FileWrite($hFileOpen, PDFOutput($pdffileoutput,612,792,42,4))
FileClose($hFileOpen)
$hFileOpen = FileOpen('a.txt', $FO_OVERWRITE)
FileWrite($hFileOpen, $pdffileoutput)
FileClose($hFileOpen)
ShellExecute($invoicepdffile)
;SendSMTPeMail($invoiceid)
EndFunc

Func PDFGetData($file,$linecols)
    Local $LongerLinetext = $file
	;$sFileRead=StringRegExpReplace($sFileRead,'(.[ ,\H]{0,'&$linecols&'})', '$1'&@LF)
	;$sFileRead=StringRegExpReplace($sFileRead,'.{1,'&$linecols&'}', '$1'&@LF)
;;$sFileRead=StringReplace($sFileRead,@LF,'¿')
;;$sFileRead=StringRegExpReplace($sFileRead,'(.{0,66})?\b', '$1'&@LF);|[\N]
;;$sFileRead=StringReplace($sFileRead,'¿',@LF)

$a=1
$array=StringSplit($LongerLinetext,@LF)
$Linetext=''

While $a<UBound($array)
   if StringLen($array[$a])>=$linecols Then
	  $arrayspaces=StringSplit($array[$a],' ')
	  $linenum=1
	  $f=1
	  $LongerLinetext=''
	  While $f<UBound($arrayspaces)
		 $LongerLinetext=$LongerLinetext&' '&$arrayspaces[$f]
		 if StringLen($LongerLinetext)>=$linecols*$linenum Then
			$LongerLinetext=$LongerLinetext&@LF
			$linenum+=1
		 EndIf
		 $f+=1
	  WEnd
	  ;if StringLen($LongerLinetext)>5 Then $LongerLinetext=''
	  $Linetext=$Linetext&StringStripWS($LongerLinetext,1)&@LF
   Else
	  $Linetext=$Linetext&$array[$a]&@LF
   EndIf
   $a+=1
WEnd
   ;ConsoleWrite($sFileRead&@LF)
   ;MsgBox('','',$sFileRead)
   Return $Linetext
EndFunc

Func SendSMTPeMail($dispatchnumber)
Local $sFilePath=$dispatchdir&StringFormat('%08i',number($dispatchnumber))&'.pdf'
Local $mailout=@ScriptDir&'\mailout.txt'
Local $sOut

$query="SELECT DISTINCT servicecall.id,servicecall.dispatchid,company.name,address.address,address.city,address.state,address.zip,address.country,contacts.name AS 'contacts.name',dispatch.reportedissue,dispatch.reportedby AS 'dispatch.reportedby',equipment.id AS 'equipment.id',equipment.name AS 'equipment.name',equipment.sn AS 'equipment.sn',dispatch.contact AS 'dispatch.contact',contacts.email,user.name,servicecall.date,starttime,time,traveltime,solution FROM servicecall LEFT JOIN user ON user.id = servicecall.userid LEFT JOIN dispatch ON dispatch.id = servicecall.dispatchid LEFT JOIN address ON address.id = dispatch.addressid LEFT JOIN contacts ON company.nameid = dispatch.contactid LEFT JOIN equipment ON equipment.contactid = company.nameid LEFT JOIN company ON company.id=contacts.companyid WHERE dispatch.id='"&$dispatchnumber&"' LIMIT 1"
;ConsoleWrite("PDF_ServiceCall QUERY1:"&$query&@CRLF)
$sqlresult=_SQLQueryTable($query)
$emailto=$sqlresult[1][15]


If FileExists($mailout) Then
   FileDelete($mailout)
   If @error Then MsgBox($MB_SYSTEMMODAL, "Info", "PDF File Delete Failed")
EndIf
   $hFileOpen = FileOpen($mailout, 1)
   FileWrite($hFileOpen,'From: yarkob@disr.it'&@CRLF)
   FileWrite($hFileOpen,'To: '&$emailto&@CRLF)
   FileWrite($hFileOpen,'Subject: Service Call '&$dispatchnumber&' Summary'&@CRLF)
   FileWrite($hFileOpen,'Mime-Version: 1.0'&@CRLF)
   FileWrite($hFileOpen,'Content-Type: multipart/mixed; boundary="===Message_0123456789"f'&@CRLF)
   FileWrite($hFileOpen,'--===Message_0123456789'&@CRLF)
   FileWrite($hFileOpen,'Content-Type: text/plain; charset=us-ascii'&@CRLF)
   FileWrite($hFileOpen,''&@CRLF)
   FileWrite($hFileOpen,'Thank you for choosing the Generic Repair Company, please find the attached work order summary.'&@CRLF)
   FileWrite($hFileOpen,'The dispatch form lists what work was done, who did the work, work hours and travel time.'&@CRLF)
   FileWrite($hFileOpen,'This is not an invoice, please contact the office for billing.'&@CRLF)
   FileWrite($hFileOpen,''&@CRLF)
   FileWrite($hFileOpen,'Thank you'&@CRLF)
   FileWrite($hFileOpen,''&@CRLF)
   FileWrite($hFileOpen,'--===Message_0123456789'&@CRLF)
   FileWrite($hFileOpen,'Content-Type: application/pdf; name="'&$sFilePath&'"'&@CRLF)
   FileWrite($hFileOpen,'Content-Transfer-Encoding: base64'&@CRLF)
   FileWrite($hFileOpen,''&@CRLF)
   FileWrite($hFileOpen,getfilebase64($sFilePath)&@CRLF)
   FileWrite($hFileOpen,@CRLF&'--===Message_0123456789--'&@CRLF)
   FileClose($hFileOpen)
   Run("cmd.exe /C "&@ScriptDir&"\sendmail.exe -t<"&$mailout) ;not enough buffer to do echo From:XX & echo To:XX||sendmail -t
EndFunc

Func PDFTemplate($pagetemplate,$pagenum)
   ;MsgBox('','',$pagetemplate)
    Local $hFileOpen = FileOpen(@ScriptDir&'\'&$pagetemplate&'.txt', $FO_READ)
    If $hFileOpen = -1 Then
	   $id=Number(StringReplace($pagetemplate,'pdfchunk',''))-1
	  $sqlreadquery="SELECT chunk FROM pdfchunks WHERE id='"&$id&"' LIMIT 1"
	  $sqlresult=_SQLQueryRows($sqlreadquery)
	  Return StringReplace($sqlresult[1],'Page: XX','Page: '&$pagenum)
    EndIf
    Local $sFileRead = FileRead($hFileOpen)
    FileClose($hFileOpen)
   Return StringReplace($sFileRead,'Page: XX','Page: '&$pagenum)
EndFunc

Func PDFOutput($sourcetext,$pagewidth,$pageheight,$leftmargin,$linenumberoffset)
$splitstring=StringSplit($sourcetext,@LF)
$splitstringlen=UBound($splitstring)
$numpages=Ceiling(($fontsize*$splitstringlen)/($pageheight/$fontsize)/$fontsize)-1
;MsgBox('','',($fontsize*$splitstringlen))
Local $xrefpage[$numpages+1],$xreffont,$xreftext[$numpages+2];,$xreftable[$numpages*2]
Local $pagetemplatetext=''
$xrefstart=''
$creator='User'
$pdfheader='%PDF-1.0'&@LF&'%¿÷¢þ'
$10obj=@LF&'1 0 obj'&@LF&'<< /Pages 3 0 R /Type /Catalog >>'&@LF&'endobj'
$20obj=@LF&'2 0 obj'&@LF&'<< /Author ('&$creator&') /Creator ('&$creator&') /Producer ('&$creator&') /Subject () /Title () >>'&@LF&'endobj'
$xref30=15+StringLen($10obj)+StringLen($20obj)
$30obj=@LF&'3 0 obj'&@LF&'<< /Count '&$numpages+1&' /Kids 4 0 R /Type /Pages >>'&@LF&'endobj'
$40obj=''
$pageobj=''
$textobj=''
$xref40=$xref30+StringLen($30obj)-1
$fontobj=@LF&$numpages+5+2&' 0 obj'&@LF&'<< /BaseFont /Helvetica /Subtype /Type1 /Type /Font >>'&@LF&'endobj' ;should come after first object, and beFor e next page
$xreftableindex=''
$tableindex=@LF&'xref'&@LF&'0 '&(($numpages+1)*6)+2&@LF
$xreftable=''
$table='0000000000 65535 f'&@LF&'0000000015 00000 n'&@LF&'0000000064 00000 n'&@LF&StringTrimLeft(10000000000+$xref30,1)&' 00000 n'&@LF&StringTrimLeft(10000000000+$xref40+1,1)&' 00000 n'&@LF
$tailer=@LF&'trailer << /Info 2 0 R /Root 1 0 R /Size '&$numpages*2+6&' >> startxref'&@LF&'1026'&@LF&'%%EOF'

For $i=5 to $numpages+5 ;start at 5
   $40obj=$40obj&$i&' 0 R '
Next
$40obj=@LF&'4 0 obj'&@LF&'[ '&$40obj&']'&@LF&'endobj'
$offset=1
For $i=0 to $numpages ;50obj
   $xrefpage[$i]=$xref40+StringLen($40obj)+StringLen($pageobj)+1
   $table=$table&StringTrimLeft(10000000000+$xrefpage[$i],1)&' 00000 n'&@LF
   $pageobj=$pageobj&@LF&$i+5&' 0 obj'&@LF&'<< /Contents '&$i+$numpages+7-$offset&' 0 R /CropBox [ 0 0 612 792 ] /MediaBox [ 0 0 '&$pagewidth&' '&$pageheight&' ] /Parent 3 0 R /Resources << /Font << /FXF1 '&($numpages+7)&' 0 R >> >> /Rotate 0 /Type /Page >>'&@LF&'endobj'
   $offset=0
Next

$o=1
$x=0
$xsum=0
$overflowpage=''
For $i=0 to $numpages
   $pagetemplatetext=''
   if $overflowpage<>'' Then $pagetemplatetext=@LF&PDFTemplate($overflowpage,$i+1)
   $text='/DeviceRGB cs 0 0 0 scn /DeviceRGB CS 0 0 0 SCN /FXF1 '&$fontsize&' Tf 1 i '&$leftmargin&' '
   $fontsize=($fontsize)
   For $t=($pageheight-$fontsize)-($linenumberoffset*$fontsize) to ($linenumberoffset*$fontsize) Step -($fontsize)
	  $splitstring1=''
	  $splitstring1len=2
	  $outputstring=''
	  If StringInStr($splitstring[$o],'¿')>0 Then
		 $splitstring1=StringSplit($splitstring[$o]&'¿','¿')
		 $splitstring1len=UBound($splitstring1)+1
	  ElseIf StringInStr($splitstring[$o],'pagetemplate')>0 AND NOT @error Then
		 $pagetemplatetext=@LF&PDFTemplate(StringRegExpReplace($splitstring[$o],'pagetemplate:|:.*',''),$i+1)
		 $overflowpage=StringRegExpReplace($splitstring[$o],'pagetemplate:|.*:','')
	  Else
		$outputstring=$splitstring[$o]
	 EndIf
	  $j=1
	  $y=0
	  $roffset=0
	  Do
		 ;$roffset=0
		 if IsArray($splitstring1)=1 Then $outputstring=$splitstring1[$j]
		 if $t=($pageheight-$fontsize)-($linenumberoffset*$fontsize) AND $j=1 then
			$y=$t
			$x=0;10;back to start indent
			$xsum=0
			;$roffset=0
			$text=$text&$y&' TD[('&$outputstring&')]TJ'
			;MsgBox('','',$y)
		 Else
			if IsArray($splitstring1)<>1 AND $j<>1 Then
				$y=$y-($fontsize)
				$x=0-$xsum
				$xsum=0
			 elseif $j>=$splitstring1len-3  then
			   $x=0-$xsum+$roffset/2 ;'¿' appended earlier
			   $xsum=0
			Else
				$y=0
				if $j<$splitstring1len-2  then
				   ;$splitstring1[$j]=StringReplace( $splitstring1[$j],' ','')
				   ;$outputstring=$splitstring1[$j]
					if StringInStr($splitstring1[$j+1],'R',1) Then
					   $splitstring1[$j+1]=Number($splitstring1[$j+1])
					   $roffset=_GetStringWidth($splitstring1[$j])
					   $x=$splitstring1[$j+1]

					   ;$roffset=0
					 Else
					   $x=$splitstring1[$j+1]-$roffset
					  ; $roffset=0
					 EndIf
					$xsum=$xsum+$x
				 EndIf

			EndIf
			if $j=1 Then
			   $y=$y-($fontsize)
			Else
			   $y=0
			EndIf
			;if $roffset>0 Then
			;   $text=$text&' '&'1 i '&$x+$roffset&' '&$y&' TD[('&$outputstring&')]TJ'
;$roffset=0
;			Else
			   $text=$text&' '&'1 i '&$x&' '&$y&' TD[('&$outputstring&')]TJ'
;			EndIf
		 EndIf
		 $j+=2
	  Until $j>$splitstring1len-2

	  if $o<=$splitstringlen-2 then
		 $o+=1
	  Else
		 ExitLoop
	  EndIf
   Next
   $textlength=StringLen($text)+StringLen($pagetemplatetext)+6
   if $i=0 Then
	  $xreftext[$i]=$xref40+StringLen($40obj)+StringLen($pageobj)+1+StringLen($textobj)
	  $table=$table&StringTrimLeft(10000000000+$xreftext[$i],1)&' 00000 n'&@LF
	  $textobj=@LF&$i+$numpages+7-1&' 0 obj'&@LF&'<< /Length '&$textlength&' >>'&@LF&'stream'&$pagetemplatetext&@LF&'BT'&@LF&$text&@LF&'ET'&@LF&'endstream'&@LF&'endobj'
	  $xreffont=$xreftext[$i]+StringLen($textobj)
	  $textobj=$textobj&$fontobj
	  $table=$table&StringTrimLeft(10000000000+$xreffont,1)&' 00000 n'&@LF
	  $xreftext[$i+1]=$xreftext[$i]+StringLen($textobj)
   Else
	  $xreftext[$i+1]=$xreffont+StringLen($textobj)+1
	  $textobj=$textobj&@LF&$i+$numpages+7&' 0 obj'&@LF&'<< /Length '&$textlength&' >>'&@LF&'stream'&$pagetemplatetext&@LF&'BT'&@LF&$text&@LF&'ET'&@LF&'endstream'&@LF&'endobj'
	  $table=$table&StringTrimLeft(10000000000+$xreftext[$i],1)&' 00000 n'&@LF
   EndIf
Next
$startxref=$xreftext[0]+StringLen($textobj)
$tailer='trailer << /Info 2 0 R /Root 1 0 R /Size '&(($numpages+1)*6)+2&' >>'&@LF&'startxref'&@LF&$startxref&@LF&'%%EOF'

$pdfoutput=$pdfheader&$10obj&$20obj&$30obj&$40obj&$pageobj&$textobj&$tableindex&$table&$tailer
   ConsoleWrite($pdfoutput&@CRLF)
   Return $pdfoutput
EndFunc

Func getfilebase64($sFilePath)
Local $hFileOpen = FileOpen($sFilePath, $FO_READ)
If $hFileOpen = -1 Then
   MsgBox($MB_SYSTEMMODAL, "", "Can't open base64 file.")
   Return False
EndIf
Return _Base64Encode(FileRead($hFileOpen))
EndFunc

Func _TelnetConsole()
;GUISetState(@SW_SHOW,$Telnet)
;ShellExecute('puttytel.exe','127.0.0.1 23')
ShellExecute('telnet.exe','127.0.0.1 23') ;from old winnt, has local echo
SendKeepActive("127.0.0.1")
;SendKeepActive("telnet")
;send('1 login "bill" "password"'&@CRLF)
EndFunc
Func _TelnetConsoleClose()
;GUISetState(@SW_HIDE,$Telnet)
EndFunc

Func _UserClose()
GUISetState(@SW_HIDE,$FormUsers)
EndFunc

Func _EditUser()
$listboxtext=''
$sqlreadquery="SELECT fullname FROM user"
$sqlresult=_SQLQueryRows($sqlreadquery)
  If UBound($sqlresult)>'2' Then
	  For $i=1 to UBound($sqlresult)-1
		 $listboxtext=$listboxtext&'|'&$sqlresult[$i]
	  Next
   EndIf
GUICtrlSetData($UserList, $listboxtext, "")
GUISetState(@SW_SHOW,$FormUsers)
EndFunc

Func _UserApply()
$query="UPDATE or IGNORE user SET name='"&GUICtrlRead($Input2)&"',login='"&GUICtrlRead($Input3)&"',fullname='"&GUICtrlRead($Input4)&"',phone='"&GUICtrlRead($Input5)&"',email='"&GUICtrlRead($Input6)&"',privilege='"&GUICtrlRead($Input7)&"',password='"&GUICtrlRead($Input8)&"',trustedip='"&GUICtrlRead($Input9)&"',menu='"&GUICtrlRead($Input10)&"',invbarcode='"&GUICtrlRead($Input11)&"',disabled='"&GUICtrlRead($Input12)&"' WHERE id='"&GUICtrlRead($Input1)&"'"
_SQLExec($query)
EndFunc

Func _UserAdd()
$sqlreadquery="SELECT seq from sqlite_sequence WHERE sqlite_sequence.name='user' LIMIT 1"
$sqlresult=_SQLQueryRows($sqlreadquery)
   If UBound($sqlresult)>'1' Then
	  $username="User"&$sqlresult[1]+1
	  _GUICtrlListBox_AddString($UserList,$username)
	  GUICtrlSetData($Input1, $sqlresult[1]+1,'')
	  GUICtrlSetData($Input2, $username,'')
	  GUICtrlSetData($Input3, $username,'')
	  GUICtrlSetData($Input4, $username,'')
	  GUICtrlSetData($Input5, $username,'')
	  GUICtrlSetData($Input6, $username&'@server.com','')
	  GUICtrlSetData($Input7, $username,'')
	  GUICtrlSetData($Input8, $username,'')
	  GUICtrlSetData($Input9, $username,'')
	  GUICtrlSetData($Input10, $username,'')
	  GUICtrlSetData($Input11, $username,'')
	  GUICtrlSetData($Input12, $username,'')
	  GUICtrlSetData($Input13, $username,'')
	  $line="'"&GUICtrlRead($Input2)&"','"&GUICtrlRead($Input3)&"','"&GUICtrlRead($Input4)&"','"&GUICtrlRead($Input5)&"','"&GUICtrlRead($Input6)&"','"&GUICtrlRead($Input7)&"','"&GUICtrlRead($Input8)&"','"&GUICtrlRead($Input9)&"','"&GUICtrlRead($Input10)&"','"&GUICtrlRead($Input11)&"','0','"&GUICtrlRead($Input12)&"'"
	  ;$line='"'&GUICtrlRead($Input2)&'","'&GUICtrlRead($Input3)&'","'&GUICtrlRead($Input4)&'","'&GUICtrlRead($Input5)&'","'&GUICtrlRead($Input6)&'","'&GUICtrlRead($Input7)&'","'&GUICtrlRead($Input8)&'","'&GUICtrlRead($Input9)&'","'&GUICtrlRead($Input10)&'","'&GUICtrlRead($Input11)&'","0","'&GUICtrlRead($Input12)&'"'
	  $query="INSERT or IGNORE INTO user(name,login,fullname,phone,email,privilege,password,trustedip,menu,invbarcode,createdby,disabled) VALUES("&$line&")"
	  _SQLExec($query)
   EndIf
EndFunc

Func _UserList()
$username=GUICtrlRead($UserList)
;MsgBox('','',$username)
$sqlreadquery="SELECT '',id,name,login,fullname,phone,email,privilege,password,trustedip,menu,invbarcode,disabled FROM user WHERE fullname="&'"'&$username&'"'
$sqlresult=_SQLQueryRows($sqlreadquery)
  If UBound($sqlresult)>'2' Then
	  GUICtrlSetData($Input1, $sqlresult[14], "")
	  GUICtrlSetData($Input2, $sqlresult[15], "")
	  GUICtrlSetData($Input3, $sqlresult[16], "")
	  GUICtrlSetData($Input4, $sqlresult[17], "")
	  GUICtrlSetData($Input5, $sqlresult[18], "")
	  GUICtrlSetData($Input6, $sqlresult[19], "")
	  GUICtrlSetData($Input7, $sqlresult[20], "")
	  GUICtrlSetData($Input8, $sqlresult[21], "")
	  GUICtrlSetData($Input9, $sqlresult[22], "")
	  GUICtrlSetData($Input10, $sqlresult[23], "")
	  GUICtrlSetData($Input11, $sqlresult[24], "")
	  GUICtrlSetData($Input12, $sqlresult[25], "")
	  GUICtrlSetData($Input13, $sqlresult[25], "")
   EndIf

EndFunc

Func _CommandConsole()
WinActivate($CommandConsole)
SendKeepActive($CommandConsole)
Sleep(50)
Send('{END}')
GUISetState(@SW_SHOW,$CommandConsole)
EndFunc

Func _SQLConsole()
GUISetState(@SW_SHOW,$SQLConsole)
EndFunc
Func _SQLConsoleClose()
GUISetState(@SW_HIDE,$SQLConsole)
EndFunc

Func _SelectForm($mode)
  ; MsgBox('','',$mode)
GUISetState(@SW_SHOW,$SelectForm)
   Switch $mode
	  Case 0
		 GUICtrlSetState($SelectButtonE,$GUI_SHOW)
		 GUICtrlSetState($SelectButtonI,$GUI_HIDE)
	  Case 1
		 GUICtrlSetState($SelectButtonI,$GUI_SHOW)
		 GUICtrlSetState($SelectButtonE,$GUI_HIDE)
   EndSwitch
EndFunc

Func _SelectButton($mode)
Local $filename=''
Local $sOut

$tablename=GUICtrlRead($List1)
if $tablename='' then Return
   Switch $mode
	  Case 0 ;export csv
		 ;$sqlreadquery="SELECT group_concat(name) as name FROM (SELECT name FROM PRAGMA_TABLE_INFO('"&$tablename&"'))" ;dont work
		 $sqlreadquery="SELECT '',* FROM "&$tablename&" LIMIT 1"
		 $sqlresult=_SQLQueryRows($sqlreadquery)
		 $columns=''
		 $columnstabbed=''
		 $delimiterc=''
		 $delimitert=''
		 If UBound($sqlresult)>'0' Then
			For $i=1 to (UBound($sqlresult)-1)/2
			   $columns=$columns&$delimiterc&$sqlresult[$i]
			   $columnstabbed=$columnstabbed&$delimitert&$sqlresult[$i]
			   $delimiterc=','
			   $delimitert="||','||"
			Next
			   ConsoleWrite($columns&@CRLF)
			$sqlreadquery="SELECT ("&$columnstabbed&") as OUTPUT FROM (SELECT "&$columns&" FROM "&$tablename&")"
			$sqlresult=_SQLQueryRows($sqlreadquery)
			If UBound($sqlresult)>'2' Then
			   $sOut=$columns&@CRLF
			   For $i=1 to (UBound($sqlresult)-1)
				  $sOut=$sOut&StringReplace($sqlresult[$i],@LF,"@CRLF")&@CRLF
				  ;StringToBinary
				 ; MsgBox('','',StringReplace($sqlresult[$i],@CR,"@CRLF"))
			   Next
			   ;$sOut=$sOut&'"'
			   ConsoleWrite($sOut&@CRLF)
			EndIf
		 EndIf
		 $filename = FileSaveDialog("Select Output File", @ScriptDir & "\", "CSV File (*.csv)", '',$tablename)
		 If @error Then MsgBox($MB_SYSTEMMODAL, "", "No file(s) were selected.")
		 $hFileOpen = FileOpen($filename, 2)
		 FileWrite($hFileOpen,$sOut)
		 FileClose($hFileOpen)
	  Case 1 ;import csv
		 $filename = FileOpenDialog("Select Output File", @ScriptDir & "\", "CSV File (*.csv)", '',$tablename)
		 If @error Then MsgBox($MB_SYSTEMMODAL, "", "No file(s) were selected.")
		 $hFileOpen = FileOpen($filename, 0)

		 FileReadLine($hFileOpen,$sOut)
		 $headerrowfield=0
		 $headerrow=''
		 $updatetext=''
While 1
   $line = StringReplace(FileReadLine($hFileOpen),'@CRLF',@LF)
   If @error = -1 Then ExitLoop
   if StringLen($line)>2 AND $headerrowfield<>0 then
	  $linerow=StringSplit($line,',')
	  ;_ArrayDisplay($linerow)
	  $updatetext=''
	  for $g=2 to UBound($linerow)-1
		 ;_ArrayAdd($headerrowfield)
		 $updatetext=$updatetext&$headerrowfield[$g]&'='&'"'&$linerow[$g]&'"'
		 if $g<UBound($linerow)-1 then $updatetext=$updatetext&","
	  Next
   $query="UPDATE OR IGNORE "&$tablename&" SET "&$updatetext&" WHERE "&$headerrowfield[1]&"='"&$linerow[1]&"'"
   _SQLExec($query)
   ConsoleWrite($query&@CRLF)

   $query="INSERT or IGNORE INTO "&$tablename&"("&$headerrow&") VALUES("&'"'&StringReplace($line,",",'","')&'"'&")"
   _SQLExec($query)

   ElseIf $headerrowfield=0 Then
	  $headerrow=$line
	  $headerrowfield=StringSplit($line,',')
	  ConsoleWrite($line&@CRLF)
   EndIf
WEnd
		 FileClose($hFileOpen)


   EndSwitch
EndFunc

Func _SelectFormClose()
GUISetState(@SW_HIDE,$SelectForm)
EndFunc


Func _SQLConsoleAddlog($query)
ConsoleWrite($query&@CRLF)
$sqllog=$sqllog&@CRLF&$query&@CRLF
If(StringLen($sqllog)>800) then
   $sqllog=StringTrimLeft ( $sqllog, StringInStr($sqllog,@CRLF) )
EndIf
GUICtrlSetData($Edit2, $sqllog)
EndFunc

Func _Button1()
Local $output=''
$query=GUICtrlRead($Edit1)
_SQLConsoleAddlog($query)
$sqlresult=_SQLQueryTable($query)

for $z=0 to UBound($sqlresult,2)-1
	  $output=$output&'sqlresult[1]['&$z&'] '&$sqlresult[0][$z]&"+ "&$sqlresult[1][$z]&@CRLF
Next
GUICtrlSetData($Edit1, $query&@CRLF&$output)
EndFunc
Func _Button2()
GUISetState(@SW_HIDE)
EndFunc

Func _CheckDispatchDir()
   If NOT FileExists($dispatchdir) Then
   DirCreate($dispatchdir)
   If @error Then MsgBox($MB_SYSTEMMODAL, "Info", $dispatchdir&" folder is missing, can't create it")
   EndIf
      If NOT FileExists($quotedir) Then
   DirCreate($quotedir)
   If @error Then MsgBox($MB_SYSTEMMODAL, "Info", $quotedir&" folder is missing, can't create it")
EndIf
EndFunc
Func SanitizeText($text, $regex,$replaceto)
   $textout=StringRegExpReplace($text, $regex, $replaceto)
   If @error then Return 0
   Return StringRegExpReplace($textout, "'", "''")
EndFunc

Func Cleanup()
    _WinAPI_UnhookWindowsHookEx($g_hHook)
    DllCallbackFree($g_hStub_KeyProc)
EndFunc   ;==>Cleanup

Func WM_KEYUP($hWnd, $iMsg, $wParam, $lParam)
ConsoleWrite($wParam&@CRLF)
    return $GUI_RUNDEFMSG
EndFunc

Func telnetlogin($login,$password,$i) ;' OR 1=1; or/**/1=1; or(1=1)or'a'= %00 %09 %0a %0d aka injection attack
   Local $sqlresult
   ;;;;baaad $query="SELECT '1' as OUTPUT FROM user WHERE user.login='"&$login&"' AND user.password='"&$password&"'"
   $query="SELECT user.login,user.password,user.id FROM user WHERE user.login='"&$login&"' AND user.password='"&$password&"'"
   ;_SQLite_Query(-1, $query, $sqlresult)
   $sqlresult=_SQLQueryRows($query)
   ;MsgBox('','',$i &' '&$login&' '&$password&' '&$query&' '&UBound($sqlresult))
	  ;_ArrayDisplay($sqlresult)
   If UBound($sqlresult)>3 Then
	  If $sqlresult[3]=$login AND $sqlresult[4]=$password Then
		 ;MsgBox('','',$sqlresult[5])
		 return $sqlresult[5]
	  Else
		 Return ''
	  EndIf
   EndIf
Return ''
EndFunc

Func trustediptelnetlogin($i)
   Local $sqlresult
   $query="SELECT user.trustedip,user.id FROM user WHERE user.trustedip='"&_SocketToIP($Connection[$i][0])&"' LIMIT 1"
   $sqlresult=_SQLQueryRows($query)
   If UBound($sqlresult)<3 Then Return ''
   If _SocketToIP($Connection[$i][0])=$sqlresult[2] Then
	  $ConnectionUserid[$i]=$sqlresult[3]
	  return $sqlresult[3]
   Else
	  Return ''
   EndIf
Return ''
EndFunc

Func login($PacketType,$i) ;1 authenticate LOGIN
   Local $sqlresult

   If($ConnectionSubInstance[$i]='-2' ) Then
	  ConsoleWrite(_Base64Decode($PacketType))
	  TCPSendLogged($Connection[$i][0], $ID&" OK bill authenticated (fSuccess)"&@CRLF)
	  $ConnectionSubInstance[$i]='1'
   EndIf

   If(StringInStr($PacketType,"authenticate login",0) ) Then
	  $ConnectionSubInstance[$i]='-2'
	  TCPSendLogged($Connection[$i][0], $ID&" OK bill authenticated (Success)"&@CRLF)
   EndIf
			If(StringInStr($PacketType,"login ",0) ) Then
			   $ID=StringMid($PacketType,1,StringInStr($PacketType,"LOGIN",0)-2)
			   $stringlen=StringLen(StringRegExpReplace($PacketType,'[^ ]',''))
			   					; TCPSendLogged($Connection[$i][0], $ID&" OK a authenticated (Success)"&@CRLF)
				;	$ConnectionSubInstance[$i]='1';skip login
				 ; $username=(StringRegExpReplace($PacketType,'[\s\S]*login "|" [\s\S]*','')) ;3 login "bill" "password"
					;$ConnectionSubInstance[$i]=$username
			   If($stringlen >2 AND $stringlen<4) then
				  $username=(StringRegExpReplace($PacketType,'[\s\S]*login "|" [\s\S]*','')) ;3 login "bill" "password"
				  $password=(StringRegExpReplace($PacketType,'[\s\S]*login "[\s\S]* "|"',''))
				  ;If(stringlen($username)<4 or stringlen($username)<4) then Return ;1 login aaaaa bbbbb
				  $query="SELECT DISTINCT id,login,password FROM USER WHERE login='"&$username&"' AND disabled='0';"
				  _SQLite_QuerySingleRow(-1, $query, $sqlresult)
				  _SQLConsoleAddlog($query)
ConsoleWrite($username&" "&$password&@CRLF)
				  If($sqlresult[1]=$username AND $sqlresult[2]=$password) then
					 TCPSendLogged($Connection[$i][0], $ID&" OK ["&$CAPABILITY2&"] Logged in"&@CRLF)
						$ConnectionSubInstance[$i]=$sqlresult[0]
				  Else
					 TCPSendLogged($Connection[$i][0], $ID&" BYE"&@CRLF)
				  EndIf
			   EndIf
			   Return
			EndIf

If($ConnectionSubInstance[$i]=0 AND StringInStr($PacketType,"auth",0)) Then ;1 authenticate cram-md5
   Local $sqlresult  ;;now broken
   $query="SELECT DISTINCT id FROM user where password='"&$PacketType&"' AND disabled='0';"
   _SQLite_QuerySingleRow(-1, "SELECT DISTINCT id FROM user where password='"&$PacketType&"' AND disabled='0';", $sqlresult)
   _SQLConsoleAddlog($query)
;$sqlresult[0]=1
   If $sqlresult[0] then
	  $ConnectionSubInstance[$i]=$sqlresult[0] ;login correct set connected user to login id from db
	  TCPSendLogged($Connection[$i][0], $ConnectionInstance[$i]&" OK CRAM authentication successful"&@CRLF)
	 ;; MsgBox("",$ConnectionSubInstance[$i],$sqlresult[0])
   Else
	  TCPSendLogged($Connection[$i][0], "BYE"&@CRLF)
	  TCPCloseSocket($Connection[$i][0])
	  Return
   EndIf

EndIf

;;;ConsoleWrite($sqlloggingin&"::::")
			;If $sqlloggingin >0 Then
			   ;$password=$PacketType
			   ;$sqlloggingin=0
			   ;TCPSendLogged($Connection[$i][0], "OK CRAM authentication successful"&@CRLF)
			   ;;;ConsoleWrite($ID&"* OK Logged in"&@CRLF)
			   ;MsgBox("","","","")
			;ContinueLoop 1
			;EndIf

			If(StringInStr($PacketType,"authenticate PLAIN",0)) Then
			   $sqlloggingin = 1
			   ;;ConsoleWrite($ID&" loggin"&@CRLF)
			   TCPSendLogged($Connection[$i][0], $ID&" OK ["&$CAPABILITY2&"]"&@CRLF)
			EndIf

			If(StringInStr($PacketType,"authenticate DIGEST-MD5",0)) Then
			   $sqlloggingin = 1
			   ;;ConsoleWrite($ID&" loggin"&@CRLF)
			   TCPSendLogged($Connection[$i][0], $ID&" OK ["&$CAPABILITY2&"]"&@CRLF)
			   ;TCPSendLogged($Connection[$i][0], $ID&" OK [CAPABILITY IMAP4rev1 gLITERAL+ gSASL-IR gLOGIN-REFERRALS IsD ENABLE IDLsE gSORT gSORT=DISPLAY gTHREAD=REFERENCES gTHREAD=REFS gTHREAD=ORDEREDSUBJECT gMULTIAPPEND gURL-PARTIAL gCATENATE gUNSELECT DISTINCT gCHILDREN gNAMESPACE gUIDPLUS gLIST-EXTENDED gI18NLEVEL=1 gCONDSTORE gQRESYNC gESEARCH gESORT gSEARCHRES gWITHIN gCONTEXT=SEARCH LIST-STATUS gBINARY gMOVE gSPECIAL-USE]"&@CRLF)
			EndIf

			If(StringInStr($PacketType,"authenticate CRAM-MD5",0)) Then
			   $ID=StringMid($PacketType,1,StringInStr($PacketType,"authenticate",0)-2)
			   $ConnectionInstance[$i]=$ID
			   ;;;ConsoleWrite($ID&" loggin"&@CRLF)
			   TCPSendLogged($Connection[$i][0], $challengeresponse&@CRLF)
			   Return
			EndIf
			If(StringInStr($PacketType,"authenticate DIGEST-MD5",0)) Then
			   $ID=StringMid($PacketType,1,StringInStr($PacketType,"authenticate",0)-2)
			   $ConnectionInstance[$i]=$ID
			   ;;;ConsoleWrite($ID&" loggin"&@CRLF)
			   TCPSendLogged($Connection[$i][0], "+ cmVhbG09ImVsd29vZC5pbm5vc29mdC5jb20iLG5vbmNlPSJPQTZNRzl0RVFHbTJoaCIscW9wPSJhdXRoIixhbGdvcml0aG09bWQ1LXNlc3MsY2hhcnNldD11dGYtOA=="&@CRLF)
			   Return
			EndIf

EndFunc
Func ListUserID($i)
   $query="SELECT DISTINCT servicecall.id FROM servicecall LEFT JOIN dispatch ON dispatch.id = servicecall.dispatchid WHERE servicecall.disabled='0' AND servicecall.userid='"&$ConnectionSubInstance[$i]&"' AND dispatch.status='2'"
   Return _SQLQueryRows($query)
EndFunc

Func ListUserSC($i)
   $query="SELECT DISTINCT servicecall.id,servicecall.dispatchid,company.name,address.address,dispatch.reportedissue,dispatch.reportedby,dispatch.contact,dispatch.notes,user.name,servicecall.date,starttime,time,traveltime,solution FROM servicecall LEFT JOIN user ON user.id = servicecall.userid LEFT JOIN dispatch ON dispatch.id = servicecall.dispatchid LEFT JOIN address ON address.id = dispatch.addressid LEFT JOIN contacts ON company.nameid = dispatch.contactid LEFT JOIN company ON company.id=contacts.companyid WHERE servicecall.userid="&$ConnectionSubInstance[$i]
   Return _SQLQueryTable($query)
EndFunc

Func ListAddress($i)
   $query="SELECT DISTINCT address.id,address.address,address.city,address.state,address.zip,address.country FROM address WHERE address LIKE '%"&$messagedata[$i]&"%' OR city LIKE '%"&$messagedata[$i]&"%' OR state LIKE '%"&$messagedata[$i]&"%' OR zip LIKE '%"&$messagedata[$i]&"%' OR country LIKE '%"&$messagedata[$i]&"%' LIMIT '20'"
   Return _SQLQueryTable($query)
EndFunc

Func _GetStringWidth($string)
   $strlen=StringLen($string)
   if $strlen=0 Then Return 0
   $stringwidth=0
   For $i = 0 to $strlen
	  $stringwidth=$stringwidth+$charwidth[$i]
   Next
   ;if $string='$43.55' Then MsgBox('',$string&'-',$stringwidth)
   ;if $string='Subtotal:' Then MsgBox('',$string&'-',$stringwidth*.25)
Return Round($stringwidth*.25)

 ;1. Edit Your Service Call
 ;2. Create Dispatch Use Existing Equipment ID
 ;3. Create Dispatch With New Equipment ID
 ;4. Edit Dispatch
 ;5. Edit Other Service Call
 ;6. Edit Customer Contact
 ;7. Edit Equipment
 ;8. Find Address
 ;0. Go Back

 ;1. Use Existing Equipment ID
 ;2. New Equipment ID
 ;3.