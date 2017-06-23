EnableExplicit

#FPS = 60
#ImagePath = #PB_Compiler_Home + "examples/sources/Data/"
#ROTATION_TIME = 15.0 ; Full revolution time in seconds

UsePNGImageDecoder()

Define *BMPHeader
Define *BMPImage
Define Direction.I
Define ImageHeight.I
Define ImageSize.I
Define ImageWidth.I
Define ImagePath.S
Define TextureID.I
Define.F XRot, YRot, ZRot
Define.F XInc, YInc, ZInc

If ReadFile(0, #ImagePath + "Geebee2.bmp") = 0
  MessageRequester("Error", "Loading of texture image failed!")
  End
EndIf

*BMPHeader = AllocateMemory(54)
ReadData(0, *BMPHeader, MemorySize(*BMPHeader))
ImageWidth = PeekL(*BMPHeader + 18)
ImageHeight = PeekL(*BMPHeader + 22)
ImageSize = PeekL(*BMPHeader + 34)
FreeMemory(*BMPHeader)

*BMPImage = AllocateMemory(ImageSize)
ReadData(0, *BMPImage, ImageSize)
CloseFile(0)

OpenWindow(0, 270, 100, 400, 320, "Cross-platform OpenGL demo")
SetWindowColor(0, 0)
OpenGLGadget(0, 0, 0, WindowWidth(0) , WindowHeight(0))

; ----- Generate texture
glGenTextures_(1, @TextureID)
glBindTexture_(#GL_TEXTURE_2D, TextureID)
glTexParameteri_(#GL_TEXTURE_2D, #GL_TEXTURE_MIN_FILTER, #GL_LINEAR)
glTexParameteri_(#GL_TEXTURE_2D, #GL_TEXTURE_MAG_FILTER, #GL_LINEAR)
glTexImage2D_(#GL_TEXTURE_2D, 0, 3, ImageWidth, ImageHeight, 0, #GL_BGR_EXT, #GL_UNSIGNED_BYTE, *BMPImage)
FreeMemory(*BMPImage)

Direction = -1

glMatrixMode_(#GL_PROJECTION)
gluPerspective_(30.0, Abs(WindowWidth(0) / WindowHeight(0)), 0.1, 500.0)

Repeat
  XInc = (Direction * 360.0) / (#ROTATION_TIME * #FPS)
  YInc = 360.0 / (#ROTATION_TIME   * #FPS)
  ZInc = (Direction * 360.0) / (#ROTATION_TIME * #FPS) / 1.5

  glMatrixMode_(#GL_MODELVIEW)
  glEnable_(#GL_CULL_FACE)

  glClear_(#GL_COLOR_BUFFER_BIT | #GL_DEPTH_BUFFER_BIT)   ; Clear screen and depth buffer
  glLoadIdentity_()                                       ; Reset current modelview matrix
  glTranslatef_(0.0, 0.0, -7.5)
  glRotatef_(XRot, 1.0, 0.0, 0.0)
  glRotatef_(YRot, 0.0, 1.0, 0.0)
  glRotatef_(ZRot, 0.0, 0.0, 1.0)
  glEnable_(#GL_TEXTURE_2D)                               ; Enable texture mapping
  glBindTexture_(#GL_TEXTURE_2D, TextureID)
 
  glBegin_(#GL_QUADS)                                     ; Start drawing the cube
    glTexCoord2f_(1.0, 1.0) : glVertex3f_( 1.0, 1.0,-1.0) ; Top right of cube (Top)
    glTexCoord2f_(0.0, 1.0) : glVertex3f_(-1.0, 1.0,-1.0) ; Top left of cube (Top)
    glTexCoord2f_(0.0, 0.0) : glVertex3f_(-1.0, 1.0, 1.0) ; Bottom left of cube (Top)
    glTexCoord2f_(1.0, 0.0) : glVertex3f_( 1.0, 1.0, 1.0) ; Bottom right of cube (Top)
 
    glTexCoord2f_(1.0, 1.0) : glVertex3f_(-1.0, 1.0, 1.0) ; Top right of cube (left)
    glTexCoord2f_(0.0, 1.0) : glVertex3f_(-1.0, 1.0,-1.0) ; Top left of cube (left)
    glTexCoord2f_(0.0, 0.0) : glVertex3f_(-1.0,-1.0,-1.0) ; Bottom left of cube (left)
    glTexCoord2f_(1.0, 0.0) : glVertex3f_(-1.0,-1.0, 1.0) ; Bottom right of cube (left)
 
    glTexCoord2f_(1.0, 1.0) : glVertex3f_( 1.0, 1.0, 1.0) ; Top right of cube (Front)
    glTexCoord2f_(0.0, 1.0) : glVertex3f_(-1.0, 1.0, 1.0) ; Top left of cube (Front) 
    glTexCoord2f_(0.0, 0.0) : glVertex3f_(-1.0,-1.0, 1.0) ; Bottom left of cube (Front)
    glTexCoord2f_(1.0, 0.0) : glVertex3f_( 1.0,-1.0, 1.0) ; Bottom right of cube (Front)
 
    glTexCoord2f_(1.0, 1.0) : glVertex3f_(-1.0, 1.0,-1.0) ; Top right of cube (Back)
    glTexCoord2f_(0.0, 1.0) : glVertex3f_( 1.0, 1.0,-1.0) ; Top left of cube (Back)
    glTexCoord2f_(0.0, 0.0) : glVertex3f_( 1.0,-1.0,-1.0) ; Bottom left of cube (Back)
    glTexCoord2f_(1.0, 0.0) : glVertex3f_(-1.0,-1.0,-1.0) ; Bottom right of cube (Back)
 
    glTexCoord2f_(1.0, 1.0) : glVertex3f_( 1.0, 1.0,-1.0) ; Top right of cube (right)
    glTexCoord2f_(0.0, 1.0) : glVertex3f_( 1.0, 1.0, 1.0) ; Top left of cube (right)
    glTexCoord2f_(0.0, 0.0) : glVertex3f_( 1.0,-1.0, 1.0) ; Bottom left of cube (right)
    glTexCoord2f_(1.0, 0.0) : glVertex3f_( 1.0,-1.0,-1.0) ; Bottom right of cube (right)
 
    glTexCoord2f_(1.0, 1.0) : glVertex3f_( 1.0,-1.0, 1.0) ; Top right of cube (Bottom)
    glTexCoord2f_(0.0, 1.0) : glVertex3f_(-1.0,-1.0, 1.0) ; Top left of cube (Bottom) 
    glTexCoord2f_(0.0, 0.0) : glVertex3f_(-1.0,-1.0,-1.0) ; Bottom left of cube (Bottom)
    glTexCoord2f_(1.0, 0.0) : glVertex3f_( 1.0,-1.0,-1.0) ; Bottom right of cube (Bottom)
  glEnd_()

  YRot - YInc
 
  If YRot < -360.0
    YRot = 0.0   
  EndIf
 
  XRot + XInc
 
  If XRot > 180.0
    Direction = - Direction
  EndIf
 
  If XRot < -180.0
    Direction = - Direction
  EndIf
 
  ZRot + ZInc
 
  SetGadgetAttribute(0, #PB_OpenGL_FlipBuffers, #True)

  If WaitWindowEvent(10) = #PB_Event_CloseWindow
    glDeleteTextures_(1, @TextureID)
    Break
  EndIf
ForEver
; IDE Options = PureBasic 5.40 LTS (Windows - x86)
; CursorPosition = 125
; FirstLine = 87
; EnableUnicode
; EnableXP