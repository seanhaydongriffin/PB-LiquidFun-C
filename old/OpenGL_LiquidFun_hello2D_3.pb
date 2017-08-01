XIncludeFile "LiquidFun-C.pbi"
XIncludeFile "LiquidFun-C-Ex.pbi"

UsePNGImageDecoder()

#GL_VENDOR     = $1F00
#GL_RENDERER   = $1F01
#GL_VERSION    = $1F02
#GL_EXTENSIONS = $1F03

Global camera_linearvelocity.Vec3f
camera_linearvelocity\x = 0
camera_linearvelocity\y = 0
camera_linearvelocity\z = 0
Global camera_position.Vec3f
camera_position\x = 0
camera_position\y = 0
camera_position\z = 0
Global mouse_position.Vec2i
mouse_position\x = 0
mouse_position\y = 0
Global old_mouse_position.Vec2i
old_mouse_position\x = -99999
old_mouse_position\y = -99999
Global mouse_left_button_down.i = 0
Global mouse_wheel_position.i = 0
Global body_focused.i = 0
Global end_game.i = 0
Global sgGlVersion.s, sgGlVendor.s, sgGlRender.s, sgGlExtn.s

;Declare b2Body_AddAngle(tmp_body.l, add_angle.d)
Declare keyboard_proc(*Value)
Declare MyWindowCallback(WindowID,Message,wParam,lParam)
Declare fps_timer_proc(*Value)




; Remember! In Paint.NET save images as 32-bit PNG for the below to work
; Also for backward compatibility to OpenGL v1 we use images (textures) with dimensions
;   in powers of 2 - i.e. 2x2, 4x4, 16x16, 32x32, 64x64, 128x128, 256x256

LoadImage(0, "platform256x256.png")
platform_bitmap.BITMAP
GetObject_(ImageID(0), SizeOf(BITMAP), @platform_bitmap)

LoadImage(1, "crate128x128.png")
crate_bitmap.BITMAP
GetObject_(ImageID(1), SizeOf(BITMAP), @crate_bitmap)

   

;OpenConsole()

; OpenGL Window
OpenWindow(0, 0, 0, 800, 600, "OpenGL Gadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
OpenGLGadget(0, 0, 0, 800, 600, #PB_OpenGL_Keyboard|#PB_OpenGL_NoFlipSynchronization )

glMatrixMode_(#GL_PROJECTION)
gluPerspective_(30.0, 200/200, 1.0, 1000.0) 
glMatrixMode_(#GL_MODELVIEW)
glTranslatef_(0, 0, -200.0)
glEnable_(#GL_CULL_FACE)    ; This will enhance the rendering speed as all the back face will be
glTexParameteri_(#GL_TEXTURE_2D, #GL_TEXTURE_MIN_FILTER, #GL_LINEAR)
glTexParameteri_(#GL_TEXTURE_2D, #GL_TEXTURE_MAG_FILTER, #GL_LINEAR)

; Info Text Window
SetWindowCallback(@MyWindowCallback()) ; Set callback for this window.
GetWindowRect_(WindowID(0),win.RECT)
OpenWindow(1,win\left+10,win\top+20,300,400,"Follower",#PB_Window_BorderLess, WindowID(0))
Global info_text_window.l = WindowID(1)
SetWindowColor(1,#Black)
SetWindowLong_(WindowID(1), #GWL_EXSTYLE, #WS_EX_LAYERED | #WS_EX_TOPMOST)
SetLayeredWindowAttributes_(WindowID(1),#Black,0,#LWA_COLORKEY)
TextGadget(5, 10,  10, 300, 400, "")
SetGadgetColor(5, #PB_Gadget_BackColor, #Black)
SetGadgetColor(5, #PB_Gadget_FrontColor, #White)
SetActiveWindow(0)
SetActiveGadget(0)


; OpenGL Info
sgGlVersion = Trim(PeekS(glGetString_(#GL_VERSION),#PB_Ascii))
sgGlExtn = Trim(PeekS(glGetString_(#GL_EXTENSIONS),#PB_Ascii))
sgGlVendor = Trim(PeekS(glGetString_(#GL_VENDOR),#PB_Ascii))
sgGlRender = Trim(PeekS(glGetString_(#GL_RENDERER),#PB_Ascii))

If(sgGlVersion = "") : sgGlVersion = "Not verified" : EndIf
If(   sgGlExtn = "") :    sgGlExtn = "Not verified" : EndIf
If( sgGlVendor = "") :  sgGlVendor = "Not verified" : EndIf
If( sgGlRender = "") :  sgGlRender = "Not verified" : EndIf



; setup gravity
Global gravity.b2Vec2
gravity\x = 0.0
gravity\y = -10.0
  
; setup the world
world = b2World_Create(gravity\x, gravity\y)
  
; setup the ground body
; world, active, allowSleep, angle, angularVelocity, angularDamping, awake, bullet, fixedRotation, gravityScale, linearDamping, linearVelocityX, linearVelocityY, positionX, positionY, type, userData)
Global groundBody.l = b2World_CreateBody(world, 1, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, -10, 1, 0)
b2Body_SetAngle(groundBody, Radian(-5))

; setup the ground shape and fixture
; body, density, friction, isSensor,	restitution, userData, categoryBits, groupIndex, maskBits, px, py, radius)
Global Dim groundBody_shape.b2Vec2(4)
groundBody_shape(0)\x = 50
groundBody_shape(0)\y = 10
groundBody_shape(1)\x = -50
groundBody_shape(1)\y = 10
groundBody_shape(2)\x = -50
groundBody_shape(2)\y = -10
groundBody_shape(3)\x = 50
groundBody_shape(3)\y = -10
Global groundBodyFixture.l = b2PolygonShape_CreateFixture_4(groundBody, 1, 0.1, 0, 0, 0, 1, 0, 65535, groundBody_shape(0)\x, groundBody_shape(0)\y, groundBody_shape(1)\x, groundBody_shape(1)\y, groundBody_shape(2)\x, groundBody_shape(2)\y, groundBody_shape(3)\x, groundBody_shape(3)\y)

; setup the body body
; world, active, allowSleep, angle, angularVelocity, angularDamping, awake, bullet, fixedRotation, gravityScale, linearDamping, linearVelocityX, linearVelocityY, positionX, positionY, type, userData)
Global body.l = b2World_CreateBody(world, 1, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 4, 2, 0)
b2Body_SetAngle(body, Radian(5))

; setup the body shape and fixture
; body, density, friction, isSensor,	restitution, userData, categoryBits, groupIndex, maskBits, px, py, radius)
Global Dim body_shape.b2Vec2(4)
body_shape(0)\x = 1
body_shape(0)\y = 1
body_shape(1)\x = -1
body_shape(1)\y = 1
body_shape(2)\x = -1
body_shape(2)\y = -1
body_shape(3)\x = 1
body_shape(3)\y = -1
Global bodyFixture.l = b2PolygonShape_CreateFixture_4(body, 1, 0.1, 0, 0.5, 0, 1, 0, 65535, body_shape(0)\x, body_shape(0)\y, body_shape(1)\x, body_shape(1)\y, body_shape(2)\x, body_shape(2)\y, body_shape(3)\x, body_shape(3)\y)


Global Dim tmp_pos.f(2)
frame_timer = ElapsedMilliseconds()
Global num_frames.i = 0
Global fps.i = 0
CreateThread(@fps_timer_proc(), 1000)
CreateThread(@keyboard_proc(), 1000)
;keyboard_timer = ElapsedMilliseconds()


; Animation loop

StartDrawing(WindowOutput(0))
            
Repeat
  
  If (ElapsedMilliseconds() - frame_timer) > 16
    
    frame_timer = ElapsedMilliseconds()
    b2World_Step(world, (1 / 60.0), 6, 2)
    
    ; opengl movement
    
    glClear_ (#GL_COLOR_BUFFER_BIT | #GL_DEPTH_BUFFER_BIT)
    
    
    
    glEnable_(#GL_TEXTURE_2D)                               ; Enable texture mapping
    glBindTexture_(#GL_TEXTURE_2D, TextureID)
    
    
;  glBegin_(#GL_QUADS)                                     ; Start drawing the cube
 ; glEnd_()
    
    
    glTexImage2D_(#GL_TEXTURE_2D, 0, #GL_RGBA, ImageWidth(0), ImageHeight(0), 0, #GL_BGRA_EXT, #GL_UNSIGNED_BYTE, platform_bitmap\bmBits)

    
    
    ; groundBody
    b2Body_GetPosition(groundBody, tmp_pos())
    tmp_angle.d = b2Body_GetAngle(groundBody)
    glPushMatrix_()
    glTranslatef_(tmp_pos(0), tmp_pos(1), 0)
    glRotatef_ (Degree(tmp_angle), 0, 0, 1.0)
    glBegin_  (#GL_QUADS)
;    glBegin_  (#GL_LINE_LOOP)
;    glVertex3f_ (groundBody_shape(0)\x, groundBody_shape(0)\y, 0.5)   
;    glVertex3f_ (groundBody_shape(1)\x, groundBody_shape(1)\y, 0.5)   
;    glVertex3f_ (groundBody_shape(2)\x, groundBody_shape(2)\y, 0.5)   
;    glVertex3f_ (groundBody_shape(3)\x, groundBody_shape(3)\y, 0.5)   
    
;    glTexCoord2f_(1.0, 1.0) : glVertex3f_( 1.0, 1.0, 1.0) ; Top right of cube (Front)
;    glTexCoord2f_(0.0, 1.0) : glVertex3f_(-1.0, 1.0, 1.0) ; Top left of cube (Front) 
;    glTexCoord2f_(0.0, 0.0) : glVertex3f_(-1.0,-1.0, 1.0) ; Bottom left of cube (Front)
;    glTexCoord2f_(1.0, 0.0) : glVertex3f_( 1.0,-1.0, 1.0) ; Bottom right of cube (Front)
    
    glTexCoord2f_(1.0, 1.0) : glVertex3f_(groundBody_shape(0)\x, groundBody_shape(0)\y, 0.5) ; Top right of cube (Front)
    glTexCoord2f_(0.0, 1.0) : glVertex3f_(groundBody_shape(1)\x, groundBody_shape(1)\y, 0.5) ; Top left of cube (Front) 
    glTexCoord2f_(0.0, 0.0) : glVertex3f_(groundBody_shape(2)\x, groundBody_shape(2)\y, 0.5) ; Bottom left of cube (Front)
    glTexCoord2f_(1.0, 0.0) : glVertex3f_(groundBody_shape(3)\x, groundBody_shape(3)\y, 0.5) ; Bottom right of cube (Front)

    
    glEnd_()
    glPopMatrix_()
    
    glTexImage2D_(#GL_TEXTURE_2D, 0, #GL_RGBA, ImageWidth(1), ImageHeight(1), 0, #GL_BGRA_EXT, #GL_UNSIGNED_BYTE, crate_bitmap\bmBits)

    ; body
    b2Body_GetPosition(body, tmp_pos())
    tmp_angle.d = b2Body_GetAngle(body)
    glPushMatrix_()
    glTranslatef_(tmp_pos(0), tmp_pos(1), 0)
    glRotatef_ (Degree(tmp_angle), 0, 0, 1.0)
    glBegin_  (#GL_QUADS)
;    glBegin_  (#GL_LINE_LOOP)
;    glVertex3f_ (body_shape(0)\x, body_shape(0)\y, 0.5)   
;    glVertex3f_ (body_shape(1)\x, body_shape(1)\y, 0.5)   
;    glVertex3f_ (body_shape(2)\x, body_shape(2)\y, 0.5)   
;    glVertex3f_ (body_shape(3)\x, body_shape(3)\y, 0.5)   
    glTexCoord2f_(1.0, 1.0) : glVertex3f_(body_shape(0)\x, body_shape(0)\y, 0.5) ; Top right of cube (Front)
    glTexCoord2f_(0.0, 1.0) : glVertex3f_(body_shape(1)\x, body_shape(1)\y, 0.5) ; Top left of cube (Front) 
    glTexCoord2f_(0.0, 0.0) : glVertex3f_(body_shape(2)\x, body_shape(2)\y, 0.5) ; Bottom left of cube (Front)
    glTexCoord2f_(1.0, 0.0) : glVertex3f_(body_shape(3)\x, body_shape(3)\y, 0.5) ; Bottom right of cube (Front)
    glEnd_()
    glPopMatrix_()
    
    
    SetGadgetAttribute(Gadget, #PB_OpenGL_FlipBuffers, #True)
    
    ; camera movement
    
    If camera_linearvelocity\x > 0.2 Or camera_linearvelocity\x < 0.2
      
      camera_linearvelocity\x = camera_linearvelocity\x * 0.9
    EndIf
    
    If camera_linearvelocity\y > 0.2 Or camera_linearvelocity\y < 0.2
      
      camera_linearvelocity\y = camera_linearvelocity\y * 0.9
    EndIf
    
    If camera_linearvelocity\z > 0.2 Or camera_linearvelocity\z < 0.2
      
      camera_linearvelocity\z = camera_linearvelocity\z * 0.9
    EndIf
    
    camera_position\x = camera_position\x + camera_linearvelocity\x
    camera_position\y = camera_position\y + camera_linearvelocity\y
    camera_position\z = camera_position\z + camera_linearvelocity\z
    
    glTranslatef_(camera_linearvelocity\x, camera_linearvelocity\y, camera_linearvelocity\z)
    
    b2Body_SetAngularVelocityPercent(groundBody, 99)
    
    num_frames = num_frames + 1
  EndIf
  
  key.i = 0
  Eventxx = WindowEvent()
  
;   If EventType() = #PB_EventType_KeyUp ; like KeyboardReleased
  
  Select EventType()
  
    Case #PB_EventType_MouseMove
      
      mouse_position\x = GetGadgetAttribute(0, #PB_OpenGL_MouseX)
      mouse_position\y = GetGadgetAttribute(0, #PB_OpenGL_MouseY)
   
    Case #PB_EventType_LeftButtonDown
      
      mouse_left_button_down = 1
      
    Case #PB_EventType_LeftButtonUp
      
      mouse_left_button_down = 0
      
    Case #PB_EventType_MouseWheel
      
      mouse_wheel_position = GetGadgetAttribute(0, #PB_OpenGL_WheelDelta)

      
  EndSelect

;     key = GetGadgetAttribute(0,#PB_OpenGL_Key)
;     
;     Select key
;         
;       Case #PB_Shortcut_C
;         
;         body_focused = 0
;         
;       Case #PB_Shortcut_B
;         
;         body_focused = 1
;     EndSelect
;   EndIf
    
  
      
Until Eventxx = #PB_Event_CloseWindow Or end_game = 1


StopDrawing()


;   
; ; animate the world
; For i = 1 To 60
;   
;   b2World_Step(world, (1 / 60.0), 6, 2)
; 
;   b2Body_GetPosition(body, tmp_pos())
;   tmp_angle.d = b2Body_GetAngle(body)
; 
;   
;   PrintN(StrF(tmp_pos(0)) + " " + StrF(tmp_pos(1)) + " " + StrF(tmp_angle.d))
; Next
; 
; Input()




Procedure keyboard_proc(*Value)
  
  keyboard_timer = ElapsedMilliseconds()

  While (1)
  
    If (ElapsedMilliseconds() - keyboard_timer) > 16
      
      keyboard_timer = ElapsedMilliseconds()
      
      ; game control
      
      If GetAsyncKeyState_(#VK_ESCAPE)
        
        end_game = 1
      EndIf
      
      ; ground control
                  
      If GetAsyncKeyState_(#VK_Q)
        
        b2Body_AddAngularVelocity(groundBody, Radian(1))
      EndIf
      
      If GetAsyncKeyState_(#VK_E)
        
        b2Body_AddAngularVelocity(groundBody, Radian(-1))
      EndIf

      ; body control

      If GetAsyncKeyState_(#VK_A)
        
        b2Body_GetPosition(body, tmp_pos())
        b2Body_ApplyForce(body, -400, 0, tmp_pos(0), tmp_pos(1), 1)
      EndIf

      If GetAsyncKeyState_(#VK_D)
        
        b2Body_GetPosition(body, tmp_pos())
        b2Body_ApplyForce(body, 400, 0, tmp_pos(0), tmp_pos(1), 1)
      EndIf

      If GetAsyncKeyState_(#VK_W)
        
        b2Body_GetPosition(body, tmp_pos())
        b2Body_ApplyForce(body, 0, 400, tmp_pos(0), tmp_pos(1), 1)
      EndIf

      If GetAsyncKeyState_(#VK_S)
        
        b2Body_GetPosition(body, tmp_pos())
        b2Body_ApplyForce(body, 0, -400, tmp_pos(0), tmp_pos(1), 1)
      EndIf
      
      ; camera control
            
      If GetAsyncKeyState_(#VK_LEFT)
        
        camera_linearvelocity\x = camera_linearvelocity\x + 0.5
        camera_position\x = camera_position\x + 0.5
      EndIf
      
      If GetAsyncKeyState_(#VK_RIGHT)

        camera_linearvelocity\x = camera_linearvelocity\x - 0.5
        camera_position\x = camera_position\x - 0.5
      EndIf
      
      If GetAsyncKeyState_(#VK_DOWN)
        
        camera_linearvelocity\y = camera_linearvelocity\y + 0.5
        camera_position\y = camera_position\y + 0.5
      EndIf
      
      If GetAsyncKeyState_(#VK_UP)
        
        camera_linearvelocity\y = camera_linearvelocity\y - 0.5
        camera_position\y = camera_position\y - 0.5
      EndIf
            
;      If GetAsyncKeyState_(#VK_NEXT)
      If mouse_wheel_position > 0  
        
        mouse_wheel_position = 0
        camera_linearvelocity\z = camera_linearvelocity\z + 2
        camera_position\z = camera_position\z + 2
      EndIf
            
;      If GetAsyncKeyState_(#VK_PRIOR)
      If mouse_wheel_position < 0  
              
        mouse_wheel_position = 0
        camera_linearvelocity\z = camera_linearvelocity\z - 2
        camera_position\z = camera_position\z - 2
      EndIf
            
;      If GetAsyncKeyState_(#VK_M)
      If mouse_left_button_down = 1
        
        If old_mouse_position\x = -99999
          
          old_mouse_position\x = mouse_position\x
        EndIf
        
        If old_mouse_position\y = -99999
          
          old_mouse_position\y = mouse_position\y
        EndIf
        
        camera_linearvelocity\x = camera_linearvelocity\x + ((mouse_position\x - old_mouse_position\x) * (0.0148 - (camera_position\z / 15000)))
        camera_linearvelocity\y = camera_linearvelocity\y - ((mouse_position\y - old_mouse_position\y) * (0.020 - (camera_position\z / 11000)))
        
        old_mouse_position\x = mouse_position\x
        old_mouse_position\y = mouse_position\y
      Else
        
        old_mouse_position\x = -99999
        old_mouse_position\y = -99999
      EndIf
    EndIf
      
  Wend


EndProcedure


Procedure MyWindowCallback(WindowID,Message,wParam,lParam)
  Result=#PB_ProcessPureBasicEvents
  If Message=#WM_MOVE ; Main window is moving!
    GetWindowRect_(WindowID(0),win.RECT) ; Store its dimensions in "win" structure.
    SetWindowPos_(info_text_window,0,win\left+10,win\top+20,0,0,#SWP_NOSIZE|#SWP_NOACTIVATE) ; Dock other window.
  EndIf
  ProcedureReturn Result
EndProcedure


Procedure fps_timer_proc(*Value)
  
  fps_timer = ElapsedMilliseconds()

  While (1)
  
    If (ElapsedMilliseconds() - fps_timer) > 1000
      
      fps_timer = ElapsedMilliseconds()
      fps = num_frames + 1
      num_frames = 0
      
      SetGadgetText(5, "Keys" + Chr(10) +
                       "----" + Chr(10) +
                       "Arrow Keys - move camera" + Chr(10) +
                       "PgDn & PgUp - zoom camera in & out" + Chr(10) +
                       "Q & E - rotate platform" + Chr(10) +
                       "A, D, S, W - add force to create" + Chr(10) +
                       "" + Chr(10) +
                       "Info" + Chr(10) +
                       "----" + Chr(10) +
                       "OpenGL version = " + sgGlVersion + Chr(10) + 
                       "OpenGL extensions = " + sgGlExtn + Chr(10) + 
                       "OpenGL vendor = " + sgGlVendor + Chr(10) + 
                       "OpenGL renderer = " + sgGlRender + Chr(10) + 
                       "Camera position = " + Str(camera_position\x) + ", " + Str(camera_position\y) + ", " + Str(camera_position\z) + Chr(10) + 
                       "Mouse position = " + Str(mouse_position\x) + ", " + Str(mouse_position\y) + Chr(10) + 
                       "Mouse change = " + Str(mouse_position\x - old_mouse_position\x) + ", " + Str(mouse_position\y - old_mouse_position\y) + Chr(10) + 
                       "FPS2 = " + Str(fps) + Chr(10) + 
                       "# of bodies = " + Str(particlecount))
      
      
     ; Debug("fps = " + Str(fps) + ", number of bodies = " + Str(num_bodies))
 ;     _CSFML_sfText_setString(info_text, "Info" + Chr(10) + 
 ;                                        "----" + Chr(10) + 
 ;                                        "number of bodies = " + Str(particlecount) + Chr(10) + 
 ;                                        "fps = " + Str(fps))
      
    EndIf
  Wend


EndProcedure

; IDE Options = PureBasic 5.40 LTS (Windows - x86)
; CursorPosition = 251
; FirstLine = 248
; Folding = -
; EnableXP
; Executable = OpenGL_LiquidFun_hello2D_3.exe
; SubSystem = OpenGL