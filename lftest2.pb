

PrototypeC ProtoDisplayHelloFromDLL()

;result = OpenLibrary(0, "sean2jsbindings.dll")
result = OpenLibrary(0, "seandlltest.dll")
;Debug(result)

;Global b2World_Create.Protob2World_Create = GetFunction(0, "b2World_Create")
Global DisplayHelloFromDLL.ProtoDisplayHelloFromDLL = GetFunction(0, "DisplayHelloFromDLL")

;Import "seanjsbindings.lib"
  
;  b2World_Create(x.d, y.d) ;As "?b2World_Create@@YAPAXNN@Z"
;EndImport

;b2World_Create(1, 1)

DisplayHelloFromDLL()

;world.i

;world = b2World_Create()

CloseLibrary(0)

; IDE Options = PureBasic 5.40 LTS (Windows - x86)
; CursorPosition = 21
; EnableUnicode
; EnableXP