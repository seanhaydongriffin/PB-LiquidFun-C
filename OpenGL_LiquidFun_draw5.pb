XIncludeFile "LiquidFun-C.pbi"
XIncludeFile "LiquidFun-C-Ex.pbi"
UsePNGImageDecoder()

; #GLOBALS# ===================================================================================================================

Global Dim tmp_pos.f(2)
Global num_frames.i = 0
Global fps.i = 0
Global animation_speed.f = 1.0
Global is_convex_and_clockwise.i

; Box2D Bodies
Global body_mass.d
Global body_user_applied_linear_force.d = 100
Global body_user_applied_angular_force.d = 10

; Box2D Fixtures
Global Dim tmp_fixture_vector.b2Vec2(50)
Global Dim tmp_quad.b2Vec2(2)
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
Global texture_drawing_mode.i = 0
Global fixture_drawing_mode.i = 0
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

  
; =======================
; Setup Box2D / LiquidFun
; =======================

; Setup the Box2D World (gravity_x, gravity_y, and load texture, body and fixture JSON files)
b2World_CreateEx(0.0, -10.0)

; Create the Box2D Bodies, Fixtures and the LiquidFun Particle System
b2CreateScene(1, 1, 1)

  
; ============
; Setup OpenGL
; ============

; Setup the OpenGL Windows (main_window_x, main_window_y, main_window_width, main_window_height, main_window_title, openglgadget_x, openglgadget_y, openglgadget_width, openglgadget_height, text_window_width, text_window_height, text_window_background_colour, text_window_text_colour, open_console_window)
glSetupWindows(0, 0, 800, 600, "LiquidFun Demo", 0, 0, 800, 600, 400, 500, $006600, #Black, 0)

; Setup the OpenGL World (field_of_view, aspect_ratio, viewer_to_near_clipping_plane_distance, viewer_to_far_clipping_plane_distance, camera_x, camera_y, camera_z)
;glSetupWorld(30.0, 200/200, 1.0, 1000.0, 0, 0, -190.0)
glSetupWorld(30.0, 800/600, 1.0, 1000.0, 0, 0, -190.0)

; Setup OpenGL Textures
; Remember! In Paint.NET save images as 32-bit PNG for the below to work
; Also for backward compatibility to OpenGL v1 we use images (textures) with dimensions in powers of 2
;   i.e. 2x2, 4x4, 16x16, 32x32, 64x64, 128x128, 256x256

b2World_CreateTextures()


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
    
            
    ; Draw the LiquidFun Particles (texture, particle_quad_size)
    glDrawParticlesTexture(texture_struct("water"), particle_size, particle_blending)

    ; Enable Texture Mapping
 ;   glEnable_(#GL_TEXTURE_2D)
 ;   glBindTexture_(#GL_TEXTURE_2D, TextureID)
    
    ; Draw the Box2D Bodies (body, fixture, texture)
    glDrawFixture(fixture_struct("ground main"), #b2_texture)
    glDrawFixture(fixture_struct("ground post 1"), #b2_texture)
    glDrawFixture(fixture_struct("ground post 2"), #b2_texture)
    glDrawFixture(fixture_struct("body"), #gl_line_loop2)
    glDrawFixture(fixture_struct("bucket main"), #gl_line_strip2)
    glDrawFixture(fixture_struct("bucket under box 1"), #b2_texture)
    glDrawFixture(fixture_struct("bucket under box 2"), #b2_texture)
    glDrawFixture(fixture_struct("bucket under box 3"), #b2_texture)
    glDrawFixture(fixture_struct("bucket ball"), #b2_texture)
    glDrawFixture(fixture_struct("boat"));, #gl_line_loop2)

    
    
        
    ; Draw the drawing line
    If texture_drawing_mode = 2 Or texture_drawing_mode = 3
      
   ;   Debug(@tmp_fixture_vector(0)\x)
      
  ;    is_convex_and_clockwise = _Box2C_b2Vec2Array_IsConvexAndClockwise(@tmp_fixture_vector(0)\x, tmp_fixture_vector_num + 1)
      
  ;    If is_convex_and_clockwise <> 1
        
   ;     Debug("aaa")
    ;  EndIf
  ;    Debug(Str(is_convex_and_clockwise) + " " + Str(__clockwise))
      
      drawing_red.f = 1.0
      drawing_green.f = 0.0
      drawing_blue.f = 0.0
      
   ;   If is_convex_and_clockwise = 1
        
   ;     drawing_red = 0.0
   ;     drawing_green = 1.0
   ;   EndIf
      
      glEnable_(#GL_TEXTURE_2D)

      glTexImage2D_(#GL_TEXTURE_2D, 0, #GL_RGBA, ImageWidth(texture_struct("speed boat")\image_number), ImageHeight(texture_struct("speed boat")\image_number), 0, #GL_BGRA_EXT, #GL_UNSIGNED_BYTE, texture_struct("speed boat")\image_bitmap\bmBits)
      
      ;50, 10, -50, 10, -50, -10, 50, -10
      Dim tmp_quad_vertice.Vec3f(4)
      Dim tmp_texture_vertice.b2Vec2(4)
  
      tmp_texture_vertice(0)\x = 0.0
      tmp_texture_vertice(0)\y = 1.0
      tmp_quad_vertice(0)\x = tmp_quad(0)\x
      tmp_quad_vertice(0)\y = tmp_quad(0)\y
      tmp_quad_vertice(0)\z = 0.5
      
      tmp_texture_vertice(1)\x = 0.0
      tmp_texture_vertice(1)\y = 0.0
      tmp_quad_vertice(1)\x = tmp_quad(0)\x
      tmp_quad_vertice(1)\y = tmp_quad(0)\y - (tmp_quad(1)\x - tmp_quad(0)\x)
      tmp_quad_vertice(1)\z = 0.5
      
      tmp_texture_vertice(2)\x = 1.0
      tmp_texture_vertice(2)\y = 0.0
      tmp_quad_vertice(2)\x = tmp_quad(1)\x
      tmp_quad_vertice(2)\y = tmp_quad(0)\y - (tmp_quad(1)\x - tmp_quad(0)\x)
      tmp_quad_vertice(2)\z = 0.5
      
      tmp_texture_vertice(3)\x = 1.0
      tmp_texture_vertice(3)\y = 1.0
      tmp_quad_vertice(3)\x = tmp_quad(1)\x
      tmp_quad_vertice(3)\y = tmp_quad(0)\y
      tmp_quad_vertice(3)\z = 0.5
      
      glEnableClientState_(#GL_VERTEX_ARRAY )
      glEnableClientState_ (#GL_TEXTURE_COORD_ARRAY_EXT); 
      glVertexPointer_( 3, #GL_FLOAT, SizeOf(Vec3f), @tmp_quad_vertice(0)\x )
      glTexCoordPointer_(2, #GL_FLOAT, SizeOf(b2Vec2), @tmp_texture_vertice(0)\x)
      glDrawArrays_( #GL_QUADS, 0, ArraySize(tmp_quad_vertice()) )
      glDisableClientState_( #GL_TEXTURE_COORD_ARRAY_EXT )
      glDisableClientState_( #GL_VERTEX_ARRAY )
        
    ; disable texture mapping
     glBindTexture_(#GL_TEXTURE_2D, 0)
     glDisable_( #GL_TEXTURE_2D );
    EndIf
    
    
    


    If fixture_drawing_mode = 1

      
      glLineWidth_(2.5)
      glColor3f_(1.0, 0.0, 0.0)
      
      
      If tmp_fixture_vector_num > 1
      
        glBegin_(#GL_POLYGON)
      Else
        
        glBegin_(#GL_LINE_STRIP)
      EndIf
      
     ; glBegin_(#GL_QUADS)

      For i = 0 To tmp_fixture_vector_num
      ;  Debug(i)
      
        glVertex3f_(tmp_fixture_vector(i)\x, tmp_fixture_vector(i)\y, 0.0)
;        glVertex3f_(tmp_quad(0)\x, tmp_quad(0)\y, 0.0)
;        glVertex3f_(tmp_quad(0)\x, tmp_quad(0)\y - (tmp_quad(1)\x - tmp_quad(0)\x), 0.0)
;        glVertex3f_(tmp_quad(1)\x, tmp_quad(0)\y - (tmp_quad(1)\x - tmp_quad(0)\x), 0.0)
;        glVertex3f_(tmp_quad(1)\x, tmp_quad(0)\y, 0.0)
      Next
      
      glEnd_()
    EndIf    
    
    
    
    
    
    

    ; Update the display
    SetGadgetAttribute(Gadget, #PB_OpenGL_FlipBuffers, #True)
    
    ; Apply Camera Movement
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
    
    b2Body_SetAngularVelocityPercent(body_ptr("ground"), 99)
    
    body_mass.d = b2Body_GetMass(body_ptr("body"))
    
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
          
          
        Case #PB_Shortcut_6
          
          If fixture_drawing_mode = 0
            
            fixture_drawing_mode = 1
            tmp_fixture_vector_num = 0
          
            tmp_fixture_vector(tmp_fixture_vector_num)\x = ((mouse_position\x - 400) * (0.17 - (camera_position\z / 1250))) - camera_position\x
            tmp_fixture_vector(tmp_fixture_vector_num)\y = ((300 - mouse_position\y) * (0.17 - (camera_position\z / 1250))) - camera_position\y
          EndIf
          
          tmp_fixture_vector_num = tmp_fixture_vector_num + 1


        Case #PB_Shortcut_T
          
          If texture_drawing_mode = 0

            texture_drawing_mode = 1
    ;        tmp_quad(0)\x = (mouse_position\x - 400) * 0.171
    ;        tmp_quad(0)\y = (300 - mouse_position\y) * 0.171
            
            tmp_quad(0)\x = ((mouse_position\x - 400) * (0.17 - (camera_position\z / 1250))) - camera_position\x
            tmp_quad(0)\y = ((300 - mouse_position\y) * (0.17 - (camera_position\z / 1250))) - camera_position\y

          EndIf
          
          If texture_drawing_mode = 3
            
            texture_drawing_mode = 0
          EndIf
          
          If texture_drawing_mode = 2
            
            texture_drawing_mode = 3
          EndIf

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
          
          b2Body_SetMassData(body_ptr("body"), body_mass - 1.0, 0, 0, 0)
          
        Case #PB_Shortcut_G
          
          b2Body_SetMassData(body_ptr("body"), body_mass + 1.0, 0, 0, 0)
          
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
      
      If texture_drawing_mode = 1
        
        texture_drawing_mode = 2
      EndIf
      
      If texture_drawing_mode = 2

 ;       tmp_quad(1)\x = (mouse_position\x - 400) * 0.171
 ;       tmp_quad(1)\y = (300 - mouse_position\y) * 0.171
        
        tmp_quad(1)\x = ((mouse_position\x - 400) * (0.17 - (camera_position\z / 1250))) - camera_position\x
        tmp_quad(1)\y = ((300 - mouse_position\y) * (0.17 - (camera_position\z / 1250))) - camera_position\y
      EndIf
      
      If fixture_drawing_mode = 1

        tmp_fixture_vector(tmp_fixture_vector_num)\x = ((mouse_position\x - 400) * (0.17 - (camera_position\z / 1250))) - camera_position\x
        tmp_fixture_vector(tmp_fixture_vector_num)\y = ((300 - mouse_position\y) * (0.17 - (camera_position\z / 1250))) - camera_position\y
        
        ; note below is radians
  ;      tmp_fixture_angle(tmp_fixture_vector_num) = ATan2(tmp_fixture_vector(tmp_fixture_vector_num - 1)\y - tmp_fixture_vector(tmp_fixture_vector_num)\y, tmp_fixture_vector(tmp_fixture_vector_num - 1)\x - tmp_fixture_vector(tmp_fixture_vector_num)\x)
      EndIf
      
   
    ; if the mouse is clicked then flag this for later on
    Case #PB_EventType_LeftButtonDown
      
      mouse_left_button_down = 1
      
    ; if the mouse is unclicked then flag this for later on
    Case #PB_EventType_LeftButtonUp
      
      mouse_left_button_down = 0
      
;       If texture_drawing_mode = 0
;         
;         tmp_fixture_vector_num = 0
;         tmp_fixture_vector(tmp_fixture_vector_num)\x = (mouse_position\x - 400) * 0.171
;         tmp_fixture_vector(tmp_fixture_vector_num)\y = (300 - mouse_position\y) * 0.171
;       EndIf
;       
      

      
    Case #PB_EventType_RightButtonUp
      
 ;     texture_drawing_mode = 0
      fixture_drawing_mode = 0
      tmp_fixture_vector_size = tmp_fixture_vector_num + 1
      
      ; move the fixture / shape to the centroid (center of rotation) of 0,0
      centroid.b2Vec2
      _Box2C_b2PolygonShape_MoveToZeroCentroid(@tmp_fixture_vector(0)\x, tmp_fixture_vector_size, @centroid\x)
      
      clipboard_str.s = "b2PolygonShape_CreateFixture(boatFixture, boatBody, 1, 0.1, 0, 0, 1, 0, 65535, #b2_sprite, " +  Chr(34) + "["
      
      For tmp_fixture_vector_num = 0 To (tmp_fixture_vector_size - 1)
        
        If tmp_fixture_vector_num > 0
          
          clipboard_str = clipboard_str + ", "
        EndIf
        
        clipboard_str = clipboard_str + StrF(tmp_fixture_vector(tmp_fixture_vector_num)\x, 2) + ", " + StrF(tmp_fixture_vector(tmp_fixture_vector_num)\y, 2)
      Next
      
      clipboard_str = clipboard_str + "]" +  Chr(34) + ", " + StrF(tmp_quad(1)\x - tmp_quad(0)\x, 2) + ", 2.5, 1.0, 0, 0, 0, 0, @speed_boat_texture)"
      
 ;     _Box2C_b2PolygonShape_ComputeCentroid(@tmp_fixture_vector(0)\x, tmp_fixture_vector_size, @centroid\x)
  ;    clipboard_str = clipboard_str + " --- " + StrF(centroid\x, 2) + ", " + StrF(centroid\y, 2)
      
        ;    is_convex_and_clockwise = _Box2C_b2Vec2Array_IsConvexAndClockwise(@tmp_fixture_vector(0)\x, tmp_fixture_vector_num + 1)

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
        
        b2Body_AddAngularVelocity(body_ptr("ground"), Radian(1))
      EndIf
      
      If GetAsyncKeyState_(#VK_X)
        
        b2Body_AddAngularVelocity(body_ptr("ground"), Radian(-1))
      EndIf

      ; body control (keyboard)

      If GetAsyncKeyState_(#VK_A)
        
        b2Body_GetPosition(body_ptr("body"), tmp_pos())
        b2Body_ApplyForce(body_ptr("body"), body_mass * -body_user_applied_linear_force, 0, tmp_pos(0), tmp_pos(1), 1)
      EndIf

      If GetAsyncKeyState_(#VK_D)
        
        b2Body_GetPosition(body_ptr("body"), tmp_pos())
        b2Body_ApplyForce(body_ptr("body"), body_mass * body_user_applied_linear_force, 0, tmp_pos(0), tmp_pos(1), 1)
      EndIf

      If GetAsyncKeyState_(#VK_W)
        
        b2Body_GetPosition(body_ptr("body"), tmp_pos())
        b2Body_ApplyForce(body_ptr("body"), 0, body_mass * body_user_applied_linear_force, tmp_pos(0), tmp_pos(1), 1)
      EndIf

      If GetAsyncKeyState_(#VK_S)
        
        b2Body_GetPosition(body_ptr("body"), tmp_pos())
        b2Body_ApplyForce(body_ptr("body"), 0, body_mass * -body_user_applied_linear_force, tmp_pos(0), tmp_pos(1), 1)
      EndIf

      If GetAsyncKeyState_(#VK_Q)
        
        b2Body_ApplyTorque(body_ptr("body"), body_mass * body_user_applied_angular_force, 1)
      EndIf

      If GetAsyncKeyState_(#VK_E)
        
        b2Body_ApplyTorque(body_ptr("body"), body_mass * -body_user_applied_angular_force, 1)
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
        
        camera_linearvelocity\x = camera_linearvelocity\x + ((mouse_position\x - old_mouse_position\x) * (0.0189 - (camera_position\z / 11100)))
        camera_linearvelocity\y = camera_linearvelocity\y - ((mouse_position\y - old_mouse_position\y) * (0.0189 - (camera_position\z / 11100)))
        
        old_mouse_position\x = mouse_position\x
        old_mouse_position\y = mouse_position\y
      Else
        
        old_mouse_position\x = -99999
        old_mouse_position\y = -99999
      EndIf
      
      
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
;    b2Body_DestroyFixture(groundBody, groundBodyFixture\fixture_ptr)
 ;   b2Body_DestroyFixture(groundBody, groundBodySubFixture1\fixture_ptr)
 ;   b2Body_DestroyFixture(groundBody, groundBodySubFixture2\fixture_ptr)
    b2Body_DestroyFixture(body_ptr("body"), fixture_struct("body")\fixture_ptr)
    b2Body_DestroyFixture(body_ptr("bucket"), fixture_struct("bucket main")\fixture_ptr)
    b2Body_DestroyFixture(body_ptr("bucket"), fixture_struct("bucket under box 1")\fixture_ptr)
    b2Body_DestroyFixture(body_ptr("bucket"), fixture_struct("bucket under box 2")\fixture_ptr)
    b2Body_DestroyFixture(body_ptr("bucket"), fixture_struct("bucket under box 3")\fixture_ptr)
    b2Body_DestroyFixture(body_ptr("bucket ball"), fixture_struct("bucket ball")\fixture_ptr)
    b2Body_DestroyFixture(body_ptr("boat"), fixture_struct("boat")\fixture_ptr)
  EndIf
  
  If destroy_bodies = 1
  
    ; Destroy the Box2D Bodies  
    b2World_DestroyBody(world, body_ptr("ground"))
    b2World_DestroyBody(world, body_ptr("body"))
    b2World_DestroyBody(world, body_ptr("bucket"))
    b2World_DestroyBody(world, body_ptr("bucket ball"))
    b2World_DestroyBody(world, body_ptr("boat"))
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
    b2World_CreateBodies()
  EndIf
  
  If create_fixtures = 1

    ; Create the Box2D Fixtures
    b2World_CreateFixtures()
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
; CursorPosition = 818
; FirstLine = 794
; Folding = -
; EnableXP
; Executable = OpenGL_LiquidFun_draw4.exe
; SubSystem = OpenGL