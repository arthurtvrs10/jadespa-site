$ErrorActionPreference = 'Stop'
$projectRoot = $PSScriptRoot
$jdk = 'C:\Program Files\Java\jdk-21.0.11'
if (Test-Path -LiteralPath "$jdk\bin\java.exe") { $env:JAVA_HOME = $jdk }
$mavenRoot = Join-Path $env:USERPROFILE '.m2\wrapper\dists'
$maven = Get-ChildItem -LiteralPath $mavenRoot -Filter mvn.cmd -File -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
Push-Location (Join-Path $projectRoot 'backend')
try {
    Write-Host 'Inicie o MySQL no XAMPP. O banco jade_spa precisa estar configurado.'
    Write-Host 'Iniciando Jade Spa em http://localhost:8080/'
    if ($maven) { & $maven.FullName spring-boot:run }
    else { & .\mvnw.cmd spring-boot:run }
    if ($LASTEXITCODE -ne 0) { throw 'O servidor nao iniciou. Confira o erro acima.' }
} finally { Pop-Location }
