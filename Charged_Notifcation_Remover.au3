#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=D:\Downloads\1332576732_android(1).ico
#AutoIt3Wrapper_Outfile=Charged_Notifcation_Remover.exe
#AutoIt3Wrapper_Res_Description=©2012 broodplank.net
#AutoIt3Wrapper_Res_Fileversion=0.1.0.0
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#AutoIt3Wrapper_Run_Tidy=y
#AutoIt3Wrapper_Run_Obfuscator=y
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <Process.au3>
#include <File.au3>

$openfile = FileOpenDialog("Charged Notifcation Remover - Please choose a Samsung based SystemUI.apk", @WorkingDir, "APK Files (*.apk)", 1, "SystemUI.apk")
If @error Then
	MsgBox(16, "Charged Notifcation Remover", "Aborted..")
	Exit
Else
	If FileExists(@ScriptDir & "\classes.dex") Then FileDelete(@ScriptDir & "\classes.dex")
	If FileExists(@ScriptDir & "\out.dex") Then FileDelete(@ScriptDir & "\out.dex")
	If FileExists(@ScriptDir & "\SystemUI.apk") Then FileDelete(@ScriptDir & "\SystemUI.apk")
	If FileExists(@ScriptDir & "\SystemUI.zip") Then FileDelete(@ScriptDir & "\SystemUI.zip")
	If FileExists(@ScriptDir & "\finished_apks\SystemUI.apk") Then FileDelete(@ScriptDir & "\finished_apks\SystemUI.apk")
	If FileExists(@ScriptDir & "\finished_apks\SystemUI.zip") Then FileDelete(@ScriptDir & "\finished_apks\SystemUI.zip")
	FileCopy($openfile, @ScriptDir & "\SystemUI.apk")
EndIf

DirRemove(@ScriptDir & "\dexout", 1)
If FileExists(@ScriptDir & "\finished_apks\SystemUI.apk.backup") Then FileDelete(@ScriptDir & "\finished_apks\SystemUI.apk.backup")
FileCopy(@ScriptDir & "\SystemUI.apk", @ScriptDir & "\finished_apks\SystemUI.apk.backup")
SplashTextOn("Charged Notifcation Remover", "Status: Making backup...", 250, 40, -1, -1, 4, "Verdana", 10, 400)
Sleep(100)

FileDelete(@TempDir & "\results.txt")

Func _StringSearchInFile($file, $qry)
	_RunDos("find /n /i """ & $qry & """ " & $file & " >> " & @TempDir & "\results.txt")
	If Not @error Then
		FileSetAttrib(@TempDir & "\results.txt", "-N+H+T", 0)
		$CHARS = FileGetSize(@TempDir & "\results.txt")
		Return FileRead(@TempDir & "\results.txt", $CHARS) & @CRLF
	EndIf
EndFunc   ;==>_StringSearchInFile

SplashTextOn("Charged Notifcation Remover", "Status: Extracting...", 250, 40, -1, -1, 4, "Verdana", 10, 400)
Sleep(100)
RunWait(@ScriptDir & "\extract.bat", "", @SW_HIDE)
SplashTextOn("Charged Notifcation Remover", "Status: Deodexing...", 250, 40, -1, -1, 4, "Verdana", 10, 400)
RunWait(@ScriptDir & "\deodex.bat", "", @SW_HIDE)

FileDelete(@TempDir & "\results.txt")

SplashTextOn("Charged Notifcation Remover", "Status: Determine lines...", 250, 40, -1, -1, 4, "Verdana", 10, 400)

$search1 = _StringSearchInFile(@ScriptDir & "\dexout\com\android\systemui\statusbar\policy\StatusBarPolicy.smali", "Landroid/app/NotificationManager;->notify(ILandroid/app/Notification;)V")
$readfirst = FileReadLine(@TempDir & "\results.txt", 3)
$readchars1 = StringLeft($readfirst, 5)
$startline = StringRight($readchars1, 4)

ConsoleWrite($startline & @CRLF)
FileDelete(@TempDir & "\results.txt")

$search2 = _StringSearchInFile(@ScriptDir & "\dexout\com\android\systemui\statusbar\policy\StatusBarPolicy.smali", "Lcom/android/systemui/statusbar/policy/StatusBarPolicy;->turnOnScreenWithForce()V")
$readsecond = FileReadLine(@TempDir & "\results.txt", 3)
$readchars2 = StringLeft($readsecond, 5)
$endline = StringRight($readchars2, 4)

$linecount = $endline - $startline


;~ FileDelete(@TempDir&"\results.txt")

$linecount = $endline - $startline
ConsoleWrite($linecount)

;This check makes no sense actually, will figure something more realistic soon.
If $linecount > 12 Or $linecount < 8 Then
	MsgBox(16, "Error", "Charged Notification lines are not found" & @CRLF & @CRLF & "Possible Reasons:" & @CRLF & "- No Samsung SystemUI.apk" & @CRLF & "- Already removed the charged notification")
	Exit
Else
	SplashTextOn("Charged Notifcation Remover", "Status: Deleting Line: " & $startline & "...", 250, 40, -1, -1, 4, "Verdana", 10, 400)
	_FileWriteToLine(@ScriptDir & "\dexout\com\android\systemui\statusbar\policy\StatusBarPolicy.smali", $startline, " ", 1)
	Sleep(500)
	SplashTextOn("Charged Notifcation Remover", "Status: Deleting Line: " & $endline - 3 & "...", 250, 40, -1, -1, 4, "Verdana", 10, 400)
	_FileWriteToLine(@ScriptDir & "\dexout\com\android\systemui\statusbar\policy\StatusBarPolicy.smali", $endline - 3, " ", 1)
	Sleep(500)
	SplashTextOn("Charged Notifcation Remover", "Status: Deleting Line: " & $endline & "...", 250, 40, -1, -1, 4, "Verdana", 10, 400)
	_FileWriteToLine(@ScriptDir & "\dexout\com\android\systemui\statusbar\policy\StatusBarPolicy.smali", $endline, " ", 1)
	Sleep(500)
EndIf

SplashTextOn("Charged Notifcation Remover", "Status: Compiling classes.dex...", 250, 40, -1, -1, 4, "Verdana", 10, 400)
RunWait(@ScriptDir & "\compile.bat", "", @SW_HIDE)
Sleep(100)
DirRemove(@ScriptDir & "\dexout", 1)

SplashTextOn("Charged Notifcation Remover", "Status: Updating SystemUI.apk...", 250, 40, -1, -1, 4, "Verdana", 10, 400)
RunWait(@ScriptDir & "\addfiles.bat", "", @SW_HIDE)
Sleep(100)

SplashTextOn("Charged Notifcation Remover", "Status: Moving..", 250, 40, -1, -1, 4, "Verdana", 10, 400)
Sleep(100)

SplashTextOn("Charged Notifcation Remover", "Status: Done!", 250, 40, -1, -1, 4, "Verdana", 10, 400)
Sleep(500)
SplashOff()
ShellExecute(@ScriptDir & "\finished_apks", "", "", "open", @SW_SHOW)
MsgBox(0, "Removed Charged Notification", "Thanks for using this tool, coded by: broodplank1337 @ XDA")

Exit

