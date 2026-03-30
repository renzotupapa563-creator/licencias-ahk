#Persistent

; 🔐 CONFIG
url := "https://raw.githubusercontent.com/renzotupapa563-creator/licencias-ahk/main/licencias.txt"
repoOwner := "renzotupapa563-creator"
repoName := "licencias-ahk"
filePath := "licencias.txt"
githubToken := "TU_TOKEN_PERSONAL" ; <- aquí pones tu token de GitHub

; 🧠 Generar HWID
DllCall("GetVolumeInformation", "Str", "C:\", "Str", "", "UInt", 0, "UInt*", serial, "UInt", 0, "UInt", 0, "Str", "", "UInt", 0)
hwid := serial

; 🔑 Pedir clave
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
        if (keyHWID = "" || keyHWID = hwid)
        {
            valid := true
            keyHWID := hwid  ; asigna HWID a la clave
        }
        else
        {
            MsgBox, 48, Error, Licencia inválida o ya usada en otra PC
            ExitApp
        }
    }
    newContent .= clave "|" keyHWID "`n"
}

if (!valid)
{
    MsgBox, 48, Error, Licencia no encontrada
    ExitApp
}

MsgBox, 64, OK, Licencia válida ✔

; 💾 Guardar HWID en GitHub
; Preparar contenido en Base64
encodedContent := Base64Encode(newContent)
urlAPI := "https://api.github.com/repos/" repoOwner "/" repoName "/contents/" filePath

; Obtener SHA del archivo actual
http := ComObjCreate("WinHttp.WinHttpRequest.5.1")
http.Open("GET", urlAPI, false)
http.SetRequestHeader("Authorization", "token " githubToken)
http.SetRequestHeader("User-Agent", "AHK-Script")
http.Send()
resp := http.ResponseText
RegExMatch(resp, """sha"":\s*""(.*?)""", shaMatch)
sha := shaMatch1

; Subir cambios
payload := "{""message"":""Update HWID for license " userKey """,""content"":""" encodedContent """,""sha"":""" sha """}"
http.Open("PUT", urlAPI, false)
http.SetRequestHeader("Authorization", "token " githubToken)
http.SetRequestHeader("User-Agent", "AHK-Script")
http.SetRequestHeader("Content-Type", "application/json")
http.Send(payload)

; ✅ Tu hack original
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

; 🔹 Función Base64
Base64Encode(str)
{
    DllCall("Crypt32.dll\CryptBinaryToStringA", "Ptr", &str, "UInt", StrPut(str, "CP0"), "UInt", 0x1, "Ptr", 0, "UInt*", outSize)
    VarSetCapacity(out, outSize)
    DllCall("Crypt32.dll\CryptBinaryToStringA", "Ptr", &str, "UInt", StrPut(str, "CP0"), "UInt", 0x1, "Str", out, "UInt*", outSize)
    return out
}
