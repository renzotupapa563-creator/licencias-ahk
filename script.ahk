#Persistent

; 🔐 CONFIG
url := "https://tu-link.com/licencias.txt" ; ← CAMBIA ESTO

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

; 🔍 Validar clave
if !InStr(content, userKey)
{
    MsgBox, 48, Error, Licencia inválida
    ExitApp
}

MsgBox, 64, OK, Licencia válida ✔

SetTimer, StaminaHack, 100
return


; 💪 TU HACK ORIGINAL
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