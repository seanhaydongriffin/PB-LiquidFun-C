; example1.nsi
;
; This script is perhaps one of the simplest NSIs you can make. All of the
; optional settings are left to their default settings. The installer simply 
; prompts the user asking them where to install, and drops a copy of example1.nsi
; there. 

;--------------------------------

; The name of the installer
Name "PureBasic LiquidFun OpenGL Demo"

; The file to write
OutFile "PB_LiquidFun_OpenGL_demo_setup.exe"

; The default installation directory
InstallDir "$DESKTOP\PureBasic LiquidFun OpenGL Demo"

; Request application privileges for Windows Vista
RequestExecutionLevel user

;--------------------------------

; Pages

Page directory
Page instfiles

;--------------------------------

; The stuff to install
Section "" ;No components page, name is not important

  SetOutPath $INSTDIR
  File LiquidFun-C.lib
  File LiquidFun-C.dll
  File PB_LiquidFun_OpenGL_demo.exe
  SetOutPath $INSTDIR\data
  File data\*.*
  SetOutPath $INSTDIR\texture
  File texture\*.*

  
SectionEnd ; end the section
