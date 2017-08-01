;
; OpenGL Gadget demonstration
;
; (c) Fantaisie Software
;
; Axis explainations:
;
;             +
;             y
;
;             |
;             |
;  +          |
;  x ---------\
;              \
;               \
;                \ 
;                  z+
;
; So a rotate on the y axis will take the y axis as center. With OpenGL, we can specify
; positive And negative value. Positive values are always in the same sens as the axis
; (like described on the schmatic, with '+' signs)
;

Structure Vec2 Align #PB_Structure_AlignC
  x.f
  y.f 
EndStructure

Global Dim triangle.Vec2(2)


Global RotateSpeedZ.f = 1.0

;Global ZoomFactor.f = 1.0 ; Distance of the camera. Negative value = zoom back
Global ZoomFactor.f = 0.0 ; Distance of the camera. Negative value = zoom back

Procedure DrawCube(Gadget)
  
  SetGadgetAttribute(Gadget, #PB_OpenGL_SetContext, #True)
  
  glPushMatrix_()                  ; Save the original Matrix coordinates
  glMatrixMode_(#GL_MODELVIEW)
  glTranslatef_(0, 0, ZoomFactor)  ;  move it forward a bit

  ; clear framebuffer And depth-buffer
  glClear_ (#GL_COLOR_BUFFER_BIT | #GL_DEPTH_BUFFER_BIT)

  glDisable_(#GL_LIGHTING)
  
  glBegin_  (#GL_TRIANGLES)
  glNormal3f_ (0,0,1.0)
  
;  glVertex3f_ (0.5,0.5,0)   
;  glVertex3f_ (-0.5,0.5,0)
;  glVertex3f_ (-0.5,-0.5,0)
  
 ; x.i = 1
 ; y.i = 1
  
  For i = 0 To (ArraySize(triangle()) - 1)
    
    glVertex3f_ (triangle(i)\x + -0.5, triangle(i)\y + 0.5, 0)   
    glVertex3f_ (triangle(i)\x + -0.5, triangle(i)\y + -0.5, 0)
    glVertex3f_ (triangle(i)\x + 0.5, triangle(i)\y + 0, 0)
    
  Next
  
  

  
  glEnd_()
  
  glPopMatrix_()
  glFinish_()

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
gluPerspective_(30.0, 200/200, 1.0, 20.0) 

; position viewer
glMatrixMode_(#GL_MODELVIEW)

glTranslatef_(0, 0, -20.0)

;glEnable_(#GL_DEPTH_TEST)   ; Enabled, it slowdown a lot the rendering. It's to be sure than the
                            ; rendered objects are inside the z-buffer.

glEnable_(#GL_CULL_FACE)    ; This will enhance the rendering speed as all the back face will be
                            ; ignored. This works only with CLOSED objects like a cube... Singles
                            ; planes surfaces will be visibles only on one side.
  
;glShadeModel_(#GL_SMOOTH)


triangle(0)\x = 1
triangle(0)\y = 1
triangle(1)\x = -1
triangle(1)\y = 1


;AddWindowTimer(0, 1, 16) ; about 60 fps
AddWindowTimer(0, 1, 16) ; about 60 fps

Repeat
  Event = WaitWindowEvent()
  
  Select Event
    Case #PB_Event_Timer
      If EventTimer() = 1
        DrawCube(0)
      EndIf
  EndSelect
  
Until Event = #PB_Event_CloseWindow


; IDE Options = PureBasic 5.40 LTS (Windows - x86)
; CursorPosition = 99
; FirstLine = 82
; Folding = -
; EnableUnicode
; EnableXP