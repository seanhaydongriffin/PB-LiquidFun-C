
Global RollAxisZ.f

Global RotateSpeedZ.f = 1.0

Global ZoomFactor.f = 1.0 ; Distance of the camera. Negative value = zoom back

Procedure DrawCube(Gadget)
;  glMatrixMode_(#GL_MODELVIEW)

  glRotatef_ (RollAxisZ, 0, 0, 1.0) ; rotate around Z axis
  RollAxisZ + RotateSpeedZ 

  glClear_ (#GL_COLOR_BUFFER_BIT | #GL_DEPTH_BUFFER_BIT)
  glBegin_  (#GL_QUADS)
  
  glNormal3f_ (0,0,1.0)
  glVertex3f_ (0.5,0.5,0.5)   
  glVertex3f_ (-0.5,0.5,0.5)
  glVertex3f_ (-0.5,-0.5,0.5)
  glVertex3f_ (0.5,-0.5,0.5) 
  
  glEnd_()

  SetGadgetAttribute(Gadget, #PB_OpenGL_FlipBuffers, #True)
EndProcedure



Procedure HandleError (Result, Text$)
  If Result = 0
    MessageRequester("Error", Text$, 0)
    End
  EndIf
EndProcedure


OpenWindow(0, 0, 0, 800, 600, "OpenGL Gadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
OpenGLGadget(0, 0, 0, 800, 600, #PB_OpenGL_NoFlipSynchronization )
glMatrixMode_(#GL_PROJECTION)
gluPerspective_(30.0, 200/200, 1.0, 30.0) 
glMatrixMode_(#GL_MODELVIEW)
glTranslatef_(0, 0, -30.0)
glEnable_(#GL_CULL_FACE)    ; This will enhance the rendering speed as all the back face will be
  
  

AddWindowTimer(0, 1, 16) ; about 60 fps

Repeat
  Event = WaitWindowEvent()
  
  Select Event
    Case #PB_Event_Timer
      If EventTimer() = 1
        DrawCube(0)
       ; DrawCube(1)
      EndIf
  EndSelect
  
Until Event = #PB_Event_CloseWindow


; IDE Options = PureBasic 5.40 LTS (Windows - x86)
; CursorPosition = 20
; Folding = -
; EnableUnicode
; EnableXP
; Executable = opengl_test4.exe