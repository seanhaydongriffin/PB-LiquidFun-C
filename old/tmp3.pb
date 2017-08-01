OpenWindow(0, 10, 10, 640, 480, "OpenGL demo")
SetWindowColor(0, RGB(200,220,200))
OpenGLGadget(0, 20, 10, WindowWidth(0)-40 , WindowHeight(0)-20)

Procedure.f RandF(Min.f, Max.f, Resolution.i = 10000)
  ProcedureReturn (Min + (Max - Min) * Random(Resolution) / Resolution)
EndProcedure


Structure Pointq
  x.f
  y.f
  r.f
  g.f
  b.f
  a.f
EndStructure

Global Dim points.Pointq(500)


glMatrixMode_(#GL_PROJECTION);
glLoadIdentity_();
;glOrtho_(-50, 50, -50, 50, -1, 1);
glOrtho_(-100, 100, -100, 100, -1, 1)

glMatrixMode_(#GL_MODELVIEW);
glLoadIdentity_();

Declare display()


Repeat
   ;// populate points
  ;points.Pointq
  For i = 0 To 500
   
        points(i)\x = RandF(-50,50)
        points(i)\y = RandF(-50,50)
        points(i)\r = RandF(0,1)
        points(i)\g = RandF(0,1)
        points(i)\b = RandF(0,1)
        points(i)\a = RandF(0,1)
       
      Next
     
  display()
 
  SetGadgetAttribute(0, #PB_OpenGL_FlipBuffers, #True)
Until WindowEvent() = #PB_Event_CloseWindow


Procedure display()


  glClear_(#GL_COLOR_BUFFER_BIT | #GL_DEPTH_BUFFER_BIT)

  ;// draw
     
  glEnableClientState_(#GL_VERTEX_ARRAY )
;  glEnableClientState_( #GL_COLOR_ARRAY );
  glVertexPointer_( 2, #GL_FLOAT, SizeOf(Pointq), @points(0)\x );
;  glColorPointer_( 4, #GL_UNSIGNED_BYTE, SizeOf(Pointq), @points(0)\r );
  glPointSize_( 10.0 );
  glDrawArrays_( #GL_POINTS, 0, 500 );
  ;glDrawArrays_(#GL_TRIANGLES, 0, 20);
  glDisableClientState_( #GL_VERTEX_ARRAY );
;  glDisableClientState_( #GL_COLOR_ARRAY );
   
EndProcedure
  
; IDE Options = PureBasic 5.40 LTS (Windows - x86)
; CursorPosition = 58
; FirstLine = 32
; Folding = -
; EnableUnicode
; EnableXP