XIncludeFile "LiquidFun-C.pbi"
XIncludeFile "LiquidFun-C-Ex.pbi"

UsePNGImageDecoder()

#GL_VENDOR     = $1F00
#GL_RENDERER   = $1F01
#GL_VERSION    = $1F02
#GL_EXTENSIONS = $1F03

; #GLOBALS# ===================================================================================================================

; Box2D Bodies
Global groundBody.l
Global body.l

; Box2D Fixtures
groundBodyFixture.b2_4VertexFixture
bodyFixture.b2_4VertexFixture

; LiquidFun Particle System
Global particle_radius.d = 0.06
Global dampingStrength.d = 1.5
Global particledensity.d = 0.1
Global water_position_x.d = 0.0
Global water_position_y.d = 40.0
Global water_strength.d = 1.0
Global water_stride.d = 0.3
Global water_radius.d = 9.0

; LiquidFun Particle Groups
Global particlegroup.l

; OpenGL Textures
Global groundBody_texture.gl_Texture
Global body_texture.gl_Texture
Global water_texture.gl_Texture

; Game Controls
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
Global end_game.i = 0


; ===============================================================================================================================


; #VARIABLES# ===================================================================================================================


; ===============================================================================================================================

; #FUNCTIONS# ===================================================================================================================
Declare keyboard_mouse_proc(*Value)
Declare MyWindowCallback(WindowID,Message,wParam,lParam)
Declare fps_timer_proc(*Value)
Declare destroy_all()
Declare create_all()
; ===============================================================================================================================



; Setup the OpenGL Textures

; Remember! In Paint.NET save images as 32-bit PNG for the below to work
; Also for backward compatibility to OpenGL v1 we use images (textures) with dimensions in powers of 2
;   i.e. 2x2, 4x4, 16x16, 32x32, 64x64, 128x128, 256x256

glCreateTexture(groundBody_texture, "platform256x256.png")
glCreateTexture(body_texture, "crate128x128.png")
glCreateTexture(water_texture, "waterparticle64x64.png")


;OpenConsole()

; Setup the OpenGL Main Window
OpenWindow(0, 0, 0, 800, 600, "OpenGL Gadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
OpenGLGadget(0, 0, 0, 800, 600, #PB_OpenGL_Keyboard|#PB_OpenGL_NoFlipSynchronization )

; Setup OpenGL
glSetup()

; Setup the OpenGL Info Window
info_text_window_bgcolor = $006600
SetWindowCallback(@MyWindowCallback()) ; Set callback for this window.
GetWindowRect_(WindowID(0),win.RECT)
OpenWindow(1,win\left+10,win\top+20,300,400,"Follower",#PB_Window_BorderLess, WindowID(0))
Global info_text_window.l = WindowID(1)
SetWindowColor(1,info_text_window_bgcolor)
SetWindowLong_(WindowID(1), #GWL_EXSTYLE, #WS_EX_LAYERED | #WS_EX_TOPMOST)
SetLayeredWindowAttributes_(WindowID(1),info_text_window_bgcolor,0,#LWA_COLORKEY)
TextGadget(5, 10,  10, 300, 400, "")
SetGadgetColor(5, #PB_Gadget_BackColor, info_text_window_bgcolor)
SetGadgetColor(5, #PB_Gadget_FrontColor, #Black)
SetActiveWindow(0)
SetActiveGadget(0)
GLGetInfo()

; Setup the Box2D World
; gravity_x, gravity_y
b2World_CreateEx(0.0, -10.0)

; Setup the Box2D Bodies
; world, active, allowSleep, angle, angularVelocity, angularDamping, awake, bullet, fixedRotation, gravityScale, linearDamping, linearVelocityX, linearVelocityY, positionX, positionY, type, userData)
groundBody = b2World_CreateBody(world, 1, 1, Radian(-5), 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, -10, 1, 0)
body = b2World_CreateBody(world, 1, 1, Radian(5), 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 4, 2, 0)

; Setup the Box2D Fixtures
; fixture_struct, body_ptr, density, friction, isSensor,restitution, v0_x, v0_y, v1_x, v1_y, v2_x, v2_y, v3_x, v3_y
b2PolygonShape_Create4VertexFixture(groundBodyFixture, groundBody, 1, 0.1, 0, 0, 50, 10, -50, 10, -50, -10, 50, -10)
b2PolygonShape_Create4VertexFixture(bodyFixture, body, 1, 0.1, 0, 0.5, 1, 1, -1, 1, -1, -1, 1, -1)




; Wave Machine Sean
particlesystem = b2World_CreateParticleSystem(world, 0.5, 0.2, 1, 0.5, 0.25, 0.016666666666666666, 0.5, 0.05, particle_radius, 1, 0.25, 8, 0.2, 0.2, 0.2, 0.2, 0.25)
b2ParticleSystem_SetDensity(particlesystem, particledensity)
particlegroup = b2CircleShape_CreateParticleGroup(particlesystem, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, water_position_x, water_position_y, 0, 0, water_strength, water_stride, 0, 0, 0, water_radius)
particlecount = b2ParticleSystem_GetParticleCount(particlesystem)
;Debug(particlecount)
particlepositionbuffer = b2ParticleSystem_GetPositionBuffer(particlesystem)
;Debug (particlepositionbuffer)

ReDim particle_quad_vertice(Int(particlecount) * 4)
ReDim particle_texture_vertice(Int(particlecount) * 4)



Global Dim tmp_pos.f(2)
frame_timer = ElapsedMilliseconds()
Global num_frames.i = 0
Global fps.i = 0
CreateThread(@fps_timer_proc(), 1000)
CreateThread(@keyboard_mouse_proc(), 1000)


; Animation loop

StartDrawing(WindowOutput(0))
            
Repeat
  
  If (ElapsedMilliseconds() - frame_timer) > 16
    
    frame_timer = ElapsedMilliseconds()
    b2World_Step(world, (1 / 60.0), 6, 2)
    
    ; reset colouring and clear the openglgadget
    glColor3f_(1.0, 1.0, 1.0)
;    glClearColor_(1, 1, 1, 1)
    glClearColor_(0.7, 0.7, 0.7, 1)
    glClear_ (#GL_COLOR_BUFFER_BIT | #GL_DEPTH_BUFFER_BIT)
    
    ; enable texture mapping
    glEnable_(#GL_TEXTURE_2D)
    glBindTexture_(#GL_TEXTURE_2D, TextureID)
    
    ; Draw the Box2D Bodies
    glDrawBodyFixtureTexture(groundBody, groundBodyFixture, groundBody_texture)
    glDrawBodyFixtureTexture(body, bodyFixture, body_texture)
        
    ; Draw the LiquidFun Particles
    ; texture, particle_quad_size
    glDrawParticlesTexture(water_texture, 0.4)

    ; update the display
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
  
  Select EventType()
      
    Case #PB_EventType_KeyUp ; like KeyboardReleased
      
      key = GetGadgetAttribute(0,#PB_OpenGL_Key)

      Select key
          
        Case #PB_Shortcut_R
          
          destroy_all()
          create_all()
          
        Case #PB_Shortcut_K
          
          b2ParticleGroup_DestroyParticles(particlegroup, 0)
          
          ; I read in the LiquidFun docs that the particle groups aren't destroyed until the next Step.  So Step below...
          b2World_Step(world, (1 / 60.0), 6, 2)

          particlegroup = b2CircleShape_CreateParticleGroup(particlesystem, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 40, 0, 0, 1, 0.4, 0, 0, 0, 9)
          particlecount = b2ParticleSystem_GetParticleCount(particlesystem)
          particlepositionbuffer = b2ParticleSystem_GetPositionBuffer(particlesystem)
      EndSelect
      
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
      
Until Eventxx = #PB_Event_CloseWindow Or end_game = 1

StopDrawing()



Procedure keyboard_mouse_proc(*Value)
  
  keyboard_mouse_timer = ElapsedMilliseconds()

  While (1)
  
    If (ElapsedMilliseconds() - keyboard_mouse_timer) > 16
      
      keyboard_mouse_timer = ElapsedMilliseconds()
      
      ; game control (keyboard)
      
      If GetAsyncKeyState_(#VK_ESCAPE)
        
        end_game = 1
      EndIf
      
      ; ground control (keyboard)
                  
      If GetAsyncKeyState_(#VK_Z)
        
        b2Body_AddAngularVelocity(groundBody, Radian(1))
      EndIf
      
      If GetAsyncKeyState_(#VK_X)
        
        b2Body_AddAngularVelocity(groundBody, Radian(-1))
      EndIf

      ; body control (keyboard)

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

      If GetAsyncKeyState_(#VK_Q)
        
        b2Body_ApplyTorque(body, 100, 1)
      EndIf

      If GetAsyncKeyState_(#VK_E)
        
        b2Body_ApplyTorque(body, -100, 1)
      EndIf
      
      ; camera control (mouse)
            
      If mouse_wheel_position > 0  
        
        mouse_wheel_position = 0
        camera_linearvelocity\z = camera_linearvelocity\z + 2
        camera_position\z = camera_position\z + 2
      EndIf
            
      If mouse_wheel_position < 0  
              
        mouse_wheel_position = 0
        camera_linearvelocity\z = camera_linearvelocity\z - 2
        camera_position\z = camera_position\z - 2
      EndIf
            
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
      
      
      msg.s = "Keys & Mouse" + Chr(10) +
              "-----------------------" + Chr(10) +
              "Left Mouse Button & Drag - move camera" + Chr(10) +
              "Mouse Wheel - zoom camera in & out" + Chr(10) +
              "Z & X - rotate platform" + Chr(10) +
              "A, D, S, W - add linear force to crate" + Chr(10) +
              "Q, E - add angular force to crate" + Chr(10) +
              "K - re-drop the water" + Chr(10) +
              "R - restart" + Chr(10) +
              "" + Chr(10) +
              "Info" + Chr(10) +
              "-------" + Chr(10) +
              "OpenGL version = " + sgGlVersion + Chr(10) + 
              "Camera position = " + Str(camera_position\x) + ", " + Str(camera_position\y) + ", " + Str(camera_position\z) + Chr(10) + 
              "Mouse position = " + Str(mouse_position\x) + ", " + Str(mouse_position\y) + Chr(10) + 
              "FPS = " + Str(fps) + Chr(10) + 
              "# of bodies = " + Str(particlecount)

      SetGadgetText(5, msg)
      
;              "OpenGL extensions = " + sgGlExtn + Chr(10) + 
 ;             "OpenGL vendor = " + sgGlVendor + Chr(10) + 
      ;              "OpenGL renderer = " + sgGlRender + Chr(10) + 

                ;             "Mouse change = " + Str(mouse_position\x - old_mouse_position\x) + ", " + Str(mouse_position\y - old_mouse_position\y) + Chr(10) + 

    EndIf
  Wend


EndProcedure

Procedure destroy_all()
  
  ; Bodies  
  b2Body_DestroyFixture(groundBody, groundBodyFixture)
  b2World_DestroyBody(world, groundBody)
  b2Body_DestroyFixture(body, bodyFixture)
  b2World_DestroyBody(world, body)
  
  ; Particles
  b2ParticleGroup_DestroyParticles(particlegroup, 0)
  
  ; I read in the LiquidFun docs that the particle groups aren't destroyed until the next Step.  So Step below...
  b2World_Step(world, (1 / 60.0), 6, 2)

  
EndProcedure

Procedure create_all()
  
  ; Bodies  
  groundBody.l = b2World_CreateBody(world, 1, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, -10, 1, 0)
  b2Body_SetAngle(groundBody, Radian(-5))
;  groundBodyFixture.l = b2PolygonShape_CreateFixture_4(groundBody, 1, 0.1, 0, 0, 0, 1, 0, 65535, groundBody_shape(0)\x, groundBody_shape(0)\y, groundBody_shape(1)\x, groundBody_shape(1)\y, groundBody_shape(2)\x, groundBody_shape(2)\y, groundBody_shape(3)\x, groundBody_shape(3)\y)
  body.l = b2World_CreateBody(world, 1, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 4, 2, 0)
  b2Body_SetAngle(body, Radian(5))
;  bodyFixture.l = b2PolygonShape_CreateFixture_4(body, 1, 0.1, 0, 0.5, 0, 1, 0, 65535, body_shape(0)\x, body_shape(0)\y, body_shape(1)\x, body_shape(1)\y, body_shape(2)\x, body_shape(2)\y, body_shape(3)\x, body_shape(3)\y)
  
  ; Particles
  particlegroup = b2CircleShape_CreateParticleGroup(particlesystem, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, water_position_x, water_position_y, 0, 0, water_strength, water_stride, 0, 0, 0, water_radius)
  particlecount = b2ParticleSystem_GetParticleCount(particlesystem)
  particlepositionbuffer = b2ParticleSystem_GetPositionBuffer(particlesystem)
  
EndProcedure

; IDE Options = PureBasic 5.60 (Windows - x86)
; CursorPosition = 93
; FirstLine = 86
; Folding = -
; EnableXP
; Executable = OpenGL_LiquidFun_hello2D_5.exe
; SubSystem = OpenGL