$ErrorActionPreference = 'Stop'
$docker = Get-Command docker -ErrorAction SilentlyContinue
if ($docker) { $dockerExe = $docker.Source }
else { $dockerExe = 'C:\Program Files\Docker\Docker\resources\bin\docker.exe' }
if (!(Test-Path -LiteralPath $dockerExe)) { throw 'Instale o Docker Desktop com containers Linux.' }
Push-Location $PSScriptRoot
try {
    if (!(Test-Path -LiteralPath '.env')) {
        $appSecret = [guid]::NewGuid().ToString('N')
        $rootSecret = [guid]::NewGuid().ToString('N')
        $adminSecret = [guid]::NewGuid().ToString('N')
        "APP_PORT=8080`nMYSQL_PASSWORD=$appSecret`nMYSQL_ROOT_PASSWORD=$rootSecret`nADMIN_EMAIL=admin@jadespa.local`nADMIN_PASSWORD=$adminSecret" | Set-Content -LiteralPath '.env' -Encoding utf8
    }
    & $dockerExe compose up -d --build
    if ($LASTEXITCODE -ne 0) { throw 'Nao foi possivel subir os containers. Verifique o Docker Desktop e o erro acima.' }
    $port = 8080
    foreach ($line in Get-Content -LiteralPath '.env') { if ($line -match '^APP_PORT=(\d+)$') { $port = [int]$Matches[1] } }
    $url = "http://localhost:$port/"
    Write-Host 'Aguardando a aplicacao...'
    $ready = $false
    for ($attempt = 0; $attempt -lt 60; $attempt++) {
        try {
            $response = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 3
            if ($response.StatusCode -eq 200) { $ready = $true; break }
        } catch { Start-Sleep -Seconds 2 }
    }
    if (!$ready) { & $dockerExe compose logs --tail 60 app; throw 'A aplicacao ainda nao respondeu. Consulte docker compose logs -f app.' }
    Write-Host "Jade Spa pronto: $url"
    Start-Process $url
} finally { Pop-Location }
