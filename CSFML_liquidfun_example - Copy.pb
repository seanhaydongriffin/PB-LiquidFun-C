
XIncludeFile "CSFML.pbi"

ImportC "seandlltest.lib"
  
  ; b2World
  b2World_Create.l (x.d, y.d)
  b2World_Step (world.l, Step2.f, vIterations.f, pIterations.f)
  
  ; b2Body
  b2World_CreateBody.l (world.l, active.d, allowSleep.d, angle.d, angularVelocity.d, angularDamping.d, awake.d, bullet.d, fixedRotation.d, gravityScale.d, linearDamping.d, linearVelocityX.d, linearVelocityY.d, positionX.d, positionY.d, type.d, userData.l)
  b2Body_SetAngularVelocity (body.l, angle.d)
	b2Body_GetPosition (body.l, arr.l)
	b2Body_GetAngle.d (body.l)
	b2Body_SetTransform (body.l, x.d, y.d, angle.d)

  ; b2Fixture
  b2CircleShape_CreateFixture.l (body.l, density.d, friction.d, isSensor.d,	restitution.d, userData.d, categoryBits.d, groupIndex.d, maskBits.d, px.d, py.d, radius.d)
  b2PolygonShape_CreateFixture_4.l (body.l, density.d, friction.d, isSensor.d, restitution.d, userData.d, categoryBits.d, groupIndex.d, maskBits.d, x0.d, y0.d,	x1.d, y1.d, x2.d, y2.d, x3.d, y3.d)

  ; b2ParticleSystem
  b2World_CreateParticleSystem.l (world.l, colorMixingStrength.d, dampingStrength.d, destroyByAge.d, ejectionStrength.d, elasticStrength.d, lifetimeGranularity.d, powderStrength.d, pressureStrength.d, radius.d, repulsiveStrength.d, springStrength.d, staticPressureIterations.d, staticPressureRelaxation.d, staticPressureStrength.d, surfaceTensionNormalStrength.d, surfaceTensionPressureStrength.d, viscousStrength.d)
  b2ParticleSystem_GetParticleCount.d (particleSystem.l) 
  b2ParticleSystem_GetPositionBuffer.l (particleSystem.l)
  b2ParticleSystem_SetDensity (particleSystem.l, density.d)
  b2ParticleSystem_SetDamping (particleSystem.l, damping.d)

  
  ; b2Particle
  b2ParticleSystem_CreateParticle.l (particleSystem.l, colorR.d, colorB.d, colorG.d, colorA.d, flags.d, group.d, lifetime.d, positionX.d, positionY.d, userData.d, velocityX.d, velocityY.d)
  
  ; b2ParticleGroup
  b2CircleShape_CreateParticleGroup.l (particleSystem.l, angle.d, angularVelocity.d, colorR.d, colorG.d, colorB.d, colorA.d, flags.d, group.d, groupFlags.d, lifetime.d, linearVelocityX.d, linearVelocityY.d, positionX.d, positionY.d, positionData.d, particleCount.d, strength.d, stride.d, userData.d,	px.d, py.d,	radius.d)
  b2ParticleGroup_GetParticleCount.d (particleGroup.l)
EndImport

Declare animate_body_sprite(tmp_body.l, tmp_sprite.l)
Declare b2Body_SetAngle(tmp_body.l, tmp_angle.d)

Structure Vec2 Align #PB_Structure_AlignC
  x.f
  y.f 
EndStructure


;num_particles.i = 315
;particleradius.d = 0.025

Enumeration b2ParticleFlag
  #b2_waterParticle = 0
  #b2_zombieParticle = 1 << 1
  #b2_wallParticle = 1 << 2
  #b2_springParticle = 1 << 3
  #b2_elasticParticle = 1 << 4
  #b2_viscousParticle = 1 << 5
  #b2_powderParticle = 1 << 6
  #b2_tensileParticle = 1 << 7
  #b2_colorMixingParticle = 1 << 8
  #b2_destructionListenerParticle = 1 << 9
  #b2_barrierParticle = 1 << 10
  #b2_staticPressureParticle = 1 << 11
  #b2_reactiveParticle = 1 << 12
  #b2_repulsiveParticle = 1 << 13
  #b2_fixtureContactListenerParticle = 1 << 14
  #b2_particleContactListenerParticle = 1 << 15
  #b2_fixtureContactFilterParticle = 1 << 16
  #b2_particleContactFilterParticle = 1 << 17 
EndEnumeration

Enumeration b2ParticleGroupFlag
  #b2_solidParticleGroup = 1 << 0
  #b2_rigidParticleGroup = 1 << 1
  #b2_particleGroupCanBeEmpty = 1 << 2
  #b2_particleGroupWillBeDestroyed = 1 << 3
  #b2_particleGroupNeedsUpdateDepth = 1 << 4
  #b2_particleGroupInternalMask
EndEnumeration

Global window.l
world.l
body.l
body2.l
body3.l
fixture.l
fixture2.l
fixture3.l
particle.l
particlesystem.l
particlegroup.l
particlecount.d
positionbuffer.l
;Dim sprite.l(num_particles)
circle.l
tmp_sfVector2f.sfVector2f
tmp_sprite_pos.sfVector2f


;OpenConsole()

_CSFML_Startup()

sprite_pos.sfVector2f
sprite_pos\x = 100
sprite_pos\y = 100

text_pos.sfVector2f
text_pos\x = 200
text_pos\y = 200

window = _CSFML_sfRenderWindow_create(mode, "fgh", 6, #Null)
window_hwnd.l = _CSFML_sfRenderWindow_getSystemHandle(window)
_CSFML_sfRenderWindow_setVerticalSyncEnabled(window, 0)

body_texture.l = _CSFML_sfTexture_createFromFile("platformx3.gif", #Null)
body2_body3_texture.l = _CSFML_sfTexture_createFromFile("platform.gif", #Null)

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
text.l = _CSFML_sfText_create()
_CSFML_sfText_setFont(text, font)
_CSFML_sfText_setCharacterSize(text, 50)
_CSFML_sfText_setPosition(text, text_pos)


; LiquidFun
    
world = b2World_Create(0, -10)
;Debug (world)

; world, active, allowSleep, angle, angularVelocity, angularDamping, awake, bullet, fixedRotation, gravityScale, linearDamping, linearVelocityX, linearVelocityY, positionX, positionY, type, userData)
body = b2World_CreateBody(world, 1, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, -4, 1, 0)
;Debug (body)

; body, density, friction, isSensor,	restitution, userData, categoryBits, groupIndex, maskBits, px, py, radius)
;fixture = b2CircleShape_CreateFixture(body, 0.1, 0.1, 0, 0.1, 0, 1, 0, 65535, 0, 0, 4)
;fixture = b2PolygonShape_CreateFixture_4(body, 0.1, 0.1, 0, 0.1, 0, 1, 0, 65535, -7.5, -0.5, 7.5, -0.5, 7.5, 0.5, -7.5, 0.5)
;fixture = b2PolygonShape_CreateFixture_4(body, 10, 0.1, 0, 10, 0, 1, 0, 65535, -7.5, 0.5, 7.5, 0.5, 7.5, -0.5, -7.5, -0.5)
fixture = b2PolygonShape_CreateFixture_4(body, 0, 0, 0, 0, 0, 0, 0, 0, -7.5, 0.5, 7.5, 0.5, 7.5, -0.5, -7.5, -0.5)
;Debug (fixture)
body_sprite = _CSFML_sfSprite_create()
_CSFML_sfSprite_setTexture(body_sprite, body_texture, 1)
tmp_sfVector2f\x = 7.5 * 50
tmp_sfVector2f\y = 0.5 * 50
_CSFML_sfSprite_setOrigin(body_sprite, tmp_sfVector2f)


body2 = b2World_CreateBody(world, 1, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, -7, -3, 1, 0)
fixture2 = b2PolygonShape_CreateFixture_4(body2, 0, 0, 0, 0, 0, 0, 0, 0, -2.5, 0.5, 2.5, 0.5, 2.5, -0.5, -2.5, -0.5)
body_sprite2 = _CSFML_sfSprite_create()
_CSFML_sfSprite_setTexture(body_sprite2, body2_body3_texture, 1)
tmp_sfVector2f\x = 2.5 * 50
tmp_sfVector2f\y = 0.5 * 50
_CSFML_sfSprite_setOrigin(body_sprite2, tmp_sfVector2f)
b2Body_SetAngle(body2, Radian(90))

body3 = b2World_CreateBody(world, 1, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 7, -3, 1, 0)
fixture3 = b2PolygonShape_CreateFixture_4(body3, 0, 0, 0, 0, 0, 0, 0, 0, -2.5, 0.5, 2.5, 0.5, 2.5, -0.5, -2.5, -0.5)
body_sprite3 = _CSFML_sfSprite_create()
_CSFML_sfSprite_setTexture(body_sprite3, body2_body3_texture, 1)
tmp_sfVector2f\x = 2.5 * 50
tmp_sfVector2f\y = 0.5 * 50
_CSFML_sfSprite_setOrigin(body_sprite3, tmp_sfVector2f)
b2Body_SetAngle(body3, Radian(90))


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

_CSFML_sfText_setString(text, Str(particlecount))

positionbuffer = b2ParticleSystem_GetPositionBuffer(particlesystem)
;Debug (positionbuffer)


_CSFML_sfCircleShape_setRadius(circle, particleradius * 50)
_CSFML_sfCircleShape_setFillColor_rgba(circle, 0, 0, 0, 0)
_CSFML_sfCircleShape_setOutlineColor_rgba(circle, 0, 255, 0, 255)
_CSFML_sfCircleShape_setOutlineThickness(circle, 1)
frame_timer = ElapsedMilliseconds()

walls_angular_velocity.d = 2.1
b2Body_SetAngularVelocity(body, Radian(walls_angular_velocity))


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
    
   ; _CSFML_sfSprite_setPosition(sprite, sprite_pos)
    
    ; text
    
    _CSFML_sfRenderWindow_drawText(window, text, #Null)
  
  ;  _CSFML_sfRenderWindow_drawSprite(window, sprite, #Null)
    
    ; bodies
    
    animate_body_sprite(body, body_sprite)
    animate_body_sprite(body2, body_sprite2)
    animate_body_sprite(body3, body_sprite3)
    
;    b2Body_GetPosition(body, tmp_pos())
;    tmp_angle = b2Body_GetAngle(body)
;    tmp_sprite_pos\x = 400 + (tmp_pos(0) * 50)
;    tmp_sprite_pos\y = 300 - (tmp_pos(1) * 50)
;    _CSFML_sfSprite_setPosition(body_sprite, tmp_sprite_pos)
;    _CSFML_sfSprite_setRotation(body_sprite, -Degree(tmp_angle))
;    _CSFML_sfRenderWindow_drawSprite(window, body_sprite, #Null)

    ; particles
    
    *positionbuffer_ptr.Vec2 = positionbuffer
  
    For i = 0 To (particlecount - 1)
    
   ;   Debug (*positionbuffer_ptr\x)
  ;    Debug (*positionbuffer_ptr\y)
      
      tmp_sprite_pos\x = 400 + (*positionbuffer_ptr\x * 50)
      tmp_sprite_pos\y = 300 - (*positionbuffer_ptr\y * 50)
      _CSFML_sfCircleShape_setPosition(circle, tmp_sprite_pos)
      _CSFML_sfRenderWindow_drawCircleShape(window, circle, #Null)
  
      
  ;    _CSFML_sfSprite_setPosition(sprite(i), body_sprite_pos)
   ;   _CSFML_sfRenderWindow_drawSprite(window, sprite(i), #Null)
      
  
      
      *positionbuffer_ptr + SizeOf(Vec2)
    
    Next
    
  
    _CSFML_sfRenderWindow_display(window)
  EndIf
Wend


_CSFML_sfRenderWindow_destroy(window)
_CSFML_Shutdown()


Procedure animate_body_sprite(tmp_body.l, tmp_sprite.l) ;, x_offset.f, y_offset.f)
  
  Dim tmp_pos.f(2)
  tmp_angle.d
  tmp_sprite_pos.sfVector2f
    
  b2Body_GetPosition(tmp_body, tmp_pos())
  tmp_angle = b2Body_GetAngle(tmp_body)
  tmp_sprite_pos\x = 400 + (tmp_pos(0) * 50); + (x_offset * 50)
  tmp_sprite_pos\y = 300 - (tmp_pos(1) * 50); + (y_offset * 50)
  _CSFML_sfSprite_setPosition(tmp_sprite, tmp_sprite_pos)
  _CSFML_sfSprite_setRotation(tmp_sprite, -Degree(tmp_angle))
  _CSFML_sfRenderWindow_drawSprite(window, tmp_sprite, #Null)
  
EndProcedure

Procedure b2Body_SetAngle(tmp_body.l, tmp_angle.d)
  
  Dim tmp_pos.f(2)
    
  b2Body_GetPosition(tmp_body, tmp_pos())
  b2Body_SetTransform(tmp_body, tmp_pos(0), tmp_pos(1), tmp_angle)
EndProcedure
  

; IDE Options = PureBasic 5.40 LTS (Windows - x86)
; CursorPosition = 239
; FirstLine = 229
; Folding = -
; EnableUnicode
; EnableXP
; Executable = ..\Box2C_hello2D\Box2C_hello2D.exe