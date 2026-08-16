#Requires -Version 7.0
<#
    Synchronizacja repozytorium garmin-notes:
    1. git pull
    2. git add (jeśli są zmiany)
    3. git commit -m "sync from XTOWER"
    4. git push
#>

$ErrorActionPreference = "Stop"

# Zawsze działaj w katalogu, w którym leży ten skrypt
Set-Location -Path $PSScriptRoot

function Fail($msg) {
    Write-Host $msg -ForegroundColor Red
    Read-Host "Naciśnij Enter, aby zamknąć"
    exit 1
}

if (-not (Test-Path (Join-Path $PSScriptRoot ".git"))) {
    Fail "Katalog '$PSScriptRoot' nie jest repozytorium git."
}

Write-Host "== Pobieranie zmian (git pull) ==" -ForegroundColor Cyan
git pull
if ($LASTEXITCODE -ne 0) {
    Fail "git pull nie powiodło się."
}

Write-Host "== Sprawdzanie lokalnych zmian ==" -ForegroundColor Cyan
$status = git status --porcelain
if ([string]::IsNullOrWhiteSpace($status)) {
    Write-Host "Brak lokalnych zmian do zacommitowania." -ForegroundColor Yellow
}
else {
    Write-Host "== Dodawanie zmian (git add) ==" -ForegroundColor Cyan
    git add -A
    if ($LASTEXITCODE -ne 0) {
        Fail "git add nie powiodło się."
    }

    Write-Host "== Commit ==" -ForegroundColor Cyan
    git commit -m "sync from XTOWER"
    if ($LASTEXITCODE -ne 0) {
        Fail "git commit nie powiodło się."
    }

    Write-Host "== Wysyłanie zmian (git push) ==" -ForegroundColor Cyan
    git push
    if ($LASTEXITCODE -ne 0) {
        Fail "git push nie powiodło się."
    }
}

Write-Host "== Gotowe ==" -ForegroundColor Green
Read-Host "Naciśnij Enter, aby zamknąć"
