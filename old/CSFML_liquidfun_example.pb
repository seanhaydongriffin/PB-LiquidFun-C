
XIncludeFile "CSFML.pbi"
XIncludeFile "LiquidFun-C.pbi"
XIncludeFile "LiquidFun-C-Ex.pbi"

Declare fps_timer_proc(*Value)

particlesystem.l
particlegroup.l
Global particlecount.d
positionbuffer.l
circle.l
tmp_sprite_pos.sfVector2f
body_LiquidFun_SFML.pb_LiquidFun_SFML_struct
body2_LiquidFun_SFML.pb_LiquidFun_SFML_struct
body3_LiquidFun_SFML.pb_LiquidFun_SFML_struct
;Dim sprite.l(num_particles)

;OpenConsole()
_CSFML_Startup()

window = _CSFML_sfRenderWindow_create(mode, "LiquidFun and SFML for PureBasic", 6, #Null)
window_hwnd.l = _CSFML_sfRenderWindow_getSystemHandle(window)
_CSFML_sfRenderWindow_setVerticalSyncEnabled(window, 0)

;For i = 0 To (num_particles - 1)

;  sprite(i) = _CSFML_sfSprite_create()
;  _CSFML_sfSprite_setTexture(sprite(i), texture, 1)
;Next

circle_pos.sfVector2f
circle_pos\x = 100
circle_pos\y = 100
circle = _CSFML_sfCircleShape_create()
;Debug (circle)

font.l = _CSFML_sfFont_createFromFile("arial.ttf")
Global info_text.l = _CSFML_sfText_create()
_CSFML_sfText_setFont(info_text, font)
_CSFML_sfText_setCharacterSize(info_text, 12)
text_pos.sfVector2f
text_pos\x = 10
text_pos\y = 10
_CSFML_sfText_setPosition(info_text, text_pos)


; LiquidFun
    
world = b2World_Create(0, -10)

; world, active, allowSleep, angle, angularVelocity, angularDamping, awake, bullet, fixedRotation, gravityScale, linearDamping, linearVelocityX, linearVelocityY, positionX, positionY, type, userData)
body.l = b2World_CreateBody(world, 1, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, -4, 1, 0)
body2.l = b2World_CreateBody(world, 1, 1, Radian(90), 0, 0, 1, 0, 0, 1, 0, 0, 0, -7, -3.5, 1, 0)
body3.l = b2World_CreateBody(world, 1, 1, Radian(90), 0, 0, 1, 0, 0, 1, 0, 0, 0, 7, -3.5, 1, 0)

body_texture.l = _CSFML_sfTexture_createFromFile("platformx3.gif", #Null)
body2_body3_texture.l = _CSFML_sfTexture_createFromFile("platform.gif", #Null)

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
; world, colorMixingStrength, dampingStrength, destroyByAge, ejectionStrength, elasticStrength, lifetimeGranularity, powderStrength, pressureStrength, radius, repulsiveStrength, springStrength, staticPressureIterations, staticPressureRelaxation, staticPressureStrength, surfaceTensionNormalStrength, surfaceTensionPressureStrength, viscousStrength
;particlesystem = b2World_CreateParticleSystem(world, 0, 0.2, 0, 0, 0, 0, 0, 0, 0.025, 0, 0, 0, 0, 0, 0, 0, 0)
;particlesystem = b2World_CreateParticleSystem(world, 0, dampingStrength, 0, 0, 0, 0, 0, 0, particleradius, 1, 1, 1, 1, 1, 1, 1, 1)
;particlesystem = b2World_CreateParticleSystem(world, 0, 0.2, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0)
;Debug (particlesystem)
;b2ParticleSystem_SetDamping(particlesystem, 1)

; particleSystem, angle, angularVelocity, colorR, colorG, colorB, colorA, flags, group, groupFlags, lifetime, linearVelocityX, linearVelocityY, positionX, positionY, positionData, particleCount, strength, stride, userData, px, py,	radius
;particlegroup = b2CircleShape_CreateParticleGroup(particlesystem, 0, 0, 0, 0, 0, 0, #b2_waterParticle, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 2)

; Solid
;particlesystem = b2World_CreateParticleSystem(world, 0, dampingStrength, 0, 0, 0, 0, 0, 0, particleradius, 0, 0, 0, 0, 0, 0, 0, 0)
;particlesystem = b2World_CreateParticleSystem(world, 0, dampingStrength, 0, 0, 0, 0, 0, 1, particleradius, 0, 0, 0, 0, 0, 0, 0, 0)
;particlegroup = b2CircleShape_CreateParticleGroup(particlesystem, 0, 0, 0, 0, 0, 0, 0, 0, #b2_solidParticleGroup, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 2)
; Rigid
;particlesystem = b2World_CreateParticleSystem(world, 0, dampingStrength, 0, 0, 0, 0, 0, 0, particleradius, 0, 0, 0, 0, 0, 0, 0, 0)
;particlegroup = b2CircleShape_CreateParticleGroup(particlesystem, 0, 0, 0, 0, 0, 0, 0, 0, #b2_rigidParticleGroup, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 2)
; Elastic
;particlesystem = b2World_CreateParticleSystem(world, 0, dampingStrength, 0, 0, 0, 0, 0, 0, particleradius, 0, 0, 0, 0, 0, 0, 0, 0)
;particlesystem = b2World_CreateParticleSystem(world, 0, dampingStrength, 0, 0, 0, 0, 0, 1, particleradius, 0, 0, 0, 0, 0, 0, 0, 0)
;particlegroup = b2CircleShape_CreateParticleGroup(particlesystem, 0, 0, 0, 0, 0, 0, #b2_elasticParticle, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 2)
; Color-mixing
;particlesystem = b2World_CreateParticleSystem(world, 0, dampingStrength, 0, 0, 0, 0, 0, 0, particleradius, 0, 0, 0, 0, 0, 0, 0, 0)
;particlegroup = b2CircleShape_CreateParticleGroup(particlesystem, 0, 0, 0, 0, 0, 0, #b2_colorMixingParticle, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 2)
; Powder
;particlesystem = b2World_CreateParticleSystem(world, 0, dampingStrength, 0, 0, 0, 0, 0, 1, particleradius, 0, 0, 0, 0, 0, 0, 0, 0)
;particlesystem = b2World_CreateParticleSystem(world, 0, dampingStrength, 0, 0, 0, 0, 1, 0, particleradius, 0, 0, 0, 0, 0, 0, 0, 0)
;particlegroup = b2CircleShape_CreateParticleGroup(particlesystem, 0, 0, 0, 0, 0, 0, #b2_powderParticle, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 2)
; Spring
;particlesystem = b2World_CreateParticleSystem(world, 0, dampingStrength, 0, 0, 0, 0, 0, 1, particleradius, 0, 0, 0, 0, 0, 0, 0, 0)
;particlegroup = b2CircleShape_CreateParticleGroup(particlesystem, 0, 0, 0, 0, 0, 0, #b2_springParticle, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 2)
; Tensile
;particlesystem = b2World_CreateParticleSystem(world, 0, dampingStrength, 0, 0, 0, 0, 0, 0, particleradius, 0, 0, 0, 0, 0, 0, 1, 0)
;particlesystem = b2World_CreateParticleSystem(world, 0, dampingStrength, 0, 0, 0, 0, 0, 0, particleradius, 0, 0, 0, 0, 0, 1, 0, 0)
;particlesystem = b2World_CreateParticleSystem(world, 0, dampingStrength, 0, 0, 0, 0, 0, 1, particleradius, 0, 0, 0, 0, 0, 0, 0, 0)
;particlegroup = b2CircleShape_CreateParticleGroup(particlesystem, 0, 0, 0, 0, 0, 0, #b2_tensileParticle, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 2)
; Viscous
;particlesystem = b2World_CreateParticleSystem(world, 0, dampingStrength, 0, 0, 0, 0, 0, 0, particleradius, 0, 0, 0, 0, 0, 0, 0, 1)
;particlesystem = b2World_CreateParticleSystem(world, 0, dampingStrength, 0, 0, 0, 0, 0, 1, particleradius, 0, 0, 0, 0, 0, 0, 0, 0)
;particlegroup = b2CircleShape_CreateParticleGroup(particlesystem, 0, 0, 0, 0, 0, 0, #b2_viscousParticle, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 2)
; Static Pressure
;particlesystem = b2World_CreateParticleSystem(world, 0, dampingStrength, 0, 0, 0, 0, 0, 1, particleradius, 0, 0, 0, 0, 0, 0, 0, 0)
;particlegroup = b2CircleShape_CreateParticleGroup(particlesystem, 0, 0, 0, 0, 0, 0, #b2_staticPressureParticle, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 2)
; Wall
;particlesystem = b2World_CreateParticleSystem(world, 0, dampingStrength, 0, 0, 0, 0, 0, 0, particleradius, 0, 0, 0, 0, 0, 0, 0, 0)
;particlegroup = b2CircleShape_CreateParticleGroup(particlesystem, 0, 0, 0, 0, 0, 0, #b2_wallParticle, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 2)
; Barrier
;particlesystem = b2World_CreateParticleSystem(world, 0, dampingStrength, 0, 0, 0, 0, 0, 0, particleradius, 0, 0, 0, 0, 0, 0, 0, 0)
;particlegroup = b2CircleShape_CreateParticleGroup(particlesystem, 0, 0, 0, 0, 0, 0, #b2_wallParticle | #b2_barrierParticle, 0, #b2_solidParticleGroup, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 2)

; Experimental
;particlesystem = b2World_CreateParticleSystem(world, 0, dampingStrength, 0, 0, 0, 0, 1, 0, particleradius, 0, 0, 0, 0, 0, 0, 1, 1)
;particlegroup = b2CircleShape_CreateParticleGroup(particlesystem, 0, 0, 0, 0, 0, 0, #b2_powderParticle | #b2_viscousParticle | #b2_tensileParticle, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 2)

; Wave Machine Original
;particlesystem = b2World_CreateParticleSystem(world, 0.5, 0.2, 1, 0.5, 0.25, 0.016666666666666666, 0.5, 0.05, 0.025, 1, 0.25, 8, 0.2, 0.2, 0.2, 0.2, 0.25)
;particlegroup = b2CircleShape_CreateParticleGroup(particlesystem, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 1, 0, 0, 0, 0, 2)

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


_CSFML_sfCircleShape_setRadius(circle, particleradius * 50)
_CSFML_sfCircleShape_setFillColor_rgba(circle, 0, 0, 0, 0)
_CSFML_sfCircleShape_setOutlineColor_rgba(circle, 255, 255, 255, 255)
_CSFML_sfCircleShape_setOutlineThickness(circle, 1)
frame_timer = ElapsedMilliseconds()
Global num_frames.i = 0
Global fps.i = 0
CreateThread(@fps_timer_proc(), 1000)

walls_angular_velocity.d = 10
b2Body_SetAngularVelocity(body_LiquidFun_SFML\b2Body_ptr, Radian(walls_angular_velocity))


;Debug (*tmp_pos_arr_ptr)

While (_CSFML_sfRenderWindow_isOpen(window))

  While (_CSFML_sfRenderWindow_pollEvent(window, event))
    
    If event\type = #sfEvtClosed
      
      _CSFML_sfRenderWindow_close(window)
    EndIf
  Wend
  
  If (ElapsedMilliseconds() - frame_timer) > (16)
    
    frame_timer = ElapsedMilliseconds()

    b2World_Step(world, (1 / 60.0), 6, 2)
    
  ;  _CSFML_sfRenderWindow_clear(window, white)
   ; _CSFML_sfRenderWindow_clear_rgba(window, 255, 255, 255, 255)
    _CSFML_sfRenderWindow_clear_rgba(window, 0, 0, 0, 255)
    
    ; animate text
    _CSFML_sfRenderWindow_drawText(window, info_text, #Null)
    
    ; animate rigid bodies
    
    
    body_angle.f = b2Body_GetAngle(body_LiquidFun_SFML\b2Body_ptr)

    If body_angle.f < Radian(-20)
      
      b2Body_SetAngle(body_LiquidFun_SFML\b2Body_ptr, Radian(-20))
      walls_angular_velocity = -walls_angular_velocity
      b2Body_SetAngularVelocity(body_LiquidFun_SFML\b2Body_ptr, Radian(walls_angular_velocity))
    EndIf

    If body_angle.f > Radian(20)
      
      b2Body_SetAngle(body_LiquidFun_SFML\b2Body_ptr, Radian(20))
      walls_angular_velocity = -walls_angular_velocity
      b2Body_SetAngularVelocity(body_LiquidFun_SFML\b2Body_ptr, Radian(walls_angular_velocity))
    EndIf
    
    
    animate_body_sprite(body_LiquidFun_SFML\b2Body_ptr, body_LiquidFun_SFML\sfSprite_ptr)
    animate_body_sprite(body2_LiquidFun_SFML\b2Body_ptr, body2_LiquidFun_SFML\sfSprite_ptr)
    animate_body_sprite(body3_LiquidFun_SFML\b2Body_ptr, body3_LiquidFun_SFML\sfSprite_ptr)
    
    ; animate particles
    *positionbuffer_ptr.b2Vec2 = positionbuffer
    
    ; for each particle in the group
;    For i = 0 To (particlecount - 1)
    For i = 0 To 0
      
      Debug (*positionbuffer_ptr\x)
      tmp_sprite_pos\x = 400 + (*positionbuffer_ptr\x * 50)
      tmp_sprite_pos\y = 300 - (*positionbuffer_ptr\y * 50)
      _CSFML_sfCircleShape_setPosition(circle, tmp_sprite_pos)
      _CSFML_sfRenderWindow_drawCircleShape(window, circle, #Null)
      
      ; point to the next particle
      *positionbuffer_ptr + SizeOf(b2Vec2)
    Next
    
  
    _CSFML_sfRenderWindow_display(window)
    
    num_frames = num_frames + 1

  EndIf
Wend


_CSFML_sfRenderWindow_destroy(window)
_CSFML_Shutdown()




Procedure fps_timer_proc(*Value)
  
  fps_timer = ElapsedMilliseconds()

  While (_CSFML_sfRenderWindow_isOpen(window))
  
    If (ElapsedMilliseconds() - fps_timer) > 1000
      
      fps_timer = ElapsedMilliseconds()
      fps = num_frames + 1
      num_frames = 0
      
     ; Debug("fps = " + Str(fps) + ", number of bodies = " + Str(num_bodies))
      _CSFML_sfText_setString(info_text, "Info" + Chr(10) + 
                                         "----" + Chr(10) + 
                                         "number of bodies = " + Str(particlecount) + Chr(10) + 
                                         "fps = " + Str(fps))
      
    EndIf
  Wend


EndProcedure

  
; IDE Options = PureBasic 5.40 LTS (Windows - x86)
; CursorPosition = 217
; FirstLine = 199
; Folding = -
; EnableUnicode
; EnableXP
; Executable = CSFML_liquidfun_example.exe