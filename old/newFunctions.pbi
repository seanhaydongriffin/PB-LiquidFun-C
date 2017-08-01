
#GL_ARRAY_BUFFER = $8892
#GL_STATIC_DRAW = $88E4
#GL_VERTEX_SHADER = $8B31
#GL_FRAGMENT_SHADER = $8B30


Structure vec2
  x.f
  y.f
EndStructure

Structure TVertex
  x.f
  y.f
  z.f
EndStructure


Structure Colors
  r.f
  g.f
  b.f
EndStructure


Global Dim matrix.f(3,3)
matrix(0,0)=1:   matrix(0,1)=0:matrix(0,2)=0:matrix(0,3)=0 ;// first column
matrix(1,0)=0:   matrix(1,1)=1:matrix(1,2)=0:matrix(1,3)=0 ;// second column
matrix(2,0)=0:   matrix(2,1)=0:matrix(2,2)=1:matrix(2,3)=0 ; // third column
matrix(3,0)=0: matrix(3,1)=0:matrix(3,2)=0:matrix(3,3)=2 ;// fourth column

Global points_vbo.i, vao.i

Global vertex_shader.s
Global fragment_shader.s
Global *vbuff
Global shader_programme, vs, fs

Global particle_vertex_size = 2.5
Global Dim particle_vertex.TVertex(3)
particle_vertex(0)\x = -particle_vertex_size
particle_vertex(0)\y = particle_vertex_size
particle_vertex(0)\z = 0

particle_vertex(1)\x = particle_vertex_size
particle_vertex(1)\y = particle_vertex_size
particle_vertex(1)\z = 0

particle_vertex(2)\x = particle_vertex_size
particle_vertex(2)\y = -particle_vertex_size
particle_vertex(2)\z = 0

particle_vertex(3)\x = -particle_vertex_size
particle_vertex(3)\y = -particle_vertex_size
particle_vertex(3)\z = 0


Prototype PFNGLGENBUFFERSPROC ( n.i, *buffers)
Global glGenBuffers.PFNGLGENBUFFERSPROC
glGenBuffers = wglGetProcAddress_( "glGenBuffers" )

Prototype PFNGLBINDBUFFERPROC ( target.l, buffer.i)
Global glBindBuffer.PFNGLBINDBUFFERPROC
glBindBuffer = wglGetProcAddress_( "glBindBuffer" )

Prototype PFNGLBUFFERDATAPROC ( target.l, size.i, *Data_, usage.l)
Global glBufferData.PFNGLBUFFERDATAPROC
glBufferData = wglGetProcAddress_( "glBufferData" )

Prototype PFNGLGENVERTEXARRAYSPROC (n.i, *arrays)
Global glGenVertexArrays.PFNGLGENVERTEXARRAYSPROC
glGenVertexArrays = wglGetProcAddress_( "glGenVertexArrays" )

Prototype PFNGLBINDVERTEXARRAYPROC(n.i)
Global glBindVertexArray.PFNGLBINDVERTEXARRAYPROC
glBindVertexArray = wglGetProcAddress_( "glBindVertexArray" )

Prototype PFNGLENABLEVERTEXATTRIBARRAYPROC ( index.i )
Global glEnableVertexAttribArray.PFNGLENABLEVERTEXATTRIBARRAYPROC
glEnableVertexAttribArray = wglGetProcAddress_( "glEnableVertexAttribArray" )

Prototype PFNGLVERTEXATTRIBPOINTERPROC ( index.i, size.i, type.l, normalized.b, stride.i, *pointer )
Global glVertexAttribPointer.PFNGLVERTEXATTRIBPOINTERPROC
glVertexAttribPointer = wglGetProcAddress_( "glVertexAttribPointer" )

Prototype.i PFNGLCREATESHADERPROC ( type.l )
Global glCreateShader.PFNGLCREATESHADERPROC
glCreateShader = wglGetProcAddress_( "glCreateShader" )


Prototype PFNGLSHADERSOURCEPROC ( shader.i, count.i, *stringBuffer, *length )
Global glShaderSource.PFNGLSHADERSOURCEPROC
glShaderSource = wglGetProcAddress_( "glShaderSource" )


Prototype PFNGLCOMPILESHADERPROC ( shader.i )
Global glCompileShader.PFNGLCOMPILESHADERPROC
glCompileShader = wglGetProcAddress_( "glCompileShader" )


Prototype PFNGLATTACHSHADERPROC ( program.i, shader.i )
Global glAttachShader.PFNGLATTACHSHADERPROC
glAttachShader = wglGetProcAddress_( "glAttachShader" )


Prototype PFNGLLINKPROGRAMPROC ( program.i )
Global glLinkProgram.PFNGLLINKPROGRAMPROC
glLinkProgram = wglGetProcAddress_( "glLinkProgram" )

Prototype.i PFNGLCREATEPROGRAMPROC ( )
Global glCreateProgram.PFNGLCREATEPROGRAMPROC
glCreateProgram = wglGetProcAddress_( "glCreateProgram" )

Prototype PFNGLUSEPROGRAMPROC ( program.i )
Global glUseProgram.PFNGLUSEPROGRAMPROC
glUseProgram = wglGetProcAddress_( "glUseProgram" )

Prototype PFNGLDRAWARRAYSPROC ( mode.l, first.i, count.i )
Global glDrawArrays.PFNGLDRAWARRAYSPROC
glDrawArrays = wglGetProcAddress_( "glDrawArrays" )

Prototype PFNGLGETUNIFORMLOCATIONPROC ( program.i, name.p-ascii )
Global glGetUniformLocation.PFNGLGETUNIFORMLOCATIONPROC
glGetUniformLocation = wglGetProcAddress_( "glGetUniformLocation" )

Prototype PFNGLUNIFORMMATRIX4FVPROC ( location.i, count.i, transpose.b, *value )
Global glUniformMatrix4fv.PFNGLUNIFORMMATRIX4FVPROC
glUniformMatrix4fv = wglGetProcAddress_( "glUniformMatrix4fv" )

Prototype PFNGLUNIFORM1FPROC ( location.i, v0.f )
Global glUniform1f.PFNGLUNIFORM1FPROC
glUniform1f = wglGetProcAddress_( "glUniform1f" )

Prototype PFNGLUNIFORM1FVPROC ( location.i, count.i, *value )
Global glUniform1fv.PFNGLUNIFORM1FVPROC
glUniform1fv = wglGetProcAddress_( "glUniform1fv" )

Prototype PFNGLUNIFORM2FVPROC ( location.i, count.i, *value )
Global glUniform2fv.PFNGLUNIFORM2FVPROC
glUniform2fv = wglGetProcAddress_( "glUniform2fv" )


Procedure.s LoadFile(FileName.s)
  Protected FF, Format, length, *mem, Text.s
  FF = ReadFile(#PB_Any, FileName)
  If FF
    Format = ReadStringFormat(FF)
    length = Lof(FF)
    If length
      *mem = AllocateMemory(length)
      If *mem
        ReadData(FF, *mem, length)
        Text = PeekS(*mem, length, Format)
        FreeMemory(*mem)
        CloseFile(FF)
        ProcedureReturn Text
      EndIf
    EndIf
    CloseFile(FF)
  EndIf
EndProcedure

Procedure ShaderSetup()
  
vertex_shader = LoadFile("vertex_shader.txt")
fragment_shader = LoadFile("fragment_shader.txt")
*vbuff = Ascii(vertex_shader)
*fbuff = Ascii(fragment_shader)
   
glEnable_(#GL_DEPTH_TEST); // enable depth-testing


;=================================================================================
glGenBuffers( 1, @points_vbo ) ; Vertex Buffer Object
glBindBuffer(#GL_ARRAY_BUFFER, points_vbo )
glBufferData(#GL_ARRAY_BUFFER,12 * SizeOf(float),particle_vertex(0), #GL_STATIC_DRAW)

glGenVertexArrays (1, @vao);
glBindVertexArray (vao);
glBindBuffer (#GL_ARRAY_BUFFER, points_vbo);
glVertexAttribPointer (0, 3, #GL_FLOAT, #GL_FALSE, 0, #Null);
;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
glEnableVertexAttribArray(0);
;=================================================================================

vs = glCreateShader(#GL_VERTEX_SHADER)
glShaderSource(vs, 1, @*vbuff, #Null) 
glCompileShader(vs)
fs = glCreateShader(#GL_FRAGMENT_SHADER)
glShaderSource(fs, 1, @*fbuff, #Null)
glCompileShader(fs)                          

shader_programme = glCreateProgram()
glAttachShader(shader_programme, fs)
glAttachShader(shader_programme, vs)
glLinkProgram(shader_programme)     

;glTranslatef_(0, 0, 0)


glEnable_(#GL_CULL_FACE) ; cull face
glCullFace_(#GL_BACK) ; cull back face
glFrontFace_(#GL_CW) ; GL_CCW For counter clock-wise
  
EndProcedure
  

; IDE Options = PureBasic 5.60 (Windows - x86)
; CursorPosition = 53
; FirstLine = 20
; Folding = -
; EnableXP