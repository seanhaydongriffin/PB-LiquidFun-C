
XIncludeFile "CSFML.pbi"
XIncludeFile "LiquidFun-C.pbi"
XIncludeFile "LiquidFun-C-Ex.pbi"


particlesystem.l
particlegroup.l
Global particlecount.d
positionbuffer.l
circle.l
tmp_sprite_pos.sfVector2f
body_LiquidFun_SFML.pb_LiquidFun_SFML_struct
body2_LiquidFun_SFML.pb_LiquidFun_SFML_struct
body3_LiquidFun_SFML.pb_LiquidFun_SFML_struct


; LiquidFun
    
world = b2World_Create(0, -10)

; world, active, allowSleep, angle, angularVelocity, angularDamping, awake, bullet, fixedRotation, gravityScale, linearDamping, linearVelocityX, linearVelocityY, positionX, positionY, type, userData)
body.l = b2World_CreateBody(world, 1, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, -4, 1, 0)
body2.l = b2World_CreateBody(world, 1, 1, Radian(90), 0, 0, 1, 0, 0, 1, 0, 0, 0, -7, -3.5, 1, 0)
body3.l = b2World_CreateBody(world, 1, 1, Radian(90), 0, 0, 1, 0, 0, 1, 0, 0, 0, 7, -3.5, 1, 0)


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

b2ParticleSystem_SetDensity(particlesystem, particledensity)
particlecount = b2ParticleSystem_GetParticleCount(particlesystem)

positionbuffer = b2ParticleSystem_GetPositionBuffer(particlesystem)

frame_timer = ElapsedMilliseconds()
Global num_frames.i = 0
Global fps.i = 0


;Debug (*tmp_pos_arr_ptr)

While (1)
  
  
  If (ElapsedMilliseconds() - frame_timer) > (16)
    
    frame_timer = ElapsedMilliseconds()

    b2World_Step(world, (1 / 60.0), 6, 2)
    
    
    ; animate particles
    *positionbuffer_ptr.b2Vec2 = positionbuffer
    
    ; for each particle in the group
;    For i = 0 To (particlecount - 1)
    For i = 0 To 0
      
      Debug (*positionbuffer_ptr\x)
      tmp_sprite_pos\x = 400 + (*positionbuffer_ptr\x * 50)
      tmp_sprite_pos\y = 300 - (*positionbuffer_ptr\y * 50)
      
      ; point to the next particle
      *positionbuffer_ptr + SizeOf(b2Vec2)
    Next
    
    num_frames = num_frames + 1

  EndIf
Wend



; IDE Options = PureBasic 5.40 LTS (Windows - x86)
; CursorPosition = 30
; FirstLine = 6
; EnableUnicode
; EnableXP
; Executable = CSFML_liquidfun_example.exe