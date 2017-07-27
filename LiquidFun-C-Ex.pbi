
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


Enumeration b2DrawType
    #b2_texture
    #b2_wireframe
EndEnumeration

Enumeration glMode
    #gl_texture2
    #gl_texture2_and_line_loop2
    #gl_line_strip2
    #gl_line_loop2
EndEnumeration

Enumeration MenuType
    #main_menu
    #player_menu
    #particle_menu
EndEnumeration

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
  file_name.s
  image_number.i  
  image_bitmap.BITMAP
EndStructure
    
Structure b2_Body
  body_ptr.l
  active.d
  allowSleep.d
  angle.d
  angularVelocity.d
  angularDamping.d
  awake.d
  bullet.d
  fixedRotation.d
  gravityScale.d
  linearDamping.d
  linearVelocityX.d
  linearVelocityY.d
  positionX.d
  positionY.d
  type.d
  userData.d
EndStructure
    
Structure b2_Fixture
  fixture_ptr.l
  body_ptr.l
  body_name.s
  density.d
  friction.d
  isSensor.d
  restitution.d
  categoryBits.d
  groupIndex.d
  maskBits.d
  radius.f
  shape_type_str.s
  shape_type.i
  vertices_str.s
  vertex.b2Vec2[128]
  num_vertices.i
  sprite_size.f
  sprite_offset_x.d
  sprite_offset_y.d
  sprite_vertex.b2Vec2[4]
  body_offset_x.d
  body_offset_y.d
  draw_type_str.s
  draw_type.i
  line_width.f
  line_red.f
  line_green.f
  line_blue.f
  texture_name.s
  texture_ptr.l
EndStructure





Structure b2_ParticleSystem
  particle_system_ptr.l
  active.i
  colorMixingStrength.d
  dampingStrength.d
  destroyByAge.d
  ejectionStrength.d
  elasticStrength.d
  lifetimeGranularity.d
  powderStrength.d
  pressureStrength.d
  particleRadius.d
  repulsiveStrength.d
  springStrength.d
  staticPressureIterations.d
  staticPressureRelaxation.d
  staticPressureStrength.d
  surfaceTensionNormalStrength.d
  surfaceTensionPressureStrength.d
  viscousStrength.d
  particleDensity.d
  texture_name.s
  particle_size.d
  particle_blending.i
  particle_count.d
  particle_position_buffer.l
  particle_quad_vertice.Vec3f[20000 * 4]
  particle_texture_vertice.b2Vec2[20000 * 4]
EndStructure



Structure b2_ParticleGroup
  particle_group_ptr.l
  system_name.s
  active.i
  angle.d
  angularVelocity.d
  colorR.d
  colorG.d
  colorB.d
  colorA.d
  flags.s
  group.d
  groupFlags.s
  lifetime.d
  linearVelocityX.d
  linearVelocityY.d
  positionX.d
  positionY.d
  positionData.d
  particleCount.d
  strength.d
  stride.d
  userData.d
  px.d
  py.d
  radius.d
EndStructure




Structure b2_Joint
  joint_ptr.l
  active.i
  body_a_name.s
  body_b_name.s
  joint_type.s
  collideConnected.d
  dampingRatio.d
  enableLimit.d
  enableMotor.d
  lowerAngle.d
  frequencyHz.d
  localAnchorAx.d
  localAnchorAy.d
  localAnchorBx.d
  localAnchorBy.d
  localAxisAx.d
  localAxisAy.d
  maxMotorTorque.d
  lowerTranslation.d
  maxMotorForce.d
  motorSpeed.d
  referenceAngle.d
  upperAngle.d
  upperTranslation.d
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
Global __clockwise.i

; Box2D Worlds
Global world.l
Global gravity.b2Vec2

; Box2D Bodies
Global NewMap body_json.s()
Global NewMap body.b2_Body()

; Box2D Fixtures
Global NewMap fixture_json.s()
Global NewMap fixture.b2_Fixture()

; Box2D Joints
Global NewMap joint_json.s()
Global NewMap joint.b2_Joint()

; Box2D Textures
Global NewMap texture_json.s()
Global NewMap texture.gl_Texture()

Global tmp_joint.l

; LiquidFun Particle Systems
Global NewMap particle_system_json.s()
Global NewMap particle_system.b2_ParticleSystem()

; LiquidFun Particle Groups
Global NewMap particle_group_json.s()
Global NewMap particle_group.b2_ParticleGroup()

; OpenGL
Global sgGlVersion.s, sgGlVendor.s, sgGlRender.s, sgGlExtn.s

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
Global info_text_window.l
Global menu_type.i = #main_menu
Global last_particle_system_name.s
Global last_particle_group_name.s

; ===============================================================================================================================

; #VARIABLES# ===================================================================================================================
; ===============================================================================================================================


; #MISCELLANEOOUS FUNCTIONS# ============================================================================================================


Procedure MyWindowCallback(WindowID,Message,wParam,lParam)
  
  Result=#PB_ProcessPureBasicEvents
  
  If Message=#WM_MOVE ; Main window is moving!
    
    GetWindowRect_(WindowID(0),win.RECT) ; Store its dimensions in "win" structure.
    SetWindowPos_(info_text_window,0,win\left+10,win\top+20,0,0,#SWP_NOSIZE|#SWP_NOACTIVATE) ; Dock other window.
  EndIf
  
  ProcedureReturn Result
EndProcedure


Procedure animate_body_sfSprite(tmp_body.l, tmp_sprite.l)
  
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


; #GLTEXTURE FUNCTIONS# ============================================================================================================





; #FUNCTION# ====================================================================================================================
; Name...........: glTexture_Create
; Description ...: Creates an OpenGL texture
; Syntax.........: glTexture_Create(*tmp_gl_texture.gl_Texture, filename.s)
; Parameters ....: *tmp_gl_texture - a pointer to the gl_Texture object
;				           filename - the name of the file containing the texture
; Return values .: Success - 1
;				           Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Procedure glTexture_Create(*tmp_gl_texture.gl_Texture)
  
  *tmp_gl_texture\image_number = LoadImage(#PB_Any, *tmp_gl_texture\file_name)
  GetObject_(ImageID(*tmp_gl_texture\image_number), SizeOf(BITMAP), @*tmp_gl_texture\image_bitmap)
  
  ProcedureReturn 1
EndProcedure



Procedure glTexture_LoadAll()
    
  LoadJSON(2, "texture.json")
  ;Debug JSONErrorMessage()
  ExtractJSONMap(JSONValue(2), texture_json())   

  texture_name.s
  
  ForEach texture_json()
    
    texture_name = MapKey(texture_json())
    
    If texture_name <> "texture name"
      
      AddMapElement(texture(), texture_name)
      texture()\file_name = texture_json(texture_name)
    EndIf
  Next

EndProcedure






; #GLDRAW FUNCTIONS# ============================================================================================================


; #FUNCTION# ====================================================================================================================
; Name...........: glDraw_Fixture
; Description ...: Draw a Box2D Fixture with OpenGL
; Syntax.........: glDraw_Fixture(*tmp_fixture.b2_Fixture, tmp_texture_ptr.l = -1)
; Parameters ....: *tmp_fixture - a pointer to the b2_Fixture object
;				           tmp_texture_ptr - an optional pointer to a texture
; Return values .: Success - 1
;				           Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Procedure glDraw_Fixture(*tmp_fixture.b2_Fixture, tmp_texture_ptr.l = -1)
  
  ; if the drawing is texture
  
  If *tmp_fixture\draw_type = #gl_texture2 Or *tmp_fixture\draw_type = #gl_texture2_and_line_loop2
    
    tmp_body.l = body(*tmp_fixture\body_name)\body_ptr
    
 ;   If tmp_texture_ptr > -1
       
 ;     *tmp_texture.gl_Texture = tmp_texture_ptr
 ;   Else
       
 ;     *tmp_texture.gl_Texture = *tmp_fixture\texture_ptr
 ;   EndIf
        
    glEnable_(#GL_TEXTURE_2D)
    
    glTexImage2D_(#GL_TEXTURE_2D, 0, #GL_RGBA, ImageWidth(texture(*tmp_fixture\texture_name)\image_number), ImageHeight(texture(*tmp_fixture\texture_name)\image_number), 0, #GL_BGRA_EXT, #GL_UNSIGNED_BYTE, texture(*tmp_fixture\texture_name)\image_bitmap\bmBits)
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
    tmp_texture_vertice(1)\x = 0.0
    tmp_texture_vertice(1)\y = 1.0
    tmp_texture_vertice(2)\x = 0.0
    tmp_texture_vertice(2)\y = 0.0
    tmp_texture_vertice(3)\x = 1.0
    tmp_texture_vertice(3)\y = 0.0
    
    If *tmp_fixture\shape_type = #b2_sprite
      
      tmp_quad_vertice(0)\x = *tmp_fixture\sprite_vertex[0]\x
      tmp_quad_vertice(0)\y = *tmp_fixture\sprite_vertex[0]\y
      tmp_quad_vertice(1)\x = *tmp_fixture\sprite_vertex[1]\x
      tmp_quad_vertice(1)\y = *tmp_fixture\sprite_vertex[1]\y
      tmp_quad_vertice(2)\x = *tmp_fixture\sprite_vertex[2]\x
      tmp_quad_vertice(2)\y = *tmp_fixture\sprite_vertex[2]\y
      tmp_quad_vertice(3)\x = *tmp_fixture\sprite_vertex[3]\x
      tmp_quad_vertice(3)\y = *tmp_fixture\sprite_vertex[3]\y
    Else
    
      tmp_quad_vertice(0)\x = *tmp_fixture\vertex[0]\x
      tmp_quad_vertice(0)\y = *tmp_fixture\vertex[0]\y
      tmp_quad_vertice(1)\x = *tmp_fixture\vertex[1]\x
      tmp_quad_vertice(1)\y = *tmp_fixture\vertex[1]\y
      tmp_quad_vertice(2)\x = *tmp_fixture\vertex[2]\x
      tmp_quad_vertice(2)\y = *tmp_fixture\vertex[2]\y
      tmp_quad_vertice(3)\x = *tmp_fixture\vertex[3]\x
      tmp_quad_vertice(3)\y = *tmp_fixture\vertex[3]\y
    EndIf
    
    tmp_quad_vertice(0)\z = 0.5
    tmp_quad_vertice(1)\z = 0.5
    tmp_quad_vertice(2)\z = 0.5
    tmp_quad_vertice(3)\z = 0.5
    
    glEnableClientState_(#GL_VERTEX_ARRAY )
    glEnableClientState_ (#GL_TEXTURE_COORD_ARRAY_EXT); 
    glVertexPointer_( 3, #GL_FLOAT, SizeOf(Vec3f), @tmp_quad_vertice(0)\x )
    glTexCoordPointer_(2, #GL_FLOAT, SizeOf(b2Vec2), @tmp_texture_vertice(0)\x)
    glDrawArrays_( #GL_QUADS, 0, ArraySize(tmp_quad_vertice()) )
    glDisableClientState_( #GL_TEXTURE_COORD_ARRAY_EXT )
    glDisableClientState_( #GL_VERTEX_ARRAY )

    glPopMatrix_()
        
    ; disable texture mapping
    glBindTexture_(#GL_TEXTURE_2D, 0)
    glDisable_( #GL_TEXTURE_2D )

  EndIf

  
  
  ; if the drawing is wireframe
  
  If *tmp_fixture\draw_type >= #gl_texture2_and_line_loop2
  
    glLineWidth_(*tmp_fixture\line_width)
    glColor3f_(*tmp_fixture\line_red, *tmp_fixture\line_green, *tmp_fixture\line_blue)
    
    tmp_body.l = *tmp_fixture\body_ptr
   
    Dim tmp_pos.f(2)
    b2Body_GetPosition(tmp_body, tmp_pos())
    tmp_angle.d = b2Body_GetAngle(tmp_body)
      
    glPushMatrix_()
    
    glTranslatef_(tmp_pos(0), tmp_pos(1), 0)
    glRotatef_ (Degree(tmp_angle), 0, 0, 1.0)
      
    Dim tmp_chain_vertice.Vec3f(*tmp_fixture\num_vertices)
      
    For i = 0 To (*tmp_fixture\num_vertices - 1)
      
      tmp_chain_vertice(i)\x = *tmp_fixture\vertex[i]\x
      tmp_chain_vertice(i)\y = *tmp_fixture\vertex[i]\y
      tmp_chain_vertice(i)\z = 0.5
    Next
  
    glEnableClientState_(#GL_VERTEX_ARRAY )
    glVertexPointer_( 3, #GL_FLOAT, SizeOf(Vec3f), @tmp_chain_vertice(0)\x )
    
    If *tmp_fixture\draw_type = #gl_line_strip2
      
      glDrawArrays_( #GL_LINE_STRIP, 0, ArraySize(tmp_chain_vertice()) )
    Else
      
      glDrawArrays_( #GL_LINE_LOOP, 0, ArraySize(tmp_chain_vertice()) )
    EndIf
    
    glDisableClientState_( #GL_VERTEX_ARRAY )
  
    glPopMatrix_()
    
    ; set no colour
    glColor3f_(1.0, 1.0, 1.0)

  EndIf

EndProcedure

; #FUNCTION# ====================================================================================================================
; Name...........: glDraw_ParticleSystem
; Description ...: Draw a LiquidFun Particle System with OpenGL
; Syntax.........: glDraw_ParticleSystem(*tmp_particle_system.b2_ParticleSystem)
; Parameters ....: *tmp_particle_system - a pointer to the particle system (b2_ParticleSystem)
; Return values .: Success - 1
;				           Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Procedure glDraw_ParticleSystem(*tmp_particle_system.b2_ParticleSystem)

  *positionbuffer_ptr.b2Vec2 = *tmp_particle_system\particle_position_buffer
  
  For i = 0 To (Int(*tmp_particle_system\particle_count) - 1)
    

    *tmp_particle_system\particle_texture_vertice[(i * 4) + 0]\x = 1.0
    *tmp_particle_system\particle_texture_vertice[(i * 4) + 0]\y = 1.0
    *tmp_particle_system\particle_quad_vertice[(i * 4) + 0]\x = *positionbuffer_ptr\x + *tmp_particle_system\particle_size
    *tmp_particle_system\particle_quad_vertice[(i * 4) + 0]\y = *positionbuffer_ptr\y + *tmp_particle_system\particle_size
    *tmp_particle_system\particle_quad_vertice[(i * 4) + 0]\z = 0.5
    
    *tmp_particle_system\particle_texture_vertice[(i * 4) + 1]\x = 0.0
    *tmp_particle_system\particle_texture_vertice[(i * 4) + 1]\y = 1.0
    *tmp_particle_system\particle_quad_vertice[(i * 4) + 1]\x = *positionbuffer_ptr\x - *tmp_particle_system\particle_size
    *tmp_particle_system\particle_quad_vertice[(i * 4) + 1]\y = *positionbuffer_ptr\y + *tmp_particle_system\particle_size
    *tmp_particle_system\particle_quad_vertice[(i * 4) + 1]\z = 0.5
    
    *tmp_particle_system\particle_texture_vertice[(i * 4) + 2]\x = 0.0
    *tmp_particle_system\particle_texture_vertice[(i * 4) + 2]\y = 0.0
    *tmp_particle_system\particle_quad_vertice[(i * 4) + 2]\x = *positionbuffer_ptr\x - *tmp_particle_system\particle_size
    *tmp_particle_system\particle_quad_vertice[(i * 4) + 2]\y = *positionbuffer_ptr\y - *tmp_particle_system\particle_size
    *tmp_particle_system\particle_quad_vertice[(i * 4) + 2]\z = 0.5
    
    *tmp_particle_system\particle_texture_vertice[(i * 4) + 3]\x = 1.0
    *tmp_particle_system\particle_texture_vertice[(i * 4) + 3]\y = 0.0
    *tmp_particle_system\particle_quad_vertice[(i * 4) + 3]\x = *positionbuffer_ptr\x + *tmp_particle_system\particle_size
    *tmp_particle_system\particle_quad_vertice[(i * 4) + 3]\y = *positionbuffer_ptr\y - *tmp_particle_system\particle_size
    *tmp_particle_system\particle_quad_vertice[(i * 4) + 3]\z = 0.5
           
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
    
  If *tmp_particle_system\particle_blending = 1
    glEnable_(#GL_BLEND)
    glBlendFunc_(#GL_SRC_ALPHA,#GL_ONE_MINUS_SRC_ALPHA)
;    glBlendFunc_(#GL_SRC_ALPHA,#GL_ONE)
  EndIf
 ; glBlendFunc_(#GL_ONE,#GL_ONE_MINUS_SRC_ALPHA)
 ;  glBlendFunc_(#GL_ONE_MINUS_SRC_ALPHA,#GL_ONE)
  
  glTexImage2D_(#GL_TEXTURE_2D, 0, #GL_RGBA, ImageWidth(texture(*tmp_particle_system\texture_name)\image_number), ImageHeight(texture(*tmp_particle_system\texture_name)\image_number), 0, #GL_BGRA_EXT, #GL_UNSIGNED_BYTE, texture(*tmp_particle_system\texture_name)\image_bitmap\bmBits)
  
  glEnableClientState_(#GL_VERTEX_ARRAY )
  glEnableClientState_ (#GL_TEXTURE_COORD_ARRAY_EXT); 
  glVertexPointer_( 3, #GL_FLOAT, SizeOf(Vec3f), @*tmp_particle_system\particle_quad_vertice[0]\x )
  glTexCoordPointer_(2, #GL_FLOAT, SizeOf(b2Vec2), @*tmp_particle_system\particle_texture_vertice[0]\x)
  glDrawArrays_( #GL_QUADS, 0, *tmp_particle_system\particle_count * 4 )
  glDisableClientState_( #GL_TEXTURE_COORD_ARRAY_EXT )
  glDisableClientState_( #GL_VERTEX_ARRAY )
   
  glDisable_( #GL_BLEND );
;   glEnable_( #GL_DEPTH_TEST )
    
  ; disable texture mapping
  glBindTexture_(#GL_TEXTURE_2D, 0)
  glDisable_( #GL_TEXTURE_2D )

EndProcedure




; #GLINFO FUNCTIONS# ============================================================================================================


; #FUNCTION# ====================================================================================================================
; Name...........: glInfo_Get
; Description ...: Get information about the OpenGL protocol
; Syntax.........: glInfo_Get()
; Parameters ....: 
; Return values .: Success - 1
;				           Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Procedure glInfo_Get()
    
  ; OpenGL Info
  
  sgGlVersion = StringField(PeekS(glGetString_(#GL_VERSION),-1,#PB_Ascii), 1, " ")
  sgGlExtn = StringField(PeekS(glGetString_(#GL_EXTENSIONS),-1,#PB_Ascii), 1, " ")
  sgGlVendor = StringField(PeekS(glGetString_(#GL_VENDOR),-1,#PB_Ascii), 1, " ")
  sgGlRender = StringField(PeekS(glGetString_(#GL_RENDERER),-1,#PB_Ascii), 1, " ")
  
  If(sgGlVersion = "") : sgGlVersion = "Not verified" : EndIf
  If(   sgGlExtn = "") :    sgGlExtn = "Not verified" : EndIf
  If( sgGlVendor = "") :  sgGlVendor = "Not verified" : EndIf
  If( sgGlRender = "") :  sgGlRender = "Not verified" : EndIf
  
  ProcedureReturn 1
EndProcedure


; #GLWINDOW FUNCTIONS# ============================================================================================================


; #FUNCTION# ====================================================================================================================
; Name...........: glWindow_Setup
; Description ...: Setup the OpenGL windows
; Syntax.........: glWindow_Setup(main_window_x.i, main_window_y.i, main_window_width.i, main_window_height.i, main_window_title.s, openglgadget_x.i, openglgadget_y.i, openglgadget_width.i, openglgadget_height.i, text_window_width.i, text_window_height.i, text_window_background_colour.i, text_window_text_colour.i, open_console_window.i)
; Parameters ....: main_window_x
;                  main_window_y
;                  main_window_width
;                  main_window_height
;                  main_window_title
;                  openglgadget_x
;                  openglgadget_y
;                  openglgadget_width
;                  openglgadget_height
;                  text_window_width
;                  text_window_height
;                  text_window_background_colour
;                  text_window_text_colour
;                  open_console_window
; Return values .: Success - 1
;				           Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Procedure glWindow_Setup(main_window_x.i, main_window_y.i, main_window_width.i, main_window_height.i, main_window_title.s, openglgadget_x.i, openglgadget_y.i, openglgadget_width.i, openglgadget_height.i, text_window_width.i, text_window_height.i, text_window_background_colour.i, text_window_text_colour.i, open_console_window.i)
    
  ; Setup the OpenGL Main Window
  OpenWindow(0, main_window_x, main_window_y, main_window_width, main_window_height, main_window_title, #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  OpenGLGadget(0, openglgadget_x, openglgadget_y, openglgadget_width, openglgadget_height, #PB_OpenGL_Keyboard|#PB_OpenGL_NoFlipSynchronization )
  
  ; Setup the OpenGL Info Window
  SetWindowCallback(@MyWindowCallback()) ; Set callback for this window.
  GetWindowRect_(WindowID(0),win.RECT)
  OpenWindow(1, win\left+10, win\top+20, text_window_width, text_window_height, "Follower", #PB_Window_BorderLess, WindowID(0))
  info_text_window = WindowID(1)
  SetWindowColor(1, text_window_background_colour)
  SetWindowLong_(WindowID(1), #GWL_EXSTYLE, #WS_EX_LAYERED | #WS_EX_TOPMOST)
  SetLayeredWindowAttributes_(WindowID(1), text_window_background_colour,0,#LWA_COLORKEY)
  TextGadget(5, 10,  10, text_window_width, text_window_height, "")
  SetGadgetColor(5, #PB_Gadget_BackColor, text_window_background_colour)
  SetGadgetColor(5, #PB_Gadget_FrontColor, text_window_text_colour)
  SetActiveWindow(0)
  SetActiveGadget(0)
  glInfo_Get()
  
  If open_console_window = 1
    
    OpenConsole()
  EndIf
  
EndProcedure


; #GLWORLD FUNCTIONS# ============================================================================================================


; #FUNCTION# ====================================================================================================================
; Name...........: glWorld_Setup
; Description ...: Setup the OpenGL world
; Syntax.........: glWorld_Setup(field_of_view.d, aspect_ratio.d, viewer_to_near_clipping_plane_distance.d, viewer_to_far_clipping_plane_distance.d, camera_x.f, camera_y.f, camera_z.f)
; Parameters ....: field_of_view
;                  aspect_ratio
;                  viewer_to_near_clipping_plane_distance
;                  viewer_to_far_clipping_plane_distance
;                  camera_x
;                  camera_y
;                  camera_z
; Return values .: Success - 1
;				           Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Procedure glWorld_Setup(field_of_view.d, aspect_ratio.d, viewer_to_near_clipping_plane_distance.d, viewer_to_far_clipping_plane_distance.d, camera_x.f, camera_y.f, camera_z.f)
  
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

; #FUNCTION# ====================================================================================================================
; Name...........: glWorld_CreateTextures
; Description ...: Create the OpenGL textures
; Syntax.........: glWorld_CreateTextures()
; Parameters ....: 
; Return values .: Success - 1
;				           Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Procedure glWorld_CreateTextures()
            
  ResetMap(texture())

  While NextMapElement(texture())
    
    glTexture_Create(texture())
  Wend
  
  ProcedureReturn 1
EndProcedure


; #B2VEC2 FUNCTIONS# ============================================================================================================


; #FUNCTION# ====================================================================================================================
; Name...........: b2Vec2_Distance
; Description ...: Gets the distance between two vectors.
; Syntax.........: b2Vec2_Distance (x1.f, y1.f, x2.f, y2.f)
; Parameters ....: x1 - horizontal component (pixel position) of the vector
;				           y1 - vertical component (pixel position) of the vector
;				           x2 - horizontal component (pixel position) of the vector
;				           y2 - vertical component (pixel position) of the vector
; Return values .: Success - the length of the vector
;				           Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Procedure.f b2Vec2_Distance (x1.f, y1.f, x2.f, y2.f)

	ProcedureReturn Sqr(((x1 - x2) * (x1 - x2)) + ((y1 - y2) * (y1 - y2)))
EndProcedure

; #FUNCTION# ====================================================================================================================
; Name...........: b2Vec2_Vector_at_Angle_Distance
; Description ...: Gets the distance between two vectors.
; Syntax.........: b2Vec2_Vector_at_Angle_Distance($x1, $y1, $x2, $y2)
; Parameters ....: x1 - horizontal component (pixel position) of the vector
;				           y1 - vertical component (pixel position) of the vector
;				           angle - must be in radians
;				           distance - vertical component (pixel position) of the vector
; Return values .: Success - the length of the vector
;				           Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Procedure b2Vec2_Vector_at_Angle_Distance (x1.f, y1.f, angle.f, distance.f, *tmpvec.b2Vec2)
  
  *tmpvec\x = x1 - (Cos(angle) * Abs(distance))
  *tmpvec\y = y1 + (Sin(angle) * Abs(distance)) 
  
EndProcedure

; #FUNCTION# ====================================================================================================================
; Name...........: b2Vec2_GetAngleBetweenThreePoints
; Description ...:
; Syntax.........: b2Vec2_GetAngleBetweenThreePoints($x1, $y1, $x2, $y2, $x3, $y3, ByRef $clockwise)
; Parameters ....: $x1 - the first point
;				           $y1 - the first point
;				           $x2 - the second point
;				           $y2 - the second point
;				           $x3 - the third point
;				           $y3 - the third point
;				           $clockwise - returns True if the angle indicates a clockwise movement through the points, otherwise False
; Return values .: The angle (degrees)
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Procedure b2Vec2_GetAngleBetweenThreePoints(*vector1.b2Vec2, *vector2.b2Vec2, *vector3.b2Vec2)
  
	angle1.f = ATan2(*vector1\y - *vector2\y, *vector1\x - *vector2\x)
	angle2.f = ATan2(*vector3\y - *vector2\y, *vector3\x - *vector2\x)
	angle.f =  angle1 - angle2
	deg.f = Degree(angle)
	__clockwise = 1
	

	If deg < 0

	  deg = 360 + deg
	EndIf
	
	If deg > 180

	  __clockwise = 0
	EndIf
	
;	if $deg > 180 Then

;		clockwise = 0
;		$deg = 360 - $deg
;	Else

;		if $deg < 0 Then

;			$deg = 0 - $deg
;		EndIf
;	EndIf

	ProcedureReturn deg
EndProcedure

; #FUNCTION# ====================================================================================================================
; Name...........: b2Vec2Array_IsConvexAndClockwise
; Description ...: Check whether an array of vertices (a polygon) is convex and in a clockwise direction.
;					This is a requirement for a the vertices of a Box2D shape.
; Syntax.........: b2Vec2Array_IsConvexAndClockwise($vertices)
; Parameters ....: $vertices - an array of vertices
; Return values .: True if convex, otherwise False
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Procedure.i b2Vec2Array_IsConvexAndClockwise(*vector_ptr.b2Vec2, num_vertices.i)

  edited_angle.f
  angles.s
  edited_total_angles.f = 0 
  clockwise.i
  
  *first_vector_ptr.b2Vec2
  *second_vector_ptr.b2Vec2
  *vector_1_ptr.b2Vec2
  *vector_2_ptr.b2Vec2
  *vector_3_ptr.b2Vec2
  
  If num_vertices < 3
    
		ProcedureReturn 0
	EndIf

	; angle at points #2 and more

	For i = 0 To (num_vertices - 3)
	  
	  If i > 0
	    
	    *vector_ptr + SizeOf(b2Vec2)      ; move to the next vector
	  EndIf
	      
	  *vector_1_ptr = *vector_ptr
	  *vector_2_ptr = *vector_ptr + SizeOf(b2Vec2)
	  *vector_3_ptr = *vector_ptr + SizeOf(b2Vec2) + SizeOf(b2Vec2)

	  If i = 0
	    
	    *first_vector_ptr = *vector_1_ptr
	    *second_vector_ptr = *vector_2_ptr
	  EndIf
	  
		edited_angle = b2Vec2_GetAngleBetweenThreePoints(*vector_1_ptr, *vector_2_ptr, *vector_3_ptr)

	;	If __clockwise = 1

		;	ProcedureReturn 0
		;EndIf

		angles = angles + ", #" + i + " = " + StrF(edited_angle)
		edited_total_angles = edited_total_angles + edited_angle
	Next
	
	
	; angle at the last point
	edited_angle = b2Vec2_GetAngleBetweenThreePoints(*vector_2_ptr, *vector_3_ptr, *first_vector_ptr)

	;	If __clockwise = 1

		;	ProcedureReturn 0
		;EndIf
;	Debug(edited_angle)
; ;	$edited_angle = b2Vec2_GetAngleBetweenThreePoints($vertices[UBound($vertices) - 2][0], $vertices[UBound($vertices) - 2][1], $vertices[UBound($vertices) - 1][0], $vertices[UBound($vertices) - 1][1], $vertices[0][0], $vertices[0][1], $clockwise)
 	angles = angles + ", last # = " + StrF(edited_angle)
 	edited_total_angles = edited_total_angles + edited_angle

	; angle at the first point

	edited_angle = b2Vec2_GetAngleBetweenThreePoints(*vector_3_ptr, *first_vector_ptr, *second_vector_ptr)

		;If __clockwise = 1

;			ProcedureReturn 0
	;	EndIf
;	$edited_angle = b2Vec2_GetAngleBetweenThreePoints($vertices[UBound($vertices) - 1][0], $vertices[UBound($vertices) - 1][1], $vertices[0][0], $vertices[0][1], $vertices[1][0], $vertices[1][1], $clockwise)
	angles = "first # = " + StrF(edited_angle) + angles
	edited_total_angles = edited_total_angles + edited_angle
	
;	Debug(StrF(edited_total_angles, 4) + "; " + angles + "; " + Str(__clockwise))
	;Debug(angles)
	;Debug(__clockwise)
	
	expected_edited_total_angles.i = ((num_vertices - 2) * 180)
	
	If edited_total_angles >= expected_edited_total_angles - 1 And edited_total_angles <= expected_edited_total_angles + 1

		ProcedureReturn 1
	EndIf
 	
 	
	ProcedureReturn 0

EndProcedure







; #B2POLYGONSHAPE FUNCTIONS# ============================================================================================================


; #FUNCTION# ====================================================================================================================
; Name...........: b2PolygonShape_CreateFixture
; Description ...: Creates a polygon shape and corresponding fixture for a body
; Syntax.........: b2PolygonShape_CreateFixture(*tmp_b2_fixture.b2_Fixture, tmp_body.l, tmp_density.d, tmp_friction.d, tmp_isSensor.d,	tmp_restitution.d, tmp_categoryBits.d, tmp_groupIndex.d, tmp_maskBits.d, tmp_shape_type.i, tmp_vertices.s, tmp_sprite_size.f, tmp_sprite_offset_x.d, tmp_sprite_offset_y.d, tmp_draw_type.i, tmp_line_width.f, tmp_line_red.f, tmp_line_green.f, tmp_line_blue.f, body_offset_x.d = 0, body_offset_y.d = 0, tmp_texture.l = -1)
; Parameters ....: *tmp_b2_fixture - a pointer to the b2_Fixture object
;				           tmp_body - the body to attach the fixture to
;                  tmp_density
;                  tmp_friction
;                  tmp_isSensor
;                  tmp_restitution
;                  tmp_categoryBits
;                  tmp_groupIndex
;                  tmp_maskBits
;                  tmp_shape_type
;                  tmp_vertices
;                  tmp_sprite_size
;                  tmp_sprite_offset_x
;                  tmp_sprite_offset_y
;                  tmp_draw_type
;                  tmp_line_width
;                  tmp_line_red
;                  tmp_line_green
;                  tmp_line_blue
;                  body_offset_x
;                  body_offset_y
;                  tmp_texture
; Return values .: Success - 1
;				           Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Procedure b2PolygonShape_CreateFixture(*tmp_b2_fixture.b2_Fixture, tmp_body.l, tmp_density.d, tmp_friction.d, tmp_isSensor.d,	tmp_restitution.d, tmp_categoryBits.d, tmp_groupIndex.d, tmp_maskBits.d, tmp_shape_type.i, tmp_vertices.s, tmp_sprite_size.f, tmp_sprite_offset_x.d, tmp_sprite_offset_y.d, tmp_draw_type.i, tmp_line_width.f, tmp_line_red.f, tmp_line_green.f, tmp_line_blue.f, body_offset_x.d = 0, body_offset_y.d = 0, tmp_texture.l = -1)
  
  If tmp_shape_type = #b2_circle

    ParseJSON(0, tmp_vertices)    
    tmp_circle_radius.f = GetJSONDouble(GetJSONElement(JSONValue(0), 0))
    
    *tmp_b2_fixture\fixture_ptr = b2CircleShape_CreateFixture(tmp_body, tmp_density, tmp_friction, tmp_isSensor, tmp_restitution, 0, tmp_categoryBits, tmp_groupIndex, tmp_maskBits, body_offset_x, body_offset_y, tmp_circle_radius)
    *tmp_b2_fixture\body_ptr = tmp_body
    *tmp_b2_fixture\vertex[0]\x = 0 + tmp_circle_radius + body_offset_x
    *tmp_b2_fixture\vertex[0]\y = 0 + tmp_circle_radius + body_offset_y
    *tmp_b2_fixture\vertex[1]\x = 0 - tmp_circle_radius + body_offset_x
    *tmp_b2_fixture\vertex[1]\y = 0 + tmp_circle_radius + body_offset_y
    *tmp_b2_fixture\vertex[2]\x = 0 - tmp_circle_radius + body_offset_x
    *tmp_b2_fixture\vertex[2]\y = 0 - tmp_circle_radius + body_offset_y
    *tmp_b2_fixture\vertex[3]\x = 0 + tmp_circle_radius + body_offset_x
    *tmp_b2_fixture\vertex[3]\y = 0 - tmp_circle_radius + body_offset_y
    
    If tmp_texture > -1
      
      *tmp_b2_fixture\texture_ptr = tmp_texture
    EndIf
  EndIf

  
  If tmp_shape_type = #b2_polygon Or tmp_shape_type = #b2_sprite
    
    ParseJSON(0, tmp_vertices)    
    *tmp_b2_fixture\num_vertices = JSONArraySize(JSONValue(0)) / 2
      
    Dim tmp_vertex.b2Vec2(*tmp_b2_fixture\num_vertices)
    
    vertex_num.i = -1
    
    For i = 0 To ((*tmp_b2_fixture\num_vertices * 2) - 1) Step 2
      
      vertex_num = vertex_num + 1
      *tmp_b2_fixture\vertex[vertex_num]\x = GetJSONDouble(GetJSONElement(JSONValue(0), i)) + body_offset_x
      *tmp_b2_fixture\vertex[vertex_num]\y = GetJSONDouble(GetJSONElement(JSONValue(0), i + 1)) + body_offset_y
    Next i
    
    If tmp_shape_type = #b2_sprite
      
      *tmp_b2_fixture\sprite_vertex[0]\x = 0 + (tmp_sprite_size / 2) + tmp_sprite_offset_x
      *tmp_b2_fixture\sprite_vertex[0]\y = 0 + (tmp_sprite_size / 2) + tmp_sprite_offset_y
      *tmp_b2_fixture\sprite_vertex[1]\x = 0 - (tmp_sprite_size / 2) + tmp_sprite_offset_x
      *tmp_b2_fixture\sprite_vertex[1]\y = 0 + (tmp_sprite_size / 2) + tmp_sprite_offset_y
      *tmp_b2_fixture\sprite_vertex[2]\x = 0 - (tmp_sprite_size / 2) + tmp_sprite_offset_x
      *tmp_b2_fixture\sprite_vertex[2]\y = 0 - (tmp_sprite_size / 2) + tmp_sprite_offset_y
      *tmp_b2_fixture\sprite_vertex[3]\x = 0 + (tmp_sprite_size / 2) + tmp_sprite_offset_x
      *tmp_b2_fixture\sprite_vertex[3]\y = 0 - (tmp_sprite_size / 2) + tmp_sprite_offset_y
    EndIf
    
    If *tmp_b2_fixture\num_vertices = 3
      
      *tmp_b2_fixture\fixture_ptr = b2PolygonShape_CreateFixture_3(tmp_body, tmp_density, tmp_friction, tmp_isSensor, tmp_restitution, 0, tmp_categoryBits, tmp_groupIndex, tmp_maskBits, *tmp_b2_fixture\vertex[0]\x, *tmp_b2_fixture\vertex[0]\y, *tmp_b2_fixture\vertex[1]\x, *tmp_b2_fixture\vertex[1]\y, *tmp_b2_fixture\vertex[2]\x, *tmp_b2_fixture\vertex[2]\y)
    EndIf
    
    If *tmp_b2_fixture\num_vertices = 4
      
      *tmp_b2_fixture\fixture_ptr = b2PolygonShape_CreateFixture_4(tmp_body, tmp_density, tmp_friction, tmp_isSensor, tmp_restitution, 0, tmp_categoryBits, tmp_groupIndex, tmp_maskBits, *tmp_b2_fixture\vertex[0]\x, *tmp_b2_fixture\vertex[0]\y, *tmp_b2_fixture\vertex[1]\x, *tmp_b2_fixture\vertex[1]\y, *tmp_b2_fixture\vertex[2]\x, *tmp_b2_fixture\vertex[2]\y, *tmp_b2_fixture\vertex[3]\x, *tmp_b2_fixture\vertex[3]\y)
    EndIf
    
    If *tmp_b2_fixture\num_vertices = 5
      
      *tmp_b2_fixture\fixture_ptr = b2PolygonShape_CreateFixture_5(tmp_body, tmp_density, tmp_friction, tmp_isSensor, tmp_restitution, 0, tmp_categoryBits, tmp_groupIndex, tmp_maskBits, *tmp_b2_fixture\vertex[0]\x, *tmp_b2_fixture\vertex[0]\y, *tmp_b2_fixture\vertex[1]\x, *tmp_b2_fixture\vertex[1]\y, *tmp_b2_fixture\vertex[2]\x, *tmp_b2_fixture\vertex[2]\y, *tmp_b2_fixture\vertex[3]\x, *tmp_b2_fixture\vertex[3]\y, *tmp_b2_fixture\vertex[4]\x, *tmp_b2_fixture\vertex[4]\y)
    EndIf
    
    If tmp_texture > -1
      
      *tmp_b2_fixture\texture_ptr = tmp_texture
    EndIf
  
  EndIf
  
  
  If tmp_shape_type = #b2_box
    
    ParseJSON(0, tmp_vertices)    
    tmp_box_width.f = GetJSONDouble(GetJSONElement(JSONValue(0), 0))
    tmp_box_height.f = GetJSONDouble(GetJSONElement(JSONValue(0), 1))
    
    *tmp_b2_fixture\vertex[0]\x = 0 + (tmp_box_width / 2) + body_offset_x
    *tmp_b2_fixture\vertex[0]\y = 0 + (tmp_box_height / 2) + body_offset_y
    *tmp_b2_fixture\vertex[1]\x = 0 - (tmp_box_width / 2) + body_offset_x
    *tmp_b2_fixture\vertex[1]\y = 0 + (tmp_box_height / 2) + body_offset_y
    *tmp_b2_fixture\vertex[2]\x = 0 - (tmp_box_width / 2) + body_offset_x
    *tmp_b2_fixture\vertex[2]\y = 0 - (tmp_box_height / 2) + body_offset_y
    *tmp_b2_fixture\vertex[3]\x = 0 + (tmp_box_width / 2) + body_offset_x
    *tmp_b2_fixture\vertex[3]\y = 0 - (tmp_box_height / 2) + body_offset_y
    *tmp_b2_fixture\num_vertices = 4
    *tmp_b2_fixture\fixture_ptr = b2PolygonShape_CreateFixture_4(tmp_body, tmp_density, tmp_friction, tmp_isSensor, tmp_restitution, 0, tmp_categoryBits, tmp_groupIndex, tmp_maskBits, *tmp_b2_fixture\vertex[0]\x, *tmp_b2_fixture\vertex[0]\y, *tmp_b2_fixture\vertex[1]\x, *tmp_b2_fixture\vertex[1]\y, *tmp_b2_fixture\vertex[2]\x, *tmp_b2_fixture\vertex[2]\y, *tmp_b2_fixture\vertex[3]\x, *tmp_b2_fixture\vertex[3]\y)
    
    If tmp_texture > -1
      
      *tmp_b2_fixture\texture_ptr = tmp_texture
    EndIf
  
  EndIf
    
  If tmp_shape_type = #b2_chain

    ParseJSON(0, tmp_vertices)    
    *tmp_b2_fixture\num_vertices = JSONArraySize(JSONValue(0)) / 2
    Dim tmp_vertex.b2Vec2(*tmp_b2_fixture\num_vertices)
    
    vertex_num.i = -1
    
    For i = 0 To ((*tmp_b2_fixture\num_vertices * 2) - 1) Step 2
      
      vertex_num = vertex_num + 1
      *tmp_b2_fixture\vertex[vertex_num]\x = GetJSONDouble(GetJSONElement(JSONValue(0), i)) + body_offset_x
      *tmp_b2_fixture\vertex[vertex_num]\y = GetJSONDouble(GetJSONElement(JSONValue(0), i + 1)) + body_offset_y
    Next i
    
    *tmp_b2_fixture\fixture_ptr = b2ChainShape_CreateFixture(tmp_body, tmp_density, tmp_friction, tmp_isSensor, tmp_restitution, 0, tmp_categoryBits, tmp_groupIndex, tmp_maskBits, @*tmp_b2_fixture\vertex[0]\x, *tmp_b2_fixture\num_vertices * 2)
  EndIf
  
  *tmp_b2_fixture\body_ptr = tmp_body
  *tmp_b2_fixture\shape_type = tmp_shape_type
  *tmp_b2_fixture\draw_type = tmp_draw_type
  *tmp_b2_fixture\line_width = tmp_line_width
  *tmp_b2_fixture\line_red = tmp_line_red
  *tmp_b2_fixture\line_green = tmp_line_green
  *tmp_b2_fixture\line_blue = tmp_line_blue
  
  ProcedureReturn 1
EndProcedure

; #FUNCTION# ====================================================================================================================
; Name...........: b2PolygonShape_CreateFixture_4_sfSprite
; Description ...: Creates a 4 vertice polygon shape and corresponding fixture for a body using SFML
; Syntax.........: b2PolygonShape_CreateFixture_4_sfSprite(*tmp_pb_LiquidFun_SFML.pb_LiquidFun_SFML_struct, body.l, texture.l, x0.d, y0.d, x1.d, y1.d, x2.d, y2.d, x3.d, y3.d, origin_x.d, origin_y.d)
; Parameters ....: *tmp_pb_LiquidFun_SFML - a pointer to the LiquidFun SFML object
;				           body - the body to attach the fixture to
;                  texture
;                  x0
;                  y0
;                  x1
;                  y1
;                  x2
;                  y2
;                  x3
;                  y3
;                  origin_x
;                  origin_y
; Return values .: Success - 1
;				           Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
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

; #FUNCTION# ====================================================================================================================
; Name...........: b2PolygonShape_CrossProductVectorVector
; Description ...:
; Syntax.........: b2PolygonShape_CrossProductVectorVector($x1, $y1, $x2, $y2)
; Parameters ....: $x1 -
;				   $y1 -
;				   $x2 -
;				   $y2 -
; Return values .:
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Procedure.f b2PolygonShape_CrossProductVectorVector(x1.f, y1.f, x2.f, y2.f)

	ProcedureReturn x1 * y2 - y1 * x2
EndProcedure

; #FUNCTION# ====================================================================================================================
; Name...........: b2PolygonShape_ComputeCentroid
; Description ...:
; Syntax.........: b2PolygonShape_ComputeCentroid($vertices)
; Parameters ....: $x -
;				   $y -
; Return values .: A vector (2D element array) of the centroid of the vertices
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Procedure b2PolygonShape_ComputeCentroid(*vector_ptr.b2Vec2, num_vertices.i, *centroid_ptr.b2Vec2)

	area.f = 0
  *vector_1_ptr.b2Vec2
  *vector_2_ptr.b2Vec2
  *next_vector_ptr.b2Vec2

	*vector_1_ptr = *vector_ptr
  *vector_2_ptr = *vector_ptr + SizeOf(b2Vec2)
	  ;*vector_3_ptr = *vector_ptr + SizeOf(b2Vec2) + SizeOf(b2Vec2)

	If num_vertices = 2

		*centroid_ptr\x = 0.5 * (*vector_1_ptr\x + *vector_2_ptr\x)
		*centroid_ptr\y = 0.5 * (*vector_1_ptr\y + *vector_2_ptr\y)
	EndIf

	; pRef is the reference point for forming triangles.
	; It's location doesn't change the result (except for rounding error).
	
	pRef.b2Vec2
	pRef\x = 0
	pRef\y = 0
	inv3.f = 1 / 3
	p1.b2Vec2
	p2.b2Vec2
	p3.b2Vec2
	e1.b2Vec2
	e2.b2Vec2

	For i = 0 To (num_vertices - 1)
	  
	  If i > 0
	    
	    *vector_ptr + SizeOf(b2Vec2)      ; move to the next vector
	  EndIf

		p1\x = pRef\x
		p1\y = pRef\y
		p2\x = *vector_ptr\x
		p2\y = *vector_ptr\y

		If (i + 1) < num_vertices
		  
		  *next_vector_ptr = *vector_ptr + SizeOf(b2Vec2)
			p3\x = *next_vector_ptr\x
			p3\y = *next_vector_ptr\y
		Else

			p3\x = *vector_ptr\x
			p3\y = *vector_ptr\y
		EndIf

		e1\x = p2\x - p1\x
		e1\y = p2\y - p1\y
		e2\x = p3\x - p1\x
		e2\y = p3\y - p1\y

		D.f = b2PolygonShape_CrossProductVectorVector(e1\x, e1\y, e2\x, e2\y)

		triangleArea.f = 0.5 * D
		area = area + triangleArea

		; Area weighted centroid
		*centroid_ptr\x = *centroid_ptr\x + (triangleArea * inv3 * (p1\x + p2\x + p3\x))
		*centroid_ptr\y = *centroid_ptr\y + (triangleArea * inv3 * (p1\y + p2\y + p3\y))
	Next

	*centroid_ptr\x = *centroid_ptr\x * (1 / area)
	*centroid_ptr\y = *centroid_ptr\y * (1 / area)

EndProcedure

; #FUNCTION# ====================================================================================================================
; Name...........: b2PolygonShape_MoveToZeroCentroid
; Description ...: Computes the centroid of the shape and moves the vertices such that the centroid becomes 0,0.
; Syntax.........: b2PolygonShape_MoveToZeroCentroid($vertices)
; Parameters ....: $vertices
;				   $format - a StringFormat string to make a vertices smaller.  Try "%4.2f".
; Return values .: the centroid
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......: In the calling script you can apply the returned centroid to understand where the shap has moved to.
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Procedure b2PolygonShape_MoveToZeroCentroid(*vector_ptr.b2Vec2, num_vertices.i, *centroid_ptr.b2Vec2)
  
  centroid.b2Vec2
  
	; Compute the polygon centroid.

	;Local $centroid = b2PolygonShape_ComputeCentroid($vertices)
  b2PolygonShape_ComputeCentroid(*vector_ptr, num_vertices, @centroid\x)
  
;  Debug (Str(centroid\x) + ", " + Str(centroid\y))
	; Shift the shape, meaning it's center and therefore it's centroid, to the world position of 0,0, such that rotations and calculations are easier

	For vertice_num = 0 To (num_vertices - 1)
	  
	  If vertice_num > 0
	    
	    *vector_ptr + SizeOf(b2Vec2)      ; move to the next vector
	  EndIf

;		*vector_ptr\x = StringFormat($format, *vector_ptr\x - centroid\x)
;		*vector_ptr\y = StringFormat($format, *vector_ptr\y - centroid\y)
		*vector_ptr\x = *vector_ptr\x - centroid\x
		*vector_ptr\y = *vector_ptr\y - centroid\y
	Next

	; If the first vertex in $vertices is 0,0 then we can add the $centroid position above to the $first_vertex_x and $first_vertex_y
	;	to arrive at the real-world centroid position, which is then returned

;	$centroid[0] = $first_vertex_x - $vertices[0][0]
;	$centroid[1] = $first_vertex_y - $vertices[0][1]
	
	*centroid_ptr = @centroid\x
;	Return $centroid
EndProcedure





Procedure b2Fixture_LoadAll()
  
  LoadJSON(1, "fixture.json")
  ;Debug JSONErrorMessage()
  ExtractJSONMap(JSONValue(1), fixture_json())       

  fixture_name.s
  
  ForEach fixture_json()
    
    fixture_name = MapKey(fixture_json())
    
    If fixture_name <> "fixture name"
      
      ParseJSON(1, fixture_json(fixture_name))
      AddMapElement(fixture(), fixture_name)
      
      fixture()\body_name         = GetJSONString(GetJSONElement(JSONValue(1), 0))
      fixture()\density           = GetJSONDouble(GetJSONElement(JSONValue(1), 1))
      fixture()\friction          = GetJSONDouble(GetJSONElement(JSONValue(1), 2))
      fixture()\isSensor          = GetJSONDouble(GetJSONElement(JSONValue(1), 3))
      fixture()\restitution       = GetJSONDouble(GetJSONElement(JSONValue(1), 4))
      fixture()\categoryBits      = GetJSONDouble(GetJSONElement(JSONValue(1), 5))
      fixture()\groupIndex        = GetJSONDouble(GetJSONElement(JSONValue(1), 6))
      fixture()\maskBits          = GetJSONDouble(GetJSONElement(JSONValue(1), 7))
      fixture()\shape_type_str    = GetJSONString(GetJSONElement(JSONValue(1), 8))
      fixture()\vertices_str      = GetJSONString(GetJSONElement(JSONValue(1), 9))
      fixture()\sprite_size       = GetJSONFloat(GetJSONElement(JSONValue(1), 10))
      fixture()\sprite_offset_x   = GetJSONDouble(GetJSONElement(JSONValue(1), 11))
      fixture()\sprite_offset_y   = GetJSONDouble(GetJSONElement(JSONValue(1), 12))
      fixture()\draw_type_str     = GetJSONString(GetJSONElement(JSONValue(1), 13))
      fixture()\line_width        = GetJSONFloat(GetJSONElement(JSONValue(1), 14))
      fixture()\line_red          = GetJSONFloat(GetJSONElement(JSONValue(1), 15))
      fixture()\line_green        = GetJSONFloat(GetJSONElement(JSONValue(1), 16))
      fixture()\line_blue         = GetJSONFloat(GetJSONElement(JSONValue(1), 17))
      fixture()\body_offset_x     = GetJSONDouble(GetJSONElement(JSONValue(1), 18))
      fixture()\body_offset_y     = GetJSONDouble(GetJSONElement(JSONValue(1), 19))
      fixture()\texture_name      = GetJSONString(GetJSONElement(JSONValue(1), 20))
    EndIf
  Next
EndProcedure






; #B2BODY FUNCTIONS# ============================================================================================================





Procedure b2Body_LoadAll()
  
  LoadJSON(0, "body.json")
  ;Debug JSONErrorMessage()
  ExtractJSONMap(JSONValue(0), body_json())       

  body_name.s
  
  ForEach body_json()
    
    body_name = MapKey(body_json())
    
    If body_name <> "body name"
    
      ParseJSON(0, body_json(body_name))
      AddMapElement(body(), body_name)
      
      body()\active            = GetJSONDouble(GetJSONElement(JSONValue(0), 1))
      body()\allowSleep        = GetJSONDouble(GetJSONElement(JSONValue(0), 2))
      body()\angle             = GetJSONDouble(GetJSONElement(JSONValue(0), 3))
      body()\angularVelocity   = GetJSONDouble(GetJSONElement(JSONValue(0), 4))
      body()\angularDamping    = GetJSONDouble(GetJSONElement(JSONValue(0), 5))
      body()\awake             = GetJSONDouble(GetJSONElement(JSONValue(0), 6))
      body()\bullet            = GetJSONDouble(GetJSONElement(JSONValue(0), 7))
      body()\fixedRotation     = GetJSONDouble(GetJSONElement(JSONValue(0), 8))
      body()\gravityScale      = GetJSONDouble(GetJSONElement(JSONValue(0), 9))
      body()\linearDamping     = GetJSONDouble(GetJSONElement(JSONValue(0), 10))
      body()\linearVelocityX   = GetJSONDouble(GetJSONElement(JSONValue(0), 11))
      body()\linearVelocityY   = GetJSONDouble(GetJSONElement(JSONValue(0), 12))
      body()\positionX         = GetJSONDouble(GetJSONElement(JSONValue(0), 13))
      body()\positionY         = GetJSONDouble(GetJSONElement(JSONValue(0), 14))
      body()\type              = GetJSONDouble(GetJSONElement(JSONValue(0), 15))
      body()\userData          = GetJSONDouble(GetJSONElement(JSONValue(0), 16))
    EndIf
  Next
EndProcedure





; #FUNCTION# ====================================================================================================================
; Name...........: b2Body_SetAngle
; Description ...: Sets the angle (radians) of a body (b2Body)
; Syntax.........: b2Body_SetAngle(tmp_body, tmp_angle)
; Parameters ....: tmp_body - a pointer to the body (b2Body)
;				           tmp_angle - the angle (radians)
; Return values .: Success - 1
;				           Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Procedure b2Body_SetAngle(tmp_body.l, tmp_angle.d)
  
  Dim tmp_pos.f(2)
    
  b2Body_GetPosition(tmp_body, tmp_pos())
  b2Body_SetTransform(tmp_body, tmp_pos(0), tmp_pos(1), tmp_angle)
  
  ProcedureReturn 1
EndProcedure

; #FUNCTION# ====================================================================================================================
; Name...........: b2Body_AddAngle
; Description ...: Adds an angle (radians) to a body (b2Body)
; Syntax.........: b2Body_AddAngle(tmp_body.l, add_angle.d)
; Parameters ....: tmp_body - a pointer to the body (b2Body)
;				           add_angle - the angle (radians)
; Return values .: Success - 1
;				           Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Procedure b2Body_AddAngle(tmp_body.l, add_angle.d)
  
  Dim tmp_pos.f(2)
  b2Body_GetPosition(tmp_body, tmp_pos())
  curr_angle.d = b2Body_GetAngle(tmp_body)
  b2Body_SetTransform(tmp_body, tmp_pos(0), tmp_pos(1), curr_angle + add_angle)
  
  ProcedureReturn 1
EndProcedure

; #FUNCTION# ====================================================================================================================
; Name...........: b2Body_AddAngularVelocity
; Description ...: Adds an angular velocity to a body (b2Body)
; Syntax.........: b2Body_AddAngularVelocity(tmp_body.l, add_angle.d)
; Parameters ....: tmp_body - a pointer to the body (b2Body)
;				           add_velocity - the velocity
; Return values .: Success - 1
;				           Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Procedure b2Body_AddAngularVelocity(tmp_body.l, add_velocity.d)
  
  velocity.d = b2Body_GetAngularVelocity(tmp_body)
  velocity = velocity + add_velocity
  b2Body_SetAngularVelocity(tmp_body, velocity)
  
  ProcedureReturn 1
EndProcedure

; #FUNCTION# ====================================================================================================================
; Name...........: b2Body_SetAngularVelocityPercent
; Description ...: Sets the angular velocity of a body (b2Body) to a given percentage
; Syntax.........: b2Body_SetAngularVelocityPercent(tmp_body.l, percent.i)
; Parameters ....: tmp_body - a pointer to the body (b2Body)
;				           percent - the percentage
; Return values .: Success - 1
;				           Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Procedure b2Body_SetAngularVelocityPercent(tmp_body.l, percent.i)
  
  velocity.d = b2Body_GetAngularVelocity(tmp_body)
  velocity = velocity * (percent / 100)
  b2Body_SetAngularVelocity(tmp_body, velocity)
  
  ProcedureReturn 1
EndProcedure


Procedure b2Joint_LoadAll()
    
  LoadJSON(5, "joint.json")
  ;Debug JSONErrorMessage()
  ExtractJSONMap(JSONValue(5), joint_json())       

  joint_name.s
  
  ForEach joint_json()
    
    joint_name = MapKey(joint_json())
    
    If joint_name <> "joint name"
      
      ParseJSON(5, joint_json(joint_name))
      AddMapElement(joint(), joint_name)
      
      joint()\body_a_name       = GetJSONString(GetJSONElement(JSONValue(5), 0))
      joint()\body_b_name       = GetJSONString(GetJSONElement(JSONValue(5), 1))
      joint()\joint_type        = GetJSONString(GetJSONElement(JSONValue(5), 2))
      joint()\active            = GetJSONInteger(GetJSONElement(JSONValue(5), 3))
      joint()\collideConnected  = GetJSONDouble(GetJSONElement(JSONValue(5), 4))
      joint()\dampingRatio      = GetJSONDouble(GetJSONElement(JSONValue(5), 5))
      joint()\enableLimit       = GetJSONDouble(GetJSONElement(JSONValue(5), 6))
      joint()\enableMotor       = GetJSONDouble(GetJSONElement(JSONValue(5), 7))
      joint()\lowerAngle        = GetJSONDouble(GetJSONElement(JSONValue(5), 8))
      joint()\frequencyHz       = GetJSONDouble(GetJSONElement(JSONValue(5), 9))
      joint()\localAnchorAx     = GetJSONDouble(GetJSONElement(JSONValue(5), 10))
      joint()\localAnchorAy     = GetJSONDouble(GetJSONElement(JSONValue(5), 11))
      joint()\localAnchorBx     = GetJSONDouble(GetJSONElement(JSONValue(5), 12))
      joint()\localAnchorBy     = GetJSONDouble(GetJSONElement(JSONValue(5), 13))
      joint()\localAxisAx       = GetJSONDouble(GetJSONElement(JSONValue(5), 14))
      joint()\localAxisAy       = GetJSONDouble(GetJSONElement(JSONValue(5), 15))
      joint()\maxMotorTorque    = GetJSONDouble(GetJSONElement(JSONValue(5), 16))
      joint()\lowerTranslation  = GetJSONDouble(GetJSONElement(JSONValue(5), 17))
      joint()\maxMotorForce     = GetJSONDouble(GetJSONElement(JSONValue(5), 18))
      joint()\motorSpeed        = GetJSONDouble(GetJSONElement(JSONValue(5), 19))
      joint()\referenceAngle    = GetJSONDouble(GetJSONElement(JSONValue(5), 20))
      joint()\upperAngle        = GetJSONDouble(GetJSONElement(JSONValue(5), 21))
      joint()\upperTranslation  = GetJSONDouble(GetJSONElement(JSONValue(5), 22))
    EndIf
  Next
EndProcedure




; #B2PARTICLESYSTEM FUNCTIONS# ===========================================================================================================


; #FUNCTION# ====================================================================================================================
; Name...........: b2ParticleSystem_LoadAll
; Description ...: Loads all the data for the particle systems from the JSON file
; Syntax.........: b2ParticleSystem_LoadAll()
; Parameters ....: 
; Return values .: Success - 1
;				           Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Procedure b2ParticleSystem_LoadAll()
  
  LoadJSON(3, "particle_system.json")
  ;Debug JSONErrorMessage()
  ExtractJSONMap(JSONValue(3), particle_system_json())       

  particle_system_name.s
  
  ForEach particle_system_json()
    
    particle_system_name = MapKey(particle_system_json())
    
    If particle_system_name <> "system name"
    
      ParseJSON(3, particle_system_json(particle_system_name))
      AddMapElement(particle_system(), particle_system_name)
      
      particle_system()\active                          = GetJSONInteger(GetJSONElement(JSONValue(3), 1))
      particle_system()\colorMixingStrength             = GetJSONDouble(GetJSONElement(JSONValue(3), 2))
      particle_system()\dampingStrength                 = GetJSONDouble(GetJSONElement(JSONValue(3), 3))
      particle_system()\destroyByAge                    = GetJSONDouble(GetJSONElement(JSONValue(3), 4))
      particle_system()\ejectionStrength                = GetJSONDouble(GetJSONElement(JSONValue(3), 5))
      particle_system()\elasticStrength                 = GetJSONDouble(GetJSONElement(JSONValue(3), 6))
      particle_system()\lifetimeGranularity             = GetJSONDouble(GetJSONElement(JSONValue(3), 7))
      particle_system()\powderStrength                  = GetJSONDouble(GetJSONElement(JSONValue(3), 8))
      particle_system()\pressureStrength                = GetJSONDouble(GetJSONElement(JSONValue(3), 9))
      particle_system()\particleRadius                  = GetJSONDouble(GetJSONElement(JSONValue(3), 10))
      particle_system()\repulsiveStrength               = GetJSONDouble(GetJSONElement(JSONValue(3), 11))
      particle_system()\springStrength                  = GetJSONDouble(GetJSONElement(JSONValue(3), 12))
      particle_system()\staticPressureIterations        = GetJSONDouble(GetJSONElement(JSONValue(3), 13))
      particle_system()\staticPressureRelaxation        = GetJSONDouble(GetJSONElement(JSONValue(3), 14))
      particle_system()\staticPressureStrength          = GetJSONDouble(GetJSONElement(JSONValue(3), 15))
      particle_system()\surfaceTensionNormalStrength    = GetJSONDouble(GetJSONElement(JSONValue(3), 16))
      particle_system()\surfaceTensionPressureStrength  = GetJSONDouble(GetJSONElement(JSONValue(3), 17))
      particle_system()\viscousStrength                 = GetJSONDouble(GetJSONElement(JSONValue(3), 18))
      particle_system()\particleDensity                 = GetJSONDouble(GetJSONElement(JSONValue(3), 19))
      particle_system()\texture_name                    = GetJSONString(GetJSONElement(JSONValue(3), 20))
      particle_system()\particle_size                   = GetJSONDouble(GetJSONElement(JSONValue(3), 21))
      particle_system()\particle_blending               = GetJSONInteger(GetJSONElement(JSONValue(3), 22))
    EndIf
  Next
  
  ProcedureReturn 1
EndProcedure


; #B2PARTICLEGROUP FUNCTIONS# ===========================================================================================================


; #FUNCTION# ====================================================================================================================
; Name...........: b2ParticleGroup_LoadAll
; Description ...: Loads all the data for the particle groups from the JSON file
; Syntax.........: b2ParticleGroup_LoadAll()
; Parameters ....: 
; Return values .: Success - 1
;				           Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Procedure b2ParticleGroup_LoadAll()
  
  LoadJSON(4, "particle_group.json")
  ;Debug JSONErrorMessage()
  ExtractJSONMap(JSONValue(4), particle_group_json())       
  
  group_name.s
  
  ForEach particle_group_json()
    
    group_name = MapKey(particle_group_json())
    
    If group_name <> "group name"
      
      ParseJSON(4, particle_group_json(group_name))
      AddMapElement(particle_group(), group_name)
      
      particle_group()\system_name       = GetJSONString(GetJSONElement(JSONValue(4), 0))
      particle_group()\active            = GetJSONInteger(GetJSONElement(JSONValue(4), 1))
      particle_group()\angle             = GetJSONDouble(GetJSONElement(JSONValue(4), 2))
      particle_group()\angularVelocity   = GetJSONDouble(GetJSONElement(JSONValue(4), 3))
      particle_group()\colorR            = GetJSONDouble(GetJSONElement(JSONValue(4), 4))
      particle_group()\colorG            = GetJSONDouble(GetJSONElement(JSONValue(4), 5))
      particle_group()\colorB            = GetJSONDouble(GetJSONElement(JSONValue(4), 6))
      particle_group()\colorA            = GetJSONDouble(GetJSONElement(JSONValue(4), 7))
      particle_group()\flags             = GetJSONString(GetJSONElement(JSONValue(4), 8))
      particle_group()\group             = GetJSONDouble(GetJSONElement(JSONValue(4), 9))
      particle_group()\groupFlags        = GetJSONString(GetJSONElement(JSONValue(4), 10))
      particle_group()\lifetime          = GetJSONDouble(GetJSONElement(JSONValue(4), 11))
      particle_group()\linearVelocityX   = GetJSONDouble(GetJSONElement(JSONValue(4), 12))
      particle_group()\linearVelocityY   = GetJSONDouble(GetJSONElement(JSONValue(4), 13))
      particle_group()\positionX         = GetJSONDouble(GetJSONElement(JSONValue(4), 14))
      particle_group()\positionY         = GetJSONDouble(GetJSONElement(JSONValue(4), 15))
      particle_group()\positionData      = GetJSONDouble(GetJSONElement(JSONValue(4), 16))
      particle_group()\particleCount     = GetJSONDouble(GetJSONElement(JSONValue(4), 17))
      particle_group()\strength          = GetJSONDouble(GetJSONElement(JSONValue(4), 18))
      particle_group()\stride            = GetJSONDouble(GetJSONElement(JSONValue(4), 19))
      particle_group()\userData          = GetJSONDouble(GetJSONElement(JSONValue(4), 20))
      particle_group()\px                = GetJSONDouble(GetJSONElement(JSONValue(4), 21))
      particle_group()\py                = GetJSONDouble(GetJSONElement(JSONValue(4), 22))
      particle_group()\radius            = GetJSONDouble(GetJSONElement(JSONValue(4), 23))
    EndIf
  Next

  ProcedureReturn 1
EndProcedure


; #B2WORLD FUNCTIONS# ===========================================================================================================


; #FUNCTION# ====================================================================================================================
; Name...........: b2World_CreateParticleSystemEx
; Description ...: Creates a particle system for a given system name (from the JSON data)
; Syntax.........: b2World_CreateParticleSystemEx(system_name.s)
; Parameters ....: system_name = the name of the system (in the JSON data)
; Return values .: Success - 1
;				           Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Procedure b2World_CreateParticleSystemEx(system_name.s)
  
  tmp_particle_system_ptr.l = b2World_CreateParticleSystem(world, particle_system(system_name)\colorMixingStrength, particle_system(system_name)\dampingStrength, particle_system(system_name)\destroyByAge, particle_system(system_name)\ejectionStrength, particle_system(system_name)\elasticStrength, particle_system(system_name)\lifetimeGranularity, particle_system(system_name)\powderStrength, particle_system(system_name)\pressureStrength, particle_system(system_name)\particleRadius, particle_system(system_name)\repulsiveStrength, particle_system(system_name)\springStrength, particle_system(system_name)\staticPressureIterations, particle_system(system_name)\staticPressureRelaxation, particle_system(system_name)\staticPressureStrength, particle_system(system_name)\surfaceTensionNormalStrength, particle_system(system_name)\surfaceTensionPressureStrength, particle_system(system_name)\viscousStrength)
  b2ParticleSystem_SetDensity(tmp_particle_system_ptr, particle_system(system_name)\particleDensity)
  particle_system(system_name)\particle_system_ptr = tmp_particle_system_ptr

  ProcedureReturn 1
EndProcedure

; #FUNCTION# ====================================================================================================================
; Name...........: b2World_CreateParticleGroupEx
; Description ...: Creates a particle group for a given group name (from the JSON data)
; Syntax.........: b2World_CreateParticleGroupEx(group_name.s)
; Parameters ....: group_name = the name of the group (in the JSON data)
; Return values .: Success - 1
;				           Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Procedure b2World_CreateParticleGroupEx(group_name.s)
          
  flags_int.i
  
  If particle_group(group_name)\flags = "water"
    
    flags_int = #b2_waterParticle
  EndIf
  
  If particle_group(group_name)\flags = "zombie"
    
    flags_int = #b2_zombieParticle
  EndIf
  
  If particle_group(group_name)\flags = "wall"
    
    flags_int = #b2_wallParticle
  EndIf
  
  If particle_group(group_name)\flags = "spring"
    
    flags_int = #b2_springParticle
  EndIf
  
  If particle_group(group_name)\flags = "elastic"
    
    flags_int = #b2_elasticParticle
  EndIf
  
  If particle_group(group_name)\flags = "viscous"
    
    flags_int = #b2_viscousParticle
  EndIf
  
  If particle_group(group_name)\flags = "powder"
    
    flags_int = #b2_powderParticle
  EndIf
  
  If particle_group(group_name)\flags = "tensile"
    
    flags_int = #b2_tensileParticle
  EndIf
  
  If particle_group(group_name)\flags = "color mixing"
    
    flags_int = #b2_colorMixingParticle
  EndIf
  
  If particle_group(group_name)\flags = "destruction listener"
    
    flags_int = #b2_destructionListenerParticle
  EndIf
  
  If particle_group(group_name)\flags = "barrier"
    
    flags_int = #b2_barrierParticle
  EndIf
  
  If particle_group(group_name)\flags = "static pressure"
    
    flags_int = #b2_staticPressureParticle
  EndIf
  
  If particle_group(group_name)\flags = "reactive"
    
    flags_int = #b2_reactiveParticle
  EndIf
  
  If particle_group(group_name)\flags = "repulsive"
    
    flags_int = #b2_repulsiveParticle
  EndIf
  
  If particle_group(group_name)\flags = "fixture contact listener"
    
    flags_int = #b2_fixtureContactListenerParticle
  EndIf
  
  If particle_group(group_name)\flags = "particle contact listener"
    
    flags_int = #b2_particleContactListenerParticle
  EndIf
  
  If particle_group(group_name)\flags = "fixture contact filter"
    
    flags_int = #b2_fixtureContactFilterParticle
  EndIf
  
  If particle_group(group_name)\flags = "particle contact filter"
    
    flags_int = #b2_particleContactFilterParticle
  EndIf
  
  groupFlags_int.i = -1
  
  If particle_group(group_name)\groupFlags = "solid"
    
    groupFlags_int = #b2_solidParticleGroup
  EndIf
  
  If particle_group(group_name)\groupFlags = "rigid"
    
    groupFlags_int = #b2_rigidParticleGroup
  EndIf
  
  If particle_group(group_name)\groupFlags = "can be empty"
    
    groupFlags_int = #b2_particleGroupCanBeEmpty
  EndIf
  
  If particle_group(group_name)\groupFlags = "will be destroyed"
    
    groupFlags_int = #b2_particleGroupWillBeDestroyed
  EndIf
  
  If particle_group(group_name)\groupFlags = "needs update depth"
    
    groupFlags_int = #b2_particleGroupNeedsUpdateDepth
  EndIf
  
  If particle_group(group_name)\groupFlags = "internal mask"
    
    groupFlags_int = #b2_particleGroupInternalMask
  EndIf
  
  tmp_particle_group_ptr.l = b2CircleShape_CreateParticleGroup(particle_system(particle_group(group_name)\system_name)\particle_system_ptr, particle_group(group_name)\angle, particle_group(group_name)\angularVelocity, particle_group(group_name)\colorR, particle_group(group_name)\colorG, particle_group(group_name)\colorB, particle_group(group_name)\colorA, flags_int, particle_group(group_name)\group, groupFlags_int, particle_group(group_name)\lifetime, particle_group(group_name)\linearVelocityX, particle_group(group_name)\linearVelocityY, particle_group(group_name)\positionX, particle_group(group_name)\positionY, particle_group(group_name)\positionData, particle_group(group_name)\particleCount, particle_group(group_name)\strength, particle_group(group_name)\stride, particle_group(group_name)\userData,	particle_group(group_name)\px, particle_group(group_name)\py,	particle_group(group_name)\radius)
  particle_group(group_name)\particle_group_ptr = tmp_particle_group_ptr
    
  ; Update the Particle System with the latest info
  particle_system(particle_group(group_name)\system_name)\particle_count = b2ParticleSystem_GetParticleCount(particle_system(particle_group(group_name)\system_name)\particle_system_ptr)
  particle_system(particle_group(group_name)\system_name)\particle_position_buffer = b2ParticleSystem_GetPositionBuffer(particle_system(particle_group(group_name)\system_name)\particle_system_ptr)
  
  ProcedureReturn 1
EndProcedure

; #FUNCTION# ====================================================================================================================
; Name...........: b2World_CreateEx
; Description ...: Creates a Box2D world, and loads all Box2D and LiquidFun data
; Syntax.........: b2World_CreateEx(gravity_x.f, gravity_y.f)
; Parameters ....: gravity_x = the horizontal component of the gravity
;                  gravity_y = the vertical component of the gravity
; Return values .: Success - 1
;				           Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Procedure b2World_CreateEx(gravity_x.f, gravity_y.f)

  b2Body_LoadAll()  
  glTexture_LoadAll()
  b2Fixture_LoadAll()  
  b2ParticleSystem_LoadAll()
  b2ParticleGroup_LoadAll()
  b2Joint_LoadAll()
  
  gravity\x = gravity_x
  gravity\y = gravity_y
  world = b2World_Create(gravity\x, gravity\y)
  
  ProcedureReturn 1
EndProcedure








  








Procedure b2World_CreateBodyEx(body_name.s)

  body(body_name)\body_ptr = b2World_CreateBody(world, body(body_name)\active, body(body_name)\allowSleep, Radian(body(body_name)\angle), body(body_name)\angularVelocity, body(body_name)\angularDamping, body(body_name)\awake, body(body_name)\bullet, body(body_name)\fixedRotation, body(body_name)\gravityScale, body(body_name)\linearDamping, body(body_name)\linearVelocityX, body(body_name)\linearVelocityY, body(body_name)\positionX, body(body_name)\positionY, body(body_name)\type, body(body_name)\userData)

EndProcedure

Procedure b2World_CreateBodies()
              
  ResetMap(body())

  While NextMapElement(body())
    
    If body()\active = 1
      
      b2World_CreateBodyEx(MapKey(body()))
    EndIf
  Wend

EndProcedure


Procedure b2World_DestroyBodies()
  
    ; Destroy the Box2D Bodies  
    ResetMap(body())
    
    While NextMapElement(body())
      
      If body()\active = 1

        b2World_DestroyBody(world, body()\body_ptr)
      EndIf
    Wend

EndProcedure

Procedure b2World_CreateFixtures()
  
  
  
            
  ResetMap(fixture())

  While NextMapElement(fixture())

    If FindMapElement(body(), fixture()\body_name) <> 0 And body(fixture()\body_name)\active = 1 ;And b2Body_IsActive(body(fixture()\body_name)\body_ptr) = 1

      If fixture()\shape_type_str = "circle"
        
        fixture()\shape_type = #b2_circle
      EndIf
      
      If fixture()\shape_type_str = "edge"
        
        fixture()\shape_type = #b2_edge
      EndIf
      
      If fixture()\shape_type_str = "polygon"
        
        fixture()\shape_type = #b2_polygon
      EndIf
      
      If fixture()\shape_type_str = "chain"
        
        fixture()\shape_type = #b2_chain
      EndIf
      
      If fixture()\shape_type_str = "box"
        
        fixture()\shape_type = #b2_box
      EndIf
      
      If fixture()\shape_type_str = "sprite"
        
        fixture()\shape_type = #b2_sprite
      EndIf
      
      fixture()\draw_type = -1
      
      If fixture()\draw_type_str = "texture"
        
        fixture()\draw_type = #gl_texture2
      EndIf
      
      If fixture()\draw_type_str = "texture and line loop"
        
        fixture()\draw_type = #gl_texture2_and_line_loop2
      EndIf
      
      If fixture()\draw_type_str = "line loop"
        
        fixture()\draw_type = #gl_line_loop2
      EndIf
      
      If fixture()\draw_type_str = "line strip"
        
        fixture()\draw_type = #gl_line_strip2
      EndIf
      
      b2PolygonShape_CreateFixture(fixture(), body(fixture()\body_name)\body_ptr, fixture()\density, fixture()\friction, fixture()\isSensor, fixture()\restitution, fixture()\categoryBits, fixture()\groupIndex, fixture()\maskBits, fixture()\shape_type, fixture()\vertices_str, fixture()\sprite_size, fixture()\sprite_offset_x, fixture()\sprite_offset_y, fixture()\draw_type, fixture()\line_width, fixture()\line_red, fixture()\line_green, fixture()\line_blue, fixture()\body_offset_x, fixture()\body_offset_y, @texture(fixture()\texture_name))
    EndIf

  
    
  Wend


EndProcedure

Procedure b2World_CreateJointEx(joint_name.s)

  If joint(joint_name)\joint_type = "wheel"
    
    joint(joint_name)\joint_ptr = b2WheelJointDef_Create(world, body(joint(joint_name)\body_a_name)\body_ptr, body(joint(joint_name)\body_b_name)\body_ptr, joint(joint_name)\collideConnected, joint(joint_name)\dampingRatio, joint(joint_name)\enableMotor, joint(joint_name)\frequencyHz, joint(joint_name)\localAnchorAx, joint(joint_name)\localAnchorAy, joint(joint_name)\localAnchorBx, joint(joint_name)\localAnchorBy, joint(joint_name)\localAxisAx, joint(joint_name)\localAxisAy, joint(joint_name)\maxMotorTorque, joint(joint_name)\motorSpeed)
  EndIf

EndProcedure

Procedure b2World_CreateJoints()
  
  ResetMap(joint())

  While NextMapElement(joint())
      
    If joint()\active = 1
      
      b2World_CreateJointEx(MapKey(joint()))
    EndIf
  Wend
EndProcedure


Procedure b2World_DestroyJoints()
  
      ; Destroy the Box2D Joints  
    ResetMap(joint())
    
    While NextMapElement(joint())
      
      If joint()\active = 1

        b2World_DestroyJoint(world, joint()\joint_ptr)
      EndIf
    Wend
    

EndProcedure


; Procedure b2World_CreateTextures()
;   
;   texture_name.s
;   
;   ForEach texture()
;     
;     texture_name = MapKey(texture())
;     
;     If texture_name <> "texture name"
;       
;       file_name.s = texture(texture_name)
;       AddMapElement(texture_struct(), texture_name)
;       glTexture_Create(texture_struct(), file_name)
;     EndIf
;   Next
; 
; EndProcedure


Procedure b2World_CreateParticleSystems()
            
  ResetMap(particle_system())

  While NextMapElement(particle_system())
    
    If particle_system()\active = 1
      
      last_particle_system_name = MapKey(particle_system())
      b2World_CreateParticleSystemEx(last_particle_system_name)
    EndIf
  Wend

EndProcedure

Procedure b2World_DestroyParticleSystems()
  
    ; Destroy the LiquidFun Particle Systems
    ResetMap(particle_system())

    While NextMapElement(particle_system())
      
      If particle_system()\active = 1
        
        b2World_DestroyParticleSystem(world, particle_system()\particle_system_ptr)
      EndIf
    Wend
     
   ; FreeMap(particle_system_struct())
EndProcedure


Procedure b2World_CreateParticleGroups()
      
  ResetMap(particle_group())
     
  While NextMapElement(particle_group())
    
    If particle_group()\active = 1
      
      last_particle_group_name = MapKey(particle_group())
      b2World_CreateParticleGroupEx(last_particle_group_name)
    EndIf
    
  Wend

EndProcedure
 
Procedure b2World_DestroyParticleGroups()

    ; Destroy the LiquidFun Particle Groups
    ResetMap(particle_group())
     
    While NextMapElement(particle_group())
      
      If particle_group()\active = 1
        
        b2ParticleGroup_DestroyParticles(particle_group()\particle_group_ptr, 0)
      EndIf
    Wend
      
  ; FreeMap(particle_group())
  
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
;     
;     ; Destroy the Box2D Fixtures  
; ;    b2Body_DestroyFixture(groundBody, groundBodyFixture\fixture_ptr)
;  ;   b2Body_DestroyFixture(groundBody, groundBodySubFixture1\fixture_ptr)
;  ;   b2Body_DestroyFixture(groundBody, groundBodySubFixture2\fixture_ptr)
;     b2Body_DestroyFixture(body_ptr("body"), fixture_struct("body")\fixture_ptr)
;     b2Body_DestroyFixture(body_ptr("bucket"), fixture_struct("bucket main")\fixture_ptr)
;     b2Body_DestroyFixture(body_ptr("bucket"), fixture_struct("bucket under box 1")\fixture_ptr)
;     b2Body_DestroyFixture(body_ptr("bucket"), fixture_struct("bucket under box 2")\fixture_ptr)
;     b2Body_DestroyFixture(body_ptr("bucket"), fixture_struct("bucket under box 3")\fixture_ptr)
;     b2Body_DestroyFixture(body_ptr("bucket ball"), fixture_struct("bucket ball")\fixture_ptr)
;     b2Body_DestroyFixture(body_ptr("boat"), fixture_struct("boat")\fixture_ptr)
     
  ;  FreeMap(fixture())

  EndIf
  
  
  If destroy_bodies = 1
    
    ; Destroy the Joints
    b2World_DestroyJoints()
  
    ; Destroy the Bodies
    b2World_DestroyBodies()
  EndIf
  
  If destroy_particle_system = 1
    
    ; Destroy the Particle Groups
    b2World_DestroyParticleGroups()
    
    ; Destroy the Particle Systems
    b2World_DestroyParticleSystems()
  
    ; I read in the LiquidFun docs that the particle groups aren't destroyed until the next Step.  So Step below...
    b2World_Step(world, (1 / 60.0), 6, 2)
  EndIf
  
EndProcedure









Procedure glDraw_Fixtures()
    
  ResetMap(fixture())
  
  While NextMapElement(fixture())
    
    If FindMapElement(body(), fixture()\body_name) <> 0 And body(fixture()\body_name)\active = 1

      glDraw_Fixture(fixture())
    EndIf
  Wend
EndProcedure

Procedure glDraw_Particles()
 
  ResetMap(particle_system())
  
  While NextMapElement(particle_system())
    
    If particle_system()\active = 1
      
      glDraw_ParticleSystem(particle_system())
    EndIf
  Wend
EndProcedure






; ===============================================================================================================================

; IDE Options = PureBasic 5.60 (Windows - x86)
; CursorPosition = 2066
; FirstLine = 2037
; Folding = --------
; EnableXP
; EnableUnicode