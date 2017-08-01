;NeHe's Token, Extensions, Scissoring & TGA Loading Tutorial (Lesson 24)
;http://nehe.gamedev.net
;Credits: Nico Gruener, Dreglor, traumatic
;Author: hagibaba
;Date: 28 Jan 2007
;Note: up-to-date with PB v4.02 (Windows)
;Note: requires a targa in path "Data/Font.tga"

;Section for standard constants, structures, macros and declarations

XIncludeFile #PB_Compiler_Home+"Examples\Sources - Advanced\OpenGL Cube\OpenGL.pbi" ;include the gl.h constants


;wingdi.h constants
#DM_BITSPERPEL=$40000
#DM_PELSWIDTH=$80000
#DM_PELSHEIGHT=$100000

;winuser.h constants
#CDS_FULLSCREEN=4
#DISP_CHANGE_SUCCESSFUL=0
#SC_MONITORPOWER=$F170

Procedure.w LoWord(value.l) ;windef.h macro
  ProcedureReturn (value & $FFFF)
EndProcedure

Procedure.w HiWord(value.l) ;windef.h macro
  ProcedureReturn ((value >> 16) & $FFFF)
EndProcedure

Import "opengl32.lib"
  glClearDepth(depth.d) ;specifies the clear value for the depth buffer
  glOrtho(left.d,right.d,bottom.d,top.d,near.d,far.d) ;multiplies the current matrix by an orthographic matrix
  glTranslated(x.d,y.d,z.d) ;moves the current matrix to the point specified
EndImport

;Start of Lesson 24

Global hDC.l ;Private GDI Device Context
Global hRC.l ;Permanent Rendering Context
Global hWnd.l ;Holds Our Window Handle
Global hInstance.l ;Holds The Instance Of The Application

Global Dim keys.b(256) ;Array Used For The Keyboard Routine
Global active.b=#True ;Window Active Flag Set To TRUE By Default
Global fullscreen.b=#True ;Fullscreen Flag Set To Fullscreen Mode By Default

Global scroll.l ;Used For Scrolling The Screen
Global maxtokens.l ;Keeps Track Of The Number Of Extensions Supported
Global swidth.l ;Scissor Width
Global sheight.l ;Scissor Height

Global base.l ;Base Display List For The Font

Structure TEXTUREIMAGE ;Create A Structure
  imageData.l ;Image Data (Up To 32 Bits)
  bpp.l ;Image Color Depth In Bits Per Pixel.
  width.l ;Image Width
  height.l ;Image Height
  texID.l ;Texture ID Used To Select A Texture
EndStructure

Global Dim textures.TEXTUREIMAGE(1) ;Storage For One Texture

Declare.l WndProc(hWnd.l,uMsg.l,wParam.l,lParam.l) ;Declaration For WndProc

Procedure.b LoadTGA(*texture.TEXTUREIMAGE,filename.s) ;Loads A TGA File Into Memory
 
  Protected Dim TGAheader.b(12) ;Uncompressed TGA Header
  TGAheader(2)=2 ;ie. {0,0,2,0,0,0,0,0,0,0,0,0}
  Protected Dim TGAcompare.b(12) ;Used To Compare TGA Header
  Protected Dim header.b(6) ;First 6 Useful Bytes From The Header
  Protected bytesPerPixel.l ;Holds Number Of Bytes Per Pixel Used In The TGA File
  Protected imageSize.l ;Used To Store The Image Size When Setting Aside Ram
  Protected temp.l ;Temporary Variable
  Protected type.l=#GL_RGBA ;Set The Default GL Mode To RBGA (32 BPP)
  Protected file.l ;file handle
  Protected i.l ;loop variable
 
  file=ReadFile(#PB_Any,filename) ;Open The TGA File
 
  If file=0 ;Does File Even Exist?
    ProcedureReturn #False ;Return False
  EndIf
  If ReadData(file,TGAcompare(),12)<>12 ;Are There 12 Bytes To Read?
    CloseFile(file) ;Close The File
    ProcedureReturn #False ;Return False
  EndIf
  For i=0 To 12-1 ;Does The Header Match What We Want?
    If TGAheader(i)<>TGAcompare(i)
      CloseFile(file) ;Close The File
      ProcedureReturn #False ;Return False
    EndIf
  Next
  If ReadData(file,header(),6)<>6 ;If So Read Next 6 Header Bytes
    CloseFile(file) ;Close The File
    ProcedureReturn #False ;Return False
  EndIf
 
  *texture\width=((header(1) & 255)*256)+(header(0) & 255) ;Determine The TGA Width (highbyte*256+lowbyte)
  *texture\height=((header(3) & 255)*256)+(header(2) & 255) ;Determine The TGA Height (highbyte*256+lowbyte)
 
  ;Is The Width Or Height Less Than Or Equal To Zero Or Is The TGA Not 24 Or 32 Bit?
  If *texture\width<=0 Or *texture\height<=0 Or (header(4)<>24 And header(4)<>32)
    CloseFile(file) ;If Anything Failed, Close The File
    ProcedureReturn #False ;Return False
  EndIf
 
  *texture\bpp=header(4) ;Grab The TGA's Bits Per Pixel (24 or 32)
  bytesPerPixel=*texture\bpp/8 ;Divide By 8 To Get The Bytes Per Pixel
  imageSize=*texture\width**texture\height*bytesPerPixel ;Calculate The Memory Required For The TGA Data
 
  *texture\imageData=AllocateMemory(imageSize) ;Reserve Memory To Hold The TGA Data
 
  ;Does The Storage Memory Exist? and Does The Image Size Match The Memory Reserved?
  If *texture\imageData=0 Or ReadData(file,*texture\imageData,imageSize)<>imageSize
    If *texture\imageData<>0 ;Was Image Data Loaded
      FreeMemory(*texture\imageData) ;If So, Release The Image Data
    EndIf
    CloseFile(file) ;Close The File
    ProcedureReturn #False ;Return False
  EndIf
 
  For i=0 To (imageSize/bytesPerPixel)-1 ;Loop Through The Image Data
    ;Swaps The 1st And 3rd Bytes ('R'ed And 'B'lue)
    temp=PeekB(*texture\imageData+(i*bytesPerPixel)) ;Temporarily Store The Value At Image Data 'i'
    PokeB(*texture\imageData+(i*bytesPerPixel),PeekB(*texture\imageData+(i*bytesPerPixel)+2)) ;Set The 1st Byte To The Value Of The 3rd Byte
    PokeB(*texture\imageData+(i*bytesPerPixel)+2,temp) ;Set The 3rd Byte To The Value In 'temp' (1st Byte Value)
  Next
 
  CloseFile(file) ;Close The File
 
  ;Build A Texture From The Data
  glGenTextures_(1,@*texture\texID) ;Generate OpenGL texture IDs
 
  glBindTexture_(#GL_TEXTURE_2D,*texture\texID) ;Bind Our Texture
  glTexParameterf_(#GL_TEXTURE_2D,#GL_TEXTURE_MIN_FILTER,#GL_LINEAR) ;Linear Filtered
  glTexParameterf_(#GL_TEXTURE_2D,#GL_TEXTURE_MAG_FILTER,#GL_LINEAR) ;Linear Filtered
 
  If *texture\bpp=24 ;Was The TGA 24 Bits
    type=#GL_RGB ;If So Set The 'type' To GL_RGB
  EndIf
 
  glTexImage2D_(#GL_TEXTURE_2D,0,type,*texture\width,*texture\height,0,type,#GL_UNSIGNED_BYTE,*texture\imageData)
 
  If *texture\imageData
    FreeMemory(*texture\imageData)
  EndIf
 
  ProcedureReturn #True ;Texture Building Went Ok, Return True
 
EndProcedure

Procedure BuildFont() ;Build Our Font Display List
 
  Protected loop1.l,cx.f,cy.f,modx.l
 
  base=glGenLists_(256) ;Creating 256 Display Lists
  glBindTexture_(#GL_TEXTURE_2D,textures(0)\texID) ;Select Our Font Texture
 
  For loop1=0 To 256-1 ;Loop Through All 256 Lists
    modx=loop1 % 16 ;Note: can't use % with floats
    cx=modx/16.0 ;X Position Of Current Character
    cy=Int(loop1/16)/16.0 ;Y Position Of Current Character
   
    glNewList_(base+loop1,#GL_COMPILE) ;Start Building A List
    glBegin_(#GL_QUADS) ;Use A Quad For Each Character
    glTexCoord2f_(cx,1.0-cy-0.0625) ;Texture Coord (Bottom Left)
    glVertex2i_(0,16) ;Vertex Coord (Bottom Left)
    glTexCoord2f_(cx+0.0625,1.0-cy-0.0625) ;Texture Coord (Bottom Right)
    glVertex2i_(16,16) ;Vertex Coord (Bottom Right)
    glTexCoord2f_(cx+0.0625,1.0-cy-0.001) ;Texture Coord (Top Right)
    glVertex2i_(16,0) ;Vertex Coord (Top Right)
    glTexCoord2f_(cx,1.0-cy-0.001) ;Texture Coord (Top Left)
    glVertex2i_(0,0) ;Vertex Coord (Top Left)
    glEnd_() ;Done Building Our Quad (Character)
    glTranslated(14,0,0) ;Move To The Right Of The Character
    glEndList_() ;Done Building The Display List
  Next ;Loop Until All 256 Are Built
 
EndProcedure

Procedure KillFont() ;Delete The Font From Memory
 
  glDeleteLists_(base,256) ;Delete All 256 Display Lists
 
EndProcedure

Procedure glPrint(x.l,y.l,set.l,text.s) ;Where The Printing Happens
 
  If text="" ;If There's No Text
    ProcedureReturn 0 ;Do Nothing
  EndIf
 
  If set : set=1 : EndIf ;Is set True? If So, Select Set 1 (Italic)
 
  glEnable_(#GL_TEXTURE_2D) ;Enable Texture Mapping
  glLoadIdentity_() ;Reset The Modelview Matrix
  glTranslated(x,y,0) ;Position The Text (0,0 - Top Left)
  glListBase_(base-32+(128*set)) ;Choose The Font Set (0 or 1)
 
  glScalef_(1.0,2.0,1.0) ;Make The Text 2X Taller
 
  glCallLists_(Len(text),#GL_UNSIGNED_BYTE,text) ;Write The Text To The Screen
  glDisable_(#GL_TEXTURE_2D) ;Disable Texture Mapping
 
EndProcedure

Procedure ReSizeGLScene(width.l,height.l) ;Resize And Initialize The GL Window
 
  If height=0 : height=1 : EndIf ;Prevent A Divide By Zero Error
 
  swidth=width ;Set Scissor Width To Window Width
  sheight=height ;Set Scissor Height To Window Height
 
  glViewport_(0,0,width,height) ;Reset The Current Viewport
 
  glMatrixMode_(#GL_PROJECTION) ;Select The Projection Matrix
  glLoadIdentity_() ;Reset The Projection Matrix
 
  glOrtho(0.0,640,480,0.0,-1.0,1.0) ;Create Ortho 640x480 View (0,0 At Top Left)
 
  glMatrixMode_(#GL_MODELVIEW) ;Select The Modelview Matrix
  glLoadIdentity_() ;Reset The Modelview Matrix
 
EndProcedure

Procedure.l InitGL() ;All Setup For OpenGL Goes Here
 
  If LoadTGA(textures(0),"Data/Font.tga")=0 ;Load The Font Texture
    ProcedureReturn #False ;If Loading Failed, Return False
  EndIf
 
  BuildFont() ;Build The Font
 
  glShadeModel_(#GL_SMOOTH) ;Enable Smooth Shading
  glClearColor_(0.0,0.0,0.0,0.5) ;Black Background
  glClearDepth(1.0) ;Depth Buffer Setup
  glBindTexture_(#GL_TEXTURE_2D,textures(0)\texID) ;Select Our Font Texture
 
  ProcedureReturn #True ;Initialization Went OK
 
EndProcedure

Procedure.l DrawGLScene() ;Here's Where We Do All The Drawing
 
  Protected token.s ;Storage For Our Token
  Protected cnt.l=0 ;Local Counter Variable
  Protected text.s ;Storage For Our Extension String
  Protected start.l,len.l ;token variables
 
  glClear_(#GL_COLOR_BUFFER_BIT | #GL_DEPTH_BUFFER_BIT) ;Clear Screen And Depth Buffer
 
  glColor3f_(1.0,0.5,0.5) ;Set Color To Bright Red
  glPrint(20,16,1,"Renderer") ;Display Renderer
  glPrint(50,48,1,"Vendor") ;Display Vendor Name
  glPrint(36,80,1,"Version") ;Display Version
 
  glColor3f_(1.0,0.7,0.4) ;Set Color To Orange
  glPrint(170,16,1,PeekS(glGetString_(#GL_RENDERER))) ;Display Renderer
  glPrint(170,48,1,PeekS(glGetString_(#GL_VENDOR))) ;Display Vendor Name
  glPrint(170,80,1,PeekS(glGetString_(#GL_VERSION))) ;Display Version
 
  glColor3f_(0.5,0.5,1.0) ;Set Color To Bright Blue
  glPrint(192,432,1,"NeHe Productions") ;Write NeHe Productions At The Bottom Of The Screen
 
  glLoadIdentity_() ;Reset The ModelView Matrix
  glColor3f_(1.0,1.0,1.0) ;Set The Color To White
  glBegin_(#GL_LINE_STRIP) ;Start Drawing Line Strips (Something New)
  glVertex2i_(639,417) ;Top Right Of Bottom Box
  glVertex2i_(  1,417) ;Top Left Of Bottom Box
  glVertex2i_(  1,480) ;Lower Left Of Bottom Box
  glVertex2i_(639,480) ;Lower Right Of Bottom Box
  glVertex2i_(639,128) ;Up To Bottom Right Of Top Box
  glEnd_() ;Done First Line Strip
  glBegin_(#GL_LINE_STRIP) ;Start Drawing Another Line Strip
  glVertex2i_(  1,128) ;Bottom Left Of Top Box
  glVertex2i_(639,128) ;Bottom Right Of Top Box       
  glVertex2i_(639,  1) ;Top Right Of Top Box
  glVertex2i_(  1,  1) ;Top Left Of Top Box
  glVertex2i_(  1,417) ;Down To Top Left Of Bottom Box
  glEnd_() ;Done Second Line Strip
 
  glScissor_(1,Int(0.135416*sheight),swidth-2,Int(0.597916*sheight)) ;Define Scissor Region
  glEnable_(#GL_SCISSOR_TEST) ;Enable Scissor Testing
 
  text=PeekS(glGetString_(#GL_EXTENSIONS)) ;Grab The Extension List, Store In Text
 
  start=1 ;Parse 'text' For Words, Seperated By " " (spaces)
  len=FindString(text," ",start)
  token=Mid(text,start,len-start)
  While token<>"" ;While The Token Isn't NULL
    cnt+1 ;Increase The Counter
    If cnt>maxtokens ;Is 'maxtokens' Less Than 'cnt'
      maxtokens=cnt ;If So, Set 'maxtokens' Equal To 'cnt'
    EndIf
   
    glColor3f_(0.5,1.0,0.5) ;Set Color To Bright Green
    glPrint(2,96+(cnt*32)-scroll,0,Str(cnt)) ;Print Current Extension Number
    glColor3f_(1.0,1.0,0.5) ;Set Color To Yellow
    glPrint(50,96+(cnt*32)-scroll,0,token) ;Print The Current Token (Parsed Extension Name)
   
    start=len+1 ;Search For The Next Token
    len=FindString(text," ",start)
    token=Mid(text,start,len-start)
  Wend
 
  glDisable_(#GL_SCISSOR_TEST) ;Disable Scissor Testing
 
  glFlush_() ;Flush The Rendering Pipeline
 
  ProcedureReturn #True ;Everything Went OK
 
EndProcedure

Procedure KillGLWindow() ;Properly Kill The Window
 
  If fullscreen ;Are We In Fullscreen Mode?
    ChangeDisplaySettings_(#Null,0) ;If So Switch Back To The Desktop
    ShowCursor_(#True) ;Show Mouse Pointer
  EndIf
 
  If hRC ;Do We Have A Rendering Context?
    If wglMakeCurrent_(#Null,#Null)=0 ;Are We Able To Release The DC And RC Contexts?
      MessageBox_(#Null,"Release Of DC And RC Failed.","SHUTDOWN ERROR",#MB_OK | #MB_ICONINFORMATION)
    EndIf
    If wglDeleteContext_(hRC)=0 ;Are We Able To Delete The RC?
      MessageBox_(#Null,"Release Rendering Context Failed.","SHUTDOWN ERROR",#MB_OK | #MB_ICONINFORMATION)
    EndIf
    hRC=#Null ;Set RC To NULL
  EndIf
 
  If hDC And ReleaseDC_(hWnd,hDC)=0 ;Are We Able To Release The DC
    MessageBox_(#Null,"Release Device Context Failed.","SHUTDOWN ERROR",#MB_OK | #MB_ICONINFORMATION)
    hDC=#Null ;Set DC To NULL
  EndIf
 
  If hWnd And DestroyWindow_(hWnd)=0 ;Are We Able To Destroy The Window?
    MessageBox_(#Null,"Could Not Release hWnd.","SHUTDOWN ERROR",#MB_OK | #MB_ICONINFORMATION)
    hWnd=#Null ;Set hWnd To NULL
  EndIf
 
  If UnregisterClass_("OpenGL",hInstance)=0 ;Are We Able To Unregister Class
    MessageBox_(#Null,"Could Not Unregister Class.","SHUTDOWN ERROR",#MB_OK | #MB_ICONINFORMATION)
    hInstance=#Null ;Set hInstance To NULL
  EndIf
 
  KillFont() ;Kill The Font
 
EndProcedure

;This Code Creates Our OpenGL Window. Parameters Are:
;title - Title To Appear At The Top Of The Window
;width - Width Of The GL Window Or Fullscreen Mode
;height - Height Of The GL Window Or Fullscreen Mode
;bits - Number Of Bits To Use For Color (8/16/24/32)
;fullscreenflag - Use Fullscreen Mode (TRUE) Or Windowed Mode (FALSE)

Procedure.b CreateGLWindow(title.s,width.l,height.l,bits.l,fullscreenflag.b)
 
  Protected PixelFormat.l ;Holds The Results After Searching For A Match
  Protected wc.WNDCLASS ;Windows Class Structure
  Protected dwExStyle.l ;Window Extended Style
  Protected dwStyle.l ;Window Style
  Protected WindowRect.RECT ;Grabs Rectangle Upper Left / Lower Right Values
  Protected wpos.POINT ;Window position
 
  WindowRect\left=0 ;Set Left Value To 0
  WindowRect\right=width ;Set Right Value To Requested Width
  WindowRect\top=0 ;Set Top Value To 0
  WindowRect\bottom=height ;Set Bottom Value To Requested Height
 
  fullscreen=fullscreenflag ;Set The Global Fullscreen Flag
 
  hInstance=GetModuleHandle_(#Null) ;Grab An Instance For Our Window
 
  wc\style=#CS_HREDRAW | #CS_VREDRAW | #CS_OWNDC ;Redraw On Size, And Own DC For Window
  wc\lpfnWndProc=@WndProc() ;WndProc Handles Messages
  wc\cbClsExtra=0 ;No Extra Window Data
  wc\cbWndExtra=0 ;No Extra Window Data
  wc\hInstance=hInstance ;Set The Instance
  wc\hIcon=LoadIcon_(#Null,#IDI_WINLOGO) ;Load The Default Icon
  wc\hCursor=LoadCursor_(#Null,#IDC_ARROW) ;Load The Arrow Pointer
  wc\hbrBackground=#Null ;No Background Required For GL
  wc\lpszMenuName=#Null ;We Don't Want A Menu
  wc\lpszClassName=@"OpenGL" ;Set The Class Name
 
  If RegisterClass_(wc)=0 ;Attempt To Register The Window Class
    MessageBox_(#Null,"Failed To Register The Window Class.","ERROR",#MB_OK | #MB_ICONEXCLAMATION)
    ProcedureReturn #False
  EndIf
 
  If fullscreen ;Attempt Fullscreen Mode?
   
    Protected dmScreenSettings.DEVMODE ;Device Mode
    dmScreenSettings\dmSize=SizeOf(DEVMODE) ;Size Of The Devmode Structure
    dmScreenSettings\dmFields=#DM_BITSPERPEL | #DM_PELSWIDTH | #DM_PELSHEIGHT ;bit flags to specify the members of DEVMODE that were initialized
    dmScreenSettings\dmBitsPerPel=bits ;Selected Bits Per Pixel
    dmScreenSettings\dmPelsWidth=width ;Selected Screen Width in pixels
    dmScreenSettings\dmPelsHeight=height ;Selected Screen Height in pixels
   
    ;Try To Set Selected Mode And Get Results. Note: CDS_FULLSCREEN Gets Rid Of Start Bar
    If ChangeDisplaySettings_(dmScreenSettings,#CDS_FULLSCREEN)<>#DISP_CHANGE_SUCCESSFUL
      ;If The Mode Fails, Offer Two Options. Quit Or Use Windowed Mode
      If MessageBox_(#Null,"The Requested Fullscreen Mode Is Not Supported By"+Chr(10)+"Your Video Card. Use Windowed Mode Instead?","NeHe GL",#MB_YESNO | #MB_ICONEXCLAMATION)=#IDYES
        fullscreen=#False ;Windowed Mode Selected.  Fullscreen = FALSE
      Else
        ;Pop Up A Message Box Letting User Know The Program Is Closing
        MessageBox_(#Null,"Program Will Now Close.","ERROR",#MB_OK | #MB_ICONSTOP)
        ProcedureReturn #False
      EndIf
    EndIf
   
  EndIf
 
  If fullscreen ;Are We Still In Fullscreen Mode?
    dwExStyle=#WS_EX_APPWINDOW ;Window Extended Style
    dwStyle=#WS_POPUP ;Windows Style
    ShowCursor_(#False) ;Hide Mouse Pointer
  Else
    dwExStyle=#WS_EX_APPWINDOW | #WS_EX_WINDOWEDGE ;Window Extended Style
    dwStyle=#WS_OVERLAPPEDWINDOW ;Windows Style
  EndIf
 
  AdjustWindowRectEx_(WindowRect,dwStyle,#False,dwExStyle) ;Adjust Window To True Requested Size
 
  If fullscreen=0 ;if not fullscreen mode calculate screen centered window
    wpos\x=(GetSystemMetrics_(#SM_CXSCREEN)/2)-((WindowRect\right-WindowRect\left)/2)
    wpos\y=(GetSystemMetrics_(#SM_CYSCREEN)/2)-((WindowRect\bottom-WindowRect\top)/2)
  EndIf
 
  ;CreateWindowEx_(Extended Window Style, Class Name, Window Title, Window Style, Window X Position, Window Y Position, Width, Height, No Parent Window, No Menu, Instance, No Creation Data)
  hWnd=CreateWindowEx_(dwExStyle,"OpenGL",title,dwStyle | #WS_CLIPSIBLINGS | #WS_CLIPCHILDREN,wpos\x,wpos\y,WindowRect\right-WindowRect\left,WindowRect\bottom-WindowRect\top,#Null,#Null,hInstance,#Null)
  If hWnd=0
    KillGLWindow() ;Reset The Display
    MessageBox_(#Null,"Window Creation Error.","ERROR",#MB_OK | #MB_ICONEXCLAMATION)
    ProcedureReturn #False
  EndIf
 
  Protected pfd.PIXELFORMATDESCRIPTOR ;pfd Tells Windows How We Want Things To Be
  pfd\nSize=SizeOf(PIXELFORMATDESCRIPTOR) ;Size Of This Structure
  pfd\nVersion=1 ;Version Number
  pfd\dwFlags=#PFD_SUPPORT_OPENGL | #PFD_DOUBLEBUFFER | #PFD_DRAW_TO_WINDOW ;Format Must Support Window, OpenGL, Double Buffering
  pfd\iPixelType=#PFD_TYPE_RGBA ;Request An RGBA Format
  pfd\cColorBits=bits ;Select Our Color Depth
  pfd\cRedBits=0 ;Color Bits Ignored
  pfd\cRedShift=0
  pfd\cGreenBits=0
  pfd\cGreenShift=0
  pfd\cBlueBits=0
  pfd\cBlueShift=0
  pfd\cAlphaBits=0 ;No Alpha Buffer
  pfd\cAlphaShift=0 ;Shift Bit Ignored
  pfd\cAccumBits=0 ;No Accumulation Buffer
  pfd\cAccumRedBits=0 ;Accumulation Bits Ignored
  pfd\cAccumGreenBits=0
  pfd\cAccumBlueBits=0
  pfd\cAccumAlphaBits=0
  pfd\cDepthBits=16 ;16Bit Z-Buffer (Depth Buffer)
  pfd\cStencilBits=0 ;No Stencil Buffer
  pfd\cAuxBuffers=0 ;No Auxiliary Buffer
  pfd\iLayerType=#PFD_MAIN_PLANE ;Main Drawing Layer
  pfd\bReserved=0 ;Reserved
  pfd\dwLayerMask=0 ;Layer Masks Ignored
  pfd\dwVisibleMask=0
  pfd\dwDamageMask=0
 
  hDC=GetDC_(hWnd)
  If hDC=0 ;Did We Get A Device Context?
    KillGLWindow() ;Reset The Display
    MessageBox_(#Null,"Can't Create A GL Device Context.","ERROR",#MB_OK | #MB_ICONEXCLAMATION)
    ProcedureReturn #False
  EndIf
 
  PixelFormat=ChoosePixelFormat_(hDC,pfd)
  If PixelFormat=0 ;Did Windows Find A Matching Pixel Format?
    KillGLWindow() ;Reset The Display
    MessageBox_(#Null,"Can't Find A Suitable PixelFormat.","ERROR",#MB_OK | #MB_ICONEXCLAMATION)
    ProcedureReturn #False
  EndIf
 
  If SetPixelFormat_(hDC,PixelFormat,pfd)=0 ;Are We Able To Set The Pixel Format?
    KillGLWindow() ;Reset The Display
    MessageBox_(#Null,"Can't Set The PixelFormat.","ERROR",#MB_OK | #MB_ICONEXCLAMATION)
    ProcedureReturn #False
  EndIf
 
  hRC=wglCreateContext_(hDC)
  If hRC=0 ;Are We Able To Get A Rendering Context?
    KillGLWindow() ;Reset The Display
    MessageBox_(#Null,"Can't Create A GL Rendering Context.","ERROR",#MB_OK | #MB_ICONEXCLAMATION)
    ProcedureReturn #False
  EndIf
 
  If wglMakeCurrent_(hDC,hRC)=0 ;Try To Activate The Rendering Context
    KillGLWindow() ;Reset The Display
    MessageBox_(#Null,"Can't Activate The GL Rendering Context.","ERROR",#MB_OK | #MB_ICONEXCLAMATION)
    ProcedureReturn #False
  EndIf
 
  ShowWindow_(hWnd,#SW_SHOW) ;Show The Window
  SetForegroundWindow_(hWnd) ;Slightly Higher Priority
  SetFocus_(hWnd) ;Sets Keyboard Focus To The Window
  ReSizeGLScene(width,height) ;Set Up Our Perspective GL Screen
 
  If InitGL()=0 ;Initialize Our Newly Created GL Window
    KillGLWindow() ;Reset The Display
    MessageBox_(#Null,"Initialization Failed.","ERROR",#MB_OK | #MB_ICONEXCLAMATION)
    ProcedureReturn #False
  EndIf
 
  ProcedureReturn #True ;Success
 
EndProcedure

Procedure.l WndProc(hWnd.l,uMsg.l,wParam.l,lParam.l)
 
  Select uMsg ;Check For Windows Messages
     
    Case #WM_ACTIVATE ;Watch For Window Activate Message
      If HiWord(wParam)=0 ;Check Minimization State
        active=#True ;Program Is Active
      Else
        active=#False ;Program Is No Longer Active
      EndIf
      ProcedureReturn 0 ;Return To The Message Loop
     
    Case #WM_SYSCOMMAND ;Intercept System Commands
      Select wParam ;Check System Calls
        Case #SC_SCREENSAVE ;Screensaver Trying To Start?
          ProcedureReturn 0 ;Prevent From Happening
        Case #SC_MONITORPOWER ;Monitor Trying To Enter Powersave?
          ProcedureReturn 0 ;Prevent From Happening
      EndSelect
     
    Case #WM_CLOSE ;Did We Receive A Close Message?
      PostQuitMessage_(0) ;Send A Quit Message
      ProcedureReturn 0 ;Jump Back
     
    Case #WM_KEYDOWN ;Is A Key Being Held Down?
      keys(wParam)=#True ;If So, Mark It As TRUE
      ProcedureReturn 0 ;Jump Back
     
    Case #WM_KEYUP ;Has A Key Been Released?
      keys(wParam)=#False ;If So, Mark It As FALSE
      ProcedureReturn 0 ;Jump Back
     
    Case #WM_SIZE ;Resize The OpenGL Window
      ReSizeGLScene(LoWord(lParam),HiWord(lParam)) ;LoWord=Width, HiWord=Height
      ProcedureReturn 0 ;Jump Back
     
  EndSelect
 
  ;Pass All Unhandled Messages To DefWindowProc
  ProcedureReturn DefWindowProc_(hWnd,uMsg,wParam,lParam)
 
EndProcedure

Procedure.l WinMain() ;Main Program
 
  Protected msg.MSG ;Windows Message Structure
  Protected done.b ;Bool Variable To Exit Loop
 
  ;Ask The User Which Screen Mode They Prefer
  If MessageBox_(#Null,"Would You Like To Run In Fullscreen Mode?","Start FullScreen?",#MB_YESNO | #MB_ICONQUESTION)=#IDNO
    fullscreen=#False ;Windowed Mode
  EndIf
 
  If CreateGLWindow("NeHe's Token, Extensions, Scissoring & TGA Loading Tutorial",640,480,16,fullscreen)=0 ;Create The Window
    ProcedureReturn 0 ;Quit If Window Was Not Created
  EndIf
 
  While done=#False ;Loop That Runs While done=FALSE
   
    If PeekMessage_(msg,#Null,0,0,#PM_REMOVE) ;Is There A Message Waiting?
     
      If msg\message=#WM_QUIT ;Have We Received A Quit Message?
        done=#True ;If So done=TRUE
      Else ;If Not, Deal With Window Messages
        TranslateMessage_(msg) ;Translate The Message
        DispatchMessage_(msg) ;Dispatch The Message
      EndIf
     
    Else ;If There Are No Messages
     
      ;Draw The Scene. Watch For ESC Key And Quit Messages From DrawGLScene()
      If (active And DrawGLScene()=0) Or keys(#VK_ESCAPE) ;Active? Was There A Quit Received?
       
        done=#True ;ESC or DrawGLScene Signalled A Quit
       
      Else ;Not Time To Quit, Update Screen
       
        SwapBuffers_(hDC) ;Swap Buffers (Double Buffering)
       
        If keys(#VK_UP) And scroll>0 ;Is Up Arrow Being Pressed?
          scroll-2 ;If So, Decrease 'scroll' Moving Screen Down
        EndIf
       
        If keys(#VK_DOWN) And scroll<32*(maxtokens-9) ;Is Down Arrow Being Pressed?
          scroll+2 ;If So, Increase 'scroll' Moving Screen Up
        EndIf
       
      EndIf
     
      If keys(#VK_F1) ;Is F1 Being Pressed?
        keys(#VK_F1)=#False ;If So Make Key FALSE
        KillGLWindow() ;Kill Our Current Window
        fullscreen=~fullscreen & 1 ;Toggle Fullscreen / Windowed Mode
        ;Recreate Our OpenGL Window
        If CreateGLWindow("NeHe's Token, Extensions, Scissoring & TGA Loading Tutorial",640,480,16,fullscreen)=0
          ProcedureReturn 0 ;Quit If Window Was Not Created
        EndIf
      EndIf
     
    EndIf
   
  Wend
 
  ;Shutdown
  KillGLWindow() ;Kill The Window
  End ;Exit The Program
 
EndProcedure

WinMain() ;run the main program
; IDE Options = PureBasic 5.60 (Windows - x86)
; CursorPosition = 257
; FirstLine = 245
; Folding = ---
; EnableXP