Set objArgs = WScript.Arguments
If objArgs.Count <= 0 Then
  Wscript.Echo "Received no files. Drag N Drop them onto the script."
  WScript.Quit 1
End If

'Create Shell
dim shell
set shell = CreateObject("WScript.Shell")

'Create File System
dim fileSys, currFolder
set fileSys = CreateObject("Scripting.FileSystemObject")
currFolder = fileSys.GetParentFolderName(WScript.ScriptFullName)

'Do I need to create the folders
dim wavOut, rawOut, needMultipleCmd
wavOut = 0
rawOut = 0
needMultipleCmd = 0

'Create the command
dim command
command = ""
For I = 0 to objArgs.Count - 1

  'Execute to prevent too long command
  If len(command) => 6000 Then
    command = "cmd /K cd /d " & currFolder & " & " & command & " & pause & exit"

    If needMultipleCmd = 0 Then
      needMultipleCmd = 1
      Wscript.Echo "Command getting too long. Will split in multiple runs."
    End If

    'Do it
    shell.Run command, 1, True

    command = ""
  ElseIf len(command) > 0 Then
    command = command & " & "
  End If

  dim path, ffmpegCom
  path = objArgs(I)

  If LCase(fileSys.GetExtensionName(path)) = "raw" Then
    
    'Folder
    If wavOut = 0 Then
      wavOut = 1
      If Not fileSys.FolderExists(currFolder & "\wavOut") Then
        fileSys.CreateFolder(currFolder & "\wavOut")
      End If
    End If

    ffmpegCom = "ffmpeg.exe -f s16le -ar 22050 -ac 2 -i """ & path & """ ""wavOut\" & fileSys.GetBaseName(path) & ".wav"""
  Else
    
    'Folder
    If rawOut = 0 Then
      rawOut = 1
      If Not fileSys.FolderExists(currFolder & "\rawOut") Then
        fileSys.CreateFolder(currFolder & "\rawOut")
      End If
    End If

    ffmpegCom = "ffmpeg.exe -i """ & path & """ -f s16le -c:a pcm_s16le -ar 22050 -ac 2 ""rawOut\" & fileSys.GetBaseName(path) & ".raw"""
  End If

  command = command & ffmpegCom
Next

If len(command) > 0 Then
  command = "cmd /K cd /d " & currFolder & " & " & command & " & pause & exit"

  'Do it
  shell.Run command, 1, True
End If