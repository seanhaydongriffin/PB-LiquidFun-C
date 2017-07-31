
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

Enumeration b2ShapeType
    #b2_circle
    #b2_edge
    #b2_polygon
    #b2_chain
    #b2_box
    #b2_sprite
EndEnumeration

Enumeration b2BodyType
    #b2_staticBody
    #b2_kinematicBody
    #b2_dynamicBody
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
  
  
; #B2WORLD FUNCTIONS# =====================================================================================================
  
  
; #FUNCTION# ====================================================================================================================
; Name...........: b2World_Create
; Description ...: Creates a Box2D World (b2World).
; Syntax.........: b2World_Create.l (x.d, y.d)
; Parameters ....: x - the horizontal component of gravity (meters per second)
;				           y - the vertical component of gravity (meters per second)
; Return values .: A pointer (PTR) to the world.
; Author ........: Google
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
b2World_Create.l (x.d, y.d)

; #FUNCTION# ====================================================================================================================
; Name...........: b2World_Step
; Description ...: Steps one frame of animation in a Box2D world.
; Syntax.........: b2World_Step (world.l, Step2.f, vIterations.f, pIterations.f)
; Parameters ....: world - a pointer to the world (b2World)
;				           Step2 - a step value
;				           vIterations -
;				           pIterations -
; Return values .: None
; Author ........: Google
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
b2World_Step (world.l, Step2.f, vIterations.f, pIterations.f)

; #FUNCTION# ====================================================================================================================
; Name...........: b2World_DestroyJoint
; Description ...: Destroys a Box2D joint in a Box2D world.
; Syntax.........: b2World_DestroyJoint(world.l, joint.l)
; Parameters ....: world - a pointer to the world (b2World)
;				           joint - a pointer to the joint (b2Joint)
; Return values .: None
; Author ........: Google
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
b2World_DestroyJoint(world.l, joint.l)


; #B2BODY FUNCTIONS# ============================================================================================================


; #FUNCTION# ====================================================================================================================
; Name...........: b2World_CreateBody
; Description ...: Creates a Box2D body in a Box2D world
; Syntax.........: b2World_CreateBody.l (world.l, active.d, allowSleep.d, angle.d, angularVelocity.d, angularDamping.d, awake.d, bullet.d, fixedRotation.d, gravityScale.d, linearDamping.d, linearVelocityX.d, linearVelocityY.d, positionX.d, positionY.d, type.d, userData.l)
; Parameters ....: world - a pointer (PTR) to the world (b2World) to create the body within
;				           active - 
;				           allowSleep - 
;				           angle - 
;				           angularVelocity - 
;				           angularDamping - 
;				           awake - 
;				           bullet - 
;				           fixedRotation - 
;				           gravityScale - 
;				           linearDamping - 
;				           linearVelocityX - 
;				           linearVelocityY - 
;				           positionX - 
;				           positionY - 
;				           type - 
;				           userData - 
; Return values .: A pointer (PTR) to the body (b2Body)
; Author ........: Google
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
b2World_CreateBody.l (world.l, active.d, allowSleep.d, angle.d, angularVelocity.d, angularDamping.d, awake.d, bullet.d, fixedRotation.d, gravityScale.d, linearDamping.d, linearVelocityX.d, linearVelocityY.d, positionX.d, positionY.d, type.d, userData.l)

; #FUNCTION# ====================================================================================================================
; Name...........: b2World_DestroyBody
; Description ...: Destroys / removes a body from a world
; Syntax.........: b2World_DestroyBody (world.l, body.l)
; Parameters ....: world - a pointer (PTR) to the world (b2World) to remove the body from
;				           body - a pointer (PTR) to the body (b2Body) to remove
; Return values .: None
; Author ........: Google
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
b2World_DestroyBody (world.l, body.l)

; #FUNCTION# ====================================================================================================================
; Name...........: b2Body_GetAngularVelocity
; Description ...: Gets the angular velocity of a body (b2Body)
; Syntax.........: b2Body_GetAngularVelocity.d (body.l)
; Parameters ....: body - a pointer to the body (b2Body)
; Return values .: The angular velocity (meters per second)
; Author ........: Google
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
b2Body_GetAngularVelocity.d (body.l)

; #FUNCTION# ====================================================================================================================
; Name...........: b2Body_SetAngularVelocity
; Description ...: Sets the angular velocity (radians) of a body (b2Body)
; Syntax.........: b2Body_SetAngularVelocity (body.l, angle.d)
; Parameters ....: body - a pointer to the body (b2Body)
;				           angle - the angular velocity (meters per second)
; Return values .: None
; Author ........: Google
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
b2Body_SetAngularVelocity (body.l, angle.d)

; #FUNCTION# ====================================================================================================================
; Name...........: b2Body_GetPosition
; Description ...: Gets the position (vector) of a body (b2Body)
; Syntax.........: b2Body_GetPosition (body.l, arr.l)
; Parameters ....: body - a pointer to the body (b2Body)
;                  arr - a pointer to an array containing the position vector
; Return values .: None
; Author ........: Google
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
b2Body_GetPosition (body.l, arr.l)

; #FUNCTION# ====================================================================================================================
; Name...........: b2Body_GetAngle
; Description ...: Gets the angle (radians) of a body (b2Body)
; Syntax.........: b2Body_GetAngle.d (body.l)
; Parameters ....: body - a pointer to the body (b2Body)
; Return values .: The angle (radians) of the body (b2Body)
; Author ........: Google
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
b2Body_GetAngle.d (body.l)

; #FUNCTION# ====================================================================================================================
; Name...........: b2Body_IsActive
; Description ...: Gets an indicator if the body (b2Body) is active.
; Syntax.........: b2Body_IsActive.d (body.l)
; Parameters ....: body - a pointer to the body (b2Body)
; Return values .: 1 - the body is active
;                  0 - the body is inactive
; Author ........: Google
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
b2Body_IsActive.d (body.l)

; #FUNCTION# ====================================================================================================================
; Name...........: b2Body_SetTransform
; Description ...: Sets the transform of a body (b2Body).
; Syntax.........: b2Body_SetTransform (body.l, x.d, y.d, angle.d)
; Parameters ....: body - a pointer to the body (b2Body)
;				           x -
;				           y -
;				           angle -
; Return values .: None
; Author ........: Google
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
b2Body_SetTransform (body.l, x.d, y.d, angle.d)

; #FUNCTION# ====================================================================================================================
; Name...........: b2Body_ApplyForce
; Description ...: Applies a force to a point on a body (b2Body)
; Syntax.........: b2Body_ApplyForce (body.l, forceX.d, forceY.d, pointX.d, pointY.d, wake.d)
; Parameters ....: body - a pointer to the body (b2Body)
;				           forceX - the horizontal component of the force
;				           forceY - the vertical component of the force
;				           pointX - the horizontal component of the point
;				           pointY - the vertical component of the point
; Return values .: None
; Author ........: Google
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
b2Body_ApplyForce (body.l, forceX.d, forceY.d, pointX.d, pointY.d, wake.d)

; #FUNCTION# ====================================================================================================================
; Name...........: b2Body_ApplyTorque
; Description ...: Applies a torque on a body (b2Body).
; Syntax.........: b2Body_ApplyTorque(body.l, force.d, wake.d)
; Parameters ....: body - a pointer to the body (b2Body)
;				           force - the torque
;                  wake - 
; Return values .: None
; Author ........: Google
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
b2Body_ApplyTorque(body.l, force.d, wake.d)

; #FUNCTION# ====================================================================================================================
; Name...........: b2Body_GetMass
; Description ...: Retrieves the mass of a body (b2Body).
; Syntax.........: b2Body_GetMass.d (body.l)
; Parameters ....: body - a pointer to the body (b2Body)
; Return values .: The mass of the body (in kilograms)
; Author ........: Google
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
b2Body_GetMass.d (body.l)

; #FUNCTION# ====================================================================================================================
; Name...........: b2Body_SetMassData
; Description ...: Sets the mass of a body (b2Body).
; Syntax.........: b2Body_SetMassData (body.l, mass.d, centerX.d, centerY.d, inertia.d)
; Parameters ....: body - a pointer to the body (b2Body)
;                  mass - the mass (in kilograms)
;                  centerX - 
;                  centerY - 
;                  inertia - 
; Return values .: None
; Author ........: Google
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
b2Body_SetMassData (body.l, mass.d, centerX.d, centerY.d, inertia.d)

; #FUNCTION# ====================================================================================================================
; Name...........: b2Body_GetInertia
; Description ...: Retrieves the interia of a body (b2Body).
; Syntax.........: b2Body_GetInertia.d (body.l)
; Parameters ....: body - a pointer to the body (b2Body)
; Return values .: The intertia of the body
; Author ........: Google
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
b2Body_GetInertia.d (body.l)

; #FUNCTION# ====================================================================================================================
; Name...........: b2Body_GetLinearVelocity
; Description ...: Gets the linear velocity (vector) of a body (b2Body)
; Syntax.........: b2Body_GetLinearVelocity (body.l, arr.l)
; Parameters ....: body - a pointer to the body (b2Body)
;                  arr - a pointer to an array containing the velocity vector
; Return values .: None
; Author ........: Google
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
b2Body_GetLinearVelocity (body.l, arr.l)

; #FUNCTION# ====================================================================================================================
; Name...........: b2Body_SetLinearVelocity
; Description ...: Sets the linear velocity of a body (b2Body).
; Syntax.........: b2Body_SetLinearVelocity (body.l, x.d, y.d)
; Parameters ....: body - a pointer to the body (b2Body)
;				           x - the horizontal component of the velocity
;				           y - the vertical component of the velocity
; Return values .: None
; Author ........: Google
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
b2Body_SetLinearVelocity (body.l, x.d, y.d)


; #B2FIXTURE FUNCTIONS# =========================================================================================================


; #FUNCTION# ====================================================================================================================
; Name...........: b2CircleShape_CreateFixture
; Description ...: Creates a fixture for a circle shape and body combination
; Syntax.........: b2CircleShape_CreateFixture.l (body.l, density.d, friction.d, isSensor.d,	restitution.d, userData.d, categoryBits.d, groupIndex.d, maskBits.d, px.d, py.d, radius.d)
; Parameters ....: body - a pointer to the body (b2Body)
;				           density -
;				           friction -
;				           isSensor -
;				           restitution -
;				           userData -
;				           categoryBits -
;				           groupIndex -
;				           maskBits -
;                  px - 
;                  py - 
;                  radius - 
; Return values .: A pointer (PTR) to the fixture (b2Fixture)
; Author ........: Google
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
b2CircleShape_CreateFixture.l (body.l, density.d, friction.d, isSensor.d,	restitution.d, userData.d, categoryBits.d, groupIndex.d, maskBits.d, px.d, py.d, radius.d)

; #FUNCTION# ====================================================================================================================
; Name...........: b2PolygonShape_CreateFixture_3
; Description ...: Creates a fixture for a 3 vector polygon shape and body combination
; Syntax.........: b2PolygonShape_CreateFixture_3.l (body.l, density.d, friction.d, isSensor.d, restitution.d, userData.d, categoryBits.d, groupIndex.d, maskBits.d, x0.d, y0.d,	x1.d, y1.d, x2.d, y2.d)
; Parameters ....: body - a pointer to the body (b2Body)
;				           density -
;				           friction -
;				           isSensor -
;				           restitution -
;				           userData -
;				           categoryBits -
;				           groupIndex -
;				           maskBits -
;                  x0 - 
;                  y0 - 
;                  x1 - 
;                  y1 - 
;                  x2 - 
;                  y2 - 
; Return values .: A pointer (PTR) to the fixture (b2Fixture)
; Author ........: Google
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
b2PolygonShape_CreateFixture_3.l (body.l, density.d, friction.d, isSensor.d, restitution.d, userData.d, categoryBits.d, groupIndex.d, maskBits.d, x0.d, y0.d,	x1.d, y1.d, x2.d, y2.d)

; #FUNCTION# ====================================================================================================================
; Name...........: b2PolygonShape_CreateFixture_4
; Description ...: Creates a fixture for a 4 vector polygon shape and body combination
; Syntax.........: b2PolygonShape_CreateFixture_4.l (body.l, density.d, friction.d, isSensor.d, restitution.d, userData.d, categoryBits.d, groupIndex.d, maskBits.d, x0.d, y0.d,	x1.d, y1.d, x2.d, y2.d, x3.d, y3.d)
; Parameters ....: body - a pointer to the body (b2Body)
;				           density -
;				           friction -
;				           isSensor -
;				           restitution -
;				           userData -
;				           categoryBits -
;				           groupIndex -
;				           maskBits -
;                  x0 - 
;                  y0 - 
;                  x1 - 
;                  y1 - 
;                  x2 - 
;                  y2 - 
;                  x3 - 
;                  y3 - 
; Return values .: A pointer (PTR) to the fixture (b2Fixture)
; Author ........: Google
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
b2PolygonShape_CreateFixture_4.l (body.l, density.d, friction.d, isSensor.d, restitution.d, userData.d, categoryBits.d, groupIndex.d, maskBits.d, x0.d, y0.d,	x1.d, y1.d, x2.d, y2.d, x3.d, y3.d)

; #FUNCTION# ====================================================================================================================
; Name...........: b2PolygonShape_CreateFixture_5
; Description ...: Creates a fixture for a 5 vector polygon shape and body combination
; Syntax.........: b2PolygonShape_CreateFixture_5.l (body.l, density.d, friction.d, isSensor.d, restitution.d, userData.d, categoryBits.d, groupIndex.d, maskBits.d, x0.d, y0.d,	x1.d, y1.d, x2.d, y2.d, x3.d, y3.d, x4.d, y4.d)
; Parameters ....: body - a pointer to the body (b2Body)
;				           density -
;				           friction -
;				           isSensor -
;				           restitution -
;				           userData -
;				           categoryBits -
;				           groupIndex -
;				           maskBits -
;                  x0 - 
;                  y0 - 
;                  x1 - 
;                  y1 - 
;                  x2 - 
;                  y2 - 
;                  x3 - 
;                  y3 - 
;                  x4 - 
;                  y4 - 
; Return values .: A pointer (PTR) to the fixture (b2Fixture)
; Author ........: Google
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
b2PolygonShape_CreateFixture_5.l (body.l, density.d, friction.d, isSensor.d, restitution.d, userData.d, categoryBits.d, groupIndex.d, maskBits.d, x0.d, y0.d,	x1.d, y1.d, x2.d, y2.d, x3.d, y3.d, x4.d, y4.d)

; #FUNCTION# ====================================================================================================================
; Name...........: b2PolygonShape_CreateFixture_6
; Description ...: Creates a fixture for a 6 vector polygon shape and body combination
; Syntax.........: b2PolygonShape_CreateFixture_6.l (body.l, density.d, friction.d, isSensor.d, restitution.d, userData.d, categoryBits.d, groupIndex.d, maskBits.d, x0.d, y0.d,	x1.d, y1.d, x2.d, y2.d, x3.d, y3.d, x4.d, y4.d, x5.d, y5.d)
; Parameters ....: body - a pointer to the body (b2Body)
;				           density -
;				           friction -
;				           isSensor -
;				           restitution -
;				           userData -
;				           categoryBits -
;				           groupIndex -
;				           maskBits -
;                  x0 - 
;                  y0 - 
;                  x1 - 
;                  y1 - 
;                  x2 - 
;                  y2 - 
;                  x3 - 
;                  y3 - 
;                  x4 - 
;                  y4 - 
;                  x5 - 
;                  y5 - 
; Return values .: A pointer (PTR) to the fixture (b2Fixture)
; Author ........: Google
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
b2PolygonShape_CreateFixture_6.l (body.l, density.d, friction.d, isSensor.d, restitution.d, userData.d, categoryBits.d, groupIndex.d, maskBits.d, x0.d, y0.d,	x1.d, y1.d, x2.d, y2.d, x3.d, y3.d, x4.d, y4.d, x5.d, y5.d)

; #FUNCTION# ====================================================================================================================
; Name...........: b2PolygonShape_CreateFixture_7
; Description ...: Creates a fixture for a 7 vector polygon shape and body combination
; Syntax.........: b2PolygonShape_CreateFixture_7.l (body.l, density.d, friction.d, isSensor.d, restitution.d, userData.d, categoryBits.d, groupIndex.d, maskBits.d, x0.d, y0.d,	x1.d, y1.d, x2.d, y2.d, x3.d, y3.d, x4.d, y4.d, x5.d, y5.d, x6.d, y6.d)
; Parameters ....: body - a pointer to the body (b2Body)
;				           density -
;				           friction -
;				           isSensor -
;				           restitution -
;				           userData -
;				           categoryBits -
;				           groupIndex -
;				           maskBits -
;                  x0 - 
;                  y0 - 
;                  x1 - 
;                  y1 - 
;                  x2 - 
;                  y2 - 
;                  x3 - 
;                  y3 - 
;                  x4 - 
;                  y4 - 
;                  x5 - 
;                  y5 - 
;                  x6 - 
;                  y6 - 
; Return values .: A pointer (PTR) to the fixture (b2Fixture)
; Author ........: Google
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
b2PolygonShape_CreateFixture_7.l (body.l, density.d, friction.d, isSensor.d, restitution.d, userData.d, categoryBits.d, groupIndex.d, maskBits.d, x0.d, y0.d,	x1.d, y1.d, x2.d, y2.d, x3.d, y3.d, x4.d, y4.d, x5.d, y5.d, x6.d, y6.d)

; #FUNCTION# ====================================================================================================================
; Name...........: b2PolygonShape_CreateFixture_8
; Description ...: Creates a fixture for a 8 vector polygon shape and body combination
; Syntax.........: b2PolygonShape_CreateFixture_8.l (body.l, density.d, friction.d, isSensor.d, restitution.d, userData.d, categoryBits.d, groupIndex.d, maskBits.d, x0.d, y0.d,	x1.d, y1.d, x2.d, y2.d, x3.d, y3.d, x4.d, y4.d, x5.d, y5.d, x6.d, y6.d, x7.d, y7.d)
; Parameters ....: body - a pointer to the body (b2Body)
;				           density -
;				           friction -
;				           isSensor -
;				           restitution -
;				           userData -
;				           categoryBits -
;				           groupIndex -
;				           maskBits -
;                  x0 - 
;                  y0 - 
;                  x1 - 
;                  y1 - 
;                  x2 - 
;                  y2 - 
;                  x3 - 
;                  y3 - 
;                  x4 - 
;                  y4 - 
;                  x5 - 
;                  y5 - 
;                  x6 - 
;                  y6 - 
;                  x7 - 
;                  y7 - 
; Return values .: A pointer (PTR) to the fixture (b2Fixture)
; Author ........: Google
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
b2PolygonShape_CreateFixture_8.l (body.l, density.d, friction.d, isSensor.d, restitution.d, userData.d, categoryBits.d, groupIndex.d, maskBits.d, x0.d, y0.d,	x1.d, y1.d, x2.d, y2.d, x3.d, y3.d, x4.d, y4.d, x5.d, y5.d, x6.d, y6.d, x7.d, y7.d)

; #FUNCTION# ====================================================================================================================
; Name...........: b2ChainShape_CreateFixture
; Description ...: Creates a fixture for a chain shape and body combination
; Syntax.........: b2ChainShape_CreateFixture.l (body.l,	density.d, friction.d, isSensor.d, restitution.d, userData.d, categoryBits.d, groupIndex.d, maskBits.d,	*vertices.b2Vec2, length.d)
; Parameters ....: body - a pointer to the body (b2Body)
;				           density -
;				           friction -
;				           isSensor -
;				           restitution -
;				           userData -
;				           categoryBits -
;				           groupIndex -
;				           maskBits -
;                  *vertices - 
;                  length - 
; Return values .: A pointer (PTR) to the fixture (b2Fixture)
; Author ........: Google
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
b2ChainShape_CreateFixture.l (body.l,	density.d, friction.d, isSensor.d, restitution.d, userData.d, categoryBits.d, groupIndex.d, maskBits.d,	*vertices.b2Vec2, length.d)

; #FUNCTION# ====================================================================================================================
; Name...........: b2Body_DestroyFixture
; Description ...: Destroys / removes a fixture from a body
; Syntax.........: b2Body_DestroyFixture (body.l, fixture.l)
; Parameters ....: body - a pointer to the body (b2Body)
;				           fixture - a pointer to the fixture (b2Fixture)
; Return values .: None
; Author ........: Google
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
b2Body_DestroyFixture (body.l, fixture.l)


; #B2PARTICLESYSTEM FUNCTIONS# ==================================================================================================


; #FUNCTION# ====================================================================================================================
; Name...........: b2World_CreateParticleSystem
; Description ...: Creates a LiquidFun Particle System in a Box2D world
; Syntax.........: b2World_CreateParticleSystem.l (world.l, colorMixingStrength.d, dampingStrength.d, destroyByAge.d, ejectionStrength.d, elasticStrength.d, lifetimeGranularity.d, powderStrength.d, pressureStrength.d, radius.d, repulsiveStrength.d, springStrength.d, staticPressureIterations.d, staticPressureRelaxation.d, staticPressureStrength.d, surfaceTensionNormalStrength.d, surfaceTensionPressureStrength.d, viscousStrength.d)
; Parameters ....: world - a pointer (PTR) to the world (b2World) to create the system within
;				           colorMixingStrength - 
;				           dampingStrength - 
;				           destroyByAge - 
;				           ejectionStrength - 
;				           elasticStrength - 
;				           lifetimeGranularity - 
;				           powderStrength - 
;				           pressureStrength - 
;				           radius - 
;				           repulsiveStrength - 
;				           springStrength - 
;				           staticPressureIterations - 
;				           staticPressureRelaxation - 
;				           staticPressureStrength - 
;				           surfaceTensionNormalStrength - 
;				           surfaceTensionPressureStrength - 
;				           viscousStrength - 
; Return values .: A pointer (PTR) to the particle system (b2ParticleSystem)
; Author ........: Google
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
b2World_CreateParticleSystem.l (world.l, colorMixingStrength.d, dampingStrength.d, destroyByAge.d, ejectionStrength.d, elasticStrength.d, lifetimeGranularity.d, powderStrength.d, pressureStrength.d, radius.d, repulsiveStrength.d, springStrength.d, staticPressureIterations.d, staticPressureRelaxation.d, staticPressureStrength.d, surfaceTensionNormalStrength.d, surfaceTensionPressureStrength.d, viscousStrength.d)

; #FUNCTION# ====================================================================================================================
; Name...........: b2World_DestroyParticleSystem
; Description ...: Destroys a LiquidFun Particle System from a Box2D world
; Syntax.........: b2World_DestroyParticleSystem (world.l, particleSystem.l)
; Parameters ....: world - a pointer (PTR) to the world (b2World) to destroy the system within
;				           particleSystem - a pointer (PTR) to the particle system (b2ParticleSystem)
; Return values .: None
; Author ........: Google
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
b2World_DestroyParticleSystem (world.l, particleSystem.l)

; #FUNCTION# ====================================================================================================================
; Name...........: b2ParticleSystem_GetParticleCount
; Description ...: Retrieve the number of particles in a LiquidFun Particle System
; Syntax.........: b2ParticleSystem_GetParticleCount.d (particleSystem.l) 
; Parameters ....: particleSystem - a pointer (PTR) to the particle system (b2ParticleSystem)
; Return values .: The number of particles in the system
; Author ........: Google
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
b2ParticleSystem_GetParticleCount.d (particleSystem.l) 

; #FUNCTION# ====================================================================================================================
; Name...........: b2ParticleSystem_GetPositionBuffer
; Description ...: Retrieve the location (pointer) in memory of the positions of the particles in a LiquidFun Particle System
; Syntax.........: b2ParticleSystem_GetPositionBuffer.l (particleSystem.l)
; Parameters ....: particleSystem - a pointer (PTR) to the particle system (b2ParticleSystem)
; Return values .: The memory address of the particle positions
; Author ........: Google
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
b2ParticleSystem_GetPositionBuffer.l (particleSystem.l)

; #FUNCTION# ====================================================================================================================
; Name...........: b2ParticleSystem_SetDensity
; Description ...: Sets the denisty of the particles within a LiquidFun Particle System
; Syntax.........: b2ParticleSystem_SetDensity (particleSystem.l, density.d)
; Parameters ....: particleSystem - a pointer (PTR) to the particle system (b2ParticleSystem)
;                  density - the density
; Return values .: None
; Author ........: Google
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
b2ParticleSystem_SetDensity (particleSystem.l, density.d)

; #FUNCTION# ====================================================================================================================
; Name...........: b2ParticleSystem_SetDamping
; Description ...: Sets the damping of the particles within a LiquidFun Particle System
; Syntax.........: b2ParticleSystem_SetDamping (particleSystem.l, damping.d)
; Parameters ....: particleSystem - a pointer (PTR) to the particle system (b2ParticleSystem)
;                  damping - the damping
; Return values .: None
; Author ........: Google
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
b2ParticleSystem_SetDamping (particleSystem.l, damping.d)


; #B2PARTICLE FUNCTIONS# ========================================================================================================


; #FUNCTION# ====================================================================================================================
; Name...........: b2ParticleSystem_CreateParticle
; Description ...: Creates a LiquidFun Particle in a LiquidFun Particle System
; Syntax.........: b2ParticleSystem_CreateParticle.l (particleSystem.l, colorR.d, colorB.d, colorG.d, colorA.d, flags.d, group.d, lifetime.d, positionX.d, positionY.d, userData.d, velocityX.d, velocityY.d)
; Parameters ....: particleSystem - a pointer (PTR) to the particle system (b2ParticleSystem)
;				           colorR - 
;				           colorB - 
;				           colorG - 
;				           colorA - 
;				           flags - 
;				           group - 
;				           lifetime - 
;				           positionX - 
;				           positionY - 
;				           userData - 
;				           velocityX - 
;				           velocityY - 
; Return values .: A pointer (PTR) to the particle (b2Particle)
; Author ........: Google
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
b2ParticleSystem_CreateParticle.l (particleSystem.l, colorR.d, colorB.d, colorG.d, colorA.d, flags.d, group.d, lifetime.d, positionX.d, positionY.d, userData.d, velocityX.d, velocityY.d)


; #B2PARTICLEGROUP FUNCTIONS# ===================================================================================================


; #FUNCTION# ====================================================================================================================
; Name...........: b2CircleShape_CreateParticleGroup
; Description ...: Creates a LiquidFun Particle Group in a LiquidFun Particle System
; Syntax.........: b2CircleShape_CreateParticleGroup.l (particleSystem.l, angle.d, angularVelocity.d, colorR.d, colorG.d, colorB.d, colorA.d, flags.d, group.d, groupFlags.d, lifetime.d, linearVelocityX.d, linearVelocityY.d, positionX.d, positionY.d, positionData.d, particleCount.d, strength.d, stride.d, userData.d,	px.d, py.d,	radius.d)
; Parameters ....: particleSystem - a pointer (PTR) to the particle system (b2ParticleSystem)
;				           angle - 
;				           angularVelocity - 
;				           colorR - 
;				           colorG - 
;				           colorB - 
;				           colorA - 
;				           flags - 
;				           group - 
;				           groupFlags - 
;				           lifetime - 
;				           linearVelocityX - 
;				           linearVelocityY - 
;				           positionX - 
;				           positionY - 
;				           positionData - 
;				           particleCount - 
;				           strength - 
;				           stride - 
;				           userData - 
;				           px - 
;				           py - 
;				           radius - 
; Return values .: A pointer (PTR) to the particle group (b2ParticleGroup)
; Author ........: Google
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
b2CircleShape_CreateParticleGroup.l (particleSystem.l, angle.d, angularVelocity.d, colorR.d, colorG.d, colorB.d, colorA.d, flags.d, group.d, groupFlags.d, lifetime.d, linearVelocityX.d, linearVelocityY.d, positionX.d, positionY.d, positionData.d, particleCount.d, strength.d, stride.d, userData.d,	px.d, py.d,	radius.d)

; #FUNCTION# ====================================================================================================================
; Name...........: b2ParticleGroup_GetParticleCount
; Description ...: Retrieve the number of particles in a LiquidFun Particle Group
; Syntax.........: b2ParticleGroup_GetParticleCount.d (particleGroup.l)
; Parameters ....: particleSystem - a pointer (PTR) to the particle group (b2ParticleGroup)
; Return values .: The number of particles in the group
; Author ........: Google
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
b2ParticleGroup_GetParticleCount.d (particleGroup.l)

; #FUNCTION# ====================================================================================================================
; Name...........: b2ParticleGroup_DestroyParticles
; Description ...: Destroys the particles in a LiquidFun Particle Group.
; Syntax.........: b2ParticleGroup_DestroyParticles (particleGroup.l, flag.d)
; Parameters ....: particleGroup - a pointer (PTR) to the particle group (b2ParticleGroup) to destroy the particles within
;				           flag - 
; Return values .: None
; Author ........: Google
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
b2ParticleGroup_DestroyParticles (particleGroup.l, flag.d)


; #B2WELDJOINT FUNCTIONS# =======================================================================================================


; #FUNCTION# ====================================================================================================================
; Name...........: b2WeldJointDef_Create
; Description ...: Creates a Box2D weld joint (b2WeldJoint) between two Box2D bodies
; Syntax.........: b2WeldJointDef_Create.l (world.l, bodyA.l, bodyB.l, collideConnected.d, dampingRatio.d, frequencyHz.d, localAnchorAx.d, localAnchorAy.d, localAnchorBx.d, localAnchorBy.d, referenceAngle.d)
; Parameters ....: world - a pointer to the Box2D world (b2World)
;				           bodyA - a pointer to the first Box2D body (b2Body) for the joint
;				           bodyB - a pointer to the second Box2D body (b2Body) for the joint
;				           collideConnected - a boolean (true / false) to indicate if bodyA and bodyB should collide
;				           dampingRatio -
;				           frequencyHz -
;				           localAnchorAx - the horizontal position (vector) within bodyA to attach the joint to
;				           localAnchorAy - the vertical position (vector) within bodyA to attach the joint to
;				           localAnchorBx - the horizontal position (vector) within bodyB to attach the joint to
;                  localAnchorBy - the vertical position (vector) within bodyB to attach the joint to
;                  referenceAngle - 
; Return values .: A pointer (long) to the joint (b2WeldJoint)
; Author ........: Google
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
b2WeldJointDef_Create.l (world.l, bodyA.l, bodyB.l, collideConnected.d, dampingRatio.d, frequencyHz.d, localAnchorAx.d, localAnchorAy.d, localAnchorBx.d, localAnchorBy.d, referenceAngle.d)

; #FUNCTION# ====================================================================================================================
; Name...........: b2WeldJointDef_InitializeAndCreate
; Description ...: Creates (and initializes) a Box2D weld joint (b2WeldJoint) between two Box2D bodies
; Syntax.........: b2WeldJointDef_InitializeAndCreate.l (world.l, bodyA.l, bodyB.l, anchorX.d,	anchorY.d, collideConnected.d, dampingRatio.d, frequencyHz.d)
; Parameters ....: world - a pointer to the Box2D world (b2World)
;				           bodyA - a pointer to the first Box2D body (b2Body) for the joint
;				           bodyB - a pointer to the second Box2D body (b2Body) for the joint
;                  anchorX - 
;                  anchorY - 
;				           collideConnected - a boolean (true / false) to indicate if bodyA and bodyB should collide
;				           dampingRatio -
;				           frequencyHz -
; Return values .: A pointer (long) to the joint (b2WeldJoint)
; Author ........: Google
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
b2WeldJointDef_InitializeAndCreate.l (world.l, bodyA.l, bodyB.l, anchorX.d,	anchorY.d, collideConnected.d, dampingRatio.d, frequencyHz.d)


; #B2REVOLUTEJOINT FUNCTIONS# ===================================================================================================


; #FUNCTION# ====================================================================================================================
; Name...........: b2RevoluteJointDef_Create
; Description ...: Creates a Box2D revolute joint (b2RevoluteJoint) between two Box2D bodies
; Syntax.........: b2RevoluteJointDef_Create.l (world.l, bodyA.l, bodyB.l, collideConnected.d, enableLimit.d, enableMotor.d, lowerAngle.d, localAnchorAx.d, localAnchorAy.d, localAnchorBx.d, localAnchorBy.d, maxMotorTorque.d, motorSpeed.d,	referenceAngle.d, upperAngle.d)
; Parameters ....: world - a pointer to the Box2D world (b2World)
;				           bodyA - a pointer to the first Box2D body (b2Body) for the joint
;				           bodyB - a pointer to the second Box2D body (b2Body) for the joint
;				           collideConnected - a boolean (true / false) to indicate if bodyA and bodyB should collide
;				           enableLimit -
;				           enableMotor -
;				           localAnchorAx - the horizontal position (vector) within bodyA to attach the joint to
;				           localAnchorAy - the vertical position (vector) within bodyA to attach the joint to
;				           localAnchorBx - the horizontal position (vector) within bodyB to attach the joint to
;                  localAnchorBy - the vertical position (vector) within bodyB to attach the joint to
;                  maxMotorTorque - 
;                  motorSpeed - 
;                  referenceAngle - 
;                  upperAngle - 
; Return values .: A pointer (long) to the joint (b2WeldJoint)
; Author ........: Google
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
b2RevoluteJointDef_Create.l (world.l, bodyA.l, bodyB.l, collideConnected.d,	enableLimit.d, enableMotor.d, lowerAngle.d,	localAnchorAx.d, localAnchorAy.d, localAnchorBx.d, localAnchorBy.d, maxMotorTorque.d, motorSpeed.d,	referenceAngle.d, upperAngle.d)

; #FUNCTION# ====================================================================================================================
; Name...........: b2RevoluteJointDef_InitializeAndCreate
; Description ...: Creates (and initializes) a Box2D revolute joint (b2RevoluteJoint) between two Box2D bodies
; Syntax.........: b2RevoluteJointDef_InitializeAndCreate.l (world.l, bodyA.l, bodyB.l, anchorX.d, anchorY.d, collideConnected.d, enableLimit.d,	enableMotor.d, lowerAngle.d, maxMotorTorque.d, motorSpeed.d, upperAngle.d)
; Parameters ....: world - a pointer to the Box2D world (b2World)
;				           bodyA - a pointer to the first Box2D body (b2Body) for the joint
;				           bodyB - a pointer to the second Box2D body (b2Body) for the joint
;                  anchorX - 
;                  anchorY - 
;				           collideConnected - a boolean (true / false) to indicate if bodyA and bodyB should collide
;				           enableLimit -
;				           enableMotor -
;                  lowerAngle - 
;                  maxMotorTorque - 
;                  motorSpeed - 
;                  upperAngle - 
; Return values .: A pointer (long) to the joint (b2WeldJoint)
; Author ........: Google
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
b2RevoluteJointDef_InitializeAndCreate.l (world.l, bodyA.l, bodyB.l, anchorX.d, anchorY.d, collideConnected.d, enableLimit.d,	enableMotor.d, lowerAngle.d, maxMotorTorque.d, motorSpeed.d, upperAngle.d)

; #FUNCTION# ====================================================================================================================
; Name...........: b2RevoluteJoint_EnableLimit
; Description ...: Sets a limit for a Box2D revolute joint (b2RevoluteJoint)
; Syntax.........: b2RevoluteJoint_EnableLimit (joint.l, flag.d)
; Parameters ....: joint - a pointer to the Box2D revolute joint (b2RevoluteJoint)
;				           flag - 
; Return values .: None
; Author ........: Google
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
b2RevoluteJoint_EnableLimit (joint.l, flag.d)

; #FUNCTION# ====================================================================================================================
; Name...........: b2RevoluteJoint_EnableMotor
; Description ...: Enables the motor for a Box2D revolute joint (b2RevoluteJoint)
; Syntax.........: b2RevoluteJoint_EnableMotor (joint.l, flag.d)
; Parameters ....: joint - a pointer to the Box2D revolute joint (b2RevoluteJoint)
;				           flag - 
; Return values .: None
; Author ........: Google
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
b2RevoluteJoint_EnableMotor (joint.l, flag.d)

; #FUNCTION# ====================================================================================================================
; Name...........: b2RevoluteJoint_GetJointAngle
; Description ...: Gets the angle of a Box2D revolute joint (b2RevoluteJoint)
; Syntax.........: b2RevoluteJoint_GetJointAngle.d (joint.l)
; Parameters ....: joint - a pointer to the Box2D revolute joint (b2RevoluteJoint)
; Return values .: The angle (in radians) of the joint
; Author ........: Google
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
b2RevoluteJoint_GetJointAngle.d (joint.l)

; #FUNCTION# ====================================================================================================================
; Name...........: b2RevoluteJoint_IsLimitEnabled
; Description ...: Checks whether a Box2D revolute joint (b2RevoluteJoint) has a limit
; Syntax.........: b2RevoluteJoint_IsLimitEnabled.d (joint.l)
; Parameters ....: joint - a pointer to the Box2D revolute joint (b2RevoluteJoint)
; Return values .: 0 (false) - there isn't a limit
;                  1 (true) - there is a limit
; Author ........: Google
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
b2RevoluteJoint_IsLimitEnabled.d (joint.l)

; #FUNCTION# ====================================================================================================================
; Name...........: b2RevoluteJoint_IsMotorEnabled
; Description ...: Checks whether a Box2D revolute joint (b2RevoluteJoint) has a motor
; Syntax.........: b2RevoluteJoint_IsMotorEnabled.d (joint.l)
; Parameters ....: joint - a pointer to the Box2D revolute joint (b2RevoluteJoint)
; Return values .: 0 (false) - there isn't a motor
;                  1 (true) - there is a motor
; Author ........: Google
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
b2RevoluteJoint_IsMotorEnabled.d (joint.l)

; #FUNCTION# ====================================================================================================================
; Name...........: b2RevoluteJoint_SetMotorSpeed
; Description ...: Sets the speed of the motor for a Box2D revolute joint (b2RevoluteJoint)
; Syntax.........: b2RevoluteJoint_SetMotorSpeed (joint.l, speed.d)
; Parameters ....: joint - a pointer to the Box2D revolute joint (b2RevoluteJoint)
;				           speed - the speed (in meters per second)
; Return values .: None
; Author ........: Google
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
b2RevoluteJoint_SetMotorSpeed (joint.l, speed.d)


; #B2PRISMATICJOINT FUNCTIONS# ==================================================================================================


; #FUNCTION# ====================================================================================================================
; Name...........: b2PrismaticJointDef_Create
; Description ...: Creates a Box2D prismatic joint (b2PrismaticJoint) between two Box2D bodies
; Syntax.........: b2PrismaticJointDef_Create.l (world.l, bodyA.l, bodyB.l, collideConnected.d, enableLimit.d, enableMotor.d, localAnchorAx.d,	localAnchorAy.d, localAnchorBx.d, localAnchorBy.d, localAxisAx.d, localAxisAy.d, lowerTranslation.d, maxMotorForce.d, motorSpeed.d, referenceAngle.d, upperTranslation.d)
; Parameters ....: world - a pointer to the Box2D world (b2World)
;				           bodyA - a pointer to the first Box2D body (b2Body) for the joint
;				           bodyB - a pointer to the second Box2D body (b2Body) for the joint
;				           collideConnected - a boolean (true / false) to indicate if bodyA and bodyB should collide
;				           enableLimit -
;				           enableMotor -
;				           localAnchorAx - the horizontal position (vector) within bodyA to attach the joint to
;				           localAnchorAy - the vertical position (vector) within bodyA to attach the joint to
;				           localAnchorBx - the horizontal position (vector) within bodyB to attach the joint to
;                  localAnchorBy - the vertical position (vector) within bodyB to attach the joint to
;                  localAxisAx - 
;                  localAxisAy - 
;                  lowerTranslation - 
;                  maxMotorForce - 
;                  motorSpeed - 
;                  referenceAngle - 
;                  upperTranslation - 
; Return values .: A pointer (long) to the joint (b2PrismaticJoint)
; Author ........: Google
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
b2PrismaticJointDef_Create.l (world.l, bodyA.l, bodyB.l, collideConnected.d, enableLimit.d, enableMotor.d, localAnchorAx.d,	localAnchorAy.d, localAnchorBx.d, localAnchorBy.d, localAxisAx.d, localAxisAy.d, lowerTranslation.d, maxMotorForce.d, motorSpeed.d, referenceAngle.d, upperTranslation.d)

; #FUNCTION# ====================================================================================================================
; Name...........: b2PrismaticJointDef_InitializeAndCreate
; Description ...: Creates (and initializes) a Box2D prismatic joint (b2PrismaticJoint) between two Box2D bodies
; Syntax.........: b2PrismaticJointDef_InitializeAndCreate.l (world.l,	bodyA.l, bodyB.l, anchorX.d, anchorY.d, axisX.d, axisY.d,	collideConnected.d,	enableLimit.d, enableMotor.d, lowerTranslation.d, maxMotorForce.d, motorSpeed.d, upperTranslation.d)
; Parameters ....: world - a pointer to the Box2D world (b2World)
;				           bodyA - a pointer to the first Box2D body (b2Body) for the joint
;				           bodyB - a pointer to the second Box2D body (b2Body) for the joint
;                  anchorX - 
;                  anchorY - 
;                  axisX - 
;                  axisY - 
;				           collideConnected - a boolean (true / false) to indicate if bodyA and bodyB should collide
;				           enableLimit -
;				           enableMotor -
;                  lowerTranslation - 
;                  maxMotorForce - 
;                  motorSpeed - 
;                  upperTranslation - 
; Return values .: A pointer (long) to the joint (b2PrismaticJoint)
; Author ........: Google
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
b2PrismaticJointDef_InitializeAndCreate.l (world.l,	bodyA.l, bodyB.l, anchorX.d, anchorY.d, axisX.d, axisY.d,	collideConnected.d,	enableLimit.d, enableMotor.d, lowerTranslation.d, maxMotorForce.d, motorSpeed.d, upperTranslation.d)

; #FUNCTION# ====================================================================================================================
; Name...........: b2PrismaticJoint_EnableLimit
; Description ...: Sets a limit for a Box2D prismatic joint (b2PrismaticJoint)
; Syntax.........: b2PrismaticJoint_EnableLimit (joint.l, flag.d)
; Parameters ....: joint - a pointer to the Box2D prismatic joint (b2PrismaticJoint)
;				           flag - 
; Return values .: None
; Author ........: Google
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
b2PrismaticJoint_EnableLimit (joint.l, flag.d)

; #FUNCTION# ====================================================================================================================
; Name...........: b2PrismaticJoint_EnableMotor
; Description ...: Enables the motor for a Box2D prismatic joint (b2PrismaticJoint)
; Syntax.........: b2PrismaticJoint_EnableMotor (joint.l, flag.d)
; Parameters ....: joint - a pointer to the Box2D prismatic joint (b2PrismaticJoint)
;				           flag - 
; Return values .: None
; Author ........: Google
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
b2PrismaticJoint_EnableMotor (joint.l, flag.d)

; #FUNCTION# ====================================================================================================================
; Name...........: b2PrismaticJoint_GetJointTranslation
; Description ...: Gets the translation of a Box2D prismatic joint (b2PrismaticJoint)
; Syntax.........: b2PrismaticJoint_GetJointTranslation (joint.l)
; Parameters ....: joint - a pointer to the Box2D prismatic joint (b2PrismaticJoint)
; Return values .: The translation of the joint
; Author ........: Google
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
b2PrismaticJoint_GetJointTranslation.d (joint.l)

; #FUNCTION# ====================================================================================================================
; Name...........: b2PrismaticJoint_GetMotorSpeed
; Description ...: Gets the speed of the motor for a Box2D prismatic joint (b2PrismaticJoint)
; Syntax.........: b2PrismaticJoint_GetMotorSpeed (joint.l, speed.d)
; Parameters ....: joint - a pointer to the Box2D prismatic joint (b2PrismaticJoint)
; Return values .: The speed of the motor (in meters per second)
; Author ........: Google
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
b2PrismaticJoint_GetMotorSpeed.d (joint.l)

; #FUNCTION# ====================================================================================================================
; Name...........: b2PrismaticJoint_GetMotorForce
; Description ...: Gets the force of the motor for a Box2D prismatic joint (b2PrismaticJoint)
; Syntax.........: b2PrismaticJoint_GetMotorForce (joint.l, hz.d)
; Parameters ....: joint - a pointer to the Box2D prismatic joint (b2PrismaticJoint)
;				           hz - 
; Return values .: The force of the motor
; Author ........: Google
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
b2PrismaticJoint_GetMotorForce.d (joint.l, hz.d)

; #FUNCTION# ====================================================================================================================
; Name...........: b2PrismaticJoint_IsLimitEnabled
; Description ...: Checks whether a Box2D prismatic joint (b2PrismaticJoint) has a limit
; Syntax.........: b2PrismaticJoint_IsLimitEnabled.d (joint.l)
; Parameters ....: joint - a pointer to the Box2D prismatic joint (b2PrismaticJoint)
; Return values .: 0 (false) - there isn't a limit
;                  1 (true) - there is a limit
; Author ........: Google
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
b2PrismaticJoint_IsLimitEnabled.d (joint.l)

; #FUNCTION# ====================================================================================================================
; Name...........: b2PrismaticJoint_IsMotorEnabled
; Description ...: Checks whether a Box2D prismatic joint (b2PrismaticJoint) has a motor
; Syntax.........: b2PrismaticJoint_IsMotorEnabled.d (joint.l)
; Parameters ....: joint - a pointer to the Box2D prismatic joint (b2PrismaticJoint)
; Return values .: 0 (false) - there isn't a motor
;                  1 (true) - there is a motor
; Author ........: Google
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
b2PrismaticJoint_IsMotorEnabled.d (joint.l)

; #FUNCTION# ====================================================================================================================
; Name...........: b2PrismaticJoint_SetMotorSpeed
; Description ...: Sets the speed of the motor for a Box2D prismatic joint (b2PrismaticJoint)
; Syntax.........: b2PrismaticJoint_SetMotorSpeed (joint.l, speed.d)
; Parameters ....: joint - a pointer to the Box2D prismatic joint (b2PrismaticJoint)
;				           speed - the speed (in meters per second)
; Return values .: None
; Author ........: Google
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
b2PrismaticJoint_SetMotorSpeed (joint.l, speed.d)


; #B2WHEELJOINT FUNCTIONS# =====================================================================================================


; #FUNCTION# ====================================================================================================================
; Name...........: b2WheelJointDef_Create
; Description ...: Creates a Box2D wheel joint (b2WheelJoint) between two Box2D bodies
; Syntax.........: b2WheelJointDef_Create.l (world.l, bodyA.l, bodyB.l, collideConnected.d, dampingRatio.d, enableMotor.d, frequencyHz.d, localAnchorAx.d, localAnchorAy.d, localAnchorBx.d,	localAnchorBy.d, localAxisAx.d, localAxisAy.d, maxMotorTorque.d, motorSpeed.d)
; Parameters ....: world - a pointer to the Box2D world (b2World)
;				           bodyA - a pointer to the first Box2D body (b2Body) for the joint
;				           bodyB - a pointer to the second Box2D body (b2Body) for the joint
;				           collideConnected - a boolean (true / false) to indicate if bodyA and bodyB should collide
;				           dampingRatio -
;				           enableMotor -
;                  frequencyHz - 
;				           localAnchorAx - the horizontal position (vector) within bodyA to attach the joint to
;				           localAnchorAy - the vertical position (vector) within bodyA to attach the joint to
;				           localAnchorBx - the horizontal position (vector) within bodyB to attach the joint to
;                  localAnchorBy - the vertical position (vector) within bodyB to attach the joint to
;                  localAxisAx - 
;                  localAxisAy - 
;                  maxMotorTorque - 
;                  motorSpeed - 
; Return values .: A pointer (long) to the joint (b2WheelJoint)
; Author ........: Google
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
b2WheelJointDef_Create.l (world.l, bodyA.l, bodyB.l, collideConnected.d, dampingRatio.d, enableMotor.d, frequencyHz.d, localAnchorAx.d, localAnchorAy.d, localAnchorBx.d,	localAnchorBy.d, localAxisAx.d, localAxisAy.d, maxMotorTorque.d, motorSpeed.d)

; #FUNCTION# ====================================================================================================================
; Name...........: b2WheelJointDef_InitializeAndCreate
; Description ...: Creates (and initializes) a Box2D wheel joint (b2WheelJoint) between two Box2D bodies
; Syntax.........: b2WheelJointDef_InitializeAndCreate.l (world.l, bodyA.l, bodyB.l, anchorX.d, anchorY.d, axisX.d, axisY.d, collideConnected.d, dampingRatio.d, enableMotor.d, frequencyHz.d, maxMotorTorque.d, motorSpeed.d)
; Parameters ....: world - a pointer to the Box2D world (b2World)
;				           bodyA - a pointer to the first Box2D body (b2Body) for the joint
;				           bodyB - a pointer to the second Box2D body (b2Body) for the joint
;                  anchorX - 
;                  anchorY - 
;                  axisX - 
;                  axisY - 
;				           collideConnected - a boolean (true / false) to indicate if bodyA and bodyB should collide
;				           dampingRatio -
;				           enableMotor -
;                  frequencyHz - 
;                  maxMotorTorque - 
;                  motorSpeed - 
; Return values .: A pointer (long) to the joint (b2WheelJoint)
; Author ........: Google
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
b2WheelJointDef_InitializeAndCreate.l (world.l, bodyA.l, bodyB.l, anchorX.d, anchorY.d, axisX.d, axisY.d, collideConnected.d, dampingRatio.d, enableMotor.d, frequencyHz.d, maxMotorTorque.d, motorSpeed.d)

; #FUNCTION# ====================================================================================================================
; Name...........: b2WheelJoint_SetMotorSpeed
; Description ...: Sets the speed of the motor for a Box2D wheel joint (b2WheelJoint)
; Syntax.........: b2WheelJoint_SetMotorSpeed (joint.l, speed.d)
; Parameters ....: joint - a pointer to the Box2D wheel joint (b2WheelJoint)
;				           speed - the speed (in meters per second)
; Return values .: None
; Author ........: Google
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
b2WheelJoint_SetMotorSpeed (wheel.l, speed.d)

; #FUNCTION# ====================================================================================================================
; Name...........: b2WheelJoint_SetSpringFrequencyHz
; Description ...: Sets the frequency of the spring of a Box2D wheel joint (b2WheelJoint)
; Syntax.........: b2WheelJoint_SetSpringFrequencyHz (wheel.l, frequency.d)
; Parameters ....: joint - a pointer to the Box2D wheel joint (b2WheelJoint)
;				           frequency - the speed (in hertz)
; Return values .: None
; Author ........: Google
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
b2WheelJoint_SetSpringFrequencyHz (wheel.l, frequency.d)

  
EndImport
; ===============================================================================================================================

; IDE Options = PureBasic 5.60 (Windows - x86)
; CursorPosition = 1368
; FirstLine = 1342
; EnableXP
; EnableUnicode