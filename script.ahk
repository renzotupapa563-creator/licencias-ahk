#Persistent

url := "https://raw.githubusercontent.com/renzotupapa563-creator/licencias-ahk/main/licencias.txt"

; 🧠 Obtener HWID
DriveGet, serial, Serial, C:\
hwid := serial

; 🔑 Pedir clave
InputBox, userKey, Licencia, Ingresa tu clave:
if (userKey = "")
{
    MsgBox, Cancelado
    ExitApp
}

; 🌐 Descargar lista
tempFile := A_Temp "\keys.txt"
UrlDownloadToFile, %url%, %tempFile%
FileRead, content, %tempFile%

valid := false
needsBind := false

Loop, Parse, content, `n, `r
{
    StringSplit, parts, A_LoopField, |
    clave := parts1
    keyHWID := parts2

    if (clave = userKey)
    {
        if (keyHWID = "")
        {
            needsBind := true
            valid := false
            break
        }
        else if (keyHWID = hwid)
        {
            valid := true
            break
        }
        else
        {
            MsgBox, 48, Error, Esta licencia ya está usada en otra PC
            ExitApp
        }
    }
}

if (needsBind)
{
    MsgBox, 64, Activación, Envíame este código para activar tu licencia:`n`n%hwid%
    ExitApp
}

if (!valid)
{
    MsgBox, 48, Error, Licencia inválida
    ExitApp
}

MsgBox, 64, OK, Licencia válida ✔

SetTimer, StaminaHack, 100
return
