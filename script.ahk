#Persistent

; 🔐 CONFIG
url := "https://raw.githubusercontent.com/renzotupapa563-creator/licencias-ahk/main/licencias.txt"

; 💻 Generar HWID
DllCall("GetVolumeInformationW","Str","C:\","Str","","UInt",0,"UIntP",serial,"UInt",0,"UInt",0,"Str","", "UInt",0)
hwid := serial

; 🧠 Pedir clave
InputBox, userKey, Licencia, Ingresa tu clave:

if (userKey = "")
{
    MsgBox, Cancelado
    ExitApp
}

; 🌐 Descargar lista de licencias
tempFile := A_Temp "\keys.txt"
UrlDownloadToFile, %url%, %tempFile%
FileRead, content, %tempFile%

; 🔍 Validar clave y HWID
valid := false
newContent := ""
Loop, Parse, content, `n, `r
{
    StringSplit, parts, A_LoopField, |
    clave := parts1
    keyHWID := parts2

    if (clave = userKey)
    {
        if (keyHWID = "" || keyHWID = hwid) ; si está vacía o coincide
        {
            valid := true
            keyHWID := hwid ; asigna HWID a la clave
        }
    }
    newContent .= clave "|" keyHWID "`n"
}

if (!valid)
{
    MsgBox, 48, Error, Licencia inválida o ya usada en otra PC
    ExitApp
}

; 💾 Guardar HWID actualizado (sobrescribiendo temporal)
FileDelete, %tempFile%
FileAppend, %newContent%, %tempFile%

MsgBox, 64, OK, Licencia válida ✔
