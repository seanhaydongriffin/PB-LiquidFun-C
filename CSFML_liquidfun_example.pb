
XIncludeFile "CSFML.pbi"

ImportC "seandlltest.lib"
  
  ; b2World
  b2World_Create.l (x.d, y.d)
  b2World_Step (world.l, Step2.f, vIterations.f, pIterations.f)
  
  ; b2Body
  b2World_CreateBody.l (world.l, active.d, allowSleep.d, angle.d, angularVelocity.d, angularDamping.d, awake.d, bullet.d, fixedRotation.d, gravityScale.d, linearDamping.d, linearVelocityX.d, linearVelocityY.d, positionX.d, positionY.d, type.d, userData.l)
    
  ; b2Fixture
  b2CircleShape_CreateFixture.l (body.l, density.d, friction.d, isSensor.d,	restitution.d, userData.d, categoryBits.d, groupIndex.d, maskBits.d, px.d, py.d, radius.d)
  b2PolygonShape_CreateFixture_4.l (body.l, density.d, friction.d, isSensor.d, restitution.d, userData.d, categoryBits.d, groupIndex.d, maskBits.d, x0.d, y0.d,	x1.d, y1.d, x2.d, y2.d, x3.d, y3.d)

  ; b2ParticleSystem
  b2World_CreateParticleSystem.l (world.l, colorMixingStrength.d, dampingStrength.d, destroyByAge.d, ejectionStrength.d, elasticStrength.d, lifetimeGranularity.d, powderStrength.d, pressureStrength.d, radius.d, repulsiveStrength.d, springStrength.d, staticPressureIterations.d, staticPressureRelaxation.d, staticPressureStrength.d, surfaceTensionNormalStrength.d, surfaceTensionPressureStrength.d, viscousStrength.d)
  b2ParticleSystem_GetParticleCount.d (particleSystem.l) 
  b2ParticleSystem_GetPositionBuffer.l (particleSystem.l)
  
  ; b2Particle
  b2ParticleSystem_CreateParticle.l (particleSystem.l, colorR.d, colorB.d, colorG.d, colorA.d, flags.d, group.d, lifetime.d, positionX.d, positionY.d, userData.d, velocityX.d, velocityY.d)
  
  ; b2ParticleGroup
  b2CircleShape_CreateParticleGroup.l (particleSystem.l, angle.d, angularVelocity.d, colorR.d, colorG.d, colorB.d, colorA.d, flags.d, group.d, groupFlags.d, lifetime.d, linearVelocityX.d, linearVelocityY.d, positionX.d, positionY.d, positionData.d, particleCount.d, strength.d, stride.d, userData.d,	px.d, py.d,	radius.d)
  b2ParticleGroup_GetParticleCount.d (particleGroup.l)
EndImport


Structure Vec2 Align #PB_Structure_AlignC
  x.f
  y.f 
EndStructure

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
num_particles.i = 1253
Dim sprite.l(num_particles)
circle.l

;OpenConsole()

_CSFML_Startup()

sprite_pos.sfVector2f
sprite_pos\x = 100
sprite_pos\y = 100

text_pos.sfVector2f
text_pos\x = 200
text_pos\y = 200

window.l = _CSFML_sfRenderWindow_create(mode, "fgh", 6, #Null)
window_hwnd.l = _CSFML_sfRenderWindow_getSystemHandle(window)
_CSFML_sfRenderWindow_setVerticalSyncEnabled(window, 1)

texture.l = _CSFML_sfTexture_createFromFile("smallest_crate.gif", #Null)

For i = 0 To (num_particles - 1)

  sprite(i) = _CSFML_sfSprite_create()
  _CSFML_sfSprite_setTexture(sprite(i), texture, 1)
Next

circle_pos.sfVector2f
circle_pos\x = 100
circle_pos\y = 100
circle = _CSFML_sfCircleShape_create()
_CSFML_sfCircleShape_setRadius(circle, 5)
;Debug (circle)

font.l = _CSFML_sfFont_createFromFile("arial.ttf")
text.l = _CSFML_sfText_create()
_CSFML_sfText_setString(text, "hello")
_CSFML_sfText_setFont(text, font)
_CSFML_sfText_setCharacterSize(text, 50)
_CSFML_sfText_setPosition(text, text_pos)


; LiquidFun
    
world = b2World_Create(0, -10)
;Debug (world)

; world, active, allowSleep, angle, angularVelocity, angularDamping, awake, bullet, fixedRotation, gravityScale, linearDamping, linearVelocityX, linearVelocityY, positionX, positionY, type, userData)
body = b2World_CreateBody(world, 1, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, -4, 0, 0)
;Debug (body)

; body, density, friction, isSensor,	restitution, userData, categoryBits, groupIndex, maskBits, px, py, radius)
;fixture = b2CircleShape_CreateFixture(body, 0.1, 0.1, 0, 0.1, 0, 1, 0, 65535, 0, 0, 4)
;fixture = b2PolygonShape_CreateFixture_4(body, 0.1, 0.1, 0, 0.1, 0, 1, 0, 65535, -7.5, -0.5, 7.5, -0.5, 7.5, 0.5, -7.5, 0.5)
fixture = b2PolygonShape_CreateFixture_4(body, 0.1, 0.1, 0, 0.1, 0, 1, 0, 65535, -7.5, 0.5, 7.5, 0.5, 7.5, -0.5, -7.5, -0.5)
;Debug (fixture)

body2 = b2World_CreateBody(world, 1, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, -7, -4, 0, 0)
fixture2 = b2PolygonShape_CreateFixture_4(body2, 0.1, 0.1, 0, 0.1, 0, 1, 0, 65535, -1, -4, 1, -4, 1, 4, -1, 4)

body3 = b2World_CreateBody(world, 1, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 7, -4, 0, 0)
fixture3 = b2PolygonShape_CreateFixture_4(body3, 0.1, 0.1, 0, 0.1, 0, 1, 0, 65535, -1, -4, 1, -4, 1, 4, -1, 4)


; world, colorMixingStrength, dampingStrength, destroyByAge, ejectionStrength, elasticStrength, lifetimeGranularity, powderStrength, pressureStrength, radius, repulsiveStrength, springStrength, staticPressureIterations, staticPressureRelaxation, staticPressureStrength, surfaceTensionNormalStrength, surfaceTensionPressureStrength, viscousStrength
;particlesystem = b2World_CreateParticleSystem(world, 0, 0.2, 0, 0, 0, 0, 0, 0, 0.025, 0, 0, 0, 0, 0, 0, 0, 0)
particlesystem = b2World_CreateParticleSystem(world, 0, 0, 0, 0, 0, 0, 0, 0, 0.08, 0, 0, 0, 0, 0, 0, 0, 0)
;Debug (particlesystem)


; particleSystem, angle, angularVelocity, colorR, colorG, colorB, colorA, flags, group, groupFlags, lifetime, linearVelocityX, linearVelocityY, positionX, positionY, positionData, particleCount, strength, stride, userData, px, py,	radius
particlegroup = b2CircleShape_CreateParticleGroup(particlesystem, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 3)
;Debug (particlegroup)

particlecount = b2ParticleSystem_GetParticleCount(particlesystem)
;Debug (particlecount)

positionbuffer = b2ParticleSystem_GetPositionBuffer(particlesystem)
;Debug (positionbuffer)


body_sprite_pos.sfVector2f


While (_CSFML_sfRenderWindow_isOpen(window))

  While (_CSFML_sfRenderWindow_pollEvent(window, event))
    
    If event\type = #sfEvtClosed
      
      _CSFML_sfRenderWindow_close(window)
    EndIf
  Wend
  
  b2World_Step(world, (1 / 60.0), 6, 2)
  
;  _CSFML_sfRenderWindow_clear(window, white)
 ; _CSFML_sfRenderWindow_clear_rgba(window, 255, 255, 255, 255)
  _CSFML_sfRenderWindow_clear_rgba(window, 0, 0, 0, 255)
  
 ; _CSFML_sfSprite_setPosition(sprite, sprite_pos)
  
  _CSFML_sfRenderWindow_drawText(window, text, #Null)

;  _CSFML_sfRenderWindow_drawSprite(window, sprite, #Null)
  
  ; particles
  
  *positionbuffer_ptr.Vec2 = positionbuffer

  For i = 0 To (num_particles - 1)
  
 ;   Debug (*positionbuffer_ptr\x)
;    Debug (*positionbuffer_ptr\y)
    
    body_sprite_pos\x = 400 + (*positionbuffer_ptr\x * 50)
    body_sprite_pos\y = 300 - (*positionbuffer_ptr\y * 50)

    
;    _CSFML_sfSprite_setPosition(sprite(i), body_sprite_pos)
 ;   _CSFML_sfRenderWindow_drawSprite(window, sprite(i), #Null)
    
    _CSFML_sfCircleShape_setPosition(circle, body_sprite_pos)
    _CSFML_sfRenderWindow_drawCircleShape(window, circle, #Null)

    
    *positionbuffer_ptr + SizeOf(Vec2)
  
  Next
  

  _CSFML_sfRenderWindow_display(window)
  
Wend


_CSFML_sfRenderWindow_destroy(window)
_CSFML_Shutdown()


; IDE Options = PureBasic 5.40 LTS (Windows - x86)
; CursorPosition = 114
; FirstLine = 93
; EnableUnicode
; EnableXP
; Executable = ..\Box2C_hello2D\Box2C_hello2D.exe