# PB-LiquidFun-C

## Introduction

This is a LiquidFun / Box2D library for PureBasic.  Also included is an extension to this library (LiquidFun-C-Ex.pbi) which adds several convenience procedures for developing games.

## Demonstration

Try the demo by running this installer ->  <a href="https://github.com/seanhaydongriffin/PB-LiquidFun-C/raw/master/bin/PB_LiquidFun_OpenGL_demo_setup.exe" target="_blank">PB_LiquidFun_OpenGL_demo_setup.exe</a>  

Check out the following video of the demonstration => 
<a href="http://www.youtube.com/watch?feature=player_embedded&v=h5QH1O63Wik
" target="_blank"><img src="http://img.youtube.com/vi/h5QH1O63Wik/0.jpg" 
alt="IMAGE ALT TEXT HERE" width="240" height="180" border="10" /></a>

## Download

Click **Clone or download** above, then **Download ZIP**, then download and extract the contents of the zip file to your computer.

## Contents

- **<a href="https://github.com/seanhaydongriffin/PB-LiquidFun-C/raw/master/bin/PB_LiquidFun_OpenGL_demo_setup.exe" target="_blank">bin/PB_LiquidFun_OpenGL_demo_setup.exe</a>** is the installer for the demo of the library
- **<a href="https://github.com/seanhaydongriffin/PB-LiquidFun-C/raw/master/bin/PB_LiquidFun_OpenGL_demo_setup.exe" target="_blank">src/LiquidFun-C.lib</a>** is a static C library of LiquidFun (required by LiquidFun-C.pbi below)
- **<a href="https://github.com/seanhaydongriffin/PB-LiquidFun-C/raw/master/bin/PB_LiquidFun_OpenGL_demo_setup.exe" target="_blank">src/LiquidFun-C.dll</a>** is a dynamic C library of LiquidFun (required by LiquidFun-C.pbi below)
- **<a href="https://github.com/seanhaydongriffin/PB-LiquidFun-C/raw/master/bin/PB_LiquidFun_OpenGL_demo_setup.exe" target="_blank">src/CSFML.pbi</a>** is a PureBasic Interface File (library) for SFML (required by LiquidFun-C-Ex.pbi below)
- **<a href="https://github.com/seanhaydongriffin/PB-LiquidFun-C/raw/master/bin/PB_LiquidFun_OpenGL_demo_setup.exe" target="_blank">src/LiquidFun-C.pbi</a>** is the PureBasic Interface File (library) for LiquidFun
- **<a href="https://github.com/seanhaydongriffin/PB-LiquidFun-C/raw/master/bin/PB_LiquidFun_OpenGL_demo_setup.exe" target="_blank">src/LiquidFun-C-Ex.pbi</a>** is an extended library of PureBasic procedures for LiquidFun
- **<a href="https://github.com/seanhaydongriffin/PB-LiquidFun-C/raw/master/bin/PB_LiquidFun_OpenGL_demo_setup.exe" target="_blank">src/PB_LiquidFun_OpenGL_demo.pb</a>** is the demonstration source
- **<a href="https://github.com/seanhaydongriffin/PB-LiquidFun-C/raw/master/bin/PB_LiquidFun_OpenGL_demo_setup.exe" target="_blank">src/example.pb</a>** is the full source of the Example below
- **<a href="https://github.com/seanhaydongriffin/PB-LiquidFun-C/raw/master/bin/PB_LiquidFun_OpenGL_demo_setup.exe" target="_blank">src/data</a>** is a folder of JSON files containing all the definitions of the LiquidFun / Box2D objects (bodies, textures, fixtures, joints, particle systems and groups)
- **<a href="https://github.com/seanhaydongriffin/PB-LiquidFun-C/raw/master/bin/PB_LiquidFun_OpenGL_demo_setup.exe" target="_blank">src/texture</a>** is a folder (of PNG files) containing all the textures used in the library

## Example

The following is a walkthrough on how to write a simple LquidFun demo using this library.

Start your PB file as follows...

```
XIncludeFile "LiquidFun-C.pbi"
XIncludeFile "LiquidFun-C-Ex.pbi"
```

This includes both the base LiquidFun library and extension library.

The following block of code creates the LiquidFun and Box2D environment (including the world, bodies, textures, fixtures, joints, particle systems and groups).  The Box2D world is created with a downwards gravity of 10 meters per second.

```
b2World_CreateEx(0.0, -10.0)
b2World_CreateAll()
```

The following block of code creates the OpenGL environment, including the main window, OpenGL gadget configuration and textures.  The main window is set to 800 x 600 pixels, with title "LiquidFun Demo".

```
glWindow_Setup(0, 0, 800, 600, "LiquidFun Demo", 0, 0, 800, 600, 400, 500, $006600, #Black, 0)
glWorld_Setup(30.0, 800/600, 1.0, 1000.0, 0, -10, -190.0)
glWorld_CreateTextures()
```

```
frame_timer = 0
```

```
Repeat
```
  
```
  If (ElapsedMilliseconds() - frame_timer) > 16
    
    frame_timer = ElapsedMilliseconds()
```
    
```
    b2World_Step(world\ptr, (1 / 60.0), 6, 2)
```
    
```
    glColor3f_(1.0, 1.0, 1.0)
    glClearColor_(0.7, 0.7, 0.7, 1)
    glClear_ (#GL_COLOR_BUFFER_BIT | #GL_DEPTH_BUFFER_BIT)
    glDraw_Particles()
    glDraw_Fixtures()
    SetGadgetAttribute(Gadget, #PB_OpenGL_FlipBuffers, #True)
```

```
    Eventxx = WindowEvent()
  EndIf
    
Until Eventxx = #PB_Event_CloseWindow Or end_game = 1
```



You can run any of the executables (exe files) above to test the UDF. The Angry Nerds game demo should play similar to this YouTube video:

<a href="http://www.youtube.com/watch?feature=player_embedded&v=h5QH1O63Wik
" target="_blank"><img src="http://img.youtube.com/vi/h5QH1O63Wik/0.jpg" 
alt="IMAGE ALT TEXT HERE" width="240" height="180" border="10" /></a>

The four speed tests will test the performance of the UDF against four popular graphics engines, as follows.

Filename | Test
-------- | ----
Box2C_speed_test_SFML.exe | Tests the SFML graphics engine with the Box2D UDF
Box2C_speed_test_Irrlicht.exe | Tests the Irrlicht graphics engine with the Box2D UDF
Box2C_speed_test_D2D.exe | Tests the Direct 2D graphics engine with the Box2D UDF
Box2C_speed_test_GDIPlus.exe | Tests the GDI+ graphics engine with the Box2D UDF

Follow the prompts in the displayed GUI on how to conduct the test.

SFML (Box2C_speed_test_SFML.exe) should provide the best performance.

## Benchmarks

FPS readings are not limited.

test 1. 60hz box2d step, all frame rendering, for 4 bodies ...

Engine | FPS
------ | ---
Irrlicht | 1360
SFML | 1260
D2D | 650
GDI+ | 114

Repeated above but with 10 bodies ...

Engine | FPS
------ | ---
Irrlicht | 780
SFML | 700
D2D | 333
GDI+ | 86

Repeated above but with 100 bodies ...

Engine | FPS
------ | ---
Irrlicht | 100
SFML | 87
D2D | 44
GDI+ | 24

test 2. Irrlicht and SFML only. 60hz box2d step and frame rendering combined, for 100 bodies

Engine | FPS
------ | ---
Irrlicht | 7300
SFML | 6500

test 3. as above but excluding transforming / draw logic

Engine | FPS
------ | ---
Irrlicht | 13000
SFML | 14200

