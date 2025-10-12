Option Explicit
Dim intExitCode
intExitCode=0
If Wscript.Arguments.count=2 Then
	Dim fsoPatchFile,fsoTextFile,objRegExp,fsoOutFile,strTextLine,strPatchLine,fso,i,j,lngStartOffset,objMatchCollection,lngOffset,lngChar41Offset,lngOldChar41Offset,objSubRegExp,strPatchLines(),lngUbound
	Set fso=CreateObject("Scripting.FileSystemObject")
	Set objRegExp=New RegExp
	strPatchLine=Left(WScript.Arguments(1), InStrRev(WScript.Arguments(1), "\")) & Mid(WScript.Arguments(0), InStrRev(WScript.Arguments(0), "\") + 1)
	fso.CreateTextFile strPatchLine
	Set fsoOutFile=fso.GetFile(strPatchLine).OpenAsTextStream(2,0)
	Set fsoPatchFile=fso.GetFile(WScript.Arguments(1)).OpenAsTextStream(1,0)
	Set fsoTextFile=fso.GetFile(WScript.Arguments(0)).OpenAsTextStream(1,0)
	Do Until fsoPatchFile.AtEndOfStream Or fsoTextFile.AtEndOfStream
		objRegExp.Pattern=fsoPatchFile.ReadLine
		Do
			strTextLine=fsoTextFile.ReadLine
			If objRegExp.test(strTextLine) Then
				intExitCode=intExitCode+1
				i=CLng(fsoPatchFile.ReadLine)
				If i=0 Then
					'Replace the matched line
					Do Until fsoPatchFile.AtEndOfStream
						strPatchLine=fsoPatchFile.ReadLine
						If strPatchLine="" Then Exit Do
						fsoOutFile.WriteLine(strPatchLine)
					Loop
				ElseIf i<0 Then
					If i=-2147483648 Then
						Set objMatchCollection=objRegExp.Execute(strTextLine)
						i=objMatchCollection.Item(0).SubMatches.Count
						Set objMatchCollection=Nothing
						if i=0 Then
							'Add before the matched line
							Do Until fsoPatchFile.AtEndOfStream
								strPatchLine=fsoPatchFile.ReadLine
								If strPatchLine="" Then Exit Do
								fsoOutFile.WriteLine(strPatchLine)
							Loop
							fsoOutFile.WriteLine(strTextLine)
						Else
							'Replace parts of the matched line
							lngOffset=1
							lngChar41Offset=0
							lngOldChar41Offset=0
							Set objSubRegExp=New RegExp
							Do
								With objRegExp
								Do
									lngChar41Offset=InStr(lngChar41Offset+1,.Pattern,")")
								Loop Until Mid(.Pattern,lngChar41Offset-1,1)<>"\"
								objSubRegExp.Pattern=Mid(.Pattern,lngOldChar41Offset+1,lngChar41Offset-lngOldChar41Offset)
								End With
								Set objMatchCollection=objSubRegExp.Execute(Mid(strTextLine,lngOffset))
								With objMatchCollection.Item(0)
								fsoOutFile.Write(Mid(strTextLine,lngOffset,.Length-Len(.SubMatches(0))))
								fsoOutFile.Write(fsoPatchFile.ReadLine)
								lngOffset=lngOffset+.Length
								End With
								Set objMatchCollection = Nothing
								lngOldChar41Offset = lngChar41Offset
								i=i-1
							Loop Until i=0
							Set objSubRegExp=Nothing
							fsoOutFile.WriteLine(Mid(strTextLine,lngOffset))
							Do Until fsoPatchFile.AtEndOfStream
								If fsoPatchFile.ReadLine="" Then Exit Do
							Loop
						End If
					ElseIf i=-1 Then
						'Add before the matched line
						Do Until fsoPatchFile.AtEndOfStream
							strPatchLine=fsoPatchFile.ReadLine
							If strPatchLine="" Then Exit Do
							fsoOutFile.WriteLine(strPatchLine)
						Loop
						fsoOutFile.WriteLine(strTextLine)
					Else
						lngOldChar41Offset=-i-1
						i=0
						redim strPatchLines(lngOldChar41Offset,2)
						strPatchLines(0,0)=strTextLine
						strTextLine=fsoPatchFile.ReadLine
						j=Instr(strTextLine,"")
						strPatchLines(0,1)=Left(strTextLine,j-1)
						strPatchLines(0,2)=Mid(strTextLine,j+1)
						j=-1
						Do
							i=i+1
							if fsoTextFile.AtEndOfStream Then
								i=i-1
								For j=0 To i
									fsoOutFile.WriteLine(strPatchLines(j,0))
								Next
								Exit Do
							Else
								strPatchLines(i,0)=fsoTextFile.ReadLine
								strTextLine=fsoPatchFile.ReadLine
								lngChar41Offset=Instr(strTextLine,"")
								strPatchLines(i,1)=Left(strTextLine,lngChar41Offset-1)
								strPatchLines(i,2)=Mid(strTextLine,lngChar41Offset+1)
								objRegExp.Pattern=strPatchLines(i,1)
								If Not objRegExp.test(strPatchLines(i,0)) Then
									For j=0 To i
										fsoOutFile.WriteLine(strPatchLines(j,0))
									Next
									lngChar41Offset=0
									Do Until fsoTextFile.AtEndOfStream
										strPatchLines(lngChar41Offset,0)=fsoTextFile.ReadLine
										objRegExp.Pattern=strPatchLines(lngChar41Offset,1)
										If objRegExp.test(strPatchLines(lngChar41Offset,0)) Then
											If (lngChar41Offset=i) Then
												j=-1
												Exit Do
											Else
												lngChar41Offset=lngChar41Offset+1
											End If
										Else
											For lngOffset=0 To lngChar41Offset
												fsoOutFile.WriteLine(strPatchLines(lngOffset,0))
											Next
											lngChar41Offset=0
										End If
									Loop
									If (lngChar41Offset<>0) And (j<>-1) Then
										lngChar41Offset=lngChar41Offset-1
										For lngOffset=0 To lngChar41Offset
											fsoOutFile.WriteLine(strPatchLines(lngOffset,0))
										Next
									End if
								End If
							End If
						Loop Until i=lngOldChar41Offset
						lngUbound=i
						Do While j<lngUbound
							j=j+1
							If strPatchLines(j,2)="" Then
								'Keep original line
								fsoOutFile.WriteLine(strPatchLines(j,0))
							Else
								objRegExp.Pattern=strPatchLines(j,1)
								Set objMatchCollection=objRegExp.Execute(strPatchLines(j,0))
								i=objMatchCollection.Item(0).SubMatches.Count
								Set objMatchCollection=Nothing
								lngOffset=1
								if i=0 Then
									'Replace the matched line
									lngChar41Offset=InStr(strPatchLines(j,2),"")
									Do Until lngChar41Offset=0
										fsoOutFile.WriteLine(Mid(strPatchLines(j,2),lngOffset,lngChar41Offset-lngOffset))
										lngOffset=lngChar41Offset+1
										lngChar41Offset=InStr(lngOffset,strPatchLines(j,2),"")
									Loop
									fsoOutFile.WriteLine(Mid(strPatchLines(j,2),lngOffset))
								Else
									'Replace parts of the matched line
									lngChar41Offset=0
									lngOldChar41Offset=0
									lngStartOffset=1
									Set objSubRegExp=New RegExp
									Do
										With objRegExp
										Do
											lngChar41Offset=InStr(lngChar41Offset+1,.Pattern,")")
										Loop Until Mid(.Pattern,lngChar41Offset-1,1)<>"\"
										objSubRegExp.Pattern=Mid(.Pattern,lngOldChar41Offset+1,lngChar41Offset-lngOldChar41Offset)
										End With
										Set objMatchCollection=objSubRegExp.Execute(Mid(strPatchLines(j,0),lngOffset))
										With objMatchCollection.Item(0)
										fsoOutFile.Write(Mid(strPatchLines(j,0),lngOffset,.Length-Len(.SubMatches(0))))
										if lngStartOffset<>0 Then
											lngOldChar41Offset=Instr(lngStartOffset,strPatchLines(j,2),"")
											If lngOldChar41Offset=0 Then
												fsoOutFile.Write(Mid(strPatchLines(j,2),lngStartOffset))
												lngStartOffset=0
											Else
												fsoOutFile.Write(Mid(strPatchLines(j,2),lngStartOffset,lngOldChar41Offset-lngStartOffset))
												lngStartOffset=lngOldChar41Offset+1
											End If
										End If
										lngOffset=lngOffset+.Length
										End With
										Set objMatchCollection = Nothing
										lngOldChar41Offset = lngChar41Offset
										i=i-1
									Loop Until i=0
									Set objSubRegExp=Nothing
									fsoOutFile.WriteLine(Mid(strPatchLines(j,0),lngOffset))
								End If
							End If
						Loop
						Do Until fsoPatchFile.AtEndOfStream
							If fsoPatchFile.ReadLine="" Then Exit Do
						Loop
						Erase strPatchLines
					End If
				Else
					'Skip i-1 lines after the matched line and add
					fsoOutFile.WriteLine(strTextLine)
					Do Until i=1 Or fsoTextFile.AtEndOfStream
						fsoOutFile.WriteLine(fsoTextFile.ReadLine)
						i=i-1
					Loop
					Do Until fsoPatchFile.AtEndOfStream
						strPatchLine=fsoPatchFile.ReadLine
						If strPatchLine="" Then Exit Do
						fsoOutFile.WriteLine(strPatchLine)
					Loop
				End If
				Exit Do
			Else
				fsoOutFile.WriteLine(strTextLine)
			End If
		Loop Until fsoTextFile.AtEndOfStream
	Loop
	Do Until fsoTextFile.AtEndOfStream
		fsoOutFile.WriteLine(fsoTextFile.ReadLine)
	Loop
	If Not fsoPatchFile.AtEndOfStream Then
		intExitCode=intExitCode+1
		Do
			fsoOutFile.WriteLine(fsoPatchFile.ReadLine)
		Loop Until fsoPatchFile.AtEndOfStream
	End If
	fsoOutFile.Close
	fsoPatchFile.Close
	fsoTextFile.Close
	Set fsoOutFile=Nothing
	Set fsoPatchFile=Nothing
	Set fsoTextFile=Nothing
	Set objRegExp=Nothing
	Set fso=Nothing
	WScript.Echo intExitCode
Else
	WScript.Echo "USAGE: CScript //Nologo",WScript.ScriptName,"<text file path> <patch file path>"
End If
WScript.Quit intExitCode