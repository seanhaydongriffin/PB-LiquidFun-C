InitKeyboard()
CompilerIf #PB_Compiler_OS = #PB_OS_Windows
  CompilerIf Subsystem("OpenGL") = #False
    MessageRequester("Error", "Please set the Library subsystem to OpenGL from IDE : Compiler... Compiler Options")
    End
  CompilerEndIf
CompilerEndIf

If InitSprite() = 0
  MessageRequester("Error", "Can't open screen & sprite environment!")
  End
EndIf

OpenWindow(0, 0, 0, 800, 600, "rotating cube", #PB_Window_SystemMenu | #PB_Window_Invisible)
SetWindowColor(0, 14403509)
ContainerGadget(0, 5, WindowHeight(0)-50, 250, 60, #PB_Container_Raised)
ButtonGadget(1, 5, 5, 55, 20, "Stop/Run")
TrackBarGadget(2, 60, 10, 90, 20, 0, 200)
TextGadget(3, 150, 10, 100, 25, "0")
CloseGadgetList()
SetGadgetState(0, 0)

OpenWindowedScreen(WindowID(0), 0, 0, WindowWidth(0)-50, WindowHeight(0)-60, 0, 0, 0)

HideWindow(0, #False)
Global RollAxisX.f
Global RollAxisY.f
Global RollAxisZ.f

Global RotateSpeedX.f
Global RotateSpeedY.f
Global RotateSpeedZ.f

Global ZoomFactor.f
Global running = 1

glClearColor_ (0.0, 0.0, 0.0, 0.0);
glShadeModel_ (#GL_SMOOTH)

glEnable_(#GL_LIGHTING);
glEnable_(#GL_LIGHT0);
glEnable_(#GL_DEPTH_TEST);


glColorMaterial_(#GL_FRONT,  #GL_AMBIENT_AND_DIFFUSE)
glEnable_(#GL_COLOR_MATERIAL) ; color tracking

glEnable_(#GL_NORMALIZE)

Procedure.l Cube_Render()

 glPushMatrix_()                  ; Save the original Matrix coordinates
  glMatrixMode_(#GL_MODELVIEW)

  glTranslatef_(0, 0, ZoomFactor)  ;  move it forward a bit

  glRotatef_ (RollAxisX, 1.0, 0, 0) ; rotate around X axis
  glRotatef_ (RollAxisY, 0, 1.0, 0) ; rotate around Y axis
  glRotatef_ (RollAxisZ, 0, 0, 1.0) ; rotate around Z axis
 
  RollAxisX + RotateSpeedX
  RollAxisY + RotateSpeedY
  RollAxisZ + RotateSpeedZ

  ; clear framebuffer And depth-buffer

  glClear_ (#GL_COLOR_BUFFER_BIT | #GL_DEPTH_BUFFER_BIT)

  ; draw the faces of a cube
 
  ; draw colored faces

  glDisable_(#GL_LIGHTING)
  glBegin_  (#GL_QUADS)
 
  ; Build a face, composed of 4 vertex !
  ; glBegin() specify how the vertexes are considered. Here a group of
  ; 4 vertexes (GL_QUADS) form a rectangular surface.

  ; Now, the color stuff: It's r,v,b but with float values which
  ; can go from 0.0 To 1.0 (0 is .. zero And 1.0 is full intensity)
 
  glNormal3f_ (0,0,1.0)
  glColor3f_  (0,0,1.0)
  glVertex3f_ (0.5,0.5,0.5)   
  glColor3f_  (0,1.0,1.0)         
  glVertex3f_ (-0.5,0.5,0.5)
  glColor3f_  (1.0,1.0,1.0)
  glVertex3f_ (-0.5,-0.5,0.5)
  glColor3f_  (0,0,0)
  glVertex3f_ (0.5,-0.5,0.5)

  ; The other face is the same than the previous one
  ; except the colour which is nice blue To white gradiant

  glNormal3f_ (0,0,-1.0)
  glColor3f_  (0,0,1.0)
  glVertex3f_ (-0.5,-0.5,-0.5)
  glColor3f_  (0,0,1.0)
  glVertex3f_ (-0.5,0.5,-0.5)
  glColor3f_  (1.0,1.0,1.0)
  glVertex3f_ (0.5,0.5,-0.5)
  glColor3f_  (1.0,1.0,1.0)
  glVertex3f_ (0.5,-0.5,-0.5)
 
  glEnd_()
 
  ; draw shaded faces

  glEnable_(#GL_LIGHTING)
  glEnable_(#GL_LIGHT0)
  glBegin_ (#GL_QUADS)

  glNormal3f_ (   0, 1.0,   0)
  glVertex3f_ ( 0.5, 0.5, 0.5)
  glVertex3f_ ( 0.5, 0.5,-0.5)
  glVertex3f_ (-0.5, 0.5,-0.5)
  glVertex3f_ (-0.5, 0.5, 0.5)

  glNormal3f_ (0,-1.0,0)
  glVertex3f_ (-0.5,-0.5,-0.5)
  glVertex3f_ (0.5,-0.5,-0.5)
  glVertex3f_ (0.5,-0.5,0.5)
  glVertex3f_ (-0.5,-0.5,0.5)

  glNormal3f_ (1.0,0,0)
  glVertex3f_ (0.5,0.5,0.5)
  glVertex3f_ (0.5,-0.5,0.5)
  glVertex3f_ (0.5,-0.5,-0.5)
  glVertex3f_ (0.5,0.5,-0.5)

  glNormal3f_ (-1.0,   0,   0)
  glVertex3f_ (-0.5,-0.5,-0.5)
  glVertex3f_ (-0.5,-0.5, 0.5)
  glVertex3f_ (-0.5, 0.5, 0.5)
  glVertex3f_ (-0.5, 0.5,-0.5)

  glEnd_()

  glPopMatrix_()
  glFinish_()
   

EndProcedure

HideWindow(0, #False)

RotateSpeedX = 2.0   ; The speed of the rotation For the 3 axis
RotateSpeedY = 2
RotateSpeedZ = 2.0

ZoomFactor = 0      ; Distance of the camera. Negative value = zoom back

glViewport_(0, 0, WindowWidth(0), WindowHeight(0))
glMatrixMode_(#GL_PROJECTION)
glLoadIdentity_()
gluPerspective_(30.0, Abs(WindowWidth(0) / WindowHeight(0)), 0.1, 500.0)
glMatrixMode_(#GL_MODELVIEW)
glLoadIdentity_()
glClear_(#GL_COLOR_BUFFER_BIT | #GL_DEPTH_BUFFER_BIT)
glLoadIdentity_ ()
; viewing transformation
glTranslatef_(0.0, 2.0, -1.0);
gluLookAt_(0,5,15,0,1.5,0,0,1,0);
 

  Repeat
    EventID = WindowEvent()
    Select EventID
      Case #PB_Event_Gadget
          If EventGadget() = 1
            running ! 1
            RotateSpeedX = running
            RotateSpeedY = running
            RotateSpeedZ = running
          EndIf
          If EventGadget() = 2
            ZoomFactor = (GetGadgetState(2)/200)*5
           
           SetGadgetText(3, Str(ZoomFactor))
          EndIf     
      Case #PB_Event_CloseWindow
        Quit = 1
    EndSelect
    ExamineKeyboard()
     
  Cube_Render()
  FlipBuffers()
  Delay(20)
 
  Until Quit = 1 Or KeyboardPushed(#PB_Key_Escape)

End
; IDE Options = PureBasic 5.40 LTS (Windows - x86)
; CursorPosition = 180
; FirstLine = 154
; Folding = -
; EnableUnicode
; EnableXP
; SubSystem = OpenGL