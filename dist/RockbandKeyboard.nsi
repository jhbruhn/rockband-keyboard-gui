; Rockband Keyboard
; Installer Source
; Version 1.0

;Include Modern UI
!include "MUI2.nsh"
!include "FileFunc.nsh"

;General Settings
!searchparse /file "../package.json" `  "version": "` RK_VERSION `",`
Name "Rockband Keyboard"
Caption "Rockband Keyboard v${RK_VERSION}"
BrandingText "Rockband Keyboard v${RK_VERSION}"
VIAddVersionKey "ProductName" "Rockband Keyboard"
VIAddVersionKey "ProductVersion" "v${RK_VERSION}"
VIAddVersionKey "FileDescription" "Rockband Keyboard"
VIAddVersionKey "FileVersion" "v${RK_VERSION}"
VIAddVersionKey "CompanyName" "Jan-Henrik Bruhn"
VIAddVersionKey "LegalCopyright" "https://github.com/jhbruhn/rockband-keyboard-gui"
VIAddVersionKey "OriginalFilename" "Rockband-Keyboard-Win-32.exe"
VIProductVersion "${RK_VERSION}.0"
OutFile "Rockband-Keyboard-${RK_VERSION}-Win-32.exe"
CRCCheck on
SetCompressor /SOLID lzma
!define NW_VER "0.9.2"
!define UNINSTALLPATH "Software\Microsoft\Windows\CurrentVersion\Uninstall\Rockband-Keyboard"

;Default installation folder
InstallDir "$APPDATA\Rockband Keyboard"

;Request application privileges
RequestExecutionLevel user

;Define UI settings
!define MUI_LICENSEPAGE_BGCOLOR /GRAY
!define MUI_ICON "..\res\icon.ico"
!define MUI_UNICON "..\res\icon.ico"
!define MUI_ABORTWARNING
!define MUI_FINISHPAGE_RUN
!define MUI_FINISHPAGE_RUN_TEXT "Start Rockband Keyboard"
!define MUI_FINISHPAGE_RUN_FUNCTION "LaunchRockbandKeyboard"
!define MUI_FINISHPAGE_LINK "Rockband Keyboard Official Homepage"
!define MUI_FINISHPAGE_LINK_LOCATION "https://github.com/jhbruhn/rockband-keyboard-gui"

;Define the pages
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "../LICENSE"
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

;Load Language Files
!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "Afrikaans"
!insertmacro MUI_LANGUAGE "Albanian"
!insertmacro MUI_LANGUAGE "Arabic"
!insertmacro MUI_LANGUAGE "Basque"
!insertmacro MUI_LANGUAGE "Belarusian"
!insertmacro MUI_LANGUAGE "Bosnian"
!insertmacro MUI_LANGUAGE "Breton"
!insertmacro MUI_LANGUAGE "Bulgarian"
!insertmacro MUI_LANGUAGE "Catalan"
!insertmacro MUI_LANGUAGE "Croatian"
!insertmacro MUI_LANGUAGE "Czech"
!insertmacro MUI_LANGUAGE "Danish"
!insertmacro MUI_LANGUAGE "Dutch"
!insertmacro MUI_LANGUAGE "Esperanto"
!insertmacro MUI_LANGUAGE "Estonian"
!insertmacro MUI_LANGUAGE "Farsi"
!insertmacro MUI_LANGUAGE "Finnish"
!insertmacro MUI_LANGUAGE "French"
!insertmacro MUI_LANGUAGE "Galician"
!insertmacro MUI_LANGUAGE "German"
!insertmacro MUI_LANGUAGE "Greek"
!insertmacro MUI_LANGUAGE "Hebrew"
!insertmacro MUI_LANGUAGE "Hungarian"
!insertmacro MUI_LANGUAGE "Icelandic"
!insertmacro MUI_LANGUAGE "Indonesian"
!insertmacro MUI_LANGUAGE "Irish"
!insertmacro MUI_LANGUAGE "Italian"
!insertmacro MUI_LANGUAGE "Japanese"
!insertmacro MUI_LANGUAGE "Korean"
!insertmacro MUI_LANGUAGE "Kurdish"
!insertmacro MUI_LANGUAGE "Latvian"
!insertmacro MUI_LANGUAGE "Lithuanian"
!insertmacro MUI_LANGUAGE "Luxembourgish"
!insertmacro MUI_LANGUAGE "Macedonian"
!insertmacro MUI_LANGUAGE "Malay"
!insertmacro MUI_LANGUAGE "Mongolian"
!insertmacro MUI_LANGUAGE "Norwegian"
!insertmacro MUI_LANGUAGE "NorwegianNynorsk"
!insertmacro MUI_LANGUAGE "Polish"
!insertmacro MUI_LANGUAGE "Portuguese"
!insertmacro MUI_LANGUAGE "PortugueseBR"
!insertmacro MUI_LANGUAGE "Romanian"
!insertmacro MUI_LANGUAGE "Russian"
!insertmacro MUI_LANGUAGE "Serbian"
!insertmacro MUI_LANGUAGE "SerbianLatin"
!insertmacro MUI_LANGUAGE "SimpChinese"
!insertmacro MUI_LANGUAGE "Slovak"
!insertmacro MUI_LANGUAGE "Slovenian"
!insertmacro MUI_LANGUAGE "Spanish"
!insertmacro MUI_LANGUAGE "SpanishInternational"
!insertmacro MUI_LANGUAGE "Swedish"
!insertmacro MUI_LANGUAGE "Thai"
!insertmacro MUI_LANGUAGE "TradChinese"
!insertmacro MUI_LANGUAGE "Turkish"
!insertmacro MUI_LANGUAGE "Ukrainian"
!insertmacro MUI_LANGUAGE "Uzbek"
!insertmacro MUI_LANGUAGE "Welsh"

AutoCloseWindow false
ShowInstDetails show
ShowUninstDetails show

Section ; App Files

	RMDir /r "$INSTDIR"

	;Set output path to InstallDir
	SetOutPath "$INSTDIR"

	;Add the files
	File /r "rockband-keyboard-gui-win-ia32\*.*"
	File "/oname=Rockband-Keyboard.exe" "rockband-keyboard-gui-win-ia32\nw.exe"

	;Create uninstaller
	WriteUninstaller "$INSTDIR\Uninstall.exe"

SectionEnd

Section ; Shortcuts

	SetOutPath "$INSTDIR"

	;Working Directory Shortcut
	CreateShortCut "$INSTDIR\Start Rockband Keyboard.lnk" "$INSTDIR\Rockband-Keyboard.exe" "" "$INSTDIR\res\icon.ico" "" "" "" "Start Rockband Keyboard"

	;Start Menu Shortcut
	RMDir /r "$SMPROGRAMS\Rockband Keyboard"
	CreateDirectory "$SMPROGRAMS\Rockband Keyboard"
	CreateShortCut "$SMPROGRAMS\Rockband Keyboard\Rockband Keyboard.lnk" "$INSTDIR\Rockband-Keyboard.exe" "" "$INSTDIR\res\icon.ico" "" "" "" "Start Rockband Keyboard"
	CreateShortCut "$SMPROGRAMS\Rockband Keyboard\Uninstall.lnk" "$INSTDIR\Uninstall.exe"

	;Desktop Shortcut
	Delete "$DESKTOP\Rockband Keyboard.lnk"
	CreateShortCut "$DESKTOP\Rockband Keyboard.lnk" "$INSTDIR\Rockband-Keyboard.exe" "" "$INSTDIR\res\icon.ico" "" "" "" "Start Rockband Keyboard"

	WriteRegStr HKLM "${UNINSTALLPATH}" "DisplayName" "Rockband Keyboard"
	WriteRegStr HKLM "${UNINSTALLPATH}" "DisplayVersion" "${RK_VERSION}"
	WriteRegStr HKLM "${UNINSTALLPATH}" "Publisher" "Jan-Henrik Bruhn"
	WriteRegStr HKLM "${UNINSTALLPATH}" "UninstallString" "$\"$INSTDIR\Uninstall.exe$\""
	WriteRegStr HKLM "${UNINSTALLPATH}" "InstallLocation" "$\"$INSTDIR$\""
	WriteRegStr HKLM "${UNINSTALLPATH}" "DisplayIcon" "$\"$INSTDIR\res\icon.ico$\""
	WriteRegStr HKLM "${UNINSTALLPATH}" "URLInfoAbout" "https://github.com/jhbruhn/rockband-keyboard-gui"
	WriteRegStr HKLM "${UNINSTALLPATH}" "HelpLink" "https://github.com/jhbruhn/rockband-keyboard-gui/issues"
	WriteRegDWORD HKLM "${UNINSTALLPATH}" "NoModify" 1
	WriteRegDWORD HKLM "${UNINSTALLPATH}" "NoRepair" 1
	${GetSize} "$INSTDIR" "/S=0K" $0 $1 $2
	IntFmt $0 "0x%08X" $0
	WriteRegDWORD HKLM "${UNINSTALLPATH}" "EstimatedSize" "$0"

SectionEnd

Section "un.uninstall" ; Uninstaller

	RMDir /r "$INSTDIR"
	RMDir /r "$SMPROGRAMS\Rockband Keyboard"
	Delete "$DESKTOP\Rockband Keyboard.lnk"
	DeleteRegKey HKLM "${UNINSTALLPATH}"

SectionEnd

Function "LaunchRockbandKeyboard"
  ExecShell "" "$INSTDIR\Start Rockband Keyboard.lnk"
FunctionEnd
