XIncludeFile "LiquidFun-C.pbi"
XIncludeFile "LiquidFun-C-Ex.pbi"
UsePNGImageDecoder()

; #GLOBALS# ===================================================================================================================

Global num_frames.i = 0
Global fps.i = 0
Global animation_speed.f = 1.0
Global is_convex_and_clockwise.i
Global curr_particle_system_name.s = "water"
Global player_main_body_name.s = "boat"
Global player_spinning_body_name.s = "boat prop"
Global player_tracking.i = 0
Global player_tracking_angle.d = 0

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

; ===============================================================================================================================

; #VARIABLES# ===================================================================================================================
; ===============================================================================================================================

; #FUNCTIONS# ===================================================================================================================
Declare keyboard_mouse_handler(*Value)
Declare text_window_handler(*Value)
; ===============================================================================================================================

  
; =======================
; Setup Box2D / LiquidFun
; =======================

; Setup the Box2D World (gravity_x, gravity_y, and load texture, body and fixture JSON files)
b2World_CreateEx(0.0, -10.0)
;b2World_CreateEx(0.0, 0.0)

; Create the Box2D Bodies, Fixtures and the LiquidFun Particle System
b2World_CreateBodies()
b2World_CreateJoints()
b2World_CreateFixtures()
b2World_CreateParticleSystems()
b2World_CreateParticleGroups()
  
; ============
; Setup OpenGL
; ============

; Setup the OpenGL Windows (main_window_x, main_window_y, main_window_width, main_window_height, main_window_title, openglgadget_x, openglgadget_y, openglgadget_width, openglgadget_height, text_window_width, text_window_height, text_window_background_colour, text_window_text_colour, open_console_window)
glWindow_Setup(0, 0, 800, 600, "LiquidFun Demo", 0, 0, 800, 600, 400, 500, $006600, #Black, 0)

; Setup the OpenGL World (field_of_view, aspect_ratio, viewer_to_near_clipping_plane_distance, viewer_to_far_clipping_plane_distance, camera_x, camera_y, camera_z)
;glWorld_Setup(30.0, 200/200, 1.0, 1000.0, 0, 0, -190.0)
glWorld_Setup(30.0, 800/600, 1.0, 1000.0, 0, -10, -190.0)

; Setup OpenGL Textures
; Remember! In Paint.NET save images as 32-bit PNG for the below to work
; Also for backward compatibility to OpenGL v1 we use images (textures) with dimensions in powers of 2
;   i.e. 2x2, 4x4, 16x16, 32x32, 64x64, 128x128, 256x256
glWorld_CreateTextures()



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
    b2World_Step(world\ptr, (animation_speed / 60.0), 6, 2)
    

    ; Clear the OpenGLGadget
    glColor3f_(1.0, 1.0, 1.0)
;    glClearColor_(1, 1, 1, 1)
    glClearColor_(0.7, 0.7, 0.7, 1)
    glClear_ (#GL_COLOR_BUFFER_BIT | #GL_DEPTH_BUFFER_BIT)
    
            
    ; Draw the LiquidFun Particles (texture, particle_quad_size)
    glDraw_Particles()
    
    
    ; Draw the Box2D Bodies (body, fixture, texture)
    glDraw_Fixtures()

    
    
        
    ; Draw the drawing line
    If texture_drawing_mode = 2 Or texture_drawing_mode = 3
      
   ;   Debug(@tmp_fixture_vector(0)\x)
      
  ;    is_convex_and_clockwise = b2Vec2Array_IsConvexAndClockwise(@tmp_fixture_vector(0)\x, tmp_fixture_vector_num + 1)
      
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

      glTexImage2D_(#GL_TEXTURE_2D, 0, #GL_RGBA, ImageWidth(texture("speed boat")\image_number), ImageHeight(texture("speed boat")\image_number), 0, #GL_BGRA_EXT, #GL_UNSIGNED_BYTE, texture("speed boat")\image_bitmap\bmBits)
      
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
    
    If player_tracking = 0
      
      glTranslatef_(world\mainCameraDisplacementPositionX, world\mainCameraDisplacementPositionY, world\mainCameraDisplacementPositionZ)
    Else
      
      ; unrotate world first
;      glRotatef_(Degree(player_tracking_angle), 0, 0, 1)
      
      ; move the camera a vector that's equivalent to the velocity step of the player
      ; so the player always appears in the center of the window
      b2World_FollowBody(player_main_body_name)
      
      ; rotate the world back to where it was
;      glRotatef_(-Degree(player_tracking_angle), 0, 0, 1)
      
      ; rotate the camera
;      tmp_body_angle_offset.d = b2Body_GetAngularVelocity(body(player_main_body_name)\ptr)
;      tmp_body_angle_offset = tmp_body_angle_offset * 0.0167
;      glRotatef_(-Degree(tmp_body_angle_offset), 0, 0, 1)
;      player_tracking_angle = player_tracking_angle - tmp_body_angle_offset
    EndIf
    
    world\mainCameraPositionX = world\mainCameraPositionX - world\mainCameraDisplacementPositionX
    world\mainCameraPositionY = world\mainCameraPositionY - world\mainCameraDisplacementPositionY
    world\mainCameraDisplacementPositionX=0
    world\mainCameraDisplacementPositionY=0
    world\mainCameraDisplacementPositionZ=0
    
    b2Body_SetAngularVelocityPercent(body("ground")\ptr, 99)
    
    body_mass.d = b2Body_GetMass(body(player_main_body_name)\ptr)
    b2Body_GetLinearVelocityEx(player_main_body_name)
    
    num_frames = num_frames + 1
  EndIf
  
  key.i = 0
  Eventxx = WindowEvent()
  
  Select EventType()
      
    ; if a single key is released
    Case #PB_EventType_KeyUp
      
      key = GetGadgetAttribute(0,#PB_OpenGL_Key)
      
      ; For all menus
      Select key
        
        ; if Escape is pressed then toggle menus or quit demo
        Case #PB_Shortcut_Escape
          
          end_game = 1
          
        ; if 1 is pressed then display the main menu
        Case #PB_Shortcut_1
          
          menu_type = #main_menu
          
        ; if 2 is pressed then display the player menu
        Case #PB_Shortcut_2
          
          menu_type = #player_menu
          
        ; if 3 is pressed then display the player menu
        Case #PB_Shortcut_3
          
          menu_type = #particle_menu
          
        ; if R is pressed then reset the Box2D World
        Case #PB_Shortcut_R
          
          player_tracking = 0
          
          ; destroy the scene
          b2World_DestroyJoints()
          b2World_DestroyBodies()
          b2World_DestroyParticleGroups()
          b2World_DestroyParticleSystems()
  
          ; I read in the LiquidFun docs that the particle groups aren't destroyed until the next Step.  So Step below...
          b2World_Step(world\ptr, (1 / 60.0), 6, 2)

          
          
          body("boat")\positionX = -38
          body("boat")\positionY = 2
          body("boat")\angle = 0
          body("boat")\linearVelocityX = 0
          body("boat")\linearVelocityY = 0
          body("boat")\angularVelocity = 0
          body("boat prop")\positionX = body("boat")\positionX
          body("boat prop")\positionY = body("boat")\positionY
          body("boat prop")\angle = 0
          body("boat prop")\linearVelocityX = 0
          body("boat prop")\linearVelocityY = 0
          body("boat prop")\angularVelocity = 0
          body("car")\positionX = -38
          body("car")\positionY = 4
          body("car")\angle = 0
          body("car")\linearVelocityX = 0
          body("car")\linearVelocityY = 0
          body("car")\angularVelocity = 0
          body("wheel1")\positionX = body("car")\positionX - 2
          body("wheel1")\positionY = body("car")\positionY - 3
          body("wheel1")\angle = 0
          body("wheel1")\linearVelocityX = 0
          body("wheel1")\linearVelocityY = 0
          body("wheel1")\angularVelocity = 0
          body("wheel2")\positionX = body("car")\positionX + 2
          body("wheel2")\positionY = body("car")\positionY - 3
          body("wheel2")\angle = 0
          body("wheel2")\linearVelocityX = 0
          body("wheel2")\linearVelocityY = 0
          body("wheel2")\angularVelocity = 0
          
          
          b2World_CreateBodies()
          b2World_CreateJoints()
          b2World_CreateFixtures()
          b2World_CreateParticleSystems()
          b2World_CreateParticleGroups()
          
          
      EndSelect
      
      ; For specific menus            
      Select menu_type
          
        ; main menu
        Case #main_menu

          Select key
    
            Case #PB_Shortcut_B
              
              If body("bucket")\active = 0
              
                body("bucket")\active = 1
                b2World_CreateBodyEx("bucket")
                b2World_CreateFixtureEx("bucket main")
                b2World_CreateFixtureEx("bucket under box 1")
                b2World_CreateFixtureEx("bucket under box 2")
                b2World_CreateFixtureEx("bucket under box 3")
                body("bucket ball")\active = 1
                b2World_CreateBodyEx("bucket ball")
                b2World_CreateFixtureEx("bucket ball")
              Else
                
                b2World_DestroyBody(world\ptr, body("bucket")\ptr)
                body("bucket")\active = 0
                b2World_DestroyBody(world\ptr, body("bucket ball")\ptr)
                body("bucket ball")\active = 0
              EndIf

            Case #PB_Shortcut_T
              
              If texture_drawing_mode = 0
    
                texture_drawing_mode = 1
        ;        tmp_quad(0)\x = (world\mouseCurrentPositionX - 400) * 0.171
        ;        tmp_quad(0)\y = (300 - world\mouseCurrentPositionY) * 0.171
                
                tmp_quad(0)\x = ((world\mouseCurrentPositionX - 400) * (0.17 - (world\mainCameraPositionZ / 1250))) - world\mainCameraPositionX
                tmp_quad(0)\y = ((300 - world\mouseCurrentPositionY) * (0.17 - (world\mainCameraPositionZ / 1250))) - world\mainCameraPositionY
    
              EndIf
              
              If texture_drawing_mode = 3
                
                texture_drawing_mode = 0
              EndIf
              
              If texture_drawing_mode = 2
                
                texture_drawing_mode = 3
              EndIf
        
            Case #PB_Shortcut_6
              
              If fixture_drawing_mode = 0
                
                fixture_drawing_mode = 1
                tmp_fixture_vector_num = 0
              
                tmp_fixture_vector(tmp_fixture_vector_num)\x = ((world\mouseCurrentPositionX - 400) * (0.17 - (world\mainCameraPositionZ / 1250))) - world\mainCameraPositionX
                tmp_fixture_vector(tmp_fixture_vector_num)\y = ((300 - world\mouseCurrentPositionY) * (0.17 - (world\mainCameraPositionZ / 1250))) - world\mainCameraPositionY
              EndIf
              
              tmp_fixture_vector_num = tmp_fixture_vector_num + 1
  
          EndSelect
          
        ; player menu
        Case #player_menu

          Select key
              
            Case #PB_Shortcut_T
              
              If player_tracking = 0
                
                player_tracking = 1
                b2World_FollowBody(player_main_body_name, 1)
 ;             	tmp_angle.d = b2Body_GetAngle(body(player_main_body_name)\ptr)
 ;               glRotatef_(-Degree(tmp_angle), 0, 0, 1)
  ;              player_tracking_angle = tmp_angle
              Else
                
                player_tracking = 0
              EndIf

            Case #PB_Shortcut_X
              
              b2Body_GetPosition(body(player_main_body_name)\ptr, tmp_pos())
            	tmp_angle.d = b2Body_GetAngle (body(player_main_body_name)\ptr)
              b2Body_GetLinearVelocity(body(player_main_body_name)\ptr, tmp_vel())
              tmp_torque.d = b2Body_GetAngularVelocity (body(player_main_body_name)\ptr)

              Select player_main_body_name
                  
                Case "boat"
                  
                  b2World_DestroyJoint(world\ptr, joint("prop spring")\joint_ptr)
                  joint("prop spring")\active = 0
                  b2World_DestroyBody(world\ptr, body("boat")\ptr)
                  body("boat")\active = 0
                  b2World_DestroyBody(world\ptr, body("boat prop")\ptr)
                  body("boat prop")\active = 0
                  
                  body("car")\positionX = tmp_pos(0)
                  body("car")\positionY = tmp_pos(1) + 3
                  body("car")\angle = tmp_angle
                  body("car")\linearVelocityX = tmp_vel(0)
                  body("car")\linearVelocityY = tmp_vel(1)
                  body("car")\angularVelocity = tmp_torque
                  body("wheel1")\positionX = body("car")\positionX - 2
                  body("wheel1")\positionY = body("car")\positionY - 3
                  body("wheel2")\positionX = body("car")\positionX + 2
                  body("wheel2")\positionY = body("car")\positionY - 3
                  body("car")\active = 1
                  b2World_CreateBodyEx("car")
                  b2World_CreateFixtureEx("car")
                  body("wheel1")\active = 1
                  b2World_CreateBodyEx("wheel1")
                  b2World_CreateFixtureEx("wheel1")
                  body("wheel2")\active = 1
                  b2World_CreateBodyEx("wheel2")
                  b2World_CreateFixtureEx("wheel2")
                  joint("wheel1 spring")\active = 1
                  b2World_CreateJointEx("wheel1 spring")
                  joint("wheel2 spring")\active = 1
                  b2World_CreateJointEx("wheel2 spring")
                  
                  player_main_body_name = "car"
                  player_spinning_body_name = "wheel1"
                  
                Case "car"
                  
                  b2World_DestroyJoint(world\ptr, joint("wheel1 spring")\joint_ptr)
                  joint("wheel1 spring")\active = 0
                  b2World_DestroyJoint(world\ptr, joint("wheel2 spring")\joint_ptr)
                  joint("wheel2 spring")\active = 0
                  b2World_DestroyBody(world\ptr, body("car")\ptr)
                  body("car")\active = 0
                  b2World_DestroyBody(world\ptr, body("wheel1")\ptr)
                  body("wheel1")\active = 0
                  b2World_DestroyBody(world\ptr, body("wheel2")\ptr)
                  body("wheel2")\active = 0
                  
                  body("boat")\positionX = tmp_pos(0)
                  body("boat")\positionY = tmp_pos(1)
                  body("boat")\angle = tmp_angle
                  body("boat")\linearVelocityX = tmp_vel(0)
                  body("boat")\linearVelocityY = tmp_vel(1)
                  body("boat")\angularVelocity = tmp_torque
                  body("boat prop")\positionX = body("boat")\positionX
                  body("boat prop")\positionY = body("boat")\positionY
                  body("boat")\active = 1
                  b2World_CreateBodyEx("boat")
                  b2World_CreateFixtureEx("boat")
                  b2World_CreateFixtureEx("boat motor")
                  body("boat prop")\active = 1
                  b2World_CreateBodyEx("boat prop")
                  b2World_CreateFixtureEx("boat prop")
                  joint("prop spring")\active = 1
                  b2World_CreateJointEx("prop spring")

                  player_main_body_name = "boat"
                  player_spinning_body_name = "boat prop"

              EndSelect
              
              
              
          EndSelect
              
        ; particle menu
        Case #particle_menu

          Select key
  
            Case #PB_Shortcut_K
              
              b2World_DestroyParticleGroups()
              b2World_DestroyParticleSystems()
      
              ; I read in the LiquidFun docs that the particle groups aren't destroyed until the next Step.  So Step below...
;              b2World_Step(world\ptr, (1 / 60.0), 6, 2)
              
              b2World_CreateParticleSystems()
              b2World_CreateParticleGroups()
  
              
            Case #PB_Shortcut_Q
              
              particle_group(curr_particle_system_name)\radius = particle_group(curr_particle_system_name)\radius - 0.5
              
              ; Destroy the Particle Groups
              b2World_DestroyParticleGroups()
            
              ; I read in the LiquidFun docs that the particle groups aren't destroyed until the next Step.  So Step below...
              b2World_Step(world\ptr, (1 / 60.0), 6, 2)
              
              ; Create the Particle Groups
              b2World_CreateParticleGroups()
  
            Case #PB_Shortcut_E
              
              particle_group(curr_particle_system_name)\radius = particle_group(curr_particle_system_name)\radius + 0.5
              
              ; Destroy the Particle Groups
              b2World_DestroyParticleGroups()
            
              ; I read in the LiquidFun docs that the particle groups aren't destroyed until the next Step.  So Step below...
              b2World_Step(world\ptr, (1 / 60.0), 6, 2)
              
              ; Create the Particle Groups
              b2World_CreateParticleGroups()
              
            Case #PB_Shortcut_Y
              
              If particle_system(curr_particle_system_name)\particle_blending = 0
                
                particle_system(curr_particle_system_name)\particle_blending = 1
              Else
                
                particle_system(curr_particle_system_name)\particle_blending = 0
              EndIf
              
            Case #PB_Shortcut_U
              
              particle_system(curr_particle_system_name)\particle_size = particle_system(curr_particle_system_name)\particle_size - 0.05
              
              If particle_system(curr_particle_system_name)\particle_size < 0.05
                
                particle_system(curr_particle_system_name)\particle_size = 0.05
              EndIf
              
            Case #PB_Shortcut_I
              
              particle_system(curr_particle_system_name)\particle_size = particle_system(curr_particle_system_name)\particle_size + 0.05
              
            Case #PB_Shortcut_X
              
              b2ParticleGroup_DestroyParticles(particle_group(curr_particle_system_name)\particle_group_ptr, 0)
              b2World_DestroyParticleSystem(world\ptr, particle_system(curr_particle_system_name)\particle_system_ptr)
    
              ; I read in the LiquidFun docs that the particle groups aren't destroyed until the next Step.  So Step below...
              b2World_Step(world\ptr, (1 / 60.0), 6, 2)
  
              particle_group(curr_particle_system_name)\active = 0
              particle_system(curr_particle_system_name)\active = 0
  
              Select curr_particle_system_name
                  
                Case "water"
                  
                  curr_particle_system_name = "elastic"
                  
                Case "elastic"
                  
                  curr_particle_system_name = "spring"
                  
                Case "spring"
                  
                  curr_particle_system_name = "viscous"
                  
                Case "viscous"
                  
                  curr_particle_system_name = "powder"
                  
                Case "powder"
                  
                  curr_particle_system_name = "tensile"
                  
                Case "tensile"
                  
                  curr_particle_system_name = "barrier"
                  
                Case "barrier"
                  
                  curr_particle_system_name = "blank"
                  
                Case "blank"
                  
                  curr_particle_system_name = "water"
                  
              EndSelect
              
              particle_system(curr_particle_system_name)\active = 1
              particle_group(curr_particle_system_name)\active = 1
              b2World_CreateParticleSystemEx(curr_particle_system_name)
              b2World_CreateParticleGroupEx(curr_particle_system_name)
  
              
          EndSelect
        
      EndSelect
          
          

    ;  EndSelect
      
    ; if the mouse is moved then capture it's position for later on
    Case #PB_EventType_MouseMove
      
      previous_mouse_position_x.d = world\mouseCurrentPositionX
      previous_mouse_position_y.d = world\mouseCurrentPositionY
      world\mouseCurrentPositionX = GetGadgetAttribute(0, #PB_OpenGL_MouseX)
      world\mouseCurrentPositionY = GetGadgetAttribute(0, #PB_OpenGL_MouseY)
      world\mouseDisplacementPositionX = previous_mouse_position_x - world\mouseCurrentPositionX
      world\mouseDisplacementPositionY = previous_mouse_position_y - world\mouseCurrentPositionY
      
      If texture_drawing_mode = 1
        
        texture_drawing_mode = 2
      EndIf
      
      If texture_drawing_mode = 2

        tmp_quad(1)\x = ((world\mouseCurrentPositionX - 400) * (0.17 - (world\mainCameraPositionZ / 1250))) - world\mainCameraPositionX
        tmp_quad(1)\y = ((300 - world\mouseCurrentPositionY) * (0.17 - (world\mainCameraPositionZ / 1250))) - world\mainCameraPositionY
      EndIf
      
      If fixture_drawing_mode = 1

        tmp_fixture_vector(tmp_fixture_vector_num)\x = ((world\mouseCurrentPositionX - 400) * (0.17 - (world\mainCameraPositionZ / 1250))) - world\mainCameraPositionX
        tmp_fixture_vector(tmp_fixture_vector_num)\y = ((300 - world\mouseCurrentPositionY) * (0.17 - (world\mainCameraPositionZ / 1250))) - world\mainCameraPositionY
        
        ; note below is radians
  ;      tmp_fixture_angle(tmp_fixture_vector_num) = ATan2(tmp_fixture_vector(tmp_fixture_vector_num - 1)\y - tmp_fixture_vector(tmp_fixture_vector_num)\y, tmp_fixture_vector(tmp_fixture_vector_num - 1)\x - tmp_fixture_vector(tmp_fixture_vector_num)\x)
      EndIf
      
   
    ; if the mouse is clicked then flag this for later on
    Case #PB_EventType_LeftButtonDown
      
      world\mouseLeftButtonPressed = 1
      
    ; if the mouse is unclicked then flag this for later on
    Case #PB_EventType_LeftButtonUp
      
      world\mouseLeftButtonPressed = 0
      
;       If texture_drawing_mode = 0
;         
;         tmp_fixture_vector_num = 0
;         tmp_fixture_vector(tmp_fixture_vector_num)\x = (world\mouseCurrentPositionX - 400) * 0.171
;         tmp_fixture_vector(tmp_fixture_vector_num)\y = (300 - world\mouseCurrentPositionY) * 0.171
;       EndIf
;       
      

      
    Case #PB_EventType_RightButtonUp
      
 ;     texture_drawing_mode = 0
      fixture_drawing_mode = 0
      tmp_fixture_vector_size = tmp_fixture_vector_num + 1
      
      ; move the fixture / shape to the centroid (center of rotation) of 0,0
      centroid.b2Vec2
      b2PolygonShape_MoveToZeroCentroid(@tmp_fixture_vector(0)\x, tmp_fixture_vector_size, @centroid\x)
      
      clipboard_str.s = "\" + Chr(34) + "["
      
      For tmp_fixture_vector_num = 0 To (tmp_fixture_vector_size - 1)
        
        If tmp_fixture_vector_num > 0
          
          clipboard_str = clipboard_str + ", "
        EndIf
        
        clipboard_str = clipboard_str + StrF(tmp_fixture_vector(tmp_fixture_vector_num)\x, 2) + ", " + StrF(tmp_fixture_vector(tmp_fixture_vector_num)\y, 2)
      Next
      
      clipboard_str = clipboard_str + "]\" +  Chr(34) + ", " + StrF(tmp_quad(1)\x - tmp_quad(0)\x, 2)
      
 ;     b2PolygonShape_ComputeCentroid(@tmp_fixture_vector(0)\x, tmp_fixture_vector_size, @centroid\x)
  ;    clipboard_str = clipboard_str + " --- " + StrF(centroid\x, 2) + ", " + StrF(centroid\y, 2)
      
        ;    is_convex_and_clockwise = b2Vec2Array_IsConvexAndClockwise(@tmp_fixture_vector(0)\x, tmp_fixture_vector_num + 1)

      SetClipboardText(clipboard_str)

   ;   draw_world_end_position\x = 999999
   ;   draw_world_end_position\y = 999999
      tmp_fixture_vector_num = -1
      
      
    ; if the mouse wheel is moved then capture it's position for later on
    Case #PB_EventType_MouseWheel
      
      world\mouseWheelPosition = GetGadgetAttribute(0, #PB_OpenGL_WheelDelta)
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
      
      Select menu_type
          
        ; main menu (keyboard)
        Case #main_menu
          
          If GetAsyncKeyState_(#VK_Q)
            
            b2Body_AddAngularVelocity(body("ground")\ptr, Radian(1))
          EndIf
          
          If GetAsyncKeyState_(#VK_E)
            
            b2Body_AddAngularVelocity(body("ground")\ptr, Radian(-1))
          EndIf
          
        ; player menu (keyboard)
        Case #player_menu
    
          If GetAsyncKeyState_(#VK_A)
            
            b2Body_GetPosition(body(player_main_body_name)\ptr, tmp_pos())
            b2Body_ApplyForce(body(player_main_body_name)\ptr, body_mass * -body_user_applied_linear_force, 0, tmp_pos(0), tmp_pos(1), 1)
          EndIf
    
          If GetAsyncKeyState_(#VK_D)
    
            b2Body_GetPosition(body(player_main_body_name)\ptr, tmp_pos())
            b2Body_ApplyForce(body(player_main_body_name)\ptr, body_mass * body_user_applied_linear_force, 0, tmp_pos(0), tmp_pos(1), 1)
          EndIf

          If GetAsyncKeyState_(#VK_W)
            
            b2Body_GetPosition(body(player_main_body_name)\ptr, tmp_pos())
            b2Body_ApplyForce(body(player_main_body_name)\ptr, 0, body_mass * body_user_applied_linear_force, tmp_pos(0), tmp_pos(1), 1)
          EndIf
    
          If GetAsyncKeyState_(#VK_S)
            
            b2Body_GetPosition(body(player_main_body_name)\ptr, tmp_pos())
            b2Body_ApplyForce(body(player_main_body_name)\ptr, 0, body_mass * -body_user_applied_linear_force, tmp_pos(0), tmp_pos(1), 1)
          EndIf
    
          If GetAsyncKeyState_(#VK_Q)
            
            If player_main_body_name = "car"
              
              player_spinning_body_name = "wheel1"
            EndIf
            
            tmp_velocity.d = b2Body_GetAngularVelocity(body(player_spinning_body_name)\ptr)
            
            If tmp_velocity < 30
              
              tmp_velocity = tmp_velocity + Radian(300)
            EndIf
            
            b2Body_SetAngularVelocity(body(player_spinning_body_name)\ptr, tmp_velocity)
          EndIf
    
          If GetAsyncKeyState_(#VK_E)
            
            If player_main_body_name = "car"
              
              player_spinning_body_name = "wheel2"
            EndIf
                    
            tmp_velocity.d = b2Body_GetAngularVelocity(body(player_spinning_body_name)\ptr)
            
            If tmp_velocity > -30
    
              tmp_velocity = tmp_velocity - Radian(300)
            EndIf
            
            b2Body_SetAngularVelocity(body(player_spinning_body_name)\ptr, tmp_velocity)
          EndIf
          
          If GetAsyncKeyState_(#VK_F)

            b2Body_SetMassData(body(player_main_body_name)\ptr, body_mass - 1.0, 0, 0, 0)
          EndIf
          
          If GetAsyncKeyState_(#VK_G)
          
            b2Body_SetMassData(body(player_main_body_name)\ptr, body_mass + 1.0, 0, 0, 0)
          EndIf

          
          
      EndSelect
      
      ; camera control (mouse)
            
            
      If world\mouseWheelPosition > 0  
        
        world\mouseWheelPosition = 0
        world\mainCameraDisplacementPositionZ = world\mainCameraDisplacementPositionZ + 10
        world\mainCameraPositionZ = world\mainCameraPositionZ - 10
      EndIf
            
      If world\mouseWheelPosition < 0  
              
        world\mouseWheelPosition = 0
        world\mainCameraDisplacementPositionZ = world\mainCameraDisplacementPositionZ - 10
        world\mainCameraPositionZ = world\mainCameraPositionZ + 10
      EndIf
      
      If player_tracking = 0

        If world\mouseLeftButtonPressed = 1
          
          If world\mousePreviousPositionX = -99999
            
            world\mousePreviousPositionX = world\mouseCurrentPositionX
          EndIf
          
          If world\mousePreviousPositionY = -99999
            
            world\mousePreviousPositionY = world\mouseCurrentPositionY
          EndIf
          
          world\mainCameraDisplacementPositionX = world\mainCameraDisplacementPositionX + ((world\mouseCurrentPositionX - world\mousePreviousPositionX) * (world\mainCameraPositionZ / 1125))
          world\mainCameraDisplacementPositionY = world\mainCameraDisplacementPositionY - ((world\mouseCurrentPositionY - world\mousePreviousPositionY) * (world\mainCameraPositionZ / 1125))
          
 ;         world\mainCameraDisplacementPositionX = world\mainCameraDisplacementPositionX + (world\mouseDisplacementPositionX * (world\mainCameraPositionZ / 1125))
 ;         world\mainCameraDisplacementPositionY = world\mainCameraDisplacementPositionY - (world\mouseDisplacementPositionY * (world\mainCameraPositionZ / 1125))
          
          
          world\mousePreviousPositionX = world\mouseCurrentPositionX
          world\mousePreviousPositionY = world\mouseCurrentPositionY
        Else
          
          world\mousePreviousPositionX = -99999
          world\mousePreviousPositionY = -99999
        EndIf
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
      
      opengl_info.s = "OpenGL: Ver=" + sgGlVersion
      camera_info.s = "Camera: Pos=" + StrF(world\mainCameraPositionX, 2) + " m x " + StrF(world\mainCameraPositionY, 2) + " m x " + StrF(world\mainCameraPositionZ, 2) + " m"
      mouse_info.s = "Mouse: Gadget Pos=" + StrF(world\mouseCurrentPositionX, 2) + " p x " + StrF(world\mouseCurrentPositionY, 2) + " p; World Pos=" + StrF(world\mainCameraPositionX + ((400 - world\mouseCurrentPositionX) * (world\mainCameraPositionZ / 1125)), 2) + " m x " + StrF(world\mainCameraPositionY + 1.1 + ((300 - world\mouseCurrentPositionY) * (world\mainCameraPositionZ / 1125)), 2) + " m"
      animation_info.s = "Animation: Rate=" + Str(fps) + " fps"

      
      Select menu_type
          
        Case #main_menu
          
          msg.s = "Main Menu" + Chr(10) +
                  "------------------" + Chr(10) +
                  "Keys & Mouse" + Chr(10) +
                  "-----------------------" + Chr(10) +
                  "Esc: Quits this demo" + Chr(10) +
                  "2: Player menu" + Chr(10) +
                  "3: Particle menu" + Chr(10) +
                  "R: Restarts the scene" + Chr(10) +
                  "Left Mouse Button & Drag: Pans the camera" + Chr(10) +
                  "Mouse Wheel: Zooms the camera in & out" + Chr(10) +
                  "Q, E: Adds torque to the platform" + Chr(10) +
                  "B: Toggles the Bucket" + Chr(10) +
                  "T: Toggles sprite image drawing (experimental)" + Chr(10) +
                  "6: Toggles CCW convex polygon shape drawing (experimental)" + Chr(10) +
                  "-------" + Chr(10) +
                  "Info" + Chr(10) +
                  "-------" + Chr(10) +
                  opengl_info + Chr(10) + 
                  camera_info + Chr(10) + 
                  mouse_info + Chr(10) +
                  animation_info
          
        Case #player_menu
          
          msg.s = "Player Menu" + Chr(10) +
                  "------------------" + Chr(10) +
                  "Keys & Mouse" + Chr(10) +
                  "-----------------------" + Chr(10) +
                  "Esc: Quits this demo" + Chr(10) +
                  "1: Main menu" + Chr(10) +
                  "3: Particle menu" + Chr(10) +
                  "R: Restarts the scene" + Chr(10) +
                  "Left Mouse Button & Drag: Pans the camera" + Chr(10) +
                  "Mouse Wheel: Zooms the camera in & out" + Chr(10) +
                  "Q, E: Adds torque to the motor of the player" + Chr(10) +
                  "A, D, S, W: Adds Linear Force to the player" + Chr(10) +
                  "F, G: Changes the Mass of the player" + Chr(10) +
                  "T: Toggles the Tracking of the player" + Chr(10) +
                  "X: Changes the Vehicle of the player" + Chr(10) +
                  "-------" + Chr(10) +
                  "Info" + Chr(10) +
                  "-------" + Chr(10) +
                  opengl_info + Chr(10) + 
                  camera_info + Chr(10) + 
                  mouse_info + Chr(10) +
                  "Player: Mass=" + StrF(body_mass, 2) + " kg; Linear Velocity=" + StrF(b2Vec2_LinearVelocity(body(player_main_body_name)\currentLinearVelocityX, body(player_main_body_name)\currentLinearVelocityY), 2) + " m/s; Angular Velocity=" +StrF(b2Body_GetAngularVelocity(body(player_main_body_name)\ptr), 2) + " m/s" + Chr(10) + 
                  animation_info

        Case #particle_menu
          
          msg.s = "Particle Menu" + Chr(10) +
                  "------------------" + Chr(10) +
                  "Keys & Mouse" + Chr(10) +
                  "-----------------------" + Chr(10) +
                  "Esc: Quits this demo" + Chr(10) +
                  "1: Main menu" + Chr(10) +
                  "2: Player menu" + Chr(10) +
                  "R: Restarts the scene" + Chr(10) +
                  "Left Mouse Button & Drag: Pans the camera" + Chr(10) +
                  "Mouse Wheel: Zooms the camera in & out" + Chr(10) +
                  "Q, E: Changes the starting radius of the water group" + Chr(10) +
                  "Y: Toggles water particle texture blending" + Chr(10) +
                  "U, I: Changes the water particle size" + Chr(10) +
                  "X: Changes the particle system name / type" + Chr(10) +
                  "K: Restarts the water group" + Chr(10) +
                  "-------" + Chr(10) +
                  "Info" + Chr(10) +
                  "-------" + Chr(10) +
                  opengl_info + Chr(10) + 
                  camera_info + Chr(10) + 
                  mouse_info + Chr(10) +
                  "Particle System: Name=" + curr_particle_system_name + "; Number of Particles=" + Str(particle_system(curr_particle_system_name)\particle_count) + Chr(10) + 
                  "Particle Group: Starting Pos=" + Str(water_position_x) + "," + Str(water_position_y) + "; Strength=" + Str(water_strength) + "; Stride=" + Str(water_stride) + "; Radius=" + StrF(particle_group(curr_particle_system_name)\radius, 2) + Chr(10) + 
                  "Particle: Size=" + StrF(particle_system(curr_particle_system_name)\particle_size, 2) + "; Blending=" + Str(particle_system(curr_particle_system_name)\particle_blending) + Chr(10) + 
                  animation_info
          
      EndSelect

      SetGadgetText(5, msg)
      


;              "Draw: Pos=" + StrF(draw_world_start_position\x, 2) + "," + StrF(draw_world_start_position\y, 2) + "; Length=" + StrF(b2Vec2_Distance(draw_world_start_position\x, draw_world_start_position\y, draw_world_end_position\x, draw_world_end_position\y), 2) + "; Angle=" + StrF(Degree(draw_world_angle), 2) + Chr(10) +
;                        "O, P: Adjusts the Animation Speed (helps with low fps)" + Chr(10)

;              "Water Particle: Size=" + StrF(particle_system_struct("water")\particle_size) + "; Blending=" + Str(particle_system_struct("water")\particle_blending) + Chr(10) + 
;              "Bodies: Total=" + Str(particle_system_struct("water")\particle_count) + Chr(10) + 
      
      
;              "OpenGL extensions = " + sgGlExtn + Chr(10) + 
;             "OpenGL vendor = " + sgGlVendor + Chr(10) + 
;              "OpenGL renderer = " + sgGlRender + Chr(10) + 
;             "Mouse change = " + Str(world\mouseCurrentPositionX - world\mousePreviousPositionX) + ", " + Str(world\mouseCurrentPositionY - world\mousePreviousPositionY) + Chr(10) + 

    EndIf
  Wend


EndProcedure


; IDE Options = PureBasic 5.60 (Windows - x86)
; CursorPosition = 1001
; FirstLine = 997
; Folding = -
; EnableXP
; Executable = OpenGL_LiquidFun_draw6.exe
; SubSystem = OpenGL