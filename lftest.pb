
;Import "seanjsbindings.lib"
ImportC "seandlltest.lib"
  
;  DisplayHelloFromDLL () ;As "?b2World_Create@@YAPAXNN@Z"
  
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

;DisplayHelloFromDLL()

Structure Vec2 Align #PB_Structure_AlignC
  x.f
  y.f 
EndStructure

world.l
body.l
particle.l
particlesystem.l
particlegroup.l
particlecount.d
positionbuffer.l
    
world = b2World_Create(1,1)
Debug (world)

body = b2World_CreateBody(world, 1, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0)
Debug (body)

; world, colorMixingStrength, dampingStrength, destroyByAge, ejectionStrength, elasticStrength, lifetimeGranularity, powderStrength, pressureStrength, radius, repulsiveStrength, springStrength, staticPressureIterations, staticPressureRelaxation, staticPressureStrength, surfaceTensionNormalStrength, surfaceTensionPressureStrength, viscousStrength
particlesystem = b2World_CreateParticleSystem(world, 0, 0.2, 0, 0, 0, 0, 0, 0, 0.025, 0, 0, 0, 0, 0, 0, 0, 0)
Debug (particlesystem)

;group.d = #Null
;userdata.d = #Null
;particle = b2ParticleSystem_CreateParticle (particlesystem, 0, 0, 0, 0, 0, group, 0, 0, 0, userdata, 0, 0)
;Debug (particle)
;b2ParticleSystem_CreateParticle (particlesystem, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)

;group2.d = #Null
;userdata2.d = #Null
;particle2.l
;particle2 = b2ParticleSystem_CreateParticle (particlesystem, 0, 0, 0, 0, 0, group2, 0, 0, 0, userdata2, 0, 0)
;Debug (particle2)

; particleSystem, angle, angularVelocity, colorR, colorG, colorB, colorA, flags, group, groupFlags, lifetime, linearVelocityX, linearVelocityY, positionX, positionY, positionData, particleCount, strength, stride, userData, px, py,	radius
;particlegroup = b2CircleShape_CreateParticleGroup(particlesystem, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 0, 0, 0, 0, 0, 1)
particlegroup = b2CircleShape_CreateParticleGroup(particlesystem, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1)
Debug (particlegroup)

;particlecount = b2ParticleGroup_GetParticleCount(particlegroup)
;Debug (particlecount)

particlecount = b2ParticleSystem_GetParticleCount(particlesystem)
Debug (particlecount)

positionbuffer = b2ParticleSystem_GetPositionBuffer(particlesystem)
Debug (positionbuffer)
*positionbuffer_ptr.Vec2 = positionbuffer

;For i = 0 To (2226 - 1)
For i = 0 To (10 - 1)
  
  Debug (*positionbuffer_ptr\x)
  Debug (*positionbuffer_ptr\y)
  
  *positionbuffer_ptr + SizeOf(Vec2)
  
Next
;b2World_Step(world, (1 / 60.0), 6, 2)

; IDE Options = PureBasic 5.40 LTS (Windows - x86)
; CursorPosition = 16
; EnableUnicode
; EnableXP