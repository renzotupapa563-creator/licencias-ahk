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
    clave := Trim(parts1)
    keyHWID := Trim(parts2)

    if (StrLower(clave) = StrLower(userKey))
    {
        if (keyHWID = "")
        {
            needsBind := true
            break
        }
        else if (Trim(keyHWID) = Trim(hwid))
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

StaminaHack:
Process, Exist, gta_sa.exe
pid := ErrorLevel

if (pid)
{
    hProcess := DllCall("OpenProcess", "UInt", 0x1F0FFF, "Int", 0, "UInt", pid)

    ; Dirección de stamina (GTA SA 1.0 US)
    staminaAddr := 0xB7CDB4

    VarSetCapacity(buffer, 4, 0)
    NumPut(1000.0, buffer, 0, "Float") ; stamina alta

    DllCall("WriteProcessMemory", "Ptr", hProcess, "Ptr", staminaAddr, "Ptr", &buffer, "UInt", 4, "Ptr", 0)

    DllCall("CloseHandle", "Ptr", hProcess)
}
return
