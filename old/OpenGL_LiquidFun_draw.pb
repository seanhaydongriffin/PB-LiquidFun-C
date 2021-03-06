﻿XIncludeFile "LiquidFun-C.pbi"
XIncludeFile "LiquidFun-C-Ex.pbi"
UsePNGImageDecoder()

; #GLOBALS# ===================================================================================================================

Global Dim tmp_pos.f(2)
Global num_frames.i = 0
Global fps.i = 0
Global animation_speed.f = 1.0

; Box2D Bodies
Global bucketBody.l
Global bucketBallBody.l
Global groundBody.l
Global body.l
Global body_mass.d
Global body_user_applied_linear_force.d = 100
Global body_user_applied_angular_force.d = 10

; Box2D Fixtures
Global bucketBodyFixture1.b2_4VertexFixture
Global bucketBodyFixture2.b2_4VertexFixture
Global bucketBodyFixture3.b2_4VertexFixture
Global bucketBodyFixture4.b2_4VertexFixture
Global bucketBodyFixture5.b2_4VertexFixture
Global bucketBodyFixture6.b2_4VertexFixture
Global bucketBodyFixture7.b2_4VertexFixture
Global bucketBodyFixture8.b2_4VertexFixture
Global bucketBodyFixture9.b2_4VertexFixture
Global bucketBodyFixture10.b2_4VertexFixture
Global bucketBodyFixture11.b2_4VertexFixture
Global bucketBallBodyFixture1.b2_4VertexFixture
Global bucketBallBodyFixture2.b2_4VertexFixture
Global bucketBallBodyFixture3.b2_4VertexFixture
Global bucketBallBodyFixture4.b2_4VertexFixture
Global bucketBallBodyFixture5.b2_4VertexFixture
Global bucketBallBodyFixture6.b2_4VertexFixture
Global bucketBallBodyFixture7.b2_4VertexFixture
Global bucketBallBodyFixture8.b2_4VertexFixture
Global groundBodyFixture.b2_4VertexFixture
Global groundBodySubFixture1.b2_4VertexFixture
Global groundBodySubFixture2.b2_4VertexFixture
Global bodyFixture.b2_4VertexFixture
Global Dim tmp_fixture_vector.b2Vec2(50)
Global tmp_fixture_vector_num = -1
Global tmp_fixture_vector_size = -1
Global Dim tmp_fixture_angle.f(50)

; LiquidFun Particle System
Global particle_flags.i
Global particle_group_flags.i
Global particle_powder_strength.d
Global particle_pressure_strength.d
Global particle_radius.d = 0.06
Global dampingStrength.d = 1.5
Global particle_size.f = 0.5
Global particle_blending.i = 1
Global particle_density.d
Global particle_group_position_x.d = 0.0
Global particle_group_position_y.d = 40.0
Global particle_group_strength.d = 1.0
Global particle_group_stride.d = 0.3
Global particle_group_radius.d = 9.0

; LiquidFun Particle Groups
Global particlegroup.l

; OpenGL Textures
Global groundBody_texture.gl_Texture
Global body_texture.gl_Texture
Global water_texture.gl_Texture

; Game Controls
Global mouse_position.Vec2i
mouse_position\x = 0
mouse_position\y = 0
Global draw_world_start_position.b2Vec2
draw_world_start_position\x = 999999
draw_world_start_position\y = 999999
Global draw_world_end_position.b2Vec2
draw_world_end_position\x = 999999
draw_world_end_position\y = 999999
Global draw_world_angle.f
Global old_mouse_position.Vec2i
old_mouse_position\x = -99999
old_mouse_position\y = -99999
Global mouse_left_button_down.i = 0
Global mouse_wheel_position.i = 0
Global drawing_mode.i = 0
Global end_game.i = 0
; ===============================================================================================================================

; #VARIABLES# ===================================================================================================================
; ===============================================================================================================================

; #FUNCTIONS# ===================================================================================================================
Declare keyboard_mouse_handler(*Value)
Declare text_window_handler(*Value)
Declare b2DestroyScene(destroy_fixtures.i, destroy_bodies.i, destroy_particle_system.i)
Declare b2CreateScene(create_fixtures.i, create_bodies.i, create_particle_system.i)
; ===============================================================================================================================

; ============
; Setup OpenGL
; ============

; Setup the OpenGL Windows (main_window_x, main_window_y, main_window_width, main_window_height, main_window_title, openglgadget_x, openglgadget_y, openglgadget_width, openglgadget_height, text_window_width, text_window_height, text_window_background_colour, text_window_text_colour, open_console_window)
glSetupWindows(0, 0, 800, 600, "LiquidFun Demo", 0, 0, 800, 600, 400, 500, $006600, #Black, 0)

; Setup the OpenGL World (field_of_view, aspect_ratio, viewer_to_near_clipping_plane_distance, viewer_to_far_clipping_plane_distance, camera_x, camera_y, camera_z)
;glSetupWorld(30.0, 200/200, 1.0, 1000.0, 0, 0, -190.0)
glSetupWorld(30.0, 800/600, 1.0, 1000.0, 0, 0, -190.0)

; =====================
; Setup OpenGL Textures
; =====================

; Remember! In Paint.NET save images as 32-bit PNG for the below to work
; Also for backward compatibility to OpenGL v1 we use images (textures) with dimensions in powers of 2
;   i.e. 2x2, 4x4, 16x16, 32x32, 64x64, 128x128, 256x256

glCreateTexture(groundBody_texture, "platform256x256.png")
glCreateTexture(body_texture, "crate128x128.png")
;glCreateTexture(water_texture, "waterparticle64x64.png")
glCreateTexture(water_texture, "waterparticle-3-64x64.png")

; =======================
; Setup Box2D / LiquidFun
; =======================

; Setup the Box2D World (gravity_x, gravity_y)
b2World_CreateEx(0.0, -10.0)

; Create the Box2D Bodies, Fixtures and the LiquidFun Particle System
b2CreateScene(1, 1, 1)

; ========================
; Setup Threads and Timers
; ========================

CreateThread(@text_window_handler(), 1000)
CreateThread(@keyboard_mouse_handler(), 1000)
frame_timer = ElapsedMilliseconds()

; ==============
; Animation Loop
; ==============

StartDrawing(WindowOutput(0))


Repeat
  
  ; Every 1 / 60th of a second, or 16 milliseconds (or 60 frames per second)
  If (ElapsedMilliseconds() - frame_timer) > 16
    
    frame_timer = ElapsedMilliseconds()
    
    ; Step the Box2D World
    b2World_Step(world, (animation_speed / 60.0), 6, 2)
    
    ; Clear the OpenGLGadget
    glColor3f_(1.0, 1.0, 1.0)
;    glClearColor_(1, 1, 1, 1)
    glClearColor_(0.7, 0.7, 0.7, 1)
    glClear_ (#GL_COLOR_BUFFER_BIT | #GL_DEPTH_BUFFER_BIT)
    
    ; Enable Texture Mapping
    glEnable_(#GL_TEXTURE_2D)
    glBindTexture_(#GL_TEXTURE_2D, TextureID)
    
    ; Draw the Box2D Bodies (body, fixture, texture)
    glDrawFixtureTexture(groundBodyFixture)
    glDrawFixtureTexture(groundBodySubFixture1)
    glDrawFixtureTexture(groundBodySubFixture2)
    glDrawFixtureTexture(bodyFixture)
    glDrawFixtureTexture(bucketBodyFixture1)
    glDrawFixtureTexture(bucketBodyFixture2)
    glDrawFixtureTexture(bucketBodyFixture3)
    glDrawFixtureTexture(bucketBodyFixture4)
    glDrawFixtureTexture(bucketBodyFixture5)
    glDrawFixtureTexture(bucketBodyFixture6)
    glDrawFixtureTexture(bucketBodyFixture7)
    glDrawFixtureTexture(bucketBodyFixture8)
    glDrawFixtureTexture(bucketBodyFixture9)
    glDrawFixtureTexture(bucketBodyFixture10)
    glDrawFixtureTexture(bucketBodyFixture11)
    glDrawFixtureTexture(bucketBallBodyFixture1)
    glDrawFixtureTexture(bucketBallBodyFixture2)
    glDrawFixtureTexture(bucketBallBodyFixture3)
    glDrawFixtureTexture(bucketBallBodyFixture4)
    glDrawFixtureTexture(bucketBallBodyFixture5)
    glDrawFixtureTexture(bucketBallBodyFixture6)
    glDrawFixtureTexture(bucketBallBodyFixture7)
    glDrawFixtureTexture(bucketBallBodyFixture8)
        
    ; Draw the LiquidFun Particles (texture, particle_quad_size)
    glDrawParticlesTexture(water_texture, particle_size, particle_blending)
    
    
    
    ; Draw the drawing line
    

    
    If drawing_mode = 1
      
      glLineWidth_(2.5)
      glColor3f_(1.0, 0.0, 0.0)
      glBegin_(#GL_LINE_STRIP)

      For i = 0 To tmp_fixture_vector_num
  ;     Debug(i)
      
;        glVertex3f_(tmp_fixture_vector(tmp_fixture_vector_num - 1)\x, tmp_fixture_vector(tmp_fixture_vector_num - 1)\y, 0.0)
        glVertex3f_(tmp_fixture_vector(i)\x, tmp_fixture_vector(i)\y, 0.0)
      Next
      
      glEnd_()
    EndIf
    

    ; Update the display
    SetGadgetAttribute(Gadget, #PB_OpenGL_FlipBuffers, #True)
    
    b2Body_SetAngularVelocityPercent(groundBody, 99)
    
    body_mass.d = b2Body_GetMass(body)
    
    num_frames = num_frames + 1
  EndIf
  
  key.i = 0
  Eventxx = WindowEvent()
  
  Select EventType()
      
    ; if a single key is released
    Case #PB_EventType_KeyUp
      
      key = GetGadgetAttribute(0,#PB_OpenGL_Key)

      Select key
          
        ; if R is pressed then reset the Box2D World
        Case #PB_Shortcut_R
          
          b2DestroyScene(1, 1, 1)
          b2CreateScene(1, 1, 1)
          
        Case #PB_Shortcut_K
          
          b2DestroyScene(0, 0, 1)
          b2CreateScene(0, 0, 1)
          
        Case #PB_Shortcut_C
          
          water_radius = water_radius - 0.5
          b2DestroyScene(0, 0, 1)
          b2CreateScene(0, 0, 1)
          
        Case #PB_Shortcut_V
          
          water_radius = water_radius + 0.5
          b2DestroyScene(0, 0, 1)
          b2CreateScene(0, 0, 1)
          
        Case #PB_Shortcut_O
          
          animation_speed = animation_speed - 0.5
          
        Case #PB_Shortcut_P
          
          animation_speed = animation_speed + 0.5
          
        Case #PB_Shortcut_F
          
          b2Body_SetMassData(body, body_mass - 1.0, 0, 0, 0)
          
        Case #PB_Shortcut_G
          
          b2Body_SetMassData(body, body_mass + 1.0, 0, 0, 0)
          
        Case #PB_Shortcut_Y
          
          If particle_blending = 0
            
            particle_blending = 1
          Else
            
            particle_blending = 0
          EndIf
          
        Case #PB_Shortcut_U
          
          particle_size = particle_size - 0.05
          
          If particle_size < 0.05
            
            particle_size = 0.05
          EndIf
          
        Case #PB_Shortcut_I
          
          particle_size = particle_size + 0.05

      EndSelect
      
    ; if the mouse is moved then capture it's position for later on
    Case #PB_EventType_MouseMove
      
      mouse_position\x = GetGadgetAttribute(0, #PB_OpenGL_MouseX)
      mouse_position\y = GetGadgetAttribute(0, #PB_OpenGL_MouseY)
      
      If drawing_mode = 1
        
        tmp_fixture_vector(tmp_fixture_vector_num)\x = (mouse_position\x - 400) * 0.171
        tmp_fixture_vector(tmp_fixture_vector_num)\y = (300 - mouse_position\y) * 0.171
        
        ; note below is radians
        tmp_fixture_angle(tmp_fixture_vector_num) = ATan2(tmp_fixture_vector(tmp_fixture_vector_num - 1)\y - tmp_fixture_vector(tmp_fixture_vector_num)\y, tmp_fixture_vector(tmp_fixture_vector_num - 1)\x - tmp_fixture_vector(tmp_fixture_vector_num)\x)

      EndIf
      
      
   
    ; if the mouse is clicked then flag this for later on
;    Case #PB_EventType_LeftButtonDown
      
 ;           mouse_left_button_down = 1
      
    ; if the mouse is unclicked then flag this for later on
    Case #PB_EventType_LeftButtonUp
      
      mouse_left_button_down = 0
      
      If drawing_mode = 0
        
        tmp_fixture_vector_num = 0
        tmp_fixture_vector(tmp_fixture_vector_num)\x = (mouse_position\x - 400) * 0.171
        tmp_fixture_vector(tmp_fixture_vector_num)\y = (300 - mouse_position\y) * 0.171
      EndIf
      
      drawing_mode = 1
      tmp_fixture_vector_num = tmp_fixture_vector_num + 1


      
    Case #PB_EventType_RightButtonUp
      
      drawing_mode = 0
      tmp_fixture_vector_size = tmp_fixture_vector_num
            
;      SetClipboardText("Draw: Pos=" + StrF(draw_world_start_position\x, 2) + "," + StrF(draw_world_start_position\y, 2) + "; Length=" + StrF(_Box2C_b2Vec2_Distance(draw_world_start_position\x, draw_world_start_position\y, draw_world_end_position\x, draw_world_end_position\y), 2) + "; Angle=" + StrF(draw_world_angle, 2))
      
;      SetClipboardText("tmpbody = b2World_CreateBody(world, 1, 1, Radian(" + StrF(draw_world_angle, 2) + "), 0, 0, 1, 0, 0, 1, 0, 0, 0, " + StrF(draw_world_start_position\x, 2) + ", " + StrF(draw_world_start_position\y, 2) + ", 2, 0)" + Chr(10) +
 ;                      "b2PolygonShape_CreateBoxFixture(tmpbody_fixture, tmpbody, 1, 0.1, 0, 0, 1, 0, 65535, 2, 4, 0, 0, @tmpbody_texture)")
      
;                            "tmpbody = b2World_CreateBody(world, 1, 1, Radian(0), 0, 0, 1, 0, 0, 1, 0, 0, 0, " + StrF(draw_world_start_position\x, 2) + ", " + StrF(draw_world_start_position\y, 2) + ", 2, 0)" + Chr(10) +

      tmp_v0.b2Vec2
      tmp_v1.b2Vec2
      tmp_v2.b2Vec2
      tmp_v3.b2Vec2
      clipboard_str.s = ""
      
      For tmp_fixture_vector_num = 1 To tmp_fixture_vector_size
      
     ;   Debug(draw_world_angle)
        _Box2C_b2Vec2_Vector_at_Angle_Distance(tmp_fixture_vector(tmp_fixture_vector_num - 1)\x, tmp_fixture_vector(tmp_fixture_vector_num - 1)\y, tmp_fixture_angle(tmp_fixture_vector_num) - Radian(90) - Radian(90), 0.5, @tmp_v0)
        _Box2C_b2Vec2_Vector_at_Angle_Distance(tmp_fixture_vector(tmp_fixture_vector_num - 1)\x, tmp_fixture_vector(tmp_fixture_vector_num - 1)\y, tmp_fixture_angle(tmp_fixture_vector_num) - Radian(90) + Radian(90), 0.5, @tmp_v1)
        _Box2C_b2Vec2_Vector_at_Angle_Distance(tmp_fixture_vector(tmp_fixture_vector_num)\x, tmp_fixture_vector(tmp_fixture_vector_num)\y, tmp_fixture_angle(tmp_fixture_vector_num) - Radian(90) + Radian(90), 0.5, @tmp_v2)
        _Box2C_b2Vec2_Vector_at_Angle_Distance(tmp_fixture_vector(tmp_fixture_vector_num)\x, tmp_fixture_vector(tmp_fixture_vector_num)\y, tmp_fixture_angle(tmp_fixture_vector_num) - Radian(90) - Radian(90), 0.5, @tmp_v3)
        
        clipboard_str = clipboard_str + Chr(10) +
                        "b2PolygonShape_Create4VertexFixture(tmpbody_fixture, tmpbody, 1, 0.1, 0, 0, 1, 0, 65535, " + StrF(tmp_v0\x, 2) + ", " + StrF(tmp_v0\y, 2) + ", " + StrF(tmp_v1\x, 2) + ", " + StrF(tmp_v1\y, 2) + ", " + StrF(tmp_v2\x, 2) + ", " + StrF(tmp_v2\y, 2) + ", " + StrF(tmp_v3\x, 2) + ", " + StrF(tmp_v3\y, 2) + ", 0, 0, @tmpbody_texture)"
      Next
    
      SetClipboardText(clipboard_str)
      
      
      draw_world_end_position\x = 999999
      draw_world_end_position\y = 999999
      tmp_fixture_vector_num = -1
      
      
    ; if the mouse wheel is moved then capture it's position for later on
    Case #PB_EventType_MouseWheel
      
      mouse_wheel_position = GetGadgetAttribute(0, #PB_OpenGL_WheelDelta)
  EndSelect
      
Until Eventxx = #PB_Event_CloseWindow Or end_game = 1

StopDrawing()


; #FUNCTION# ====================================================================================================================
; Name...........: keyboard_mouse_handler
; Description ...: Handles keyboard and mouse events
; Syntax.........: keyboard_mouse_handler()
; Parameters ....:
; Return values .: None
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......: 
; Link ..........:
; Example .......:
; ===============================================================================================================================
Procedure keyboard_mouse_handler(*Value)
  
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
        b2Body_ApplyForce(body, body_mass * -body_user_applied_linear_force, 0, tmp_pos(0), tmp_pos(1), 1)
      EndIf

      If GetAsyncKeyState_(#VK_D)
        
        b2Body_GetPosition(body, tmp_pos())
        b2Body_ApplyForce(body, body_mass * body_user_applied_linear_force, 0, tmp_pos(0), tmp_pos(1), 1)
      EndIf

      If GetAsyncKeyState_(#VK_W)
        
        b2Body_GetPosition(body, tmp_pos())
        b2Body_ApplyForce(body, 0, body_mass * body_user_applied_linear_force, tmp_pos(0), tmp_pos(1), 1)
      EndIf

      If GetAsyncKeyState_(#VK_S)
        
        b2Body_GetPosition(body, tmp_pos())
        b2Body_ApplyForce(body, 0, body_mass * -body_user_applied_linear_force, tmp_pos(0), tmp_pos(1), 1)
      EndIf

      If GetAsyncKeyState_(#VK_Q)
        
        b2Body_ApplyTorque(body, body_mass * body_user_applied_angular_force, 1)
      EndIf

      If GetAsyncKeyState_(#VK_E)
        
        b2Body_ApplyTorque(body, body_mass * -body_user_applied_angular_force, 1)
      EndIf
      
      ; camera control (mouse)
            
;       If mouse_left_button_down = 1
;         
;         If old_mouse_position\x = -99999
;           
;           old_mouse_position\x = mouse_position\x
;         EndIf
;         
;         If old_mouse_position\y = -99999
;           
;           old_mouse_position\y = mouse_position\y
;         EndIf
;         
;         camera_linearvelocity\x = camera_linearvelocity\x + ((mouse_position\x - old_mouse_position\x) * (0.0148 - (camera_position\z / 15000)))
;         camera_linearvelocity\y = camera_linearvelocity\y - ((mouse_position\y - old_mouse_position\y) * (0.020 - (camera_position\z / 11000)))
;         
;         old_mouse_position\x = mouse_position\x
;         old_mouse_position\y = mouse_position\y
;       Else
;         
;         old_mouse_position\x = -99999
;         old_mouse_position\y = -99999
;       EndIf
      
      
    EndIf
      
  Wend


EndProcedure


; #FUNCTION# ====================================================================================================================
; Name...........: text_window_handler
; Description ...: Handles keyboard and mouse events
; Syntax.........: text_window_handler()
; Parameters ....:
; Return values .: None
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......: 
; Link ..........:
; Example .......:
; ===============================================================================================================================
Procedure text_window_handler(*Value)
  
  fps_timer = ElapsedMilliseconds()

  While (1)
    
    ; Every one second refresh the information in the text window
    If (ElapsedMilliseconds() - fps_timer) > 1000
      
      fps_timer = ElapsedMilliseconds()
      fps = num_frames + 1
      num_frames = 0
      
      msg.s = "Keys & Mouse" + Chr(10) +
              "-----------------------" + Chr(10) +
              "Left Mouse Button & Drag: pans the camera" + Chr(10) +
              "Mouse Wheel: zooms the camera in & out" + Chr(10) +
              "A, D, S, W: adds linear force to the crate" + Chr(10) +
              "Q, E: adds angular force to the crate" + Chr(10) +
              "Z, X: rotates the platform" + Chr(10) +
              "F, G: adjusts the mass of the crate" + Chr(10) +
              "C, V: adjusts the starting radius of the water group" + Chr(10) +
              "O, P: adjusts the animation speed (helps with low fps)" + Chr(10) +
              "Y: toggles water particle texture blending" + Chr(10) +
              "U, I: adjusts the water particle size" + Chr(10) +
              "K: restarts the water group" + Chr(10) +
              "R: resets the scene" + Chr(10) +
              "Esc: quits the demo" + Chr(10) +
              "" + Chr(10) +
              "Info" + Chr(10) +
              "-------" + Chr(10) +
              "OpenGL: Ver=" + sgGlVersion + Chr(10) + 
              "Draw: Pos=" + StrF(draw_world_start_position\x, 2) + "," + StrF(draw_world_start_position\y, 2) + "; Length=" + StrF(_Box2C_b2Vec2_Distance(draw_world_start_position\x, draw_world_start_position\y, draw_world_end_position\x, draw_world_end_position\y), 2) + "; Angle=" + StrF(Degree(draw_world_angle), 2) + Chr(10) +
              "Crate: Mass=" + StrF(body_mass, 2) + Chr(10) + 
              "Mouse: Gadget Pos=" + Str(mouse_position\x) + "," + Str(mouse_position\y) + "; World Pos=" + StrF((mouse_position\x - 400) * 0.171, 2) + "," + StrF((300 - mouse_position\y) * 0.171, 2) + Chr(10) +
              "Animation: Speed=" + StrF(animation_speed / 60.0) + " ms" + Chr(10) + 
              "Water Particle: Size=" + StrF(particle_size) + "; Blending=" + Str(particle_blending) + Chr(10) + 
              "Water Group: Starting Pos=" + Str(water_position_x) + "," + Str(water_position_y) + "; Strength=" + Str(water_strength) + "; Stride=" + Str(water_stride) + "; Radius=" + StrF(water_radius, 2) + Chr(10) + 
              "Bodies: Total=" + Str(particlecount) + Chr(10) + 
              "Frames: Per Sec=" + Str(fps) + " fps"

      SetGadgetText(5, msg)
      
;              "Camera: Pos=" + Str(camera_position\x) + "," + Str(camera_position\y) + "," + Str(camera_position\z) + Chr(10) + 
;              "OpenGL extensions = " + sgGlExtn + Chr(10) + 
;             "OpenGL vendor = " + sgGlVendor + Chr(10) + 
;              "OpenGL renderer = " + sgGlRender + Chr(10) + 
;             "Mouse change = " + Str(mouse_position\x - old_mouse_position\x) + ", " + Str(mouse_position\y - old_mouse_position\y) + Chr(10) + 

    EndIf
  Wend


EndProcedure

; #FUNCTION# ====================================================================================================================
; Name...........: b2DestroyScene
; Description ...: Destroy all objects in the current Box2D scene
; Syntax.........: b2DestroyScene()
; Parameters ....: destroy_fixtures - 1 (true) to destroy all fixtures, anything else to ignore
;                  destroy_bodies - 1 (true) to destroy all bodies, anything else to ignore
;                  destroy_particle_system - 1 (true) to destroy all particle system elements, anything else to ignore
; Return values .: None
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......: 
; Link ..........:
; Example .......:
; ===============================================================================================================================
Procedure b2DestroyScene(destroy_fixtures.i, destroy_bodies.i, destroy_particle_system.i)
  
  If destroy_fixtures = 1
    
    ; Destroy the Box2D Fixtures  
    b2Body_DestroyFixture(groundBody, groundBodyFixture\fixture_ptr)
    b2Body_DestroyFixture(body, bodyFixture\fixture_ptr)
    b2Body_DestroyFixture(bucketBody, bucketBodyFixture1\fixture_ptr)
    b2Body_DestroyFixture(bucketBody, bucketBodyFixture2\fixture_ptr)
    b2Body_DestroyFixture(bucketBody, bucketBodyFixture3\fixture_ptr)
    b2Body_DestroyFixture(bucketBody, bucketBodyFixture4\fixture_ptr)
    b2Body_DestroyFixture(bucketBody, bucketBodyFixture5\fixture_ptr)
    b2Body_DestroyFixture(bucketBody, bucketBodyFixture6\fixture_ptr)
    b2Body_DestroyFixture(bucketBody, bucketBodyFixture7\fixture_ptr)
    b2Body_DestroyFixture(bucketBody, bucketBodyFixture8\fixture_ptr)
    b2Body_DestroyFixture(bucketBody, bucketBodyFixture9\fixture_ptr)
    b2Body_DestroyFixture(bucketBody, bucketBodyFixture10\fixture_ptr)
    b2Body_DestroyFixture(bucketBody, bucketBodyFixture11\fixture_ptr)
    b2Body_DestroyFixture(bucketBallBody, bucketBallBodyFixture1\fixture_ptr)
    b2Body_DestroyFixture(bucketBallBody, bucketBallBodyFixture2\fixture_ptr)
    b2Body_DestroyFixture(bucketBallBody, bucketBallBodyFixture3\fixture_ptr)
    b2Body_DestroyFixture(bucketBallBody, bucketBallBodyFixture4\fixture_ptr)
    b2Body_DestroyFixture(bucketBallBody, bucketBallBodyFixture5\fixture_ptr)
    b2Body_DestroyFixture(bucketBallBody, bucketBallBodyFixture6\fixture_ptr)
    b2Body_DestroyFixture(bucketBallBody, bucketBallBodyFixture7\fixture_ptr)
    b2Body_DestroyFixture(bucketBallBody, bucketBallBodyFixture8\fixture_ptr)
  EndIf
  
  If destroy_bodies = 1
  
    ; Destroy the Box2D Bodies  
    b2World_DestroyBody(world, groundBody)
    b2World_DestroyBody(world, body)
    b2World_DestroyBody(world, bucketBody)
    b2World_DestroyBody(world, bucketBallBody)
  EndIf
  
  If destroy_particle_system = 1

    ; Destory the LiquidFun Particle System
    b2ParticleGroup_DestroyParticles(particlegroup, 0)
    b2World_DestroyParticleSystem(world, particlesystem)
  
    ; I read in the LiquidFun docs that the particle groups aren't destroyed until the next Step.  So Step below...
    b2World_Step(world, (1 / 60.0), 6, 2)
  EndIf
  
EndProcedure

; #FUNCTION# ====================================================================================================================
; Name...........: b2CreateScene
; Description ...: Destroy all objects in the current Box2D scene
; Syntax.........: b2CreateScene()
; Parameters ....: destroy_fixtures - 1 (true) to create all fixtures, anything else to ignore
;                  destroy_bodies - 1 (true) to create all bodies, anything else to ignore
;                  destroy_particle_system - 1 (true) to create all particle system elements, anything else to ignore
; Return values .: None
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......: 
; Link ..........:
; Example .......:
; ===============================================================================================================================
Procedure b2CreateScene(create_fixtures.i, create_bodies.i, create_particle_system.i)
  
  If create_bodies = 1

    ; Create the Box2D Bodies
    ; world, active, allowSleep, angle, angularVelocity, angularDamping, awake, bullet, fixedRotation, gravityScale, linearDamping, linearVelocityX, linearVelocityY, positionX, positionY, type, userData)
    groundBody = b2World_CreateBody(world, 1, 1, Radian(-5), 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, -10, 1, 0)
    body = b2World_CreateBody(world, 1, 1, Radian(5), 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 4, 2, 0)
    
    ; bucket
    bucketBody = b2World_CreateBody(world, 1, 1, Radian(0), 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, -7.5, 2, 0)
    bucketBallBody = b2World_CreateBody(world, 1, 1, Radian(0), 0, 0, 1, 0, 0, 1, 0, 0, 0, 2.5, -4, 1, 0)
  EndIf
  
  If create_fixtures = 1

    ; Create the Box2D Fixtures
    ; fixture_struct, body_ptr, density, friction, isSensor, restitution, v0_x, v0_y, v1_x, v1_y, v2_x, v2_y, v3_x, v3_y
    b2PolygonShape_Create4VertexFixture(groundBodyFixture, groundBody, 1, 0.1, 0, 0, 1, 0, 65535, 50, 10, -50, 10, -50, -10, 50, -10, 0, 0, @groundBody_texture)
    b2PolygonShape_CreateBoxFixture(groundBodySubFixture1, groundBody, 1, 0.1, 0, 0, 1, 0, 65535, 2, 4, -12, 12, @body_texture)
    b2PolygonShape_CreateBoxFixture(groundBodySubFixture2, groundBody, 1, 0.1, 0, 0, 1, 0, 65535, 2, 4, 12, 12, @body_texture)
    b2PolygonShape_Create4VertexFixture(bodyFixture, body, 0.1, 0.1, 0, 0.5, 1, 0, 65535, 1, 1, -1, 1, -1, -1, 1, -1, 0, 0, @body_texture)
    
    ; bucket
    b2PolygonShape_Create4VertexFixture(bucketBodyFixture1, bucketBody, 1, 0.1, 0, 0, 1, 0, 65535, -16.69, 40.47, -17.51, 39.90, -7.59, 25.87, -6.77, 26.45, 0, 0, @body_texture)
    b2PolygonShape_Create4VertexFixture(bucketBodyFixture2, bucketBody, 1, 0.1, 0, 0, 1, 0, 65535, -7.20, 26.66, -7.16, 25.66, -3.40, 25.83, -3.44, 26.83, 0, 0, @body_texture)
    b2PolygonShape_Create4VertexFixture(bucketBodyFixture3, bucketBody, 1, 0.1, 0, 0, 1, 0, 65535, -3.92, 26.33, -2.92, 26.33, -2.92, 29.93, -3.92, 29.93, 0, 0, @body_texture)
    b2PolygonShape_Create4VertexFixture(bucketBodyFixture4, bucketBody, 1, 0.1, 0, 0, 1, 0, 65535, -3.76, 30.29, -3.08, 29.56, -1.03, 31.44, -1.71, 32.17, 0, 0, @body_texture)
    b2PolygonShape_Create4VertexFixture(bucketBodyFixture5, bucketBody, 1, 0.1, 0, 0, 1, 0, 65535, -1.37, 32.31, -1.37, 31.31, 2.39, 31.31, 2.39, 32.31, 0, 0, @body_texture)
    b2PolygonShape_Create4VertexFixture(bucketBodyFixture6, bucketBody, 1, 0.1, 0, 0, 1, 0, 65535, 2.76, 32.14, 2.03, 31.47, 3.91, 29.42, 4.64, 30.09, 0, 0, @body_texture)
    b2PolygonShape_Create4VertexFixture(bucketBodyFixture7, bucketBody, 1, 0.1, 0, 0, 1, 0, 65535, 4.78, 29.75, 3.78, 29.75, 3.78, 26.85, 4.78, 26.85, 0, 0, @body_texture)
    b2PolygonShape_Create4VertexFixture(bucketBodyFixture8, bucketBody, 1, 0.1, 0, 0, 1, 0, 65535, 4.28, 27.35, 4.28, 26.35, 8.21, 26.35, 8.21, 27.35, 0, 0, @body_texture)
    b2PolygonShape_Create4VertexFixture(bucketBodyFixture9, bucketBody, 1, 0.1, 0, 0, 1, 0, 65535, 7.77, 27.09, 8.65, 26.61, 16.68, 41.31, 15.81, 41.79, 0, 0, @body_texture)
    b2PolygonShape_Create4VertexFixture(bucketBodyFixture10, bucketBody, 1, 0.1, 0, 0, 1, 0, 65535, 16.53, 41.97, 15.96, 41.14, 18.70, 39.26, 19.26, 40.08, 0, 0, @body_texture)
    b2PolygonShape_CreateBoxFixture(bucketBodyFixture11, bucketBody, 2, 0.1, 0, 0, 1, 0, 65535, 6, 6, 0, 22, @body_texture)
    
    b2PolygonShape_Create4VertexFixture(bucketBallBodyFixture1, bucketBallBody, 1, 0.1, 0, 0, 1, 0, 65535, -3.60, 25.48, -4.60, 25.48, -4.60, 23.77, -3.60, 23.77, 0, 0, @body_texture)
    b2PolygonShape_Create4VertexFixture(bucketBallBodyFixture2, bucketBallBody, 1, 0.1, 0, 0, 1, 0, 65535, -3.81, 24.18, -4.39, 23.36, -3.20, 22.51, -2.62, 23.32, 0, 0, @body_texture)
    b2PolygonShape_Create4VertexFixture(bucketBallBodyFixture3, bucketBallBody, 1, 0.1, 0, 0, 1, 0, 65535, -2.91, 23.41, -2.91, 22.41, -1.37, 22.41, -1.37, 23.41, 0, 0, @body_texture)
    b2PolygonShape_Create4VertexFixture(bucketBallBodyFixture4, bucketBallBody, 1, 0.1, 0, 0, 1, 0, 65535, -1.69, 23.29, -1.04, 22.53, 0.15, 23.56, -0.50, 24.32, 0, 0, @body_texture)
    b2PolygonShape_Create4VertexFixture(bucketBallBodyFixture5, bucketBallBody, 1, 0.1, 0, 0, 1, 0, 65535, -0.67, 23.94, 0.33, 23.94, 0.33, 25.65, -0.67, 25.65, 0, 0, @body_texture)
    b2PolygonShape_Create4VertexFixture(bucketBallBodyFixture6, bucketBallBody, 1, 0.1, 0, 0, 1, 0, 65535, -0.52, 25.30, 0.18, 26.00, -1.01, 27.20, -1.72, 26.49, 0, 0, @body_texture)
    b2PolygonShape_Create4VertexFixture(bucketBallBodyFixture7, bucketBallBody, 1, 0.1, 0, 0, 1, 0, 65535, -1.41, 26.35, -1.33, 27.35, -3.38, 27.52, -3.46, 26.52, 0, 0, @body_texture)
    b2PolygonShape_Create4VertexFixture(bucketBallBodyFixture8, bucketBallBody, 1, 0.1, 0, 0, 1, 0, 65535, -2.99, 26.77, -3.85, 27.27, -4.54, 26.07, -3.67, 25.57, 0, 0, @body_texture)
    
  EndIf
  
  If create_particle_system = 1
    
    ; Water (wave machine) parameters
    particle_flags.i = #b2_waterParticle
    particle_density = 1.8
    particle_powder_strength = 0.5
    particle_pressure_strength = 0.01
    particle_radius = 0.3
    particle_group_flags.i = #b2_solidParticleGroup
    particle_group_strength = 1.0
    particle_group_stride = 0.4
    particle_group_radius = 10.0
    
    ; Create the Particle System
    ; world, colorMixingStrength, dampingStrength, destroyByAge, ejectionStrength, elasticStrength, lifetimeGranularity, powderStrength, pressureStrength, radius, repulsiveStrength, springStrength, staticPressureIterations, staticPressureRelaxation, staticPressureStrength, surfaceTensionNormalStrength, surfaceTensionPressureStrength, viscousStrength
    particlesystem = b2World_CreateParticleSystem(world, 0.5, 0.2, 1, 0.5, 0.25, 0.016666666666666666, particle_powder_strength, particle_pressure_strength, particle_radius, 1, 0.25, 8, 0.2, 0.2, 0.2, 0.2, 0.25)
    b2ParticleSystem_SetDensity(particlesystem, particle_density)
    
    ; Create the Particle Group
    ; particleSystem, angle, angularVelocity, colorR, colorG, colorB, colorA, flags, group, groupFlags, lifetime, linearVelocityX, linearVelocityY, positionX, positionY, positionData, particleCount, strength, stride, userData, px, py,	radius
  ;  Debug(flags)
    particlegroup = b2CircleShape_CreateParticleGroup(particlesystem, 0, 0, 0, 0, 0, 0, particle_flags, 0, particle_group_flags, 0, 0, 0, particle_group_position_x, particle_group_position_y, 0, 0, particle_group_strength, particle_group_stride, 0, 0, 0, particle_group_radius)
    
    
    
    particlecount = b2ParticleSystem_GetParticleCount(particlesystem)
    particlepositionbuffer = b2ParticleSystem_GetPositionBuffer(particlesystem)
  
    ReDim particle_quad_vertice(Int(particlecount) * 4)
    ReDim particle_texture_vertice(Int(particlecount) * 4)
  EndIf
  
EndProcedure


; IDE Options = PureBasic 5.60 (Windows - x86)
; CursorPosition = 56
; FirstLine = 53
; Folding = -
; EnableXP
; Executable = OpenGL_LiquidFun_draw.exe
; SubSystem = OpenGL