#Persistent

url := "https://raw.githubusercontent.com/renzotupapa563-creator/licencias-ahk/main/licencias.txt"

; 🔑 Pedir clave
InputBox, userKey, Licencia, Ingresa tu clave:
if (ErrorLevel)
    ExitApp

userKey := Trim(userKey)
StringLower, userKey, userKey

; 🧠 HWID
DriveGet, serial, Serial, C:\
hwid := Trim(serial)

; 🌐 Descargar archivo
tempFile := A_Temp "\licencias.txt"
url2 := url "?nocache=" A_TickCount
UrlDownloadToFile, %url2%, %tempFile%

FileRead, content, %tempFile%

valid := false

Loop, Parse, content, `n, `r
{
    line := Trim(A_LoopField)
    if (line = "")
        continue

    pos := InStr(line, "|")

    if (pos)
    {
        clave := Trim(SubStr(line, 1, pos-1))
        keyHWID := Trim(SubStr(line, pos+1))
keyHWID := RegExReplace(keyHWID, "[^0-9]")
    }
    else
    {
        clave := Trim(line)
        keyHWID := ""
    }

    StringLower, clave, clave

    if (clave = userKey)
    {
        ; 🔓 SIN ACTIVAR
        if (keyHWID = "")
        {
            MsgBox, 64, Activación, Envíame este código:`n`n%hwid%
            ExitApp
        }

        ; ✅ ACTIVADA
        if (Trim(keyHWID) = Trim(hwid))
        {
            valid := true
            break
        }

        ; ❌ YA USADA
        MsgBox, 48, Error, Licencia usada en otra PC
        ExitApp
    }
}

if (!valid)
{
    MsgBox, 48, Error, Licencia inválida
    ExitApp
}

MsgBox, 64, OK, Acceso concedido ✔

SetTimer, StaminaHack, 100
return


StaminaHack:
Process, Exist, gta_sa.exe
pid := ErrorLevel

if (pid)
{
    hProcess := DllCall("OpenProcess", "UInt", 0x1F0FFF, "Int", 0, "UInt", pid)

    staminaAddr := 0xB7CDB4

    VarSetCapacity(buffer, 4, 0)
    NumPut(1000.0, buffer, 0, "Float")

    DllCall("WriteProcessMemory", "Ptr", hProcess, "Ptr", staminaAddr, "Ptr", &buffer, "UInt", 4, "Ptr", 0)

    DllCall("CloseHandle", "Ptr", hProcess)
}
return
