
XIncludeFile "LiquidFun-C.pbi"
XIncludeFile "LiquidFun-C-Ex.pbi"

UsePNGImageDecoder()

Declare DrawCube(Gadget)
Declare fps_timer_proc(*Value)


Structure Vec2 Align #PB_Structure_AlignC
  x.f
  y.f 
EndStructure

Structure Vec3 Align #PB_Structure_AlignC
  x.f
  y.f
  z.f
EndStructure




Global RotateSpeedZ.f = 1.0

;Global ZoomFactor.f = 1.0 ; Distance of the camera. Negative value = zoom back
Global ZoomFactor.f = 0 ;-5.01 ; Distance of the camera. Negative value = zoom back





particlesystem.l
particlegroup.l
Global particlecount.d
Global positionbuffer.l
circle.l
tmp_sprite_pos.sfVector2f
body_LiquidFun_SFML.pb_LiquidFun_SFML_struct
body2_LiquidFun_SFML.pb_LiquidFun_SFML_struct
body3_LiquidFun_SFML.pb_LiquidFun_SFML_struct
;Dim sprite.l(num_particles)



; Remember! In Paint.NET save images as 32-bit PNG for the below to work
; Also for backward compatibility to OpenGL v1 we use images (textures) with dimensions
;   in powers of 2 - i.e. 2x2, 4x4, 16x16, 32x32, 64x64, 128x128, 256x256

;LoadImage(0, "particle64x64.png")
LoadImage(0, "waterparticle64x64.png")
;LoadImage(0, "waterparticle-2-64x64.png")
Global particle_bitmap.BITMAP
GetObject_(ImageID(0), SizeOf(BITMAP), @particle_bitmap)



OpenWindow(0, 0, 0, 800, 600, "OpenGL Gadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
OpenGLGadget(0, 0, 0, 800, 600, #PB_OpenGL_NoFlipSynchronization )
glMatrixMode_(#GL_PROJECTION)
gluPerspective_(30.0, 200/200, 1.0, 30.0) 
glMatrixMode_(#GL_MODELVIEW)
glTranslatef_(0, 0, -30.0)
glEnable_(#GL_CULL_FACE)    ; This will enhance the rendering speed as all the back face will be
glTexParameteri_(#GL_TEXTURE_2D, #GL_TEXTURE_MIN_FILTER, #GL_LINEAR)
glTexParameteri_(#GL_TEXTURE_2D, #GL_TEXTURE_MAG_FILTER, #GL_LINEAR)
;glTexEnvi_(#GL_TEXTURE_ENV, #GL_TEXTURE_ENV_MODE, #GL_MODULATE)
;glTexEnvi_(#GL_TEXTURE_ENV, #GL_TEXTURE_ENV_MODE, #GL_DECAL)
;glDepthMask_(#GL_FALSE)

; the code below makes alpha channel work for Paint.NET PNG files
glEnable_( #GL_ALPHA_TEST );
glAlphaFunc_( #GL_NOTEQUAL, 0.0 );


; LiquidFun
    
world = b2World_Create(0, -10)

; world, active, allowSleep, angle, angularVelocity, angularDamping, awake, bullet, fixedRotation, gravityScale, linearDamping, linearVelocityX, linearVelocityY, positionX, positionY, type, userData)
Global body.l = b2World_CreateBody(world, 1, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, -4, 1, 0)
Global body2.l = b2World_CreateBody(world, 1, 1, Radian(90), 0, 0, 1, 0, 0, 1, 0, 0, 0, -7, -3.5, 1, 0)
Global body3.l = b2World_CreateBody(world, 1, 1, Radian(90), 0, 0, 1, 0, 0, 1, 0, 0, 0, 7, -3.5, 1, 0)

;body_texture.l = _CSFML_sfTexture_createFromFile("platformx3.gif", #Null)
;body2_body3_texture.l = _CSFML_sfTexture_createFromFile("platform.gif", #Null)

; body, density, friction, isSensor,	restitution, userData, categoryBits, groupIndex, maskBits, px, py, radius)
;fixture = b2CircleShape_CreateFixture(body, 0.1, 0.1, 0, 0.1, 0, 1, 0, 65535, 0, 0, 4)
;fixture = b2PolygonShape_CreateFixture_4(body, 0.1, 0.1, 0, 0.1, 0, 1, 0, 65535, -7.5, -0.5, 7.5, -0.5, 7.5, 0.5, -7.5, 0.5)
;fixture = b2PolygonShape_CreateFixture_4(body, 10, 0.1, 0, 10, 0, 1, 0, 65535, -7.5, 0.5, 7.5, 0.5, 7.5, -0.5, -7.5, -0.5)

b2PolygonShape_CreateFixture_4_sfSprite(body_LiquidFun_SFML, body, body_texture, -7.5, 0.5, 7.5, 0.5, 7.5, -0.5, -7.5, -0.5, 7.5, 0.5)
b2PolygonShape_CreateFixture_4_sfSprite(body2_LiquidFun_SFML, body2, body2_body3_texture, -2.5, 0.5, 2.5, 0.5, 2.5, -0.5, -2.5, -0.5, 2.5, 0.5)
b2PolygonShape_CreateFixture_4_sfSprite(body3_LiquidFun_SFML, body3, body2_body3_texture, -2.5, 0.5, 2.5, 0.5, 2.5, -0.5, -2.5, -0.5, 2.5, 0.5)

;particleradius.d = 0.1
particleradius.d = 0.06
dampingStrength.d = 1.5
particledensity.d = 0.1

; Wave Machine Sean
particlesystem = b2World_CreateParticleSystem(world, 0.5, 0.2, 1, 0.5, 0.25, 0.016666666666666666, 0.5, 0.05, particleradius, 1, 0.25, 8, 0.2, 0.2, 0.2, 0.2, 0.25)
particlegroup = b2CircleShape_CreateParticleGroup(particlesystem, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 2)
b2ParticleSystem_SetDensity(particlesystem, particledensity)
particlecount = b2ParticleSystem_GetParticleCount(particlesystem)
;Debug(particlecount)
positionbuffer = b2ParticleSystem_GetPositionBuffer(particlesystem)
;Debug (positionbuffer)


;Global Dim triangles.b2Vec2(particlecount * 3)
;Global Dim triangles.b2Vec2(100 * 3)
Global Dim triangles.Vec3(Int(particlecount) * 4)
Global Dim texVertices.Vec2(Int(particlecount) * 4)
Global Dim texVertices2.Vec2(Int(particlecount))



frame_timer = ElapsedMilliseconds()
Global num_frames.i = 0
Global fps.i = 0
CreateThread(@fps_timer_proc(), 1000)

Global walls_angular_velocity.d = 10
b2Body_SetAngularVelocity(body, Radian(walls_angular_velocity))


StartDrawing(WindowOutput(0))
            
i.i = 1            
            
Repeat
  
  If (ElapsedMilliseconds() - frame_timer) > (16)
    
    frame_timer = ElapsedMilliseconds()

    DrawCube(0)
     DrawText(10, 10, "FPS2 = " + Str(fps) + ", # of bodies = " + Str(particlecount))

    num_frames = num_frames + 1
  EndIf
  
  
  
  Eventxx = WindowEvent()

Until Eventxx = #PB_Event_CloseWindow

StopDrawing()



Procedure DrawCube(Gadget)
  
  b2World_Step(world, (1 / 60.0), 6, 2)
  
  
  
  ; animate rigid bodies
  
  
  body_angle.f = b2Body_GetAngle(body)
  
  If body_angle.f < Radian(-20)
    

    b2Body_SetAngle(body, Radian(-20))
    walls_angular_velocity = -walls_angular_velocity
    b2Body_SetAngularVelocity(body, Radian(walls_angular_velocity))
  EndIf

  If body_angle.f > Radian(20)
    
    b2Body_SetAngle(body, Radian(20))
    walls_angular_velocity = -walls_angular_velocity
    b2Body_SetAngularVelocity(body, Radian(walls_angular_velocity))
  EndIf

   *positionbuffer_ptr.b2Vec2 = positionbuffer
   
  ; background colour
;  glClearColor_(1, 1, 1, 1)

   

   
  
  ;Render triangles using a glVertexPointer ...
 
 ; triangle_size.f = 0.07
  triangle_size.f = 0.2

  For i = 0 To (Int(particlecount) - 1)

    texVertices((i * 4) + 0)\x = 1.0
    texVertices((i * 4) + 0)\y = 1.0
    triangles((i * 4) + 0)\x = *positionbuffer_ptr\x + triangle_size
    triangles((i * 4) + 0)\y = *positionbuffer_ptr\y + triangle_size
    triangles((i * 4) + 0)\z = 0.5
    
    texVertices((i * 4) + 1)\x = 0.0
    texVertices((i * 4) + 1)\y = 1.0
    triangles((i * 4) + 1)\x = *positionbuffer_ptr\x - triangle_size
    triangles((i * 4) + 1)\y = *positionbuffer_ptr\y + triangle_size
    triangles((i * 4) + 1)\z = 0.5
    
    texVertices((i * 4) + 2)\x = 0.0
    texVertices((i * 4) + 2)\y = 0.0
    triangles((i * 4) + 2)\x = *positionbuffer_ptr\x - triangle_size
    triangles((i * 4) + 2)\y = *positionbuffer_ptr\y - triangle_size
    triangles((i * 4) + 2)\z = 0.5
    
    texVertices((i * 4) + 3)\x = 1.0
    texVertices((i * 4) + 3)\y = 0.0
    triangles((i * 4) + 3)\x = *positionbuffer_ptr\x + triangle_size
    triangles((i * 4) + 3)\y = *positionbuffer_ptr\y - triangle_size
    triangles((i * 4) + 3)\z = 0.5
           
    ; point to the next particle
    *positionbuffer_ptr + SizeOf(b2Vec2)

  Next
; 
;   ; clear framebuffer And depth-buffer
  glClear_ (#GL_COLOR_BUFFER_BIT | #GL_DEPTH_BUFFER_BIT)
  
  glDisable_(#GL_LIGHTING)
  
  ; for the particle blending technique either use this line...
 ;  glDisable_(#GL_DEPTH_TEST)
  ; or these two lines ...   
 ;  glEnable_(#GL_DEPTH_TEST)
;   glDepthMask_(#GL_FALSE) 
   
   glEnable_(#GL_TEXTURE_2D)
   glEnable_(#GL_BLEND)
   glBlendFunc_(#GL_SRC_ALPHA,#GL_ONE)
  ; glBlendFunc_(#GL_ONE,#GL_ONE_MINUS_SRC_ALPHA)
 ;  glBlendFunc_(#GL_ONE_MINUS_SRC_ALPHA,#GL_ONE)
  
  ; enable texture mapping
  glEnable_(#GL_TEXTURE_2D)
  glBindTexture_(#GL_TEXTURE_2D, TextureID)
   
  glTexImage2D_(#GL_TEXTURE_2D, 0, #GL_RGBA, ImageWidth(0), ImageHeight(0), 0, #GL_BGRA_EXT, #GL_UNSIGNED_BYTE, particle_bitmap\bmBits)
  
  glEnableClientState_(#GL_VERTEX_ARRAY )
  glEnableClientState_ (#GL_TEXTURE_COORD_ARRAY_EXT); 
  glVertexPointer_( 3, #GL_FLOAT, SizeOf(Vec3), @triangles(0)\x )
  glTexCoordPointer_(2, #GL_FLOAT, SizeOf(Vec2), @texVertices(0)\x)
  glDrawArrays_( #GL_QUADS, 0, ArraySize(triangles()) )
  glDisableClientState_( #GL_TEXTURE_COORD_ARRAY_EXT )
  glDisableClientState_( #GL_VERTEX_ARRAY )
   
;   glDisable_( #GL_BLEND );
;   glEnable_( #GL_DEPTH_TEST );
  
  
  
  
  SetGadgetAttribute(Gadget, #PB_OpenGL_FlipBuffers, #True)
  
EndProcedure




Procedure HandleError (Result, Text$)
  If Result = 0
    
    Debug("bad")
    MessageRequester("Error", Text$, 0)
    End
  EndIf
EndProcedure



Procedure fps_timer_proc(*Value)
  
  fps_timer = ElapsedMilliseconds()

  While (1)
  
    If (ElapsedMilliseconds() - fps_timer) > 1000
      
      fps_timer = ElapsedMilliseconds()
      fps = num_frames + 1
      num_frames = 0
      
     ; Debug("fps = " + Str(fps) + ", number of bodies = " + Str(num_bodies))
 ;     _CSFML_sfText_setString(info_text, "Info" + Chr(10) + 
 ;                                        "----" + Chr(10) + 
 ;                                        "number of bodies = " + Str(particlecount) + Chr(10) + 
 ;                                        "fps = " + Str(fps))
      
    EndIf
  Wend


EndProcedure

; IDE Options = PureBasic 5.60 (Windows - x86)
; CursorPosition = 232
; FirstLine = 207
; Folding = -
; EnableXP
; Executable = PB_liquidfun_example.exe
; EnableUnicode