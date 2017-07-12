﻿
; #INDEX# =======================================================================================================================
; Title ............: LiquidFun-C-Ex
; PureBasic Version : ?
; Language .........: English
; Description ......: LiquidFun Functions in C
; Author(s) ........: Sean Griffin
; Libraries ........: LiquidFun-C.lib
; ===============================================================================================================================

XIncludeFile "LiquidFun-C.pbi"
XIncludeFile "CSFML.pbi"


; #CONSTANTS# ===================================================================================================================
#GL_VENDOR     = $1F00
#GL_RENDERER   = $1F01
#GL_VERSION    = $1F02
#GL_EXTENSIONS = $1F03
; ===============================================================================================================================

; #ENUMERATIONS# ===================================================================================================================
; ===============================================================================================================================


; #STRUCTURES# ===================================================================================================================



Structure Vec2i
  x.i
  y.i
EndStructure

Structure Vec3f
  x.f
  y.f
  z.f
EndStructure

Structure Colour3f
  r.f
  g.f
  b.f
EndStructure

Structure gl_Texture
  image_number.i  
  image_bitmap.BITMAP
EndStructure

Structure b2_4VertexFixture
  fixture_ptr.l
  vertex.b2Vec2[4]
  body_ptr.l
  texture_ptr.l
EndStructure


; A structure that combines Box2D Shapes and SFML Textures
;   The result is a texture with physical properties
;   created is a boolean indicating if the shape-texture has been created

Structure pb_LiquidFun_SFML_struct
  b2Body_ptr.l
  b2Fixture_ptr.l
  sfSprite_ptr.l
  sfTexture_ptr.l
EndStructure

; ===============================================================================================================================

; #GLOBALS# ===================================================================================================================
;Global sfBool.i
Global window.l

; Box2D Worlds
Global world.l
Global gravity.b2Vec2


; OpenGL
Global sgGlVersion.s, sgGlVendor.s, sgGlRender.s, sgGlExtn.s

; LiquidFun Particle System
Global particlesystem.l
Global particlecount.d
Global particlepositionbuffer.l

; OpenGL Particles
Global Dim particle_quad_vertice.Vec3f(0)
Global Dim particle_texture_vertice.b2Vec2(0)


; ===============================================================================================================================

; #VARIABLES# ===================================================================================================================
; ===============================================================================================================================

; #FUNCTIONS# ===================================================================================================================

Procedure b2PolygonShape_CreateFixture_4_sfSprite(*tmp_pb_LiquidFun_SFML.pb_LiquidFun_SFML_struct, body.l, texture.l, x0.d, y0.d, x1.d, y1.d, x2.d, y2.d, x3.d, y3.d, origin_x.d, origin_y.d)
  
  tmp_sfVector2f.sfVector2f
  
  *tmp_pb_LiquidFun_SFML\b2Body_ptr = body
  *tmp_pb_LiquidFun_SFML\b2Fixture_ptr = b2PolygonShape_CreateFixture_4(body, 0, 0, 0, 0, 0, 0, 0, 0, x0, y0, x1, y1, x2, y2, x3, y3)
  *tmp_pb_LiquidFun_SFML\sfSprite_ptr = _CSFML_sfSprite_create()
  _CSFML_sfSprite_setTexture(*tmp_pb_LiquidFun_SFML\sfSprite_ptr, texture, 1)
  tmp_sfVector2f\x = origin_x * 50
  tmp_sfVector2f\y = origin_y * 50
  _CSFML_sfSprite_setOrigin(*tmp_pb_LiquidFun_SFML\sfSprite_ptr, tmp_sfVector2f)
  *tmp_pb_LiquidFun_SFML\sfTexture_ptr = texture
  
EndProcedure


Procedure animate_body_sprite(tmp_body.l, tmp_sprite.l)
  
  Dim tmp_pos.f(2)
  tmp_angle.d
  tmp_sprite_pos.sfVector2f
    
  b2Body_GetPosition(tmp_body, tmp_pos())
  tmp_angle = b2Body_GetAngle(tmp_body)
  tmp_sprite_pos\x = 400 + (tmp_pos(0) * 50)
  tmp_sprite_pos\y = 300 - (tmp_pos(1) * 50)
  _CSFML_sfSprite_setPosition(tmp_sprite, tmp_sprite_pos)
  _CSFML_sfSprite_setRotation(tmp_sprite, -Degree(tmp_angle))
  _CSFML_sfRenderWindow_drawSprite(window, tmp_sprite, #Null)
  
EndProcedure

Procedure b2Body_SetAngle(tmp_body.l, tmp_angle.d)
  
  Dim tmp_pos.f(2)
    
  b2Body_GetPosition(tmp_body, tmp_pos())
  b2Body_SetTransform(tmp_body, tmp_pos(0), tmp_pos(1), tmp_angle)
EndProcedure


Procedure b2Body_AddAngle(tmp_body.l, add_angle.d)
  
  Dim tmp_pos.f(2)
  b2Body_GetPosition(tmp_body, tmp_pos())
  curr_angle.d = b2Body_GetAngle(tmp_body)
  b2Body_SetTransform(tmp_body, tmp_pos(0), tmp_pos(1), curr_angle + add_angle)
EndProcedure

Procedure b2Body_AddAngularVelocity(tmp_body.l, add_angle.d)
  
  velocity.d = b2Body_GetAngularVelocity(tmp_body)
  velocity = velocity + add_angle
  b2Body_SetAngularVelocity(tmp_body, velocity)
EndProcedure

Procedure b2Body_SetAngularVelocityPercent(tmp_body.l, percent.i)
  
  velocity.d = b2Body_GetAngularVelocity(tmp_body)
  velocity = velocity * (percent / 100)
  b2Body_SetAngularVelocity(tmp_body, velocity)
EndProcedure

Procedure b2World_CreateEx(gravity_x.f, gravity_y.f)
  
  gravity\x = gravity_x
  gravity\y = gravity_y
  world = b2World_Create(gravity\x, gravity\y)
EndProcedure

Procedure glCreateTexture(*tmp_gl_texture.gl_Texture, filename.s)
  
  *tmp_gl_texture\image_number = LoadImage(#PB_Any, filename)
  GetObject_(ImageID(*tmp_gl_texture\image_number), SizeOf(BITMAP), @*tmp_gl_texture\image_bitmap)
EndProcedure

;Procedure b2PolygonShape_Create4VertexFixture_GLQuad()
  
  
;EndProcedure

Procedure b2PolygonShape_Create4VertexFixture(*tmp_b2_fixture.b2_4VertexFixture, tmp_body.l, tmp_density.d, tmp_friction.d, tmp_isSensor.d,	tmp_restitution.d, tmp_categoryBits.d, tmp_groupIndex.d, tmp_maskBits.d, v0_x.d, v0_y.d, v1_x.d, v1_y.d, v2_x.d, v2_y.d, v3_x.d, v3_y.d, body_offset_x.d, body_offset_y.d, tmp_texture.l = -1)
  
  *tmp_b2_fixture\vertex[0]\x = v0_x + body_offset_x
  *tmp_b2_fixture\vertex[0]\y = v0_y + body_offset_y
  *tmp_b2_fixture\vertex[1]\x = v1_x + body_offset_x
  *tmp_b2_fixture\vertex[1]\y = v1_y + body_offset_y
  *tmp_b2_fixture\vertex[2]\x = v2_x + body_offset_x
  *tmp_b2_fixture\vertex[2]\y = v2_y + body_offset_y
  *tmp_b2_fixture\vertex[3]\x = v3_x + body_offset_x
  *tmp_b2_fixture\vertex[3]\y = v3_y + body_offset_y
  *tmp_b2_fixture\fixture_ptr = b2PolygonShape_CreateFixture_4(tmp_body, tmp_density, tmp_friction, tmp_isSensor, tmp_restitution, 0, tmp_categoryBits, tmp_groupIndex, tmp_maskBits, *tmp_b2_fixture\vertex[0]\x, *tmp_b2_fixture\vertex[0]\y, *tmp_b2_fixture\vertex[1]\x, *tmp_b2_fixture\vertex[1]\y, *tmp_b2_fixture\vertex[2]\x, *tmp_b2_fixture\vertex[2]\y, *tmp_b2_fixture\vertex[3]\x, *tmp_b2_fixture\vertex[3]\y)
  *tmp_b2_fixture\body_ptr = tmp_body
  
  If tmp_texture > -1
    
    *tmp_b2_fixture\texture_ptr = tmp_texture
  EndIf
  
EndProcedure

Procedure b2PolygonShape_CreateBoxFixture(*tmp_b2_fixture.b2_4VertexFixture, tmp_body.l, tmp_density.d, tmp_friction.d, tmp_isSensor.d,	tmp_restitution.d, tmp_categoryBits.d, tmp_groupIndex.d, tmp_maskBits.d, tmp_box_width.d, tmp_box_height.d, body_offset_x.d, body_offset_y.d, tmp_texture.l = -1)
  
  *tmp_b2_fixture\vertex[0]\x = 0 + (tmp_box_width / 2) + body_offset_x
  *tmp_b2_fixture\vertex[0]\y = 0 + (tmp_box_height / 2) + body_offset_y
  *tmp_b2_fixture\vertex[1]\x = 0 - (tmp_box_width / 2) + body_offset_x
  *tmp_b2_fixture\vertex[1]\y = 0 + (tmp_box_height / 2) + body_offset_y
  *tmp_b2_fixture\vertex[2]\x = 0 - (tmp_box_width / 2) + body_offset_x
  *tmp_b2_fixture\vertex[2]\y = 0 - (tmp_box_height / 2) + body_offset_y
  *tmp_b2_fixture\vertex[3]\x = 0 + (tmp_box_width / 2) + body_offset_x
  *tmp_b2_fixture\vertex[3]\y = 0 - (tmp_box_height / 2) + body_offset_y
  *tmp_b2_fixture\fixture_ptr = b2PolygonShape_CreateFixture_4(tmp_body, tmp_density, tmp_friction, tmp_isSensor, tmp_restitution, 0, tmp_categoryBits, tmp_groupIndex, tmp_maskBits, *tmp_b2_fixture\vertex[0]\x, *tmp_b2_fixture\vertex[0]\y, *tmp_b2_fixture\vertex[1]\x, *tmp_b2_fixture\vertex[1]\y, *tmp_b2_fixture\vertex[2]\x, *tmp_b2_fixture\vertex[2]\y, *tmp_b2_fixture\vertex[3]\x, *tmp_b2_fixture\vertex[3]\y)
  *tmp_b2_fixture\body_ptr = tmp_body
  
  If tmp_texture > -1
    
    *tmp_b2_fixture\texture_ptr = tmp_texture
  EndIf
  
EndProcedure



Procedure glDrawFixtureTexture(*tmp_fixture.b2_4VertexFixture, tmp_texture_ptr.l = -1)
  
    tmp_body.l = *tmp_fixture\body_ptr

    If tmp_texture_ptr > -1
      
      *tmp_texture.gl_Texture = tmp_texture_ptr
    Else
      
      *tmp_texture.gl_Texture = *tmp_fixture\texture_ptr
    EndIf
  
    glTexImage2D_(#GL_TEXTURE_2D, 0, #GL_RGBA, ImageWidth(*tmp_texture\image_number), ImageHeight(*tmp_texture\image_number), 0, #GL_BGRA_EXT, #GL_UNSIGNED_BYTE, *tmp_texture\image_bitmap\bmBits)
    Dim tmp_pos.f(2)
    b2Body_GetPosition(tmp_body, tmp_pos())
    tmp_angle.d = b2Body_GetAngle(tmp_body)
    
    glPushMatrix_()
    
    glTranslatef_(tmp_pos(0), tmp_pos(1), 0)
    glRotatef_ (Degree(tmp_angle), 0, 0, 1.0)
    
    
    Dim tmp_quad_vertice.Vec3f(4)
    Dim tmp_texture_vertice.b2Vec2(4)

    tmp_texture_vertice(0)\x = 1.0
    tmp_texture_vertice(0)\y = 1.0
    tmp_quad_vertice(0)\x = *tmp_fixture\vertex[0]\x
    tmp_quad_vertice(0)\y = *tmp_fixture\vertex[0]\y
    tmp_quad_vertice(0)\z = 0.5
    
    tmp_texture_vertice(1)\x = 0.0
    tmp_texture_vertice(1)\y = 1.0
    tmp_quad_vertice(1)\x = *tmp_fixture\vertex[1]\x
    tmp_quad_vertice(1)\y = *tmp_fixture\vertex[1]\y
    tmp_quad_vertice(1)\z = 0.5
    
    tmp_texture_vertice(2)\x = 0.0
    tmp_texture_vertice(2)\y = 0.0
    tmp_quad_vertice(2)\x = *tmp_fixture\vertex[2]\x
    tmp_quad_vertice(2)\y = *tmp_fixture\vertex[2]\y
    tmp_quad_vertice(2)\z = 0.5
    
    tmp_texture_vertice(3)\x = 1.0
    tmp_texture_vertice(3)\y = 0.0
    tmp_quad_vertice(3)\x = *tmp_fixture\vertex[3]\x
    tmp_quad_vertice(3)\y = *tmp_fixture\vertex[3]\y
    tmp_quad_vertice(3)\z = 0.5
    
    glEnableClientState_(#GL_VERTEX_ARRAY )
    glEnableClientState_ (#GL_TEXTURE_COORD_ARRAY_EXT); 
    glVertexPointer_( 3, #GL_FLOAT, SizeOf(Vec3f), @tmp_quad_vertice(0)\x )
    glTexCoordPointer_(2, #GL_FLOAT, SizeOf(b2Vec2), @tmp_texture_vertice(0)\x)
    glDrawArrays_( #GL_QUADS, 0, ArraySize(tmp_quad_vertice()) )
    glDisableClientState_( #GL_TEXTURE_COORD_ARRAY_EXT )
    glDisableClientState_( #GL_VERTEX_ARRAY )

    glPopMatrix_()
EndProcedure



Procedure glDrawBodyFixtureTexture(tmp_body.l, *tmp_fixture.b2_4VertexFixture, *tmp_texture.gl_Texture)
  
    glTexImage2D_(#GL_TEXTURE_2D, 0, #GL_RGBA, ImageWidth(*tmp_texture\image_number), ImageHeight(*tmp_texture\image_number), 0, #GL_BGRA_EXT, #GL_UNSIGNED_BYTE, *tmp_texture\image_bitmap\bmBits)
    Dim tmp_pos.f(2)
    b2Body_GetPosition(tmp_body, tmp_pos())
    tmp_angle.d = b2Body_GetAngle(tmp_body)
    
    glPushMatrix_()
    
    glTranslatef_(tmp_pos(0), tmp_pos(1), 0)
    glRotatef_ (Degree(tmp_angle), 0, 0, 1.0)
    
    
    Dim tmp_quad_vertice.Vec3f(4)
    Dim tmp_texture_vertice.b2Vec2(4)

    tmp_texture_vertice(0)\x = 1.0
    tmp_texture_vertice(0)\y = 1.0
    tmp_quad_vertice(0)\x = *tmp_fixture\vertex[0]\x
    tmp_quad_vertice(0)\y = *tmp_fixture\vertex[0]\y
    tmp_quad_vertice(0)\z = 0.5
    
    tmp_texture_vertice(1)\x = 0.0
    tmp_texture_vertice(1)\y = 1.0
    tmp_quad_vertice(1)\x = *tmp_fixture\vertex[1]\x
    tmp_quad_vertice(1)\y = *tmp_fixture\vertex[1]\y
    tmp_quad_vertice(1)\z = 0.5
    
    tmp_texture_vertice(2)\x = 0.0
    tmp_texture_vertice(2)\y = 0.0
    tmp_quad_vertice(2)\x = *tmp_fixture\vertex[2]\x
    tmp_quad_vertice(2)\y = *tmp_fixture\vertex[2]\y
    tmp_quad_vertice(2)\z = 0.5
    
    tmp_texture_vertice(3)\x = 1.0
    tmp_texture_vertice(3)\y = 0.0
    tmp_quad_vertice(3)\x = *tmp_fixture\vertex[3]\x
    tmp_quad_vertice(3)\y = *tmp_fixture\vertex[3]\y
    tmp_quad_vertice(3)\z = 0.5
    
    glEnableClientState_(#GL_VERTEX_ARRAY )
    glEnableClientState_ (#GL_TEXTURE_COORD_ARRAY_EXT); 
    glVertexPointer_( 3, #GL_FLOAT, SizeOf(Vec3f), @tmp_quad_vertice(0)\x )
    glTexCoordPointer_(2, #GL_FLOAT, SizeOf(b2Vec2), @tmp_texture_vertice(0)\x)
    glDrawArrays_( #GL_QUADS, 0, ArraySize(tmp_quad_vertice()) )
    glDisableClientState_( #GL_TEXTURE_COORD_ARRAY_EXT )
    glDisableClientState_( #GL_VERTEX_ARRAY )

    glPopMatrix_()
EndProcedure


Procedure glDrawParticlesTexture(*tmp_texture.gl_Texture, particle_quad_size.f, blending.i)
      
  *positionbuffer_ptr.b2Vec2 = particlepositionbuffer
 
  For i = 0 To (Int(particlecount) - 1)

    particle_texture_vertice((i * 4) + 0)\x = 1.0
    particle_texture_vertice((i * 4) + 0)\y = 1.0
    particle_quad_vertice((i * 4) + 0)\x = *positionbuffer_ptr\x + particle_quad_size
    particle_quad_vertice((i * 4) + 0)\y = *positionbuffer_ptr\y + particle_quad_size
    particle_quad_vertice((i * 4) + 0)\z = 0.5
    
    particle_texture_vertice((i * 4) + 1)\x = 0.0
    particle_texture_vertice((i * 4) + 1)\y = 1.0
    particle_quad_vertice((i * 4) + 1)\x = *positionbuffer_ptr\x - particle_quad_size
    particle_quad_vertice((i * 4) + 1)\y = *positionbuffer_ptr\y + particle_quad_size
    particle_quad_vertice((i * 4) + 1)\z = 0.5
    
    particle_texture_vertice((i * 4) + 2)\x = 0.0
    particle_texture_vertice((i * 4) + 2)\y = 0.0
    particle_quad_vertice((i * 4) + 2)\x = *positionbuffer_ptr\x - particle_quad_size
    particle_quad_vertice((i * 4) + 2)\y = *positionbuffer_ptr\y - particle_quad_size
    particle_quad_vertice((i * 4) + 2)\z = 0.5
    
    particle_texture_vertice((i * 4) + 3)\x = 1.0
    particle_texture_vertice((i * 4) + 3)\y = 0.0
    particle_quad_vertice((i * 4) + 3)\x = *positionbuffer_ptr\x + particle_quad_size
    particle_quad_vertice((i * 4) + 3)\y = *positionbuffer_ptr\y - particle_quad_size
    particle_quad_vertice((i * 4) + 3)\z = 0.5
           
    ; point to the next particle
    *positionbuffer_ptr + SizeOf(b2Vec2)
  Next
  
 ; glDisable_(#GL_LIGHTING)
  
  ; for the particle blending technique either use this line...
  ; glDisable_(#GL_DEPTH_TEST)
  ; or these two lines ...   
;   glEnable_(#GL_DEPTH_TEST)
;   glDepthMask_(#GL_FALSE) 
   
    glEnable_(#GL_TEXTURE_2D)
  
  If blending = 1
    glEnable_(#GL_BLEND)
    glBlendFunc_(#GL_SRC_ALPHA,#GL_ONE_MINUS_SRC_ALPHA)
;    glBlendFunc_(#GL_SRC_ALPHA,#GL_ONE)
  EndIf
 ; glBlendFunc_(#GL_ONE,#GL_ONE_MINUS_SRC_ALPHA)
 ;  glBlendFunc_(#GL_ONE_MINUS_SRC_ALPHA,#GL_ONE)
  
  glTexImage2D_(#GL_TEXTURE_2D, 0, #GL_RGBA, ImageWidth(*tmp_texture\image_number), ImageHeight(*tmp_texture\image_number), 0, #GL_BGRA_EXT, #GL_UNSIGNED_BYTE, *tmp_texture\image_bitmap\bmBits)
  
  glEnableClientState_(#GL_VERTEX_ARRAY )
  glEnableClientState_ (#GL_TEXTURE_COORD_ARRAY_EXT); 
  glVertexPointer_( 3, #GL_FLOAT, SizeOf(Vec3f), @particle_quad_vertice(0)\x )
  glTexCoordPointer_(2, #GL_FLOAT, SizeOf(b2Vec2), @particle_texture_vertice(0)\x)
  glDrawArrays_( #GL_QUADS, 0, ArraySize(particle_quad_vertice()) )
  glDisableClientState_( #GL_TEXTURE_COORD_ARRAY_EXT )
  glDisableClientState_( #GL_VERTEX_ARRAY )
   
   glDisable_( #GL_BLEND );
;   glEnable_( #GL_DEPTH_TEST );
    
    ; disable texture mapping
     glBindTexture_(#GL_TEXTURE_2D, 0)
     glDisable_( #GL_TEXTURE_2D );

EndProcedure
  

Procedure MyWindowCallback(WindowID,Message,wParam,lParam)
  Result=#PB_ProcessPureBasicEvents
  If Message=#WM_MOVE ; Main window is moving!
    GetWindowRect_(WindowID(0),win.RECT) ; Store its dimensions in "win" structure.
    SetWindowPos_(info_text_window,0,win\left+10,win\top+20,0,0,#SWP_NOSIZE|#SWP_NOACTIVATE) ; Dock other window.
  EndIf
  ProcedureReturn Result
EndProcedure


Procedure GLGetInfo()
  
    
  ; OpenGL Info
  
  sgGlVersion = StringField(PeekS(glGetString_(#GL_VERSION),-1,#PB_Ascii), 1, " ")
  sgGlExtn = StringField(PeekS(glGetString_(#GL_EXTENSIONS),-1,#PB_Ascii), 1, " ")
  sgGlVendor = StringField(PeekS(glGetString_(#GL_VENDOR),-1,#PB_Ascii), 1, " ")
  sgGlRender = StringField(PeekS(glGetString_(#GL_RENDERER),-1,#PB_Ascii), 1, " ")
  
  If(sgGlVersion = "") : sgGlVersion = "Not verified" : EndIf
  If(   sgGlExtn = "") :    sgGlExtn = "Not verified" : EndIf
  If( sgGlVendor = "") :  sgGlVendor = "Not verified" : EndIf
  If( sgGlRender = "") :  sgGlRender = "Not verified" : EndIf

EndProcedure



Procedure glSetupWindows(main_window_x.i, main_window_y.i, main_window_width.i, main_window_height.i, main_window_title.s, openglgadget_x.i, openglgadget_y.i, openglgadget_width.i, openglgadget_height.i, text_window_width.i, text_window_height.i, text_window_background_colour.i, text_window_text_colour.i, open_console_window.i)
    
  ; Setup the OpenGL Main Window
  OpenWindow(0, main_window_x, main_window_y, main_window_width, main_window_height, main_window_title, #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  OpenGLGadget(0, openglgadget_x, openglgadget_y, openglgadget_width, openglgadget_height, #PB_OpenGL_Keyboard|#PB_OpenGL_NoFlipSynchronization )
  
  ; Setup the OpenGL Info Window
  SetWindowCallback(@MyWindowCallback()) ; Set callback for this window.
  GetWindowRect_(WindowID(0),win.RECT)
  OpenWindow(1, win\left+10, win\top+20, text_window_width, text_window_height, "Follower", #PB_Window_BorderLess, WindowID(0))
  Global info_text_window.l = WindowID(1)
  SetWindowColor(1, text_window_background_colour)
  SetWindowLong_(WindowID(1), #GWL_EXSTYLE, #WS_EX_LAYERED | #WS_EX_TOPMOST)
  SetLayeredWindowAttributes_(WindowID(1), text_window_background_colour,0,#LWA_COLORKEY)
  TextGadget(5, 10,  10, text_window_width, text_window_height, "")
  SetGadgetColor(5, #PB_Gadget_BackColor, text_window_background_colour)
  SetGadgetColor(5, #PB_Gadget_FrontColor, text_window_text_colour)
  SetActiveWindow(0)
  SetActiveGadget(0)
  GLGetInfo()
  
  If open_console_window = 1
    
    OpenConsole()
  EndIf
  
EndProcedure


Procedure glSetupWorld(field_of_view.d, aspect_ratio.d, viewer_to_near_clipping_plane_distance.d, viewer_to_far_clipping_plane_distance.d, camera_x.f, camera_y.f, camera_z.f)
  
  glMatrixMode_(#GL_PROJECTION)
  gluPerspective_(field_of_view, aspect_ratio, viewer_to_near_clipping_plane_distance, viewer_to_far_clipping_plane_distance) 
  glMatrixMode_(#GL_MODELVIEW)
  glTranslatef_(camera_x, camera_y, camera_z)
  glEnable_(#GL_CULL_FACE)                                              ; Will enhance the rendering speed as all the back face will be culled
  glTexParameteri_(#GL_TEXTURE_2D, #GL_TEXTURE_MIN_FILTER, #GL_LINEAR)  ; For texture mapping
  glTexParameteri_(#GL_TEXTURE_2D, #GL_TEXTURE_MAG_FILTER, #GL_LINEAR)  ; For texture mapping
  glEnable_( #GL_ALPHA_TEST )                                           ; Makes alpha channel work for Paint.NET PNG files
  glAlphaFunc_( #GL_NOTEQUAL, 0.0 )                                     ; Makes alpha channel work for Paint.NET PNG files
EndProcedure




; ===============================================================================================================================

; IDE Options = PureBasic 5.60 (Windows - x86)
; CursorPosition = 403
; FirstLine = 375
; Folding = ---
; EnableXP
; EnableUnicode