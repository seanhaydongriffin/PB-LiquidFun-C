Structure TVertex
  x.f
  y.f
  z.f
  r.f
  g.f
  b.f
EndStructure


Define event, quit

OpenWindow(0, 0, 0, 800, 600, "OpenGL.. 3D Curve with Grid , using glDrawElements with glVertexPointer and glColorPointer ")
SetWindowColor(0, RGB(200,220,200))
OpenGLGadget(0, 20, 10, WindowWidth(0)-40 , WindowHeight(0)-20)

glMatrixMode_(#GL_PROJECTION)
glLoadIdentity_();
gluPerspective_(45.0, 800/600, 1.0, 60.0)
glMatrixMode_(#GL_MODELVIEW)
glTranslatef_(0, 0, -5)
glShadeModel_(#GL_SMOOTH)
glEnable_(#GL_DEPTH_TEST)
;glEnable_(#GL_CULL_FACE)
glColor3f_(1.0, 0.3, 0.0)
glViewport_(0, 0, 800, 600)

NbX=70
NbZ=70
size = (NbX+1)*(NbZ+1)
Dim Vertex.TVertex(size)

;xMin.f = -1 : yMin.f = -1: zMin.f = -1 : xMax.f = 1: yMax = 1 : zMax = 1
xMin.f = -2 : yMin.f = -2: zMin.f = -2 : xMax.f = 2: yMax = 2 : zMax = 2
;xMin.f = -10 : yMin.f = -10: zMin.f = -10 : xMax.f = 10: yMax = 10 : zMax = 10
;xMin.f = -0.5 : zMin.f = -0.5 : xMax.f = 0.5: zMax = 0.5
  range = xMax - xMin
  step1.f = range / NbX
  x.f = xMin: z.f = zMin : y.f = yMin : v.l = 0
  For b=0 To NbZ
   
    For a=0 To NbX
   
      ;y.f = Sin(10*(x*x+z*z))/5
      y.f =(1 - x*x -z*z) * Exp(-1/2 * (x*x + z*z)) ; Mexican Hat
     
      Vertex(v)\x = x*1
      Vertex(v)\y = y*1
      Vertex(v)\z = z*1
     
      If y>=0
        Vertex(v)\r = 1.0 :Vertex(v)\g = 0.3 :Vertex(v)\b = 0
        Else
        Vertex(v)\r = 0.2 :Vertex(v)\g = 0.8 :Vertex(v)\b = 1
      EndIf
     
      x.f + step1
      v+1
    Next a
   
    x = xMin
    z.f + step1
  Next b
  ;Debug v
;=================================================================================

 indexsize = (NbX+1)*(NbZ+1)*2
 Dim index.l(indexsize)
 
;wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww
direction = 0
For yy=0 To NbX
  If direction = 1
    direction ! 1
    xx + NbX + 1
    For i=xx To xx-NbX Step -1
     
      index(ind)=i
      ind+1
       Next
    xx+1
  Else
    direction ! 1
    For i=xx To xx+NbX
       
      index(ind)=i
      ind+1
    Next
    xx = i - 1
  EndIf
Next

xx=(NbX+1)*(NbZ+1) -1
direction = 0
For yy=0 To NbX
  If direction = 1
    direction ! 1
    i=xx
    x2 = xx+(NbX+1)*NbZ
    While i<= xx+(NbX+1)*NbZ 
     
      index(ind)=i
      ind+1
      i+NbX+1
     Wend
     
     i-(NbX+1)
     
    xx = i-1
   
  Else
    direction ! 1
    i=xx
    x2 = xx-(NbX+1)*NbZ
    While i>= x2
     
      index(ind)=i
      ind+1
      i-(NbX+1)
    Wend
   
    i+NbX+1
    xx = i - 1
   
  EndIf
Next

;indexsize = (ind)
;Debug indexsize
rot.f = 1

glTranslatef_(0.0, 0.0, -2)
Repeat
 
 
  glViewport_(0, 0, WindowWidth(0), WindowHeight(0))
  glClearColor_(0.9, 0.9, 0.9, 1)
  glClear_(#GL_COLOR_BUFFER_BIT | #GL_DEPTH_BUFFER_BIT)
 
  glEnableClientState_(#GL_VERTEX_ARRAY )
  glEnableClientState_(#GL_COLOR_ARRAY)
  glRotatef_(rot, 1, 1, 0);
 
  glVertexPointer_(3, #GL_FLOAT,SizeOf(TVertex),Vertex(0))
  glColorPointer_(3, #GL_FLOAT, SizeOf(TVertex), @Vertex(0)\r)
 
  ;glPointSize_(12)
  glDrawElements_(#GL_LINE_STRIP,indexsize,#GL_UNSIGNED_INT, @index(0))

  glDisableClientState_(#GL_VERTEX_ARRAY);
  glDisableClientState_(#GL_COLOR_ARRAY)
 
 Repeat
    event = WindowEvent()
    If event = #PB_Event_CloseWindow
      quit = #True
    EndIf
  Until event = 0 Or quit = #True
 
  SetGadgetAttribute(0, #PB_OpenGL_FlipBuffers, #True)
 
;  Delay(100)
Until quit = #True

; IDE Options = PureBasic 5.40 LTS (Windows - x86)
; CursorPosition = 159
; FirstLine = 125
; EnableUnicode
; EnableXP