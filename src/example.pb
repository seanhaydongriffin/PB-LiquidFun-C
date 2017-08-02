XIncludeFile "LiquidFun-C.pbi"
XIncludeFile "LiquidFun-C-Ex.pbi"

b2World_CreateEx(0.0, -10.0)
b2World_CreateAll()

glWindow_Setup(0, 0, 800, 600, "LiquidFun Demo", 0, 0, 800, 600, 0, 0, $006600, #Black)
glWorld_Setup(30.0, 800/600, 1.0, 1000.0, 0, -10, -190.0)
glWorld_CreateTextures()

frame_timer = 0

Repeat
  
  If (ElapsedMilliseconds() - frame_timer) > 16
    
    frame_timer = ElapsedMilliseconds()
    
    b2World_Step(world\ptr, (1 / 60.0), 6, 2)
    
    glColor3f_(1.0, 1.0, 1.0)
    glClearColor_(0.7, 0.7, 0.7, 1)
    glClear_ (#GL_COLOR_BUFFER_BIT | #GL_DEPTH_BUFFER_BIT)
    
    glDraw_Particles()
    glDraw_Fixtures()
    
    SetGadgetAttribute(Gadget, #PB_OpenGL_FlipBuffers, #True)

    Eventxx = WindowEvent()
  EndIf
    
Until Eventxx = #PB_Event_CloseWindow

; IDE Options = PureBasic 5.60 (Windows - x86)
; CursorPosition = 32
; EnableXP
; Executable = PB_LiquidFun_OpenGL_demo.exe
; SubSystem = OpenGL