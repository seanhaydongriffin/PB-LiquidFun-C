
XIncludeFile "LiquidFun-C.pbi"

Declare b2Body_SetAngle(tmp_body.l, tmp_angle.d)
Declare b2Body_AddAngle(tmp_body.l, add_angle.d)
Declare keyboard_proc(*Value)


WndProcMsg.MSG

;OpenConsole()

Global camera_linearvelocity_x.f = 0
Global camera_linearvelocity_y.f = 0
Global camera_linearvelocity_z.f = 0
Global body_focused.i = 0
Global end_game.i = 0


OpenWindow(0, 0, 0, 800, 600, "OpenGL Gadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
OpenGLGadget(0, 0, 0, 800, 600, #PB_OpenGL_Keyboard|#PB_OpenGL_NoFlipSynchronization )
SetActiveGadget(0)
glMatrixMode_(#GL_PROJECTION)
gluPerspective_(30.0, 200/200, 1.0, 1000.0) 
glMatrixMode_(#GL_MODELVIEW)
glTranslatef_(0, 0, -200.0)
glEnable_(#GL_CULL_FACE)    ; This will enhance the rendering speed as all the back face will be


; setup gravity
Global gravity.b2Vec2
gravity\x = 0.0
gravity\y = -10.0
  
; setup the world
world = b2World_Create(gravity\x, gravity\y)
  
; setup the ground body
; world, active, allowSleep, angle, angularVelocity, angularDamping, awake, bullet, fixedRotation, gravityScale, linearDamping, linearVelocityX, linearVelocityY, positionX, positionY, type, userData)
Global groundBody.l = b2World_CreateBody(world, 1, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, -10, 0, 0)
b2Body_SetAngle(groundBody, Radian(-5))

; setup the ground shape and fixture
; body, density, friction, isSensor,	restitution, userData, categoryBits, groupIndex, maskBits, px, py, radius)
Global Dim groundBody_shape.b2Vec2(4)
groundBody_shape(0)\x = -50
groundBody_shape(0)\y = -10
groundBody_shape(1)\x = 50
groundBody_shape(1)\y = -10
groundBody_shape(2)\x = 50
groundBody_shape(2)\y = 10
groundBody_shape(3)\x = -50
groundBody_shape(3)\y = 10
Global groundBodyFixture.l = b2PolygonShape_CreateFixture_4(groundBody, 1, 0.1, 0, 0, 0, 1, 0, 65535, groundBody_shape(0)\x, groundBody_shape(0)\y, groundBody_shape(1)\x, groundBody_shape(1)\y, groundBody_shape(2)\x, groundBody_shape(2)\y, groundBody_shape(3)\x, groundBody_shape(3)\y)

; setup the body body
; world, active, allowSleep, angle, angularVelocity, angularDamping, awake, bullet, fixedRotation, gravityScale, linearDamping, linearVelocityX, linearVelocityY, positionX, positionY, type, userData)
Global body.l = b2World_CreateBody(world, 1, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 4, 2, 0)
b2Body_SetAngle(body, Radian(5))

; setup the body shape and fixture
; body, density, friction, isSensor,	restitution, userData, categoryBits, groupIndex, maskBits, px, py, radius)
Global Dim body_shape.b2Vec2(4)
body_shape(0)\x = -1
body_shape(0)\y = -1
body_shape(1)\x = 1
body_shape(1)\y = -1
body_shape(2)\x = 1
body_shape(2)\y = 1
body_shape(3)\x = -1
body_shape(3)\y = 1
Global bodyFixture.l = b2PolygonShape_CreateFixture_4(body, 1, 0.1, 0, 0.5, 0, 1, 0, 65535, body_shape(0)\x, body_shape(0)\y, body_shape(1)\x, body_shape(1)\y, body_shape(2)\x, body_shape(2)\y, body_shape(3)\x, body_shape(3)\y)


Global Dim tmp_pos.f(2)
frame_timer = ElapsedMilliseconds()
CreateThread(@keyboard_proc(), 1000)
;keyboard_timer = ElapsedMilliseconds()



StartDrawing(WindowOutput(0))
            
Repeat
  
  If (ElapsedMilliseconds() - frame_timer) > (16)
    
    frame_timer = ElapsedMilliseconds()

  ;  DrawCube(0)
  ;   DrawText(10, 10, "FPS2 = " + Str(fps) + ", # of bodies = " + Str(particlecount))
    
    
    b2World_Step(world, (1 / 60.0), 6, 2)

    

    
      
    glClear_ (#GL_COLOR_BUFFER_BIT | #GL_DEPTH_BUFFER_BIT)

    ; groundBody
    b2Body_GetPosition(groundBody, tmp_pos())
    tmp_angle.d = b2Body_GetAngle(groundBody)
    glPushMatrix_()
    glTranslatef_(tmp_pos(0), tmp_pos(1), 0)
    glRotatef_ (Degree(tmp_angle), 0, 0, 1.0)
;    glBegin_  (#GL_QUADS)
    glBegin_  (#GL_LINE_LOOP)
    glVertex3f_ (groundBody_shape(0)\x, groundBody_shape(0)\y, 0.5)   
    glVertex3f_ (groundBody_shape(1)\x, groundBody_shape(1)\y, 0.5)   
    glVertex3f_ (groundBody_shape(2)\x, groundBody_shape(2)\y, 0.5)   
    glVertex3f_ (groundBody_shape(3)\x, groundBody_shape(3)\y, 0.5)   
    glEnd_()
    glPopMatrix_()
    
    ; body
    b2Body_GetPosition(body, tmp_pos())
    tmp_angle.d = b2Body_GetAngle(body)
    glPushMatrix_()
    glTranslatef_(tmp_pos(0), tmp_pos(1), 0)
    glRotatef_ (Degree(tmp_angle), 0, 0, 1.0)
;    glBegin_  (#GL_QUADS)
    glBegin_  (#GL_LINE_LOOP)
    glVertex3f_ (body_shape(0)\x, body_shape(0)\y, 0.5)   
    glVertex3f_ (body_shape(1)\x, body_shape(1)\y, 0.5)   
    glVertex3f_ (body_shape(2)\x, body_shape(2)\y, 0.5)   
    glVertex3f_ (body_shape(3)\x, body_shape(3)\y, 0.5)   
    glEnd_()
    glPopMatrix_()
 
    SetGadgetAttribute(Gadget, #PB_OpenGL_FlipBuffers, #True)
    
    
    ; camera movement
    
    If camera_linearvelocity_x > 0.2 Or camera_linearvelocity_x < 0.2
      
      camera_linearvelocity_x = camera_linearvelocity_x * 0.9
    EndIf
    
    If camera_linearvelocity_y > 0.2 Or camera_linearvelocity_y < 0.2
      
      camera_linearvelocity_y = camera_linearvelocity_y * 0.9
    EndIf
    
    If camera_linearvelocity_z > 0.2 Or camera_linearvelocity_z < 0.2
      
      camera_linearvelocity_z = camera_linearvelocity_z * 0.9
    EndIf

    glTranslatef_(camera_linearvelocity_x, camera_linearvelocity_y, camera_linearvelocity_z)

    
    
    
    
    
    num_frames = num_frames + 1
  EndIf
  
  key.i = 0
  Eventxx = WindowEvent()
  
;   If EventType() = #PB_EventType_KeyUp ; like KeyboardReleased
     
;     key = GetGadgetAttribute(0,#PB_OpenGL_Key)
;     
;     Select key
;         
;       Case #PB_Shortcut_C
;         
;         body_focused = 0
;         
;       Case #PB_Shortcut_B
;         
;         body_focused = 1
;     EndSelect
;   EndIf
    
  
      
Until Eventxx = #PB_Event_CloseWindow Or end_game = 1

StopDrawing()



;   
; ; animate the world
; For i = 1 To 60
;   
;   b2World_Step(world, (1 / 60.0), 6, 2)
; 
;   b2Body_GetPosition(body, tmp_pos())
;   tmp_angle.d = b2Body_GetAngle(body)
; 
;   
;   PrintN(StrF(tmp_pos(0)) + " " + StrF(tmp_pos(1)) + " " + StrF(tmp_angle.d))
; Next
; 
; Input()

Procedure b2Body_SetAngle(tmp_body.l, tmp_angle.d)
  
  Dim tmp_pos.f(2)
    
  b2Body_GetPosition(tmp_body, tmp_pos())
  b2Body_SetTransform(tmp_body, tmp_pos(0), tmp_pos(1), tmp_angle)
EndProcedure


Procedure b2Body_AddAngle(tmp_body.l, add_angle.d)
  
  Dim tmp_pos.f(2)
  b2Body_GetPosition(tmp_body, tmp_pos())
  curr_angle.d = b2Body_GetAngle(tmp_body)
  b2Body_SetTransform(tmp_body, tmp_pos(0), tmp_pos(1), curr_angle + add_angle)
EndProcedure


Procedure keyboard_proc(*Value)
  
  keyboard_timer = ElapsedMilliseconds()

  While (1)
  
    If (ElapsedMilliseconds() - keyboard_timer) > 10
      
      keyboard_timer = ElapsedMilliseconds()
      
      ; game control
      
      If GetAsyncKeyState_(#VK_ESCAPE)
        
        end_game = 1
      EndIf
      
      ; ground control
                  
      If GetAsyncKeyState_(#VK_Q)
        
        b2Body_AddAngle(groundBody, Radian(1))
      EndIf
      
      If GetAsyncKeyState_(#VK_E)
        
        b2Body_AddAngle(groundBody, Radian(-1))
      EndIf

      ; body control

      If GetAsyncKeyState_(#VK_A)
        
        b2Body_GetPosition(body, tmp_pos())
        b2Body_ApplyForce(body, -400, 0, tmp_pos(0), tmp_pos(1), 1)
      EndIf

      If GetAsyncKeyState_(#VK_D)
        
        b2Body_GetPosition(body, tmp_pos())
        b2Body_ApplyForce(body, 400, 0, tmp_pos(0), tmp_pos(1), 1)
      EndIf

      If GetAsyncKeyState_(#VK_W)
        
        b2Body_GetPosition(body, tmp_pos())
        b2Body_ApplyForce(body, 0, 400, tmp_pos(0), tmp_pos(1), 1)
      EndIf

      If GetAsyncKeyState_(#VK_S)
        
        b2Body_GetPosition(body, tmp_pos())
        b2Body_ApplyForce(body, 0, -400, tmp_pos(0), tmp_pos(1), 1)
      EndIf
      
      ; camera control
            
      If GetAsyncKeyState_(#VK_LEFT)
        
        camera_linearvelocity_x = camera_linearvelocity_x + 0.5
      EndIf
      
      If GetAsyncKeyState_(#VK_RIGHT)

        camera_linearvelocity_x = camera_linearvelocity_x - 0.5
      EndIf
      
      If GetAsyncKeyState_(#VK_DOWN)
        
        camera_linearvelocity_y = camera_linearvelocity_y + 0.5
      EndIf
      
      If GetAsyncKeyState_(#VK_UP)
        
        camera_linearvelocity_y = camera_linearvelocity_y - 0.5
      EndIf
            
      If GetAsyncKeyState_(#VK_NEXT)
              
        camera_linearvelocity_z = camera_linearvelocity_z + 0.5
      EndIf
            
      If GetAsyncKeyState_(#VK_PRIOR)
              
        camera_linearvelocity_z = camera_linearvelocity_z - 0.5
      EndIf
    EndIf
      
  Wend


EndProcedure


; IDE Options = PureBasic 5.40 LTS (Windows - x86)
; CursorPosition = 25
; FirstLine = 8
; Folding = -
; EnableUnicode
; EnableXP
; Executable = ..\Box2C_hello2D\Box2C_hello2D.exe