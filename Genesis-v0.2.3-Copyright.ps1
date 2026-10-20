# ============================================================
# Project Generator
# Version : v0.2.3 "Copyright"
# Slogan  : Think Big. Build Big.
# ============================================================

$ErrorActionPreference = 'Stop'

try {
    Add-Type -AssemblyName System.Windows.Forms -ErrorAction Stop
}
catch {
    Write-Host "ERROR: No se pudo cargar Windows Forms." -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor DarkRed
    return
}

Clear-Host

# ============================================================
# CONFIGURACION Y DOCUMENTACION
# ============================================================

$script:AppVersion = '0.2.3'
$script:Codename = 'Copyright'

$script:ProjectName = ''
$script:Extension = ''
$script:TotalVersions = 0
$script:Base = ''

$script:Readme = @"
# Project Generator

Version: v0.2.3 Copyright

Think Big. Build Big.

Everything has to start somewhere.
Big ideas require big tools.

Project Generator permite crear estructuras iniciales de proyectos,
archivos de version y documentacion integrada.

## Funciones

- Menu principal.
- Visualizacion de README, LICENSE y CHANGELOG.
- Seleccion de carpeta mediante Windows Forms.
- Creacion de archivos de version.
- Validacion de datos.
- Proteccion frente a proyectos existentes.
- Manejo de errores durante la creacion.
"@

$script:License = @"
PROJECT GENERATOR
PROPRIETARY SOFTWARE NOTICE

Copyright © 2026 Project Genesis. All rights reserved.

Project Generator, including its source code, documentation, interface,
and associated materials, is the proprietary property of Project Genesis.

No license is granted to reproduce, modify, adapt, distribute, sublicense,
publish, or create derivative works from this software without prior
written authorization from the rights holder, except as permitted by
applicable law.

Any authorized use or copy must preserve this notice and any other
applicable proprietary notices.

Unauthorized use may result in legal remedies available under applicable
law. Nothing in this notice excludes rights or exceptions that cannot
lawfully be restricted.
"@

$script:Changelog = @"
# Changelog

## v0.2.3 - Copyright
- Aviso de propiedad intelectual para Project Generator.
- Etiqueta de extension actualizada.
- Plantilla personalizable de derechos de autor para nuevos proyectos.
- Historial de versiones actualizado.

## v0.2.2 - Stability
- Correccion del flujo del menu principal.
- Validacion de nombres, extensiones y cantidad de versiones.
- Proteccion frente a proyectos ya existentes.
- Generacion de documentacion especifica para cada proyecto.
- Manejo de errores durante la creacion.
- Control de estructuras incompletas.

## v0.2.1 - Blueprint
- Menu principal.
- README, LICENSE y CHANGELOG integrados.
- Generacion inicial de archivos de version.
"@

# ============================================================
# INTERFAZ
# ============================================================

function Show-Banner {
    Clear-Host

    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host "             PROJECT GENERATOR v$script:AppVersion" -ForegroundColor Cyan
    Write-Host "                 $script:Codename" -ForegroundColor Cyan
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "                 Think Big. Build Big." -ForegroundColor DarkCyan
}

function MainMenu {
    while ($true) {
        Show-Banner

        Write-Host ""
        Write-Host "[1] README"
        Write-Host "[2] LICENSE / Propiedad intelectual"
        Write-Host "[3] CHANGELOG"
        Write-Host ""
        Write-Host "ENTER = Nuevo proyecto"
        Write-Host "EXIT  = Salir"
        Write-Host ""

        $choice = (Read-Host ">").Trim().ToUpperInvariant()

        if ($choice -eq '1') {
            Clear-Host
            Write-Host $script:Readme
            [void](Read-Host "`nPresiona ENTER para volver al menu")
            continue
        }

        if ($choice -eq '2') {
            Clear-Host
            Write-Host $script:License
            [void](Read-Host "`nPresiona ENTER para volver al menu")
            continue
        }

        if ($choice -eq '3') {
            Clear-Host
            Write-Host $script:Changelog
            [void](Read-Host "`nPresiona ENTER para volver al menu")
            continue
        }

        if ($choice -eq 'EXIT') {
            return $false
        }

        if ($choice -eq '') {
            return $true
        }

        Write-Host ""
        Write-Host "Opcion invalida." -ForegroundColor Yellow
        Start-Sleep -Seconds 1
    }
}

# ============================================================
# CAPTURA Y VALIDACION DE DATOS
# ============================================================

function Get-ProjectData {
    # Nombre del proyecto
    while ($true) {
        $candidateName = (Read-Host "Nombre del proyecto").Trim()

        if ([string]::IsNullOrWhiteSpace($candidateName)) {
            Write-Host "El nombre no puede estar vacio." -ForegroundColor Yellow
            continue
        }

        if ($candidateName.Length -gt 100) {
            Write-Host "El nombre no puede superar los 100 caracteres." -ForegroundColor Yellow
            continue
        }

        if (
            $candidateName -match '[\\/:*?"<>|]' -or
            $candidateName -match '\.$'
        ) {
            Write-Host "El nombre contiene caracteres no permitidos." -ForegroundColor Yellow
            continue
        }

        if ($candidateName -eq '.' -or $candidateName -eq '..') {
            Write-Host "El nombre del proyecto no es valido." -ForegroundColor Yellow
            continue
        }

        $baseName = ($candidateName -split '\.')[0]

        if ($baseName -match '^(CON|PRN|AUX|NUL|COM[1-9]|LPT[1-9])$') {
            Write-Host "Ese nombre esta reservado por Windows." -ForegroundColor Yellow
            continue
        }

        $containsInvalidCharacter = $false

        foreach ($character in [System.IO.Path]::GetInvalidFileNameChars()) {
            if ($candidateName.Contains([string]$character)) {
                $containsInvalidCharacter = $true
                break
            }
        }

        if ($containsInvalidCharacter) {
            Write-Host "El nombre contiene caracteres no permitidos." -ForegroundColor Yellow
            continue
        }

        $script:ProjectName = $candidateName
        break
    }

    # Extension
    Write-Host ""
    Write-Host "Ejemplos de extension: md, html, css" -ForegroundColor DarkGray

    while ($true) {
        $rawExtension = Read-Host "Extensión (sin punto)"
        $candidateExtension = $rawExtension.Trim()

        if ([string]::IsNullOrWhiteSpace($candidateExtension)) {
            Write-Host "La extension no puede estar vacia." -ForegroundColor Yellow
            continue
        }

        if ($candidateExtension.Length -gt 32) {
            Write-Host "La extension no puede superar los 32 caracteres." -ForegroundColor Yellow
            continue
        }

        if ($candidateExtension -notmatch '^[A-Za-z0-9]+(?:[._-][A-Za-z0-9]+)*$') {
            Write-Host "Extension invalida. Introducela sin el punto inicial." -ForegroundColor Yellow
            continue
        }

        $script:Extension = $candidateExtension
        break
    }

    # Cantidad de versiones
    while ($true) {
        $rawCount = Read-Host "Cantidad de versiones (1-100)"
        $versionCount = 0

        if (
            [int]::TryParse($rawCount, [ref]$versionCount) -and
            $versionCount -ge 1 -and
            $versionCount -le 100
        ) {
            $script:TotalVersions = $versionCount
            break
        }

        Write-Host "Introduce un numero entero entre 1 y 100." -ForegroundColor Yellow
    }
}

# ============================================================
# SELECCION DE CARPETA
# ============================================================

function Select-Folder {
    $dialog = New-Object System.Windows.Forms.FolderBrowserDialog

    try {
        $dialog.Description = "Selecciona la carpeta donde se creara el proyecto."
        $dialog.ShowNewFolderButton = $true

        $result = $dialog.ShowDialog()

        if ($result -ne [System.Windows.Forms.DialogResult]::OK) {
            Write-Host "Seleccion de carpeta cancelada." -ForegroundColor Yellow
            return $false
        }

        $selectedPath = $dialog.SelectedPath

        if (
            [string]::IsNullOrWhiteSpace($selectedPath) -or
            -not (Test-Path -LiteralPath $selectedPath -PathType Container)
        ) {
            Write-Host "La carpeta seleccionada no es valida." -ForegroundColor Red
            return $false
        }

        $script:Base = $selectedPath
        return $true
    }
    catch {
        Write-Host "ERROR: No se pudo seleccionar la carpeta." -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor DarkRed
        Write-Host "Comprueba que PowerShell pueda utilizar Windows Forms." -ForegroundColor Yellow

        return $false
    }
    finally {
        $dialog.Dispose()
    }
}

# ============================================================
# DOCUMENTACION DEL PROYECTO GENERADO
# ============================================================

function Build-ProjectReadme {
    $lastVersion = $script:TotalVersions - 1

    return @"
# $($script:ProjectName)

Proyecto creado con Project Generator v$($script:AppVersion).

## Estructura

- Versions/: archivos de version.
- README.md: documentacion del proyecto.
- LICENSE.md: plantilla personalizable de derechos de autor.
- CHANGELOG.md: historial de cambios.

## Archivos de version

Se han generado $($script:TotalVersions) archivo(s), desde:

$($script:ProjectName) v1.0.0.$($script:Extension)

hasta:

$($script:ProjectName) v1.0.$lastVersion.$($script:Extension)

Los archivos de version estan vacios y preparados para completar.

## Derechos de autor

El archivo LICENSE.md contiene una plantilla.
Sustituye los datos del titular y revisa las condiciones aplicables
antes de publicar o distribuir este proyecto.

## Desarrollo

Agrega aqui la descripcion, las instrucciones de instalacion,
el uso, los requisitos y cualquier otra informacion del proyecto.
"@
}

function Build-ProjectLicense {
    $year = (Get-Date).Year

    return @"
AVISO DE DERECHOS DE AUTOR
PLANTILLA PERSONALIZABLE

Copyright © $year [Nombre del titular de los derechos]. Todos los derechos reservados.

Salvo que se indique expresamente lo contrario mediante una licencia
valida o una autorizacion escrita del titular de los derechos, no se
concede permiso para reproducir, modificar, distribuir, sublicenciar
o crear obras derivadas de este proyecto, excepto en los casos
permitidos por la legislacion aplicable.

La utilizacion autorizada debera respetar las condiciones establecidas
por el titular de los derechos y conservar los avisos de propiedad
intelectual que correspondan.

El uso no autorizado puede dar lugar a las acciones o medidas legales
disponibles conforme a la legislacion aplicable.

IMPORTANTE:
Este texto es una plantilla. Sustituye el marcador por el titular
correcto y verifica las condiciones antes de publicar el proyecto.
"@
}

function Build-ProjectChangelog {
    return @"
# Changelog

## Unreleased
- Estructura inicial generada con Project Generator v$($script:AppVersion).
"@
}

# ============================================================
# ESCRITURA DE ARCHIVOS
# ============================================================

function Write-TextFile {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Path,

        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [string]$Content
    )

    Set-Content `
        -LiteralPath $Path `
        -Value $Content `
        -Encoding UTF8 `
        -ErrorAction Stop
}

# ============================================================
# CREACION DEL PROYECTO
# ============================================================

function Create-Project {
    $projectPath = Join-Path `
        -Path $script:Base `
        -ChildPath $script:ProjectName

    # Nunca sobrescribir un proyecto existente.
    if (Test-Path -LiteralPath $projectPath) {
        Write-Host ""
        Write-Host "ERROR: Ya existe una ruta con ese nombre." -ForegroundColor Red
        Write-Host $projectPath -ForegroundColor Yellow
        Write-Host "No se modifico ningun archivo existente." -ForegroundColor Yellow

        return $false
    }

    $createdProject = $false

    try {
        # Crear la carpeta principal.
        $null = [System.IO.Directory]::CreateDirectory($projectPath)
        $createdProject = $true

        # Crear la carpeta Versions.
        $versionsPath = Join-Path `
            -Path $projectPath `
            -ChildPath 'Versions'

        $null = [System.IO.Directory]::CreateDirectory($versionsPath)

        # Generar la documentacion.
        Write-TextFile `
            -Path (Join-Path $projectPath 'README.md') `
            -Content (Build-ProjectReadme)

        Write-TextFile `
            -Path (Join-Path $projectPath 'LICENSE.md') `
            -Content (Build-ProjectLicense)

        Write-TextFile `
            -Path (Join-Path $projectPath 'CHANGELOG.md') `
            -Content (Build-ProjectChangelog)

        # Generar los archivos de version.
        for ($i = 0; $i -lt $script:TotalVersions; $i++) {
            $versionFileName = '{0} v1.0.{1}.{2}' -f `
                $script:ProjectName, $i, $script:Extension

            $versionFilePath = Join-Path `
                -Path $versionsPath `
                -ChildPath $versionFileName

            $fileStream = [System.IO.File]::Create($versionFilePath)
            $fileStream.Dispose()
        }

        Write-Host ""
        Write-Host "============================================================" -ForegroundColor Green
        Write-Host "PROYECTO CREADO CORRECTAMENTE" -ForegroundColor Green
        Write-Host "============================================================" -ForegroundColor Green
        Write-Host "Nombre:    $script:ProjectName"
        Write-Host "Versiones: $script:TotalVersions"
        Write-Host "Extension: .$script:Extension"
        Write-Host "Ruta:      $projectPath"
        Write-Host ""

        # Abrir la carpeta sin invalidar la creacion si falla Explorer.
        try {
            Invoke-Item -Path $projectPath -ErrorAction Stop
        }
        catch {
            Write-Host "AVISO: El proyecto se creo, pero no se pudo abrir automaticamente." -ForegroundColor Yellow
        }

        return $true
    }
    catch {
        Write-Host ""
        Write-Host "ERROR: No se pudo completar la creacion del proyecto." -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor DarkRed

        # Intentar limpiar la estructura parcial creada por esta ejecucion.
        if ($createdProject -and (Test-Path -LiteralPath $projectPath)) {
            try {
                Remove-Item `
                    -LiteralPath $projectPath `
                    -Recurse `
                    -Force `
                    -ErrorAction Stop

                Write-Host "Se elimino la estructura incompleta." -ForegroundColor Yellow
            }
            catch {
                Write-Host "ADVERTENCIA: No se pudo eliminar toda la estructura incompleta." -ForegroundColor Yellow
                Write-Host "Revisa manualmente: $projectPath" -ForegroundColor Yellow
            }
        }

        return $false
    }
}

# ============================================================
# EJECUCION PRINCIPAL
# ============================================================

if (-not (MainMenu)) {
    return
}

Get-ProjectData

if (-not (Select-Folder)) {
    Write-Host ""
    Write-Host "Operacion cancelada. No se genero ningun proyecto." -ForegroundColor Yellow
    return
}

$created = Create-Project

if (-not $created) {
    [void](Read-Host "`nPresiona ENTER para finalizar")
    return
}

[void](Read-Host "`nPresiona ENTER para finalizar")