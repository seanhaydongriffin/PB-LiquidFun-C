


; #INDEX# =======================================================================================================================
; Title .........: CSFML
; FreeBasic Version : ?
; Language ......: English
; Description ...: SFML Functions.
; Author(s) .....: Sean Griffin
; Dlls ..........: csfml-system-2.dll, csfml-graphics-2.dll
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
#sfFalse = 0
#sfTrue = 1
; ===============================================================================================================================


; #ENUMERATIONS# ===================================================================================================================
Enumeration sfEventType
   #sfEvtClosed
   #sfEvtResized
   #sfEvtLostFocus
   #sfEvtGainedFocus
   #sfEvtTextEntered
   #sfEvtKeyPressed
   #sfEvtKeyReleased
   #sfEvtMouseWheelMoved
   #sfEvtMouseButtonPressed
   #sfEvtMouseButtonReleased
   #sfEvtMouseMoved
   #sfEvtMouseEntered
   #sfEvtMouseLeft
   #sfEvtJoyButtonPressed
   #sfEvtJoyButtonReleased
   #sfEvtJoyMoved
EndEnumeration

Enumeration sfKeyCode
   #sfKeyA = 0
   #sfKeyB = 1
   #sfKeyC = 2
   #sfKeyD = 3
   #sfKeyE = 4
   #sfKeyF = 102
   #sfKeyG = 103
   #sfKeyH = 104
   #sfKeyI = 105
   #sfKeyJ = 106
   #sfKeyK = 107
   #sfKeyL = 108
   #sfKeyM = 109
   #sfKeyN = 110
   #sfKeyO = 111
   #sfKeyP = 112
   #sfKeyQ = 113
   #sfKeyR = 114
   #sfKeyS = 115
   #sfKeyT = 116
   #sfKeyU = 117
   #sfKeyV = 118
   #sfKeyW = 119
   #sfKeyX = 120
   #sfKeyY = 121
   #sfKeyZ = 122
   #sfKeyNum0 = 48
   #sfKeyNum1 = 49
   #sfKeyNum2 = 50
   #sfKeyNum3 = 51
   #sfKeyNum4 = 52
   #sfKeyNum5 = 53
   #sfKeyNum6 = 54
   #sfKeyNum7 = 55
   #sfKeyNum8 = 56
   #sfKeyNum9 = 57
   #sfKeyEscape = 36
   #sfKeyLControl
   #sfKeyLShift
   #sfKeyLAlt
   #sfKeyLSystem    ;;< OS specific key (left side) : windows (Win And Linux), apple (MacOS), ...
   #sfKeyRControl
   #sfKeyRShift
   #sfKeyRAlt
   #sfKeyRSystem      ;;< OS specific key (right side) : windows (Win And Linux), apple (MacOS), ...
   #sfKeyMenu
   #sfKeyLBracket     ;;< [
   #sfKeyRBracket    ;;< ]
   #sfKeySemiColon    ;;< ;
   #sfKeyComma        ;;< ,
   #sfKeyPeriod      ;;< .
   #sfKeyQuote        ;;< '
   #sfKeySlash      ;;< /
   #sfKeyBackSlash
   #sfKeyTilde       ;;< ~
   #sfKeyEqual       ;;< =
   #sfKeyDash         ;;< -
   #sfKeySpace
   #sfKeyReturn
   #sfKeyBack
   #sfKeyTab
   #sfKeyPageUp
   #sfKeyPageDown
   #sfKeyEnd
   #sfKeyHome
   #sfKeyInsert
   #sfKeyDelete
   #sfKeyAdd        ;;< +
   #sfKeySubtract     ;;< -
   #sfKeyMultiply    ;;< *
   #sfKeyDivide     ;;< /
   #sfKeyLeft         ;;< Left arrow
   #sfKeyRight       ;;< Right arrow
   #sfKeyUp          ;;< Up arrow
   #sfKeyDown         ;;< Down arrow
   #sfKeyNumpad0 = 295
   #sfKeyNumpad1 = 296
   #sfKeyNumpad2 = 297
   #sfKeyNumpad3 = 298
   #sfKeyNumpad4 = 299
   #sfKeyNumpad5 = 300
   #sfKeyNumpad6 = 301
   #sfKeyNumpad7 = 302
   #sfKeyNumpad8 = 303
   #sfKeyNumpad9 = 304
   #sfKeyF1 = 305
   #sfKeyF2 = 306
   #sfKeyF3 = 307
   #sfKeyF4 = 308
   #sfKeyF5 = 309
   #sfKeyF6 = 310
   #sfKeyF7 = 311
   #sfKeyF8 = 312
   #sfKeyF9 = 313
   #sfKeyF10 = 314
   #sfKeyF11 = 315
   #sfKeyF12 = 316
   #sfKeyF13 = 317
   #sfKeyF14 = 318
   #sfKeyF15 = 319
   #sfKeyPause

   #sfKeyCount ;; For internal use
EndEnumeration

Enumeration sfMouseButton
   #sfButtonLeft
   #sfButtonRight
   #sfButtonMiddle
   #sfButtonX1
   #sfButtonX2
EndEnumeration

Enumeration sfJoyAxis
   #sfJoyAxisX
   #sfJoyAxisY
   #sfJoyAxisZ
   #sfJoyAxisR
   #sfJoyAxisU
   #sfJoyAxisV
   #sfJoyAxisPOV
EndEnumeration
; ===============================================================================================================================


; #STRUCTURES# ===================================================================================================================

Structure sfVideoMode Align #PB_Structure_AlignC
    width2.i ; As uinteger
    height2.i ; As uinteger
    bitsPerPixel2.i ; As uinteger
EndStructure

Structure sfVector2f Align #PB_Structure_AlignC
    x.f ; As Single
    y.f ; As Single
EndStructure

Structure sfContextSettings Align #PB_Structure_AlignC
     depthBits.i ; As uinteger
     stencilBits.i ; As uinteger
     antialiasingLevel.i ; As uinteger
     majorVersion.i ; As uinteger
     minorVersion.i ; As uinteger
     attributeFlags.i ; As uinteger
     sRgbCapable.l ; As Boolean 
EndStructure

Structure sfKeyEvent Align #PB_Structure_AlignC
    type.i ; As sfEventType
    code.i ;.sfKeyCode
    alt.l ; As sfBool
    control.l ; As sfBool
    shift.l   ; As sfBool
    system.l
EndStructure

Structure sfTextEvent Align #PB_Structure_AlignC
    T.i ; as sfEventType
    Unicode.i ; As sfUint32
EndStructure

Structure sfMouseMoveEvent Align #PB_Structure_AlignC
    T.i ; As sfEventType
    X.i ; As integer
    Y.i ; As integer
EndStructure

Structure sfMouseButtonEvent Align #PB_Structure_AlignC
    T.i ; As sfEventType
    Button.i ; As sfMouseButton
    X.i ; As integer
    Y.i ; As integer
EndStructure

Structure sfMouseWheelEvent Align #PB_Structure_AlignC
    T.i ; As sfEventType
    Delta.i ; As integer
EndStructure

Structure sfJoyMoveEvent Align #PB_Structure_AlignC
    T.i ; As sfEventType
    JoystickId.i ; As uinteger
    Axis.i ; As sfJoyAxis
    Position.f ; As single
EndStructure

Structure sfJoyButtonEvent Align #PB_Structure_AlignC
    T.i ; As sfEventType
    JoystickId.i ; As uinteger
    Button.i ; As uinteger
EndStructure

Structure sfSizeEvent Align #PB_Structure_AlignC
    type.i ; As sfEventType
    width.i ; As uinteger
    height.i ; As uinteger
EndStructure

Structure sfEvent Align #PB_Structure_AlignC
StructureUnion 
    type.i ; As sfEventType ;;< Type of the event
    size.sfSizeEvent
    key.sfKeyEvent
    text.sfTextEvent
    mouseMove.sfMouseMoveEvent
    mouseButton.sfMouseButtonEvent
    mouseWheel.sfMouseWheelEvent
    JoyMove.sfJoyMoveEvent
    JoyButton.sfJoyButtonEvent
EndStructureUnion
EndStructure

Structure sfColor Align #PB_Structure_AlignC
    r.i ; As sfUint8
    g.i ; As sfUint8
    b.i ; As sfUint8
    a.i ; As sfUint8
EndStructure



; ===============================================================================================================================


; #GLOBALS# ===================================================================================================================

Global sfBool.i

;; 8 bits integer types
Global sfInt8.b
;Global sfUint8 As ubyte

;; 16 bits integer types
;Global sfInt16 As short
;Global sfUint16as As ushort

;; 32 bits integer types
Global sfInt32.i
;Global sfUint32 As uinteger

Global sfBlack.sfColor
Global sfWhite.sfColor
Global sfRed.sfColor
Global sfGreen.sfColor
Global sfBlue.sfColor
Global sfYellow.sfColor
Global sfMagenta.sfColor
Global sfCyan.sfColor

;Dim Shared As Any Ptr csfml_system_library
;Dim Shared As Any Ptr csfml_graphics_library
;Dim Shared As Any Ptr csfml_window_library
;Dim Shared As sfColor black => (0, 0, 0, 255)
;Dim Shared As sfColor white => (255, 255, 255, 255)
;Dim Shared As Any Ptr courier_new_font_ptr

Global event.sfEvent

Global black.sfColor
black\r = 0
black\g = 0
black\b = 0
black\a = 255

Global white.sfColor
white\r = 0
white\g = 100
white\b = 0
white\a = 255

Global mode.sfVideoMode



; ===============================================================================================================================


; #LIBRARIES# ===================================================================================================================

OpenLibrary(2, "csfml-system-2.dll")
OpenLibrary(3, "csfml-graphics-2.dll")
OpenLibrary(4, "csfml-window-2.dll")
OpenLibrary(6, "fb_csfml-graphics-2.dll")


; #VARIABLES# ===================================================================================================================
; ===============================================================================================================================


; #MISCELLANEOUS FUNCTIONS# =====================================================================================================


; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_Startup
; Description ...: Loads the CSFML DLLs
; Syntax.........: _CSFML_Startup
; Parameters ....: 
; Return values .: 
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......: _CSFML_Shutdown
; Link ..........:
; Example .......:
; ===============================================================================================================================
Procedure _CSFML_Startup()

  ;  courier_new_font_ptr = sfFont_createFromFile("C:\Windows\Fonts\cour.ttf")

  event\type = 999
  
  mode\width2 = 800
  mode\height2 = 600
  mode\bitsPerPixel2 = 16




EndProcedure

; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_Shutdown
; Description ...: Unloads the CSFML DLLs
; Syntax.........: _CSFML_Shutdown()
; Parameters ....:
; Return values .: None
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......: _CSFML_Startup
; Link ..........:
; Example .......:
; ===============================================================================================================================
Procedure _CSFML_Shutdown()

  ; unload the DLLs
  CloseLibrary(2)
  CloseLibrary(3)
  CloseLibrary(4)

EndProcedure


; #SFCLOCK FUNCTIONS# =====================================================================================================


; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfClock_create
; Description ...: Create a new clock and start it.
; Syntax.........: _CSFML_sfClock_create()
; Parameters ....:
; Return values .: Success - A pointer to the clock (sfClock).
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......: _CSFML_sfClock_getElapsedTime
; Link ..........:
; Example .......:
; ===============================================================================================================================
PrototypeC.l ProtosfClock_create()
Global _CSFML_sfClock_create.ProtosfClock_create = GetFunction(2, "sfClock_create")

;Procedure.l _CSFML_sfClock_create()

;  fred.l = sfClock_create()
;	ProcedureReturn fred
;EndProcedure


; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfClock_getElapsedTime
; Description ...: Get the time elapsed in a clock.
;				   This function returns the time elapsed since the last call to _CSFML_sfClock_restart or _CSFML_sfClock_create.
; Syntax.........: _CSFML_sfClock_getElapsedTime($clock)
; Parameters ....:
; Return values .: Success - Time elapsed (in microseconds).
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......: _CSFML_sfClock_create, _CSFML_sfClock_restart
; Link ..........:
; Example .......:
; ===============================================================================================================================
PrototypeC.l ProtosfClock_getElapsedTime(*clock)
Global _CSFML_sfClock_getElapsedTime.ProtosfClock_getElapsedTime = GetFunction(2, "sfClock_getElapsedTime")

;Procedure.l _CSFML_sfClock_getElapsedTime(*clock)
	
;	fred2.l = sfClock_getElapsedTime(*clock)
;	ProcedureReturn fred2

;EndProcedure


; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfRenderWindow_create
; Description ...: Constructs a new render window.
; Syntax.........: _CSFML_sfRenderWindow_create($mode, $title, $style, $settings)
; Parameters ....: $mode - Video mode to use
;				   $title - Title of the window
;				   $style - Window style
;				   $settings - Creation settings (pass Null to use default values)
; Return values .: Success - a pointer to the sfRenderWindow structure (PTR)
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
PrototypeC.l Protofb_sfRenderWindow_create(*mode, title.p-ascii, style.i, settings.l)
Global _CSFML_sfRenderWindow_create.Protofb_sfRenderWindow_create = GetFunction(6, "fb_sfRenderWindow_create")


;Procedure.l _CSFML_sfRenderWindow_create(width.i, height.i, bitsPerPixel.i, title.s, style.i, settings.l)

;  fred2.l = fb_sfRenderWindow_create(width, height, bitsPerPixel, title, style, settings)
;  ProcedureReturn fred2
	
;EndProcedure


; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfRenderWindow_getSystemHandle
; Description ...: Retrieve the OS-specific handle of a render window.
; Syntax.........: _CSFML_sfRenderWindow_getSystemHandle($renderWindow, $limit)
; Parameters ....: $renderWindow - Render window object
; Return values .: Success - Window handle
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......: _CSFML_sfRenderWindow_create
; Link ..........:
; Example .......:
; ===============================================================================================================================
PrototypeC.l ProtosfRenderWindow_getSystemHandle(*renderWindow)
Global _CSFML_sfRenderWindow_getSystemHandle.ProtosfRenderWindow_getSystemHandle = GetFunction(3, "sfRenderWindow_getSystemHandle")

;Procedure _CSFML_sfRenderWindow_getSystemHandle(byval renderWindow As Long Ptr) As LongInt
	
;	Dim As LongInt fred2 = sfRenderWindow_getSystemHandle(renderWindow)
;	Return fred2
;EndProcedure



; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfRenderWindow_setVerticalSyncEnabled
; Description ...: Enable / disable vertical synchronization on a render window.
; Syntax.........: _CSFML_sfRenderWindow_setVerticalSyncEnabled($renderWindow, $enabled)
; Parameters ....: $renderWindow - Render window object
;				   $enabled - True to enable v-sync, False to deactivate
; Return values .: Success - True
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......: _CSFML_sfRenderWindow_create
; Link ..........:
; Example .......:
; ===============================================================================================================================
PrototypeC ProtosfRenderWindow_setVerticalSyncEnabled(*renderWindow, enabled.i)
Global _CSFML_sfRenderWindow_setVerticalSyncEnabled.ProtosfRenderWindow_setVerticalSyncEnabled = GetFunction(3, "sfRenderWindow_setVerticalSyncEnabled")

; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfRenderWindow_pollEvent
; Description ...: Get the event on top of event queue of a render window, if any, and pop it.
; Syntax.........: _CSFML_sfRenderWindow_pollEvent($renderWindow, $event)
; Parameters ....: $renderWindow - Render window object
;				   $event - Event to fill, if any
; Return values .: Success - True if an event was returned, False if event queue was empty
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......: _CSFML_sfRenderWindow_create
; Link ..........:
; Example .......:
; ===============================================================================================================================
PrototypeC.i ProtosfRenderWindow_isOpen(*renderWindow)
Global _CSFML_sfRenderWindow_isOpen.ProtosfRenderWindow_isOpen = GetFunction(3, "sfRenderWindow_isOpen")


; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfRenderWindow_pollEvent
; Description ...: Get the event on top of event queue of a render window, if any, and pop it.
; Syntax.........: _CSFML_sfRenderWindow_pollEvent($renderWindow, $event)
; Parameters ....: $renderWindow - Render window object
;				   $event - Event to fill, if any
; Return values .: Success - True if an event was returned, False if event queue was empty
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......: _CSFML_sfRenderWindow_create
; Link ..........:
; Example .......:
; ===============================================================================================================================
PrototypeC.i ProtosfRenderWindow_pollEvent(*renderWindow, *event)
Global _CSFML_sfRenderWindow_pollEvent.ProtosfRenderWindow_pollEvent = GetFunction(3, "sfRenderWindow_pollEvent")


; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfRenderWindow_close
; Description ...: Close a render window (but doesn;t destroy the internal Data).
; Syntax.........: _CSFML_sfRenderWindow_close($renderWindow)
; Parameters ....: $renderWindow - Render window object
; Return values .: Success - True
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......: _CSFML_sfRenderWindow_create
; Link ..........:
; Example .......:
; ===============================================================================================================================
PrototypeC ProtosfRenderWindow_close(*renderWindow)
Global _CSFML_sfRenderWindow_close.ProtosfRenderWindow_close = GetFunction(3, "sfRenderWindow_close")

; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfRenderWindow_destroy
; Description ...: Close a render window (but doesn;t destroy the internal Data).
; Syntax.........: _CSFML_sfRenderWindow_destroy($renderWindow)
; Parameters ....: $renderWindow - Render window object
; Return values .: Success - True
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......: _CSFML_sfRenderWindow_create
; Link ..........:
; Example .......:
; ===============================================================================================================================
PrototypeC ProtosfRenderWindow_destroy(*renderWindow)
Global _CSFML_sfRenderWindow_destroy.ProtosfRenderWindow_destroy = GetFunction(3, "sfRenderWindow_destroy")
	
; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfSprite_create
; Description ...: Create a new sprite.
; Syntax.........: _CSFML_sfSprite_create()
; Parameters ....: None
; Return values .: Success - A new sfSprite object (PTR)
;				   Failure - 0 or Null
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
PrototypeC.l ProtosfSprite_create()
Global _CSFML_sfSprite_create.ProtosfSprite_create = GetFunction(3, "sfSprite_create")

;Procedure _CSFML_sfSprite_create() As long ptr

;    Dim As long ptr fred3 = sfSprite_create()
;    Return fred3
;EndProcedure


; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfTexture_createFromFile
; Description ...: Create a new texture from a file.
; Syntax.........: _CSFML_sfTexture_createFromFile($filename, $area)
; Parameters ....: $filename - Path of the image file to load
;				   $area - Area of the source image to load (Null to load the entire image)
; Return values .: Success - a pointer to the sfTexture (PTR)
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
PrototypeC.l ProtosfTexture_createFromFile(filename.p-ascii, *area)
Global _CSFML_sfTexture_createFromFile.ProtosfTexture_createFromFile = GetFunction(3, "sfTexture_createFromFile")

;Procedure _CSFML_sfTexture_createFromFile(byval filename As ZString Ptr, byval area As long ptr) As long ptr

;    Dim As long ptr fred3 = sfTexture_createFromFile(filename, area)
;    Return fred3
;EndProcedure



; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfSprite_setTexture
; Description ...: Change the source texture of a sprite.
;				   The texture argument refers to a texture that must exist as long as the sprite uses it.
;				   Indeed, the sprite doesn;t store its own copy of the texture, but rather keeps a pointer To the one that
;				   you passed to this function. If the source texture is destroyed and the sprite tries to use it, the behaviour
;                  is undefined. If resetRect is true, the TextureRect property of the sprite is automatically adjusted to the
;				   size of the new texture. If it is false, the texture rect is left unchanged.
; Syntax.........: _CSFML_sfSprite_setTexture($sprite, $texture, $resetRect)
; Parameters ....: $sprite - Sprite to delete
;				   $texture - New texture
;				   $resetRect - Should the texture rect be reset to the size of the new texture?
; Return values .: Success - True
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......: _CSFML_sfSprite_create
; Link ..........:
; Example .......:
; ===============================================================================================================================
PrototypeC ProtosfSprite_setTexture(*sprite, *texture, resetRect)
Global _CSFML_sfSprite_setTexture.ProtosfSprite_setTexture = GetFunction(3, "sfSprite_setTexture")


;Sub _CSFML_sfSprite_setTexture(byval sprite As Long Ptr, byval texture As Long Ptr, byval resetRect As Boolean)

;	sfSprite_setTexture(sprite, texture, resetRect)
;End Sub


; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfRenderWindow_clear
; Description ...: Clear a render window with the given color.
; Syntax.........: _CSFML_sfRenderWindow_clear($renderWindow, $color)
; Parameters ....: $renderWindow - Render window object
;				   $color - Fill color
; Return values .: Success - True
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......: _CSFML_sfRenderWindow_create
; Link ..........:
; Example .......:
; ===============================================================================================================================
PrototypeC Protofb_sfRenderWindow_clear(*renderWindow, *color)
Global _CSFML_sfRenderWindow_clear.Protofb_sfRenderWindow_clear = GetFunction(6, "fb_sfRenderWindow_clear")


; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfRenderWindow_clear_rgba
; Description ...: Clear a render window with the given color.
; Syntax.........: _CSFML_sfRenderWindow_clear_rgba($renderWindow, $color)
; Parameters ....: $renderWindow - Render window object
;				   $color - Fill color
; Return values .: Success - True
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......: _CSFML_sfRenderWindow_create
; Link ..........:
; Example .......:
; ===============================================================================================================================
PrototypeC Protofb_sfRenderWindow_clear_rgba(*renderWindow, red, green, blue, alpha)
Global _CSFML_sfRenderWindow_clear_rgba.Protofb_sfRenderWindow_clear_rgba = GetFunction(6, "fb_sfRenderWindow_clear_rgba")


; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfRenderWindow_drawSprite
; Description ...: Draw a drawable object to the render-target.
; Syntax.........: _CSFML_sfRenderWindow_drawSprite($renderWindow, $object, $states)
; Parameters ....: $renderWindow - Render window object
;				   $object - the sprite to draw
;				   $states - Render states to use for drawing (Null to use the default states)
; Return values .: Success - True
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......: _CSFML_sfRenderWindow_create
; Link ..........:
; Example .......:
; ===============================================================================================================================
PrototypeC ProtosfRenderWindow_drawSprite(*renderWindow, *object, *states)
Global _CSFML_sfRenderWindow_drawSprite.ProtosfRenderWindow_drawSprite = GetFunction(3, "sfRenderWindow_drawSprite")

;Sub _CSFML_sfRenderWindow_drawSprite(byval renderWindow As Long Ptr, byval object2 As Long Ptr, byval states As Long Ptr)

;    sfRenderWindow_drawSprite(renderWindow, object2, states)
;End Sub


; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfRenderWindow_display
; Description ...: Display a render window on screen.
; Syntax.........: _CSFML_sfRenderWindow_display($renderWindow)
; Parameters ....: $renderWindow - Render window object
; Return values .: Success - True
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......: _CSFML_sfRenderWindow_create
; Link ..........:
; Example .......:
; ===============================================================================================================================
PrototypeC ProtosfRenderWindow_display(*renderWindow)
Global _CSFML_sfRenderWindow_display.ProtosfRenderWindow_display = GetFunction(3, "sfRenderWindow_display")



; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfText_create
; Description ...: Create a new text.
; Syntax.........: _CSFML_sfText_create()
; Parameters ....: None
; Return values .: Success - A new sfText object
;				   Failure - 0 or Null
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
PrototypeC.l ProtosfText_create()
Global _CSFML_sfText_create.ProtosfText_create = GetFunction(3, "sfText_create")


;Procedure _CSFML_sfText_create() As long ptr

;    Dim As long ptr fred3 = _CSFML_sfText_create()
;    Return fred3
;EndProcedure


; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfFont_createFromFile
; Description ...: Create a new font from a file.
; Syntax.........: _CSFML_sfFont_createFromFile($filename)
; Parameters ....: $filename - Path of the font file to load
; Return values .: Success - A new sfFont object
;				   Failure - 0 or Null
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
PrototypeC.l ProtosfFont_createFromFile(filename.p-ascii)
Global _CSFML_sfFont_createFromFile.ProtosfFont_createFromFile = GetFunction(3, "sfFont_createFromFile")


;Procedure _CSFML_sfFont_createFromFile(byval filename As ZString Ptr) As long ptr

;    Dim As long ptr fred3 = sfFont_createFromFile(filename)
;    Return fred3
;EndProcedure


; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfText_setString
; Description ...: Set the string of a text (from an ANSI string).
;				   A text;s string is empty by Default
; Syntax.........: _CSFML_sfText_setString($text, $string)
; Parameters ....: $text - Text object
;				   $string - New string
; Return values .: Success - True
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
PrototypeC ProtosfText_setString(*text, filename.p-ascii)
Global _CSFML_sfText_setString.ProtosfText_setString = GetFunction(3, "sfText_setString")


;Sub _CSFML_sfText_setString(byval text As Long Ptr, byval string2 As ZString Ptr)

;    sfText_setString(text, string2)
;End Sub


; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfText_setFont
; Description ...: Set the font of a text.
;				   The font argument refers to a texture that must exist as long as the text uses it. Indeed, the text
;				   doesn't store its own copy of the font, but rather keeps a pointer To the one that you passed To this
;				   function. If the font is destroyed and the text tries to use it, the behaviour is undefined
; Syntax.........: _CSFML_sfText_setFont($text, $font)
; Parameters ....: $text - Text object
;				   $font - New font
; Return values .: Success - True
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
PrototypeC ProtosfText_setFont(*text, *font)
Global _CSFML_sfText_setFont.ProtosfText_setFont = GetFunction(3, "sfText_setFont")


;Sub _CSFML_sfText_setFont(byval text As Long Ptr, byval font As Long Ptr)

;    sfText_setFont(text, font)
;End Sub


; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfText_setCharacterSize
; Description ...: Set the character size of a text.
;				   The default size is 30.
; Syntax.........: _CSFML_sfText_setCharacterSize($text, $size)
; Parameters ....: $text - Text object
;				   $size - New character size, in pixels
; Return values .: Success - True
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
PrototypeC ProtosfText_setCharacterSize(*text, size.i)
Global _CSFML_sfText_setCharacterSize.ProtosfText_setCharacterSize = GetFunction(3, "sfText_setCharacterSize")

;Sub _CSFML_sfText_setCharacterSize(byval text As Long Ptr, byval size As uinteger)

;    sfText_setCharacterSize(text, size)
;End Sub


; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfText_setFillColor
; Description ...: Set the fill color of a text.
;				   By default, the text;s fill color is opaque white. Setting the fill color To a transparent color With an
;				   outline will cause the outline to be displayed in the fill area of the text.
; Syntax.........: _CSFML_sfText_setFillColor($text, $color)
; Parameters ....: $text - Text object
;				   $color - New fill color of the text
; Return values .: Success - True
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
PrototypeC Protofb_sfText_setFillColor(*text, *color)
Global _CSFML_sfText_setFillColor.Protofb_sfText_setFillColor = GetFunction(6, "fb_sfText_setFillColor")

;Sub _CSFML_sfText_setFillColor(byval text As Long Ptr, byval color2 As sfColor)

;    sfText_setFillColor(text, color2)
;End Sub



; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfText_setFillColor_rgba
; Description ...: Clear a render window with the given color.
; Syntax.........: _CSFML_sfRenderWindow_clear_rgba($renderWindow, $color)
; Parameters ....: $renderWindow - Render window object
;				   $color - Fill color
; Return values .: Success - True
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......: _CSFML_sfRenderWindow_create
; Link ..........:
; Example .......:
; ===============================================================================================================================
PrototypeC Protofb_sfText_setFillColor_rgba(*renderWindow, red, green, blue, alpha)
Global _CSFML_sfText_setFillColor_rgba.Protofb_sfText_setFillColor_rgba = GetFunction(6, "fb_sfText_setFillColor_rgba")



; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfText_setPosition
; Description ...: Set the position of a text.
;				   This function completely overwrites the previous position. See sfText_move to apply an offset based on
;				   the previous position instead. The default position of a text Text object is (0, 0).

; Syntax.........: _CSFML_sfText_setPosition($text, $position)
; Parameters ....: $text - Text object
;				   $position - New position
; Return values .: Success - True
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
PrototypeC Protofb_sfText_setPosition(*sprite, *position)
Global _CSFML_sfText_setPosition.Protofb_sfText_setPosition = GetFunction(6, "fb_sfText_setPosition")


;Sub _CSFML_sfText_setPosition(byval text As Long Ptr, byval position As sfVector2f)

;    sfText_setPosition(text, position)
;End Sub



; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfSprite_setRotation
; Description ...: Set the orientation of a sprite.
;				   This function completely overwrites the previous rotation. See sfSprite_rotate to add an angle based on
;				   the previous rotation instead. The default rotation of a sprite Sprite object is 0.
; Syntax.........: _CSFML_sfSprite_setRotation($sprite, $angle)
; Parameters ....: $sprite - Sprite object
;				   $angle - New rotation, in degrees
; Return values .: Success - True
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......: _CSFML_sfSprite_create
; Link ..........:
; Example .......:
; ===============================================================================================================================
PrototypeC Protofb_sfSprite_rotate(*sprite, angle.f)
Global _CSFML_sfSprite_rotate.Protofb_sfSprite_rotate = GetFunction(3, "sfSprite_rotate")



; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfSprite_setRotation
; Description ...: Set the orientation of a sprite.
;				   This function completely overwrites the previous rotation. See sfSprite_rotate to add an angle based on
;				   the previous rotation instead. The default rotation of a sprite Sprite object is 0.
; Syntax.........: _CSFML_sfSprite_setRotation($sprite, $angle)
; Parameters ....: $sprite - Sprite object
;				   $angle - New rotation, in degrees
; Return values .: Success - True
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......: _CSFML_sfSprite_create
; Link ..........:
; Example .......:
; ===============================================================================================================================
PrototypeC Protofb_sfSprite_setRotation(*sprite, angle.f)
Global _CSFML_sfSprite_setRotation.Protofb_sfSprite_setRotation = GetFunction(3, "sfSprite_setRotation")


;Sub _CSFML_sfSprite_setRotation(byval sprite As Long Ptr, byval angle As single)

 ;   sfSprite_setRotation(sprite, angle)
;End Sub


; ; #FUNCTION# ====================================================================================================================
; ; Name...........: _CSFML_sfSprite_getPosition
; ; Description ...: Set the position of a sprite, with a sfVector2f structure.
; ;				   This function completely overwrites the previous position. See sfSprite_move to apply an offset based
; ;				   on the previous position instead. The default position of a sprite Sprite object is (0, 0).
; ; Syntax.........: _CSFML_sfSprite_getPosition($sprite, $position)
; ; Parameters ....: $sprite - Sprite object
; ;				   $position - New position (sfVector2f)
; ; Return values .: Success - True
; ;				   Failure - 0
; ; Author ........: Sean Griffin
; ; Modified.......:
; ; Remarks .......: This function is slightly slower than _CSFML_sfSprite_setPosition_xy by about 100 frames per second
; ; Related .......: _CSFML_sfSprite_create, _CSFML_sfVector2f_Constructor
; ; Link ..........:
; ; Example .......:
; ; ===============================================================================================================================
; Procedure _CSFML_sfSprite_getPosition(byval sprite As Long Ptr) As sfVector2f
; 
;     Dim As sfVector2f sprite_pos = sfSprite_getPosition(sprite)
;     Return sprite_pos
; EndProcedure

; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfSprite_setPosition
; Description ...: Set the position of a sprite, with a sfVector2f structure.
;				   This function completely overwrites the previous position. See sfSprite_move to apply an offset based
;				   on the previous position instead. The default position of a sprite Sprite object is (0, 0).
; Syntax.........: _CSFML_sfSprite_setPosition($sprite, $position)
; Parameters ....: $sprite - Sprite object
;				   $position - New position (sfVector2f)
; Return values .: Success - True
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......: This function is slightly slower than _CSFML_sfSprite_setPosition_xy by about 100 frames per second
; Related .......: _CSFML_sfSprite_create, _CSFML_sfVector2f_Constructor
; Link ..........:
; Example .......:
; ===============================================================================================================================
PrototypeC Protofb_sfSprite_setPosition(*sprite, *position)
Global _CSFML_sfSprite_setPosition.Protofb_sfSprite_setPosition = GetFunction(6, "fb_sfSprite_setPosition")


;Sub _CSFML_sfSprite_setPosition(byval sprite As Long Ptr, byval position As sfVector2f)

;    sfSprite_setPosition(sprite, position)
;End Sub


; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfRenderWindow_drawText
; Description ...: Draw text in a render window.
; Syntax.........: _CSFML_sfRenderWindow_drawText($renderWindow, $object, $states)
; Parameters ....: $renderWindow - Render window object
;				   $object - the text to draw
;				   $states - Render states to use for drawing (Null to use the default states)
; Return values .: Success - True
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......: _CSFML_sfRenderWindow_create
; Link ..........:
; Example .......:
; ===============================================================================================================================
PrototypeC ProtosfRenderWindow_drawText(*renderWindow, *object, *states)
Global _CSFML_sfRenderWindow_drawText.ProtosfRenderWindow_drawText = GetFunction(3, "sfRenderWindow_drawText")


;Sub _CSFML_sfRenderWindow_drawText(byval renderWindow As Long Ptr, byval object2 As Long Ptr, byval states As Long Ptr)

;    sfRenderWindow_drawText(renderWindow, object2, states)
;End Sub


; ; #FUNCTION# ====================================================================================================================
; ; Name...........: _CSFML_sfText_create_and_set
; ; Description ...: A convenience function to create a new text and also set it;s properties in one call.
; ; Syntax.........: _CSFML_sfText_create_and_set()
; ; Parameters ....: None
; ; Return values .: Success - A new sfText object
; ;				   Failure - 0 or Null
; ; Author ........: Sean Griffin
; ; Modified.......:
; ; Remarks .......:
; ; Related .......:
; ; Link ..........:
; ; Example .......:
; ; ===============================================================================================================================
; Procedure _CSFML_sfText_create_and_set(byval font_ptr As Long Ptr, byval size As uinteger, byval color2 As sfColor, byval x As Single, byval y As Single) As long ptr
;     
;     Dim As Long Ptr text_ptr = sfText_create()
;     sfText_setFont(text_ptr, font_ptr)
;     sfText_setCharacterSize(text_ptr, size)
;     sfText_setFillColor(text_ptr, color2)
;     Dim As sfVector2f text_pos => (x, y)
;     sfText_setPosition(text_ptr, text_pos)
;     
;     Return text_ptr
; EndProcedure
; 
; 
; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfSprite_setOrigin
; Description ...: Set the local origin of a sprite.
;				   The origin of an object defines the center point for all transformations (position, scale, rotation).
;				   The coordinates of this point must be relative to the top-left corner of the object, and ignore all
;				   transformations (position, scale, rotation). The default origin of a sprite Sprite object is (0, 0).
; Syntax.........: _CSFML_sfSprite_setOrigin($sprite, $origin)
; Parameters ....: $sprite - Sprite object
;				   $origin - New origin (sfVector2f)
; Return values .: Success - True
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......: _CSFML_sfSprite_create, _CSFML_sfVector2f_Constructor
; Link ..........:
; Example .......:
; ===============================================================================================================================
PrototypeC Protofb_sfSprite_setOrigin(*sprite, *position)
Global _CSFML_sfSprite_setOrigin.Protofb_sfSprite_setOrigin = GetFunction(6, "fb_sfSprite_setOrigin")

;Sub _CSFML_sfSprite_setOrigin(byval sprite As Long Ptr, byval origin As sfVector2f)

;    sfSprite_setOrigin(sprite, origin)
;End Sub


; ; #FUNCTION# ====================================================================================================================
; ; Name...........: _CSFML_sfSprite_setRotation
; ; Description ...: Set the orientation of a sprite.
; ;				   This function completely overwrites the previous rotation. See sfSprite_rotate to add an angle based on
; ;				   the previous rotation instead. The default rotation of a sprite Sprite object is 0.
; ; Syntax.........: _CSFML_sfSprite_setRotation($sprite, $angle)
; ; Parameters ....: $sprite - Sprite object
; ;				   $angle - New rotation, in degrees
; ; Return values .: Success - True
; ;				   Failure - 0
; ; Author ........: Sean Griffin
; ; Modified.......:
; ; Remarks .......:
; ; Related .......: _CSFML_sfSprite_create
; ; Link ..........:
; ; Example .......:
; ; ===============================================================================================================================
; Sub _CSFML_sfSprite_setRotation(byval sprite As Long Ptr, byval angle As single)
; 
;     sfSprite_setRotation(sprite, angle)
; End Sub
; 

	
; #FUNCTION# ====================================================================================================================
; Name...........: sfCircleShape_create
; Description ...: Create a new sprite.
; Syntax.........: sfCircleShape_create()
; Parameters ....: None
; Return values .: Success - A new sfSprite object (PTR)
;				   Failure - 0 or Null
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
PrototypeC.l ProtosfCircleShape_create()
Global _CSFML_sfCircleShape_create.ProtosfCircleShape_create = GetFunction(3, "sfCircleShape_create")

; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfSprite_setPosition
; Description ...: Set the position of a sprite, with a sfVector2f structure.
;				   This function completely overwrites the previous position. See sfSprite_move to apply an offset based
;				   on the previous position instead. The default position of a sprite Sprite object is (0, 0).
; Syntax.........: _CSFML_sfSprite_setPosition($sprite, $position)
; Parameters ....: $sprite - Sprite object
;				   $position - New position (sfVector2f)
; Return values .: Success - True
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......: This function is slightly slower than _CSFML_sfSprite_setPosition_xy by about 100 frames per second
; Related .......: _CSFML_sfSprite_create, _CSFML_sfVector2f_Constructor
; Link ..........:
; Example .......:
; ===============================================================================================================================
PrototypeC Protofb_sfCircleShape_setPosition(*shape, *position)
Global _CSFML_sfCircleShape_setPosition.Protofb_sfCircleShape_setPosition = GetFunction(6, "fb_sfCircleShape_setPosition")

; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfRenderWindow_drawCircleShape
; Description ...: Draw a drawable object to the render-target.
; Syntax.........: _CSFML_sfRenderWindow_drawCircleShape($renderWindow, $object, $states)
; Parameters ....: $renderWindow - Render window object
;				   $object - the sprite to draw
;				   $states - Render states to use for drawing (Null to use the default states)
; Return values .: Success - True
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......: _CSFML_sfRenderWindow_create
; Link ..........:
; Example .......:
; ===============================================================================================================================
PrototypeC ProtosfRenderWindow_drawCircleShape(*renderWindow, *object, *states)
Global _CSFML_sfRenderWindow_drawCircleShape.ProtosfRenderWindow_drawCircleShape = GetFunction(3, "sfRenderWindow_drawCircleShape")

; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfCircleShape_setRadius
; Description ...: Set the orientation of a sprite.
;				   This function completely overwrites the previous rotation. See sfSprite_rotate to add an angle based on
;				   the previous rotation instead. The default rotation of a sprite Sprite object is 0.
; Syntax.........: _CSFML_sfCircleShape_setRadius($sprite, $angle)
; Parameters ....: $sprite - Sprite object
;				   $angle - New rotation, in degrees
; Return values .: Success - True
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......: _CSFML_sfSprite_create
; Link ..........:
; Example .......:
; ===============================================================================================================================
PrototypeC Protofb_sfCircleShape_setRadius(*sprite, angle.f)
Global _CSFML_sfCircleShape_setRadius.Protofb_sfCircleShape_setRadius = GetFunction(3, "sfCircleShape_setRadius")

; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfCircleShape_setFillColor
; Description ...: Set the fill color of a text.
;				   By default, the text;s fill color is opaque white. Setting the fill color To a transparent color With an
;				   outline will cause the outline to be displayed in the fill area of the text.
; Syntax.........: _CSFML_sfCircleShape_setFillColor($text, $color)
; Parameters ....: $text - Text object
;				   $color - New fill color of the text
; Return values .: Success - True
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
PrototypeC Protofb_sfCircleShape_setFillColor(*shape, *color)
Global _CSFML_sfCircleShape_setFillColor.Protofb_sfCircleShape_setFillColor = GetFunction(6, "fb_sfCircleShape_setFillColor")

; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfCircleShape_setFillColor_rgba
; Description ...: Clear a render window with the given color.
; Syntax.........: _CSFML_sfCircleShape_setFillColor_rgba($renderWindow, $color)
; Parameters ....: $renderWindow - Render window object
;				   $color - Fill color
; Return values .: Success - True
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......: _CSFML_sfRenderWindow_create
; Link ..........:
; Example .......:
; ===============================================================================================================================
PrototypeC Protofb_sfCircleShape_setFillColor_rgba(*shape, red, green, blue, alpha)
Global _CSFML_sfCircleShape_setFillColor_rgba.Protofb_sfCircleShape_setFillColor_rgba = GetFunction(6, "fb_sfCircleShape_setFillColor_rgba")

; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfCircleShape_setOutlineColor
; Description ...: Set the fill color of a text.
;				   By default, the text;s fill color is opaque white. Setting the fill color To a transparent color With an
;				   outline will cause the outline to be displayed in the fill area of the text.
; Syntax.........: _CSFML_sfCircleShape_setOutlineColor($text, $color)
; Parameters ....: $text - Text object
;				   $color - New fill color of the text
; Return values .: Success - True
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
PrototypeC Protofb_sfCircleShape_setOutlineColor(*shape, *color)
Global _CSFML_sfCircleShape_setOutlineColor.Protofb_sfCircleShape_setOutlineColor = GetFunction(6, "fb_sfCircleShape_setOutlineColor")

; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfCircleShape_setOutlineColor_rgba
; Description ...: Clear a render window with the given color.
; Syntax.........: _CSFML_sfCircleShape_setOutlineColor_rgba($renderWindow, $color)
; Parameters ....: $renderWindow - Render window object
;				   $color - Outline color
; Return values .: Success - True
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......: _CSFML_sfRenderWindow_create
; Link ..........:
; Example .......:
; ===============================================================================================================================
PrototypeC Protofb_sfCircleShape_setOutlineColor_rgba(*shape, red, green, blue, alpha)
Global _CSFML_sfCircleShape_setOutlineColor_rgba.Protofb_sfCircleShape_setOutlineColor_rgba = GetFunction(6, "fb_sfCircleShape_setOutlineColor_rgba")

; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfCircleShape_setOutlineColor
; Description ...: Set the fill color of a text.
;				   By default, the text;s fill color is opaque white. Setting the fill color To a transparent color With an
;				   outline will cause the outline to be displayed in the fill area of the text.
; Syntax.........: _CSFML_sfCircleShape_setOutlineColor($text, $color)
; Parameters ....: $text - Text object
;				   $color - New fill color of the text
; Return values .: Success - True
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
PrototypeC ProtosfCircleShape_setOutlineThickness(*shape, thickness.f)
Global _CSFML_sfCircleShape_setOutlineThickness.ProtosfCircleShape_setOutlineThickness = GetFunction(3, "sfCircleShape_setOutlineThickness")

; IDE Options = PureBasic 5.40 LTS (Windows - x86)
; CursorPosition = 1321
; FirstLine = 1284
; Folding = -
; EnableUnicode
; EnableXP