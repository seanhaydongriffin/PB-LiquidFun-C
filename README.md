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

Click **Clone or download** above, then **<a href="https://github.com/seanhaydongriffin/PB-LiquidFun-C/archive/master.zip" target="_blank">Download ZIP</a>**, and download and extract the contents of the zip file to your computer.

## Contents

- **<a href="https://github.com/seanhaydongriffin/PB-LiquidFun-C/raw/master/bin/PB_LiquidFun_OpenGL_demo_setup.exe" target="_blank">bin/PB_LiquidFun_OpenGL_demo_setup.exe</a>** is the installer for the demo of the library
- **<a href="https://github.com/seanhaydongriffin/PB-LiquidFun-C/raw/master/src/LiquidFun-C.lib" target="_blank">src/LiquidFun-C.lib</a>** is a static C library of LiquidFun (required by LiquidFun-C.pbi below)
- **<a href="https://github.com/seanhaydongriffin/PB-LiquidFun-C/raw/master/src/LiquidFun-C.dll" target="_blank">src/LiquidFun-C.dll</a>** is a dynamic C library of LiquidFun (required by LiquidFun-C.pbi below)
- **<a href="https://github.com/seanhaydongriffin/PB-LiquidFun-C/raw/master/src/CSFML.pbi" target="_blank">src/CSFML.pbi</a>** is a PureBasic Interface File (library) for SFML (required by LiquidFun-C-Ex.pbi below)
- **<a href="https://github.com/seanhaydongriffin/PB-LiquidFun-C/raw/master/src/LiquidFun-C.pbi" target="_blank">src/LiquidFun-C.pbi</a>** is the PureBasic Interface File (library) for LiquidFun
- **<a href="https://github.com/seanhaydongriffin/PB-LiquidFun-C/raw/master/src/LiquidFun-C-Ex.pbi" target="_blank">src/LiquidFun-C-Ex.pbi</a>** is an extended library of PureBasic procedures for LiquidFun
- **<a href="https://github.com/seanhaydongriffin/PB-LiquidFun-C/raw/master/src/PB_LiquidFun_OpenGL_demo.pb" target="_blank">src/PB_LiquidFun_OpenGL_demo.pb</a>** is the demonstration source
- **<a href="https://github.com/seanhaydongriffin/PB-LiquidFun-C/raw/master/src/example.pb" target="_blank">src/example.pb</a>** is the full source of the Example below
- **<a href="https://github.com/seanhaydongriffin/PB-LiquidFun-C/tree/master/src/data" target="_blank">src/data</a>** is a folder of JSON files containing all the definitions of the LiquidFun / Box2D objects (bodies, textures, fixtures, joints, particle systems and groups)
- **<a href="https://github.com/seanhaydongriffin/PB-LiquidFun-C/tree/master/src/texture" target="_blank">src/texture</a>** is a folder (of PNG files) containing all the textures used in the library

## Requirements

This code has been tested on Windows 7, 8 and 10 64-bit operating systems.

The code was developed in PureBasic version 5.60.

The code has also been tested on a number of OpenGL versions including 1.2, 3.0 and 4.0.

## Example

The following is a walkthrough on writing a simple LiquidFun demo using this library.

Start your PB file as follows.

```
XIncludeFile "LiquidFun-C.pbi"
XIncludeFile "LiquidFun-C-Ex.pbi"
```

This will include both the base LiquidFun library and extension library.

The following block of code establishes the LiquidFun and Box2D environment.  The Box2D world is created with a downwards gravity of 10 meters per second.  All physics objects (including the world, bodies, textures, fixtures, joints, particle systems and groups) are loaded from the default JSON files (pre-existing in the **data** folder), which define their properties (such as initial positions, velocities, shape, densities, friction, masks, vertices and so forth).

```
b2World_CreateEx(0.0, -10.0)
b2World_CreateAll()
```

The following block of code creates the OpenGL environment, including the main window, OpenGL gadget configuration and textures.  The main window is set to 800 x 600 pixels, with title "LiquidFun Demo".  Within this window is a PureBasic OpenGL Gadget of the same dimensions as the main window.  

The OpenGL world is configured with a field of view of 30 degrees, and aspect ratio matching that of the OpenGL gadget (800:600 pixels), near and far clipping limits of 1 and 1000, and an initial main camera offset of -10 vertically and depth of -190.

**glWorld_CreateTextures()** takes the textures that were loaded into the Box2D environment (from b2World_CreateAll() above) and creates these as visible textures for the OpenGL environment.

```
glWindow_Setup(0, 0, 800, 600, "LiquidFun Demo", 0, 0, 800, 600, 400, 500, $006600, #Black)
glWorld_Setup(30.0, 800/600, 1.0, 1000.0, 0, -10, -190.0)
glWorld_CreateTextures()
```

The next block of code initiates the main animation loop.  The **frame_timer** is used to ensure the rate of animation is 60 frames per second (being every 16 milliseconds).

```
frame_timer = 0

Repeat
  
  If (ElapsedMilliseconds() - frame_timer) > 16
    
    frame_timer = ElapsedMilliseconds()
```

For each frame of animation in this loop the Box2D world is stepped one frame.  The default parameters below for **b2World_Step** are used.

```
    b2World_Step(world\ptr, (1 / 60.0), 6, 2)
```

The following OpenGL calls paint (draw) the LiquidFun particles and Box2D fixtures onto the OpenGL world.  **glColor3f_** resets the current color. **glClearColor_** sets the background color of the OpenGL gadget.  **glClear** clears the OpenGL gadget for the next frame of animation.

**glDraw_Particles** then draws all LiquidFun particles in all active particle systems and groups.  **glDraw_Fixtures** draws all active Box2D fixtures.

The **SetGadgetAttribute** call is responsible for displaying all objects drawn above for this (each) frame of animation.

```
    glColor3f_(1.0, 1.0, 1.0)
    glClearColor_(0.7, 0.7, 0.7, 1)
    glClear_ (#GL_COLOR_BUFFER_BIT | #GL_DEPTH_BUFFER_BIT)
    glDraw_Particles()
    glDraw_Fixtures()
    SetGadgetAttribute(Gadget, #PB_OpenGL_FlipBuffers, #True)
```

Finally, we check for the event that the user has closed the main window, and if so exit the program.

```
    Eventxx = WindowEvent()
  EndIf
    
Until Eventxx = #PB_Event_CloseWindow Or end_game = 1
```

Here is the complete PB example ...

```
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
```

Once executed the main "LiquidFun Demo" window should be displayed, with a scene consisting of a circular group of (water-like) particles descending (via gravity) onto a textured green / brown platform.  The platform has two textured posts attached at each end.  There is a textured boat at one end.  The OpenGL world position of 0,0 is drawn (just above the platform) for reference.

As the scene animates you'll notice the water particles gently push the boat off the platform (as per the laws of physics).

A more advanced and interactive version of this scene is in the demo (see the **Demonstration** section above).
