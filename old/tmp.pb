EnableExplicit
Enumeration ;/ Window
  #Window_Main
EndEnumeration
Enumeration ;/ Gadget
  #Gad_OpenGL
  #Gad_Editor
  #Gad_ShaderSelector_Combo
EndEnumeration
Structure System
  Width.i
  Height.i
  Shader_Width.i
  Shader_Height.i
  Event.i
  Exit.i
  MouseX.i
  MouseY.i
    App_CurrentTime.i
  App_StartTime.i
  Editor_LastText.s
  Shader_Vertex_Text.s
  Shader_Fragment_Text.s
  Shader_Vertex.i
  Shader_Fragment.i
  Shader_Program.i
  fragtext.s
  Shader_Uniform_Time.i
  Shader_Uniform_Resolution.i
  Shader_Uniform_Mouse.i
  Shader_Uniform_SurfacePosition.i
  FPS_Timer.i
  Frames.i
  FPS.i
EndStructure
Global System.System
Procedure test()
        System\fragtext = PeekS(? Nurbs)
    ;MessageRequester("hilfe", System\hilfetext, 0)
    ;Debug System\hilfetext.s
EndProcedure
Procedure Init_Main()
  Protected MyLoop.i
    System\Width.i = 1024
  System\Height = 480
  System\Shader_Width = 640
  System\Shader_Height = 480
  OpenWindow(#Window_Main,0,0,System\Width,System\Height,"",#PB_Window_ScreenCentered|#PB_Window_SystemMenu)
  OpenGLGadget(#Gad_OpenGL,0,0,System\Shader_Width,System\Shader_Height,#PB_OpenGL_Keyboard)
  ComboBoxGadget(#Gad_ShaderSelector_Combo,System\Shader_Width+4,2,System\Width - (System\Shader_Width+8),24)
  For MyLoop = 1 To 1
    AddGadgetItem(#Gad_ShaderSelector_Combo,-1,"Shader: "+Str(MyLoop))
  Next
  SetGadgetState(#Gad_ShaderSelector_Combo,0)
  EditorGadget(#Gad_Editor,System\Shader_Width+4,30,System\Width - (System\Shader_Width+8),System\Height-30)
  System\App_StartTime = ElapsedMilliseconds()
  System\Shader_Vertex_Text = "attribute vec3 position;"
  System\Shader_Vertex_Text + "attribute vec2 surfacePosAttrib;"
  System\Shader_Vertex_Text + "varying vec2 surfacePosition;"
  System\Shader_Vertex_Text + "   void main() {"
  System\Shader_Vertex_Text + "      surfacePosition = surfacePosAttrib;"
  System\Shader_Vertex_Text + "      gl_Position = vec4( position, 1.0 );"
  System\Shader_Vertex_Text + "   }"
EndProcedure
test()
Init_Main()
;{ Opengl shader setup & routines
#GL_VERTEX_SHADER = $8B31
#GL_FRAGMENT_SHADER = $8B30
Prototype glCreateShader(type.l)
Prototype glCreateProgram()
Prototype glCompileShader(shader.l)
Prototype glLinkProgram(shader.l)
Prototype glUseProgram(shader.l)
Prototype glAttachShader(Program.l, shader.l)
Prototype glShaderSource(shader.l, numOfStrings.l, *strings, *lenOfStrings) :
Prototype.i glGetUniformLocation(Program.i, name.p-ascii)
Prototype glUniform1i(location.i, v0.i)
Prototype glUniform2i(location.i, v0.i, v1.i)
Prototype glUniform1f(location.i, v0.f)
Prototype glUniform2f(location.i, v0.f, v1.f)
Prototype glGetShaderInfoLog(shader.i, bufSize.l, *length_l, *infoLog)
Global glCreateShader.glCreateShader = wglGetProcAddress_("glCreateShader")
Global glCreateProgram.glCreateProgram = wglGetProcAddress_("glCreateProgram")
Global glCompileShader.glCompileShader = wglGetProcAddress_("glCompileShader")
Global glLinkProgram.glLinkProgram = wglGetProcAddress_("glLinkProgram")
Global glUseProgram.glUseProgram = wglGetProcAddress_("glUseProgram")
Global glAttachShader.glAttachShader = wglGetProcAddress_("glAttachShader")
Global glShaderSource.glShaderSource = wglGetProcAddress_("glShaderSource")
Global glGetUniformLocation.glGetUniformLocation = wglGetProcAddress_("glGetUniformLocation")
Global glUniform1i.glUniform1i = wglGetProcAddress_("glUniform1i")
Global glUniform2i.glUniform2i = wglGetProcAddress_("glUniform2i")
Global glUniform1f.glUniform1f = wglGetProcAddress_("glUniform1f")
Global glUniform2f.glUniform2f = wglGetProcAddress_("glUniform2f")
Global glGetShaderInfoLog.glGetShaderInfoLog = wglGetProcAddress_("glGetShaderInfoLog")
Procedure Shader_Compile_Link_Use(Vertex.s,Fragment.s,Use.i=1)
  Protected VertShader.i, FragShader.i, *TxtPointer, Program.i
  Protected Textlength.i, Mytext.s = Space(1024)
    ;/ Compile Vertex shader
  VertShader.i = glCreateShader(#GL_VERTEX_SHADER)
;  *TxtPointer = @Vertex
    *TxtPointer = Ascii(Vertex)

  glShaderSource(VertShader, 1, @*TxtPointer, #Null)
  glCompileShader(VertShader)
  Debug "Vert: "+VertShader
  glGetShaderInfoLog(VertShader,1023,@Textlength,@Mytext)
  Debug MyText
  ;/ Compile Fragment Shader
  FragShader.i = glCreateShader(#GL_FRAGMENT_SHADER)
;  *TxtPointer = @Fragment
  *TxtPointer = Ascii(Fragment)
  glShaderSource(FragShader, 1, @*TxtPointer, #Null)
  glCompileShader(FragShader)
  Debug "Frag: "+FragShader
  glGetShaderInfoLog(FragShader,1023,@Textlength,@Mytext)
  Debug MyText
  ;/ Create Shader Program
  Program = glCreateProgram()
  glAttachShader(Program,VertShader)
  Debug "Attached Vert Shader"
  glAttachShader(Program,FragShader)
  Debug "Attached Frag Shader"
  glLinkProgram(Program)
  Debug "Link program"
  If Use = 1
    glUseProgram(Program)
  EndIf
  ProcedureReturn Program 
EndProcedure
;}
Procedure Shader_Set(Fragment.i)
  If System\Shader_Program <> 0 ;/ delete the previous shaders
    glUseProgram(0);
  EndIf
    Select Fragment
    Case 0
      System\Shader_Fragment_Text =  System\fragtext;"uniform float time;"+Chr(10)
     EndSelect
  System\Shader_Program = Shader_Compile_Link_Use(System\Shader_Vertex_Text,System\Shader_Fragment_Text)
  If System\Shader_Program = 0
    MessageRequester("Unsupported Device?","No Shader Support Available",#PB_MessageRequester_Ok)
    End
  EndIf
  ;/ store shader uniform locations
  Debug "Shader: "+System\Shader_Program
  System\Shader_Uniform_Time = glGetUniformLocation(System\Shader_Program, "time")
  System\Shader_Uniform_Mouse = glGetUniformLocation(System\Shader_Program, "mouse")
  System\Shader_Uniform_Resolution = glGetUniformLocation(System\Shader_Program, "resolution")
  System\Shader_Uniform_SurfacePosition.i = glGetUniformLocation(System\Shader_Program, "surfacePosition")
  Debug "Time location: "+System\Shader_Uniform_Time
  Debug "Mouse location: "+System\Shader_Uniform_Mouse
  Debug "Res location: "+System\Shader_Uniform_Resolution
  Debug "SurfacePos location: "+System\Shader_Uniform_SurfacePosition
  SetGadgetText(#Gad_Editor,System\Shader_Fragment_Text)
EndProcedure
Shader_Set(0)
Procedure Render()
  ;/ set shader Uniform values
  glUniform2f(System\Shader_Uniform_Resolution,System\Shader_Width,System\Shader_Height)
  glUniform1f(System\Shader_Uniform_Time,(System\App_CurrentTime-System\App_StartTime) / 1000.0)
  glUniform2i(System\Shader_Uniform_SurfacePosition.i,1.0,1.0)
   glBegin_(#GL_QUADS)
    glVertex2f_(-1,-1)
    glVertex2f_( 1,-1)
    glVertex2f_( 1, 1)
    glVertex2f_(-1, 1)
  glEnd_()           
  System\Frames + 1
  If System\App_CurrentTime > System\FPS_Timer
    System\FPS = System\Frames
    System\Frames = 0
    System\FPS_Timer = System\App_CurrentTime  + 1000
    SetWindowTitle(#Window_Main,"GLSL Testing FPS "+Str(System\FPS))
  EndIf
  SetGadgetAttribute(#Gad_OpenGL,#PB_OpenGL_FlipBuffers,1)
  EndProcedure
Repeat
  Repeat
    System\Event = WindowEvent()
    Select System\Event
      Case #PB_Event_CloseWindow
        System\Exit = #True
      Case #PB_Event_Gadget
        Select EventGadget()
          Case #Gad_ShaderSelector_Combo
            Select EventType()
              Case #PB_EventType_Change
                Debug "Set to: "+GetGadgetState(#Gad_ShaderSelector_Combo)
                Shader_Set(GetGadgetState(#Gad_ShaderSelector_Combo))
            EndSelect
          Case #Gad_OpenGL
            Select EventType()
              Case #PB_EventType_MouseMove
                System\MouseX = GetGadgetAttribute(#Gad_OpenGL,#PB_OpenGL_MouseX)
                System\MouseY = GetGadgetAttribute(#Gad_OpenGL,#PB_OpenGL_MouseY)
                glUniform2f(System\Shader_Uniform_Mouse,System\MouseX / System\Shader_Width,(System\Shader_Height-System\MouseY) / System\Shader_Height)
            EndSelect
        EndSelect
    EndSelect
      Until System\Event = 0
  System\App_CurrentTime = ElapsedMilliseconds()
  Render()
  Until System\Exit
DataSection
  Nurbs:
  IncludeBinary "nurbs.txt"
  Data.b 0
EndDataSection 
; IDE Options = PureBasic 5.60 (Windows - x86)
; CursorPosition = 78
; FirstLine = 170
; Folding = --
; EnableXP
; SubSystem = OpenGL