$urlImagem     = "https://raw.githubusercontent.com/SuporteTIARJON/PapelDeParedeNova/main/wallpaper.jpeg"
$pastaDestino  = "C:\ProgramData\EmpresaTI"
$caminhoImagem = "$pastaDestino\wallpaper.jpeg"

# 1. Garante a pasta local
if (-not (Test-Path $pastaDestino)) {
    New-Item -Path $pastaDestino -ItemType Directory -Force | Out-Null
}

# 2. Baixa a imagem do GitHub
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri $urlImagem -OutFile $caminhoImagem -UseBasicParsing

# 3. Configura o modo de exibicao para Preencher (Fill) no Registro
Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name WallpaperStyle -Value '2'
Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name TileWallpaper -Value '0'

# 4. Chama a API do Windows para aplicar e atualizar a tela
$code = @"
using System;
using System.Runtime.InteropServices;

public class Wallpaper {
    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@

Add-Type -TypeDefinition $code -ErrorAction SilentlyContinue
[Wallpaper]::SystemParametersInfo(0x0014, 0, $caminhoImagem, 0x01 -bor 0x02)