
XIncludeFile "LiquidFun-C.pbi"
XIncludeFile "LiquidFun-C-Ex.pbi"

Declare DrawCube(Gadget)
Declare fps_timer_proc(*Value)


Structure Vec2 Align #PB_Structure_AlignC
  x.f
  y.f 
EndStructure

Global Dim triangle.Vec2(2)


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



OpenWindow(0, 0, 0, 800, 600, "OpenGL Gadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
OpenGLGadget(0, 0, 0, 800, 600, #PB_OpenGL_NoFlipSynchronization )
glMatrixMode_(#GL_PROJECTION)


gluPerspective_(30.0, 200/200, 1.0, 30.0) 
glMatrixMode_(#GL_MODELVIEW)
glTranslatef_(0, 0, -30.0)
glEnable_(#GL_CULL_FACE)    ; This will enhance the rendering speed as all the back face will be

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
particlegroup = b2CircleShape_CreateParticleGroup(particlesystem, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 1, 0, 0, 0, 0, 2)

;particlegroup = b2CircleShape_CreateParticleGroup(particlesystem, 0, 0, 0, 0, 0, 0, #b2_springParticle, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 2)
;Debug (particlegroup)

b2ParticleSystem_SetDensity(particlesystem, particledensity)
particlecount = b2ParticleSystem_GetParticleCount(particlesystem)
;Debug (particlecount)

;_CSFML_sfText_setString(text, Str(particlecount))

positionbuffer = b2ParticleSystem_GetPositionBuffer(particlesystem)
;Debug (positionbuffer)


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
     DrawText(10, 10, "FPS = " + Str(fps))

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
    
  
 ; SetGadgetAttribute(Gadget, #PB_OpenGL_SetContext, #True)
  

  ; clear framebuffer And depth-buffer
  glClear_ (#GL_COLOR_BUFFER_BIT | #GL_DEPTH_BUFFER_BIT)

  glBegin_  (#GL_TRIANGLES)
  
  triangle_size.f = 0.05
  
  For i = 0 To (particlecount - 1)
    
            ;Debug (*positionbuffer_ptr\x)

      glVertex3f_ (*positionbuffer_ptr\x + -triangle_size, *positionbuffer_ptr\y + triangle_size, 0)   
      glVertex3f_ (*positionbuffer_ptr\x + -triangle_size, *positionbuffer_ptr\y + -triangle_size, 0)
      glVertex3f_ (*positionbuffer_ptr\x + triangle_size, *positionbuffer_ptr\y + 0, 0)
      
      ; point to the next particle
      *positionbuffer_ptr + SizeOf(b2Vec2)
    Next

  glEnd_()
  
  SetGadgetAttribute(Gadget, #PB_OpenGL_FlipBuffers, #True)
  
EndProcedure




Procedure HandleError (Result, Text$)
  If Result = 0
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

; IDE Options = PureBasic 5.40 LTS (Windows - x86)
; Folding = -
; EnableUnicode
; EnableXP
; Executable = PB_liquidfun_example.exe