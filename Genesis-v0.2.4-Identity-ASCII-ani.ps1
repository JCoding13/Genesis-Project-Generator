# ============================================================
# Project Generator
# Version : v0.2.4 "Identity"
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
# CONFIGURACION
# ============================================================

$script:AppVersion = '0.2.4'
$script:Codename = 'Identity'

$script:ProjectName = ''
$script:Extension = ''
$script:TotalVersions = 0
$script:Base = ''
$script:InitialAnimationPlayed = $false

# ============================================================
# CARACTERES VISUALES
# Construidos mediante codigos numericos para evitar problemas
# de codificacion en el archivo .ps1.
# ============================================================

$script:BoxTopLeft = [string][char]0x2554
$script:BoxTopRight = [string][char]0x2557
$script:BoxBottomLeft = [string][char]0x255A
$script:BoxBottomRight = [string][char]0x255D
$script:BoxHorizontal = [string][char]0x2550
$script:BoxVertical = [string][char]0x2551

$script:BlockFull = [string][char]0x2588
$script:BlockLower = [string][char]0x2584
$script:BlockUpper = [string][char]0x2580

# ============================================================
# LOGOTIPO PERSONALIZADO: GENESIS
#
# Cada letra se construye mediante una matriz de 5 x 5.
# 1 = bloque completo.
# 0 = espacio.
#
# La N utiliza una diagonal escalonada de bloques.
# No se utilizan barras diagonales como parte del dibujo.
#
# La I tiene barra superior, columna central y barra inferior.
# No se confunde con una T.
# ============================================================

$script:LogoWord = 'GENESIS'

$script:LogoGlyphs = @{
    'G' = @(
        '11111'
        '10000'
        '10111'
        '10001'
        '11111'
    )

    'E' = @(
        '11111'
        '10000'
        '11111'
        '10000'
        '11111'
    )

    'N' = @(
        '10001'
        '11001'
        '10101'
        '10011'
        '10001'
    )

    'S' = @(
        '11111'
        '10000'
        '11111'
        '00001'
        '11111'
    )

    'I' = @(
        '11111'
        '00100'
        '00100'
        '00100'
        '11111'
    )
}

$script:AsciiLogoRows = @()

for ($rowIndex = 0; $rowIndex -lt 5; $rowIndex++) {
    $lineBuilder = New-Object System.Text.StringBuilder

    for (
        $letterIndex = 0;
        $letterIndex -lt $script:LogoWord.Length;
        $letterIndex++
    ) {
        $letter = $script:LogoWord.Substring($letterIndex, 1)
        $pattern = $script:LogoGlyphs[$letter][$rowIndex]

        for ($columnIndex = 0; $columnIndex -lt 5; $columnIndex++) {
            if ($pattern[$columnIndex] -eq '1') {
                [void]$lineBuilder.Append($script:BlockFull)
            }
            else {
                [void]$lineBuilder.Append(' ')
            }
        }

        if ($letterIndex -lt ($script:LogoWord.Length - 1)) {
            [void]$lineBuilder.Append(' ')
        }
    }

    $script:AsciiLogoRows += $lineBuilder.ToString().TrimEnd()
}

$script:LogoCaptions = @(
    'PROJECT GENERATOR'
    ('v{0} "{1}"' -f $script:AppVersion, $script:Codename)
    'THINK BIG. BUILD BIG.'
)

$script:LogoInnerWidth = 0

foreach ($line in $script:AsciiLogoRows) {
    if ($line.Length -gt $script:LogoInnerWidth) {
        $script:LogoInnerWidth = $line.Length
    }
}

foreach ($caption in $script:LogoCaptions) {
    if ($caption.Length -gt $script:LogoInnerWidth) {
        $script:LogoInnerWidth = $caption.Length
    }
}

# ============================================================
# README INTEGRADO
# ============================================================

$script:Readme = @(
    '# Project Generator'
    ''
    'Version: v0.2.4 Identity'
    ''
    'Think Big. Build Big.'
    ''
    'Everything has to start somewhere.'
    'Big ideas require big tools.'
    ''
    'Project Generator es una herramienta de Project Genesis para'
    'crear estructuras iniciales de proyectos y archivos de version.'
    ''
    '## Funciones'
    ''
    '- Menu principal.'
    '- Documentacion integrada.'
    '- Logotipo de Project Genesis con caracteres de bloques.'
    '- Letra N con diagonal escalonada construida con bloques.'
    '- Letra I con barras superior e inferior.'
    '- Animacion de aparicion del logotipo.'
    '- Seleccion de carpeta mediante Windows Forms.'
    '- Generacion de archivos de version independientes.'
    '- README, LICENSE y CHANGELOG integrados.'
    '- Validacion de entradas.'
    '- Proteccion frente a proyectos existentes.'
    '- Manejo de errores durante la creacion.'
    ''
    '## Filosofia de desarrollo'
    ''
    'Las versiones anteriores deben conservarse como puntos de recuperacion.'
    'Cada nueva version debe poder evaluarse sin perder las anteriores.'
    ''
    'Con gran ayuda de ChatGPT.'
) -join [Environment]::NewLine

# ============================================================
# LICENCIA INTEGRADA
# ============================================================

$script:License = @(
    'PROJECT GENERATOR'
    'PROPRIETARY SOFTWARE NOTICE'
    ''
    ('Copyright {0} 2026 Project Genesis. All rights reserved.' -f [char]0x00A9)
    ''
    'Project Generator, including its source code, documentation, interface,'
    'and associated materials, is the proprietary property of Project Genesis,'
    'to the extent those rights are owned or lawfully controlled by Project Genesis.'
    ''
    'No license is granted to reproduce, modify, adapt, distribute, sublicense,'
    'publish, or create derivative works from this software without prior'
    'written authorization from the rights holder, except as permitted by'
    'applicable law and the applicable terms of the platforms on which'
    'the software is published.'
    ''
    'Any authorized use or copy must preserve this notice and any other'
    'applicable copyright and proprietary notices.'
    ''
    'Unauthorized use may result in legal remedies available under'
    'applicable law. Nothing in this notice excludes rights or exceptions'
    'that cannot lawfully be restricted.'
) -join [Environment]::NewLine

# ============================================================
# CHANGELOG INTEGRADO
# ============================================================

$script:Changelog = @(
    '# Changelog'
    ''
    '## v0.2.4 - Identity'
    '- Rediseño del logotipo de Project Genesis.'
    '- Letras construidas mediante matrices de bloques.'
    '- N con diagonal escalonada, sin barras diagonales.'
    '- I con barras superior e inferior.'
    '- Marco geometrico de doble linea.'
    '- Animacion de aparicion por filas.'
    '- Animacion reproducible desde la opcion 4.'
    '- Acreditacion añadida al README integrado.'
    ''
    '## v0.2.3 - Copyright'
    '- Aviso de propiedad intelectual para Project Generator.'
    '- Etiqueta de extension actualizada.'
    '- Plantilla personalizable de derechos de autor.'
    ''
    '## v0.2.2 - Stability'
    '- Correccion del flujo del menu principal.'
    '- Validacion de datos.'
    '- Proteccion frente a proyectos existentes.'
    '- Documentacion especifica para cada proyecto.'
    '- Manejo de errores durante la creacion.'
    ''
    '## v0.2.1 - Blueprint'
    '- Menu principal.'
    '- README, LICENSE y CHANGELOG integrados.'
    '- Generacion inicial de archivos de version.'
) -join [Environment]::NewLine

# ============================================================
# CONSTRUCCION DE LAS LINEAS DEL LOGOTIPO
# ============================================================

function Format-LogoCaption {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Text
    )

    $leftPadding = [int][Math]::Floor(
        ($script:LogoInnerWidth - $Text.Length) / 2
    )

    return $Text.PadLeft(
        $Text.Length + $leftPadding
    ).PadRight($script:LogoInnerWidth)
}

function Get-LogoDisplayLines {
    $width = $script:LogoInnerWidth + 2

    $horizontalLine = $script:BoxHorizontal * $width

    $borderTop = (
        $script:BoxTopLeft +
        $horizontalLine +
        $script:BoxTopRight
    )

    $borderBottom = (
        $script:BoxBottomLeft +
        $horizontalLine +
        $script:BoxBottomRight
    )

    $emptyLine = (
        $script:BoxVertical +
        (' ' * $width) +
        $script:BoxVertical
    )

    $lines = @()

    $lines += [PSCustomObject]@{
        Text  = $borderTop
        Color = 'DarkGray'
    }

    $lines += [PSCustomObject]@{
        Text  = $emptyLine
        Color = 'DarkGray'
    }

    foreach ($row in $script:AsciiLogoRows) {
        $paddedRow = $row.PadRight($script:LogoInnerWidth)

        $lines += [PSCustomObject]@{
            Text  = $script:BoxVertical + ' ' + $paddedRow + ' ' + $script:BoxVertical
            Color = 'Cyan'
        }
    }

    $lines += [PSCustomObject]@{
        Text  = $emptyLine
        Color = 'DarkGray'
    }

    $caption = Format-LogoCaption -Text $script:LogoCaptions[0]

    $lines += [PSCustomObject]@{
        Text  = $script:BoxVertical + ' ' + $caption + ' ' + $script:BoxVertical
        Color = 'White'
    }

    $caption = Format-LogoCaption -Text $script:LogoCaptions[1]

    $lines += [PSCustomObject]@{
        Text  = $script:BoxVertical + ' ' + $caption + ' ' + $script:BoxVertical
        Color = 'Gray'
    }

    $caption = Format-LogoCaption -Text $script:LogoCaptions[2]

    $lines += [PSCustomObject]@{
        Text  = $script:BoxVertical + ' ' + $caption + ' ' + $script:BoxVertical
        Color = 'DarkCyan'
    }

    $lines += [PSCustomObject]@{
        Text  = $emptyLine
        Color = 'DarkGray'
    }

    $lines += [PSCustomObject]@{
        Text  = $borderBottom
        Color = 'DarkGray'
    }

    return $lines
}

# ============================================================
# ANIMACION DEL LOGOTIPO
# -Animate reproduce una unica aparicion, fila por fila.
# Sin bucles de repeticion ni animacion permanente.
# ============================================================

function Show-AsciiLogo {
    param (
        [switch]$Animate
    )

    $logoLines = @(Get-LogoDisplayLines)

    foreach ($line in $logoLines) {
        Write-Host $line.Text -ForegroundColor $line.Color

        if ($Animate) {
            Start-Sleep -Milliseconds 55
        }
    }
}

function Show-Banner {
    Clear-Host
    Write-Host ''

    if (-not $script:InitialAnimationPlayed) {
        Show-AsciiLogo -Animate
        $script:InitialAnimationPlayed = $true
    }
    else {
        Show-AsciiLogo
    }

    Write-Host ''
}

# ============================================================
# MENU PRINCIPAL
# ============================================================

function MainMenu {
    while ($true) {
        Show-Banner

        Write-Host '[1] README'
        Write-Host '[2] LICENSE / Propiedad intelectual'
        Write-Host '[3] CHANGELOG'
        Write-Host '[4] Logo ASCII'
        Write-Host ''
        Write-Host 'ENTER = Nuevo proyecto'
        Write-Host 'EXIT  = Salir'
        Write-Host ''

        $choice = (Read-Host '>').Trim().ToUpperInvariant()

        switch ($choice) {
            '1' {
                Clear-Host
                Write-Host $script:Readme
                [void](Read-Host "`nPresiona ENTER para volver al menu")
                continue
            }

            '2' {
                Clear-Host
                Write-Host $script:License
                [void](Read-Host "`nPresiona ENTER para volver al menu")
                continue
            }

            '3' {
                Clear-Host
                Write-Host $script:Changelog
                [void](Read-Host "`nPresiona ENTER para volver al menu")
                continue
            }

            '4' {
                Clear-Host
                Write-Host ''
                Show-AsciiLogo -Animate
                Write-Host ''
                [void](Read-Host 'Presiona ENTER para volver al menu')
                continue
            }

            'EXIT' {
                return $false
            }

            '' {
                return $true
            }

            default {
                Write-Host ''
                Write-Host 'Opcion invalida.' -ForegroundColor Yellow
                Start-Sleep -Seconds 1
            }
        }
    }
}

# ============================================================
# CAPTURA Y VALIDACION DE DATOS
# ============================================================

function Get-ProjectData {
    while ($true) {
        $candidateName = (Read-Host 'Nombre del proyecto').Trim()

        if ([string]::IsNullOrWhiteSpace($candidateName)) {
            Write-Host 'El nombre no puede estar vacio.' -ForegroundColor Yellow
            continue
        }

        if ($candidateName.Length -gt 100) {
            Write-Host 'El nombre no puede superar los 100 caracteres.' -ForegroundColor Yellow
            continue
        }

        if (
            $candidateName -match '[\\/:*?"<>|]' -or
            $candidateName -match '[. ]$'
        ) {
            Write-Host 'El nombre contiene caracteres no permitidos.' -ForegroundColor Yellow
            continue
        }

        if ($candidateName -eq '.' -or $candidateName -eq '..') {
            Write-Host 'El nombre del proyecto no es valido.' -ForegroundColor Yellow
            continue
        }

        $baseName = ($candidateName -split '\.')[0]

        if ($baseName -match '^(CON|PRN|AUX|NUL|COM[1-9]|LPT[1-9])$') {
            Write-Host 'Ese nombre esta reservado por Windows.' -ForegroundColor Yellow
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
            Write-Host 'El nombre contiene caracteres no permitidos.' -ForegroundColor Yellow
            continue
        }

        $script:ProjectName = $candidateName
        break
    }

    Write-Host ''
    Write-Host 'Ejemplos de extension: md, html, css' -ForegroundColor DarkGray

    $extensionPrompt = 'Extensi' + [char]0x00F3 + 'n (sin punto)'

    while ($true) {
        $candidateExtension = (Read-Host $extensionPrompt).Trim()

        if ([string]::IsNullOrWhiteSpace($candidateExtension)) {
            Write-Host 'La extension no puede estar vacia.' -ForegroundColor Yellow
            continue
        }

        if ($candidateExtension.Length -gt 32) {
            Write-Host 'La extension no puede superar los 32 caracteres.' -ForegroundColor Yellow
            continue
        }

        if ($candidateExtension -notmatch '^[A-Za-z0-9]+(?:[._-][A-Za-z0-9]+)*$') {
            Write-Host 'Extension invalida. Introducela sin el punto inicial.' -ForegroundColor Yellow
            continue
        }

        $script:Extension = $candidateExtension
        break
    }

    while ($true) {
        $rawCount = Read-Host 'Cantidad de versiones (1-100)'
        $versionCount = 0

        if (
            [int]::TryParse($rawCount, [ref]$versionCount) -and
            $versionCount -ge 1 -and
            $versionCount -le 100
        ) {
            $script:TotalVersions = $versionCount
            break
        }

        Write-Host 'Introduce un numero entero entre 1 y 100.' -ForegroundColor Yellow
    }
}

# ============================================================
# SELECCION DE CARPETA
# ============================================================

function Select-Folder {
    $dialog = $null

    try {
        $dialog = New-Object System.Windows.Forms.FolderBrowserDialog
        $dialog.Description = 'Selecciona la carpeta donde se creara el proyecto.'
        $dialog.ShowNewFolderButton = $true

        $result = $dialog.ShowDialog()

        if ($result -ne [System.Windows.Forms.DialogResult]::OK) {
            Write-Host 'Seleccion de carpeta cancelada.' -ForegroundColor Yellow
            return $false
        }

        $selectedPath = $dialog.SelectedPath

        if (
            [string]::IsNullOrWhiteSpace($selectedPath) -or
            -not (Test-Path -LiteralPath $selectedPath -PathType Container)
        ) {
            Write-Host 'La carpeta seleccionada no es valida.' -ForegroundColor Red
            return $false
        }

        $script:Base = $selectedPath
        return $true
    }
    catch {
        Write-Host 'ERROR: No se pudo seleccionar la carpeta.' -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor DarkRed
        return $false
    }
    finally {
        if ($null -ne $dialog) {
            $dialog.Dispose()
        }
    }
}

# ============================================================
# DOCUMENTACION DEL PROYECTO GENERADO
# ============================================================

function Build-ProjectReadme {
    $lastVersion = $script:TotalVersions - 1

    $content = @(
        ("# {0}" -f $script:ProjectName)
        ''
        ("Proyecto creado con Project Generator v{0}." -f $script:AppVersion)
        ''
        '## Estructura'
        ''
        '- Versions/: archivos de version.'
        '- README.md: documentacion del proyecto.'
        '- LICENSE.md: plantilla personalizable de derechos de autor.'
        '- CHANGELOG.md: historial de cambios.'
        ''
        '## Archivos de version'
        ''
        ("Se han generado {0} archivo(s), desde:" -f $script:TotalVersions)
        ''
        ("{0} v1.0.0.{1}" -f $script:ProjectName, $script:Extension)
        ''
        'hasta:'
        ''
        ("{0} v1.0.{1}.{2}" -f $script:ProjectName, $lastVersion, $script:Extension)
        ''
        'Los archivos estan vacios y preparados para completar.'
        ''
        '## Derechos de autor'
        ''
        'El archivo LICENSE.md contiene una plantilla.'
        'Sustituye los datos del titular y revisa las condiciones aplicables'
        'antes de publicar o distribuir este proyecto.'
        ''
        '## Desarrollo'
        ''
        'Agrega aqui la descripcion, las instrucciones de instalacion,'
        'el uso, los requisitos y cualquier otra informacion del proyecto.'
    )

    return ($content -join [Environment]::NewLine)
}

function Build-ProjectLicense {
    $year = (Get-Date).Year

    $content = @(
        'AVISO DE DERECHOS DE AUTOR'
        'PLANTILLA PERSONALIZABLE'
        ''
        ('Copyright {0} {1} [Nombre del titular de los derechos]. Todos los derechos reservados.' -f [char]0x00A9, $year)
        ''
        'Salvo que se indique expresamente lo contrario mediante una licencia'
        'valida o una autorizacion escrita del titular de los derechos, no se'
        'concede permiso para reproducir, modificar, distribuir, sublicenciar'
        'o crear obras derivadas de este proyecto, excepto en los casos'
        'permitidos por la legislacion aplicable.'
        ''
        'La utilizacion autorizada debera respetar las condiciones establecidas'
        'por el titular de los derechos y conservar los avisos de propiedad'
        'intelectual que correspondan.'
        ''
        'El uso no autorizado puede dar lugar a las acciones o medidas legales'
        'disponibles conforme a la legislacion aplicable.'
        ''
        'IMPORTANTE:'
        'Este texto es una plantilla. Sustituye el marcador por el titular'
        'correcto y verifica las condiciones antes de publicar el proyecto.'
    )

    return ($content -join [Environment]::NewLine)
}

function Build-ProjectChangelog {
    $content = @(
        '# Changelog'
        ''
        '## Unreleased'
        ("- Estructura inicial generada con Project Generator v{0}." -f $script:AppVersion)
    )

    return ($content -join [Environment]::NewLine)
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

    if (Test-Path -LiteralPath $projectPath) {
        Write-Host ''
        Write-Host 'ERROR: Ya existe una ruta con ese nombre.' -ForegroundColor Red
        Write-Host $projectPath -ForegroundColor Yellow
        Write-Host 'No se modifico ningun archivo existente.' -ForegroundColor Yellow
        return $false
    }

    $createdProject = $false

    try {
        $null = [System.IO.Directory]::CreateDirectory($projectPath)
        $createdProject = $true

        $versionsPath = Join-Path $projectPath 'Versions'
        $null = [System.IO.Directory]::CreateDirectory($versionsPath)

        Write-TextFile `
            -Path (Join-Path $projectPath 'README.md') `
            -Content (Build-ProjectReadme)

        Write-TextFile `
            -Path (Join-Path $projectPath 'LICENSE.md') `
            -Content (Build-ProjectLicense)

        Write-TextFile `
            -Path (Join-Path $projectPath 'CHANGELOG.md') `
            -Content (Build-ProjectChangelog)

        for ($i = 0; $i -lt $script:TotalVersions; $i++) {
            $versionFileName = '{0} v1.0.{1}.{2}' -f `
                $script:ProjectName, $i, $script:Extension

            $versionFilePath = Join-Path $versionsPath $versionFileName

            $fileStream = [System.IO.File]::Create($versionFilePath)

            try {
                # Archivo de version independiente.
            }
            finally {
                $fileStream.Dispose()
            }
        }

        Write-Host ''
        Write-Host '============================================================' -ForegroundColor Green
        Write-Host 'PROYECTO CREADO CORRECTAMENTE' -ForegroundColor Green
        Write-Host '============================================================' -ForegroundColor Green
        Write-Host ("Nombre:    {0}" -f $script:ProjectName)
        Write-Host ("Versiones: {0}" -f $script:TotalVersions)
        Write-Host ("Extension: .{0}" -f $script:Extension)
        Write-Host ("Ruta:      {0}" -f $projectPath)
        Write-Host ''

        try {
            Invoke-Item -Path $projectPath -ErrorAction Stop
        }
        catch {
            Write-Host 'AVISO: El proyecto se creo, pero no se pudo abrir automaticamente.' -ForegroundColor Yellow
        }

        return $true
    }
    catch {
        Write-Host ''
        Write-Host 'ERROR: No se pudo completar la creacion del proyecto.' -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor DarkRed

        if ($createdProject -and (Test-Path -LiteralPath $projectPath)) {
            try {
                Remove-Item `
                    -LiteralPath $projectPath `
                    -Recurse `
                    -Force `
                    -ErrorAction Stop

                Write-Host 'Se elimino la estructura incompleta.' -ForegroundColor Yellow
            }
            catch {
                Write-Host 'ADVERTENCIA: No se pudo eliminar toda la estructura incompleta.' -ForegroundColor Yellow
                Write-Host ("Revisa manualmente: {0}" -f $projectPath) -ForegroundColor Yellow
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
    Write-Host ''
    Write-Host 'Operacion cancelada. No se genero ningun proyecto.' -ForegroundColor Yellow
    return
}

$created = Create-Project

if (-not $created) {
    [void](Read-Host "`nPresiona ENTER para finalizar")
    return
}

[void](Read-Host "`nPresiona ENTER para finalizar")