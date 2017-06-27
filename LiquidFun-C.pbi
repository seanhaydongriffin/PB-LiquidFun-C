
; #INDEX# =======================================================================================================================
; Title ............: LiquidFun-C
; PureBasic Version : ?
; Language .........: English
; Description ......: LiquidFun Functions in C
; Author(s) ........: Sean Griffin
; Libraries ........: LiquidFun-C.lib
; ===============================================================================================================================


; #CONSTANTS# ===================================================================================================================
#__epsilon = 0.00001
; ===============================================================================================================================

; #ENUMERATIONS# ===================================================================================================================
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
; ===============================================================================================================================


; #STRUCTURES# ===================================================================================================================
Structure b2Vec2 Align #PB_Structure_AlignC
  x.f
  y.f 
EndStructure
; ===============================================================================================================================

; #GLOBALS# ===================================================================================================================
;Global sfBool.i
; ===============================================================================================================================

; #VARIABLES# ===================================================================================================================
; ===============================================================================================================================

; #FUNCTIONS# ===================================================================================================================
ImportC "LiquidFun-C.lib"
  
  ; b2World
  b2World_Create.l (x.d, y.d)
  b2World_Step (world.l, Step2.f, vIterations.f, pIterations.f)
  
  ; b2Body
  b2World_CreateBody.l (world.l, active.d, allowSleep.d, angle.d, angularVelocity.d, angularDamping.d, awake.d, bullet.d, fixedRotation.d, gravityScale.d, linearDamping.d, linearVelocityX.d, linearVelocityY.d, positionX.d, positionY.d, type.d, userData.l)
  b2Body_SetAngularVelocity (body.l, angle.d)
	b2Body_GetPosition (body.l, arr.l)
	b2Body_GetAngle.d (body.l)
	b2Body_SetTransform (body.l, x.d, y.d, angle.d)
	b2Body_ApplyForce (body.l, forceX.d, forceY.d, pointX.d, pointY.d, wake.d)

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
; ===============================================================================================================================

; IDE Options = PureBasic 5.40 LTS (Windows - x86)
; CursorPosition = 76
; FirstLine = 58
; EnableUnicode
; EnableXP