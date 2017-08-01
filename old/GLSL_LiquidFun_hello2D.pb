
XIncludeFile "LiquidFun-C.pbi"


OpenWindow(0, 10, 10, 800, 600, "OpenGL demo")
SetWindowColor(0, RGB(200,220,200))
OpenGLGadget(0, 20, 10, WindowWidth(0)-40 , WindowHeight(0)-20, #PB_OpenGL_Keyboard|#PB_OpenGL_NoFlipSynchronization)
;OpenGLGadget(0, 20, 10, WindowWidth(0)-40 , WindowHeight(0)-20, #PB_OpenGL_NoDepthBuffer)
;OpenGLGadget(0, 20, 10, WindowWidth(0)-40 , WindowHeight(0)-20)
SetActiveGadget(0)

IncludeFile "newFunctions.pbi"

Global ballposx.f = 0.1, ballposy.f = 0.5
Dim ballpos.vec2(1565)
;ballpos(0)\x = 0.0
;ballpos(0)\y = 0.0
;ballpos(1)\x = 1.0
;ballpos(1)\y = 0.5

ShaderSetup()

particlesystem.l
particlegroup.l
Global particlecount.d
Global positionbuffer.l


; setup gravity
Global gravity.b2Vec2
gravity\x = 0.0
gravity\y = -10.0
  
; setup the world
world = b2World_Create(gravity\x, gravity\y)
  
; setup the ground body
; world, active, allowSleep, angle, angularVelocity, angularDamping, awake, bullet, fixedRotation, gravityScale, linearDamping, linearVelocityX, linearVelocityY, positionX, positionY, type, userData)
Global groundBody.l = b2World_CreateBody(world, 1, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, -10, 0, 0)
  
; setup the ground shape and fixture
; body, density, friction, isSensor,	restitution, userData, categoryBits, groupIndex, maskBits, px, py, radius)
Global groundBodyFixture.l = b2PolygonShape_CreateFixture_4(groundBody, 0, 0, 0, 0, 0, 1, 0, 65535, -50, -10, 50, -10, 50, 10, -50, 10)

; setup the body body
; world, active, allowSleep, angle, angularVelocity, angularDamping, awake, bullet, fixedRotation, gravityScale, linearDamping, linearVelocityX, linearVelocityY, positionX, positionY, type, userData)
;Global body.l = b2World_CreateBody(world, 1, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 4, 2, 0)

; setup the body shape and fixture
; body, density, friction, isSensor,	restitution, userData, categoryBits, groupIndex, maskBits, px, py, radius)
;Global bodyFixture.l = b2PolygonShape_CreateFixture_4(body, 0, 0, 0, 0, 0, 1, 0, 65535, -1, -1, 1, -1, 1, 1, -1, 1)


particleradius.d = 0.06
dampingStrength.d = 1.5
particledensity.d = 0.1

; Wave Machine Sean
particlesystem = b2World_CreateParticleSystem(world, 0.5, 0.2, 1, 0.5, 0.25, 0.016666666666666666, 0.5, 0.05, particleradius, 1, 0.25, 8, 0.2, 0.2, 0.2, 0.2, 0.25)
particlegroup = b2CircleShape_CreateParticleGroup(particlesystem, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 1, 0, 0, 0, 0, 2)
b2ParticleSystem_SetDensity(particlesystem, particledensity)
particlecount = b2ParticleSystem_GetParticleCount(particlesystem)
;Debug(particlecount)
positionbuffer = b2ParticleSystem_GetPositionBuffer(particlesystem)
;Debug (positionbuffer)



Dim tmp_pos.f(2)
  
glUseProgram (shader_programme)

; animation loop
   
Repeat
  
  ; box2d world step
  
  b2World_Step(world, (1 / 60.0), 6, 2)
  
  ; transform bodies
  
  
  matrix_location.l = glGetUniformLocation(shader_programme, "matrix")
  ballpos_ptr.l = glGetUniformLocation(shader_programme, "ballpos")
  ballpos_shift_x_ptr.l = glGetUniformLocation(shader_programme, "ballpos_shift_x")
  ballpos_shift_y_ptr.l = glGetUniformLocation(shader_programme, "ballpos_shift_y")
  glUniformMatrix4fv (matrix_location, 1, #GL_FALSE, @matrix(0,0))
  glUniform2fv (ballpos_ptr, 1565, positionbuffer)
  glUniform1f (ballpos_shift_x_ptr, -8.0)
  glUniform1f (ballpos_shift_y_ptr, -3.0)
  
  ; draw bodies
  
  glClear_(#GL_COLOR_BUFFER_BIT | #GL_DEPTH_BUFFER_BIT);
  glDrawArrays(#GL_QUADS, 0, 4);
  SetGadgetAttribute(0, #PB_OpenGL_FlipBuffers, #True)
  
;  Delay(16)
  
  Event = WindowEvent()

Until Event = #PB_Event_CloseWindow Or quit = 1





; IDE Options = PureBasic 5.60 (Windows - x86)
; CursorPosition = 73
; FirstLine = 70
; EnableXP
; Executable = GLSL_LiquidFun_hello2D.exe
; EnableUnicode