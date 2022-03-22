Attribute VB_Name = "system"
Option Explicit
Public Declare PtrSafe Function CreateDirectory Lib "kernel32.dll" Alias "CreateDirectoryA" (ByVal lpPathName As String, ByVal lpSecurityAttributes As LongPtr) As Long
Public Declare PtrSafe Function CloseHandle Lib "kernel32.dll" (ByVal hObject As Long) As Long
Public Declare PtrSafe Function ReadProcessMemory Lib "kernel32" (ByVal hProcess As Long, ByVal lngBaseAddress As LongPtr, ByVal lpBuffer As LongPtr, ByVal lngSize As Long, ByRef lpNumberOfBytesWritten As Long) As Long
Private Declare PtrSafe Function GetTempPath Lib "kernel32" Alias "GetTempPathA" (ByVal nBufferLength As Long, ByVal lpBuffer As String) As Long
Private Declare PtrSafe Function SuspendThread Lib "kernel32" (ByVal hthread As Long) As Long
Private Declare PtrSafe Function ResumeThread Lib "kernel32" (ByVal hthread As Long) As Long
Private Declare PtrSafe Function OpenThread Lib "kernel32" (ByVal dwDesiredAccess As Long, ByVal bInheritHandle As Long, ByVal dwProcessId As Long) As Long
Private Declare PtrSafe Function CreateToolhelp32Snapshot Lib "kernel32" (ByVal dwFlags As Long, ByVal dwProcessId As Long) As Long
Private Declare PtrSafe Function Thread32First Lib "kernel32" (ByVal hObject As Long, ByRef stThread As THREADENTRY32) As Boolean
Private Declare PtrSafe Function Thread32Next Lib "kernel32" (ByVal hObject As Long, ByRef stThread As THREADENTRY32) As Boolean
Private Declare PtrSafe Function ProcessFirst Lib "kernel32" Alias "Process32First" (ByVal hsnapshot As Long, ByRef stProc As PROCESSENTRY32) As Boolean
Private Declare PtrSafe Function ProcessNext Lib "kernel32" Alias "Process32Next" (ByVal hsnapshot As Long, ByRef stProc As PROCESSENTRY32) As Boolean
Private Declare PtrSafe Function OpenProcess Lib "kernel32" (ByVal dwDesiredAccess As Long, ByVal bInheritHandle As Long, ByVal dwProcessId As Long) As Long
Private Enum SYSTEM_THREAD_ACCESS
    SYSTEM_THREAD_TERMINATE = 1
    SYSTEM_THREAD_SUSPENDRESUME = 2
    SYSTEM_THREAD_GETCONTEXT = 8
    SYSTEM_THREAD_SETCONTEXT = 16
    SYSTEM_THREAD_SETINFORMATION = 32
    SYSTEM_THREAD_QUERYINFORMATION = 64
    SYSTEM_THREAD_SETTHREADTOKEN = 128
    SYSTEM_THREAD_IMPERSONATE = 256
    SYSTEM_THREAD_DIRECTIMPERSONATION = 512
    SYSTEM_THREAD_STANDARDRIGHTSREQUIRED = &HF0000
    SYSTEM_THREAD_SYNCHRONIZE = &H100000
    SYSTEM_THREAD_ALLACCESS = SYSTEM_THREAD_STANDARDRIGHTSREQUIRED Or SYSTEM_THREAD_SYNCHRONIZE Or &H3FF
End Enum
Public Type PROCESSENTRY32
    dwSize As Long
    cntUsage As Long
    th32ProcessID As Long
    th32DefaultHeapID As Long
    th32DefaultHeapIDB As Long
    th32ModuleID As Long
    cntThreads As Long
    th32ParentProcessID As Long
    pcPriClassBase As Long
    pcPriClassBaseB As Long
    dwFlags As Long
    szExeFile As String * MAXPATH
End Type
Private Type THREADENTRY32
    dwSize As Long
    cntUsage As Long
    th32ThreadID As Long
    th32OwnerProcessID As Long
    tpBasePri As Long
    tpDeltaPri As Long
    dwFlags As Long
End Type
Private Enum SYSTEM_TH32CS_FLAGS
    SYSTEM_TH32CS_INHERIT = &H80000000
    SYSTEM_TH32CS_SNAPHEAPLIST = &H1
    SYSTEM_TH32CS_SNAPMODULE = &H8
    SYSTEM_TH32CS_SNAPMODULE32 = &H10
    SYSTEM_TH32CS_SNAPPROCESS = &H2
    SYSTEM_TH32CS_SNAPTHREAD = &H4
    SYSTEM_TH32CS_SNAPALL = SYSTEM_TH32CS_SNAPHEAPLIST Or SYSTEM_TH32CS_SNAPMODULE Or SYSTEM_TH32CS_SNAPPROCESS Or SYSTEM_TH32CS_SNAPTHREAD
End Enum
Public Enum SYSTEM_PROC_ACCESS
    SYSTEM_PROC_DELETE = &H10000
    SYSTEM_PROC_READCONTROL = &H20000
    SYSTEM_PROC_SYNCHRONIZE = &H100000
    SYSTEM_PROC_WRITEDAC = &H40000
    SYSTEM_PROC_WRITEOWNER = &H80000
    SYSTEM_PROC_CREATEPROCESS = &H80
    SYSTEM_PROC_CREATETHREAD = &H2
    SYSTEM_PROC_DUPHANDLE = &H40
    SYSTEM_PROC_QUERYINFORMATION = &H400
    SYSTEM_PROC_QUERYLIMITEDINFORMATION = &H1000
    SYSTEM_PROC_SETINFORMATION = &H200
    SYSTEM_PROC_SETQUOTA = &H100
    SYSTEM_PROC_SUSPENDRESUME = &H800
    SYSTEM_PROC_TERMINATE = &H1
    SYSTEM_PROC_VMOPERATION = &H8
    SYSTEM_PROC_VMREAD = &H10
    SYSTEM_PROC_VMWRITE = &H20
End Enum

Public Function System_Clipboard(Optional ByVal strText As Variant = "") As String
Dim objHtml As Object
    Set objHtml = CreateObject("htmlfile")
    If strText = "" Then
        System_Clipboard = objHtml.parentWindow.clipboardData.GetData("text")
    Else
        objHtml.parentWindow.clipboardData.setData "text", strText
    End If
    Set objHtml = Nothing
End Function

Public Function System_WMIGetProcessByName(ByRef strProcessImageName As String, ByRef objProcess As Object) As Long
'objProcess.processid
'objProcess.name
'objProcess.executablepath
'...
    Dim objWmiSet As Object
    Dim objWmi As Object
    Set objWmi = GetObject("winmgmts:root\cimv2")
    Set objWmiSet = objWmi.ExecQuery("SELECT * FROM win32_process WHERE Name LIKE '" + strProcessImageName + "'")
    If objWmiSet.Count = 0 Then
        Set objProcess = Nothing
        System_WMIGetProcessByName = -1
    Else
        Set objProcess = objWmiSet.itemindex(0)
        System_WMIGetProcessByName = objProcess.ProcessId
    End If
    Set objWmiSet = Nothing
    Set objWmi = Nothing
End Function
 
Public Function System_ToogleProcessById(ByRef lngProcId As Long, ByRef blnOff As Boolean) As Long
Dim lngSnapshot As Long
Dim lngThread As Long
Dim stThread As THREADENTRY32
    lngSnapshot = CreateToolhelp32Snapshot(SYSTEM_TH32CS_SNAPTHREAD, 0)
    If lngSnapshot <> -1 Then
        stThread.dwSize = Len(stThread)
        If Thread32First(lngSnapshot, stThread) Then
            Do
                If stThread.th32OwnerProcessID = lngProcId Then
                    lngThread = OpenThread(SYSTEM_THREAD_SUSPENDRESUME, 0, stThread.th32ThreadID)
                    If lngThread <> 0 Then
                        If blnOff Then SuspendThread (lngThread) Else ResumeThread (lngThread)
                        CloseHandle lngThread
                        System_ToogleProcessById = System_ToogleProcessById + 1
                    End If
                End If
            Loop While Thread32Next(lngSnapshot, stThread)
        End If
        CloseHandle lngSnapshot
    End If
End Function

Public Function System_APIGetProcessByName(ByRef strProcessImageName As String, ByRef stProcess As PROCESSENTRY32) As Long
Dim lngSnapshot As Long
Dim ProcessId As Long
    lngSnapshot = CreateToolhelp32Snapshot(SYSTEM_TH32CS_SNAPPROCESS, 0&)
    If lngSnapshot <> -1 Then
        stProcess.dwSize = Len(stProcess)
        If ProcessFirst(lngSnapshot, stProcess) Then
            Do
                If LCase(Left(stProcess.szExeFile, InStr(1, stProcess.szExeFile, Chr(0)) - 1)) = LCase(strProcessImageName) Then
                    System_APIGetProcessByName = stProcess.th32ProcessID
                    CloseHandle lngSnapshot
                    Exit Function
                End If
            Loop While ProcessNext(lngSnapshot, stProcess)
            System_APIGetProcessByName = -1
        Else
            System_APIGetProcessByName = -1
        End If
        CloseHandle lngSnapshot
    Else
        System_APIGetProcessByName = -1
    End If
End Function

Public Function System_ToogleProcessByName(ByRef strProcessImageName As String, ByRef blnOff As Boolean) As Long
Dim stProcess As PROCESSENTRY32
    stProcess.th32ProcessID = System_APIGetProcessByName(strProcessImageName, stProcess)
    If stProcess.th32ProcessID <> -1 Then
        System_ToogleProcessByName = System_ToogleProcessById(stProcess.th32ProcessID, blnOff)
    End If
End Function

Public Function System_OpenProcessByName(ByRef strProcessImageName As String, ByRef lngProcAccess As SYSTEM_PROC_ACCESS, ByRef stProcess As PROCESSENTRY32) As Long
    If System_APIGetProcessByName(strProcessImageName, stProcess) <> -1 Then System_OpenProcessByName = OpenProcess(lngProcAccess, 0, stProcess.th32ProcessID)
End Function

Public Function System_ReadProcessLongMemoryDataSegment(ByRef lngHProcess As Long, ByRef lngLngMemoryBase As LongLong, ByVal lngDataCount As Long, ByRef lngDataSegment() As Long) As Long
    ReDim lngDataSegment(1 To lngDataCount)
    System_ReadProcessLongMemoryDataSegment = ReadProcessMemory(lngHProcess, lngLngMemoryBase, VarPtr(lngDataSegment(1)), lngDataCount * 4, 0)
End Function

Public Function System_GetTempFolderPath() As String
    System_GetTempFolderPath = Space(MAXPATH)
    System_GetTempFolderPath = Left(System_GetTempFolderPath, GetTempPath(MAXPATH, System_GetTempFolderPath))
End Function
