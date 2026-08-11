# ==============================================================================
# Script de Alteração de Papel de Parede via GitHub / N-able
# ==============================================================================

# 1. Configurações de Origem e Destino
# IMPORTANTE: Altere a URL abaixo para o link RAW do seu arquivo no GitHub
$urlImagem = "https://raw.githubusercontent.com/SuporteTIARJON/PapelDeParedeNova/main/wallpaper.jpeg"
$pastaDestino  = "C:\ProgramData\EmpresaTI"
$caminhoImagem = "$pastaDestino\wallpaper.jpeg"

# 2. Garante que o diretório de destino exista na máquina local
if (-not (Test-Path $pastaDestino)) {
    New-Item -Path $pastaDestino -ItemType Directory -Force | Out-Null
}

# 3. Força a utilização do protocolo TLS 1.2 para download do GitHub e realiza o download
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri $urlImagem -OutFile $caminhoImagem -UseBasicParsing

# 4. Compila a chamada da API do Windows para atualizar a área de trabalho
$code = @"
using System;
using System.Runtime.InteropServices;

public class Wallpaper {
    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@

Add-Type -TypeDefinition $code

# 5. Aplica a nova imagem e força a atualização imediata da interface do Windows
# SPI_SETDESKWALLPAPER = 0x0014 | SPIF_UPDATEINIFILE = 0x01 | SPIF_SENDCHANGE = 0x02
[Wallpaper]::SystemParametersInfo(0x0014, 0, $caminhoImagem, 0x01 -bor 0x02)
