#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
 #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#Include JSON_to_obj.ahk

whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
whr.Open("GET", "http://manifest.robertsspaceindustries.com/Launcher/_LauncherInfo", true)
whr.Send()
whr.WaitForResponse()
jsonurl := whr.ResponseText

Loop, Parse, jsonurl, `n, `r
{
	ifInString, A_LoopField, Public_fileIndex
	{
		jsonurl := A_LoopField
		Continue
	}
	ifInString, A_LoopField, Public_version
	{
		version := A_LoopField
		Continue
	}
}

StringSplit, jsonurl, jsonurl, %A_Space%
jsonurl := jsonurl3

StringSplit, version, version, =
version := version2

whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
whr.Open("GET", jsonurl, true)
whr.Send()
whr.WaitForResponse()
json := whr.ResponseText

jsonobj := json_toobj(json)

weburl := jsonobj["webseed_urls"][1]
prefix := jsonobj["key_prefix"]

IfExist, StarCitizen %version%.txt
	FileDelete, StarCitizen %version%.txt
For jkey, value in jsonobj["file_list"]
	FileAppend, %weburl%/%prefix%/%value%`n, StarCitizen %version%.txt

SoundPlay, %A_WinDir%\Media\ding.wav, 1