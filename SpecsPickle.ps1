Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Crear el formulario principal
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Hardware Detector'
$form.Size = New-Object System.Drawing.Size(1200, 750)
$form.StartPosition = 'CenterScreen'
$form.FormBorderStyle = 'FixedDialog'
$form.MaximizeBox = $false
$form.BackColor = [System.Drawing.Color]::FromArgb(15, 23, 42)
$form.Font = New-Object System.Drawing.Font('Segoe UI', 9)

# Obtener nombre del usuario
$userName = $env:USERNAME
if ([string]::IsNullOrEmpty($userName)) {
    $userName = "Usuario"
}

# Título de bienvenida
$welcomeLabel = New-Object System.Windows.Forms.Label
$welcomeLabel.Text = 'Bienvenido, '
$welcomeLabel.Font = New-Object System.Drawing.Font('Segoe UI', 24, [System.Drawing.FontStyle]::Bold)
$welcomeLabel.ForeColor = [System.Drawing.Color]::White
$welcomeLabel.AutoSize = $true
$welcomeLabel.Location = New-Object System.Drawing.Point(30, 30)
$form.Controls.Add($welcomeLabel)

$nameLabel = New-Object System.Windows.Forms.Label
$nameLabel.Text = $userName
$nameLabel.Font = New-Object System.Drawing.Font('Segoe UI', 24, [System.Drawing.FontStyle]::Bold)
$nameLabel.ForeColor = [System.Drawing.Color]::FromArgb(96, 165, 250)
$nameLabel.AutoSize = $true
$nameLabel.Location = New-Object System.Drawing.Point(($welcomeLabel.Location.X + 230), 30)
$form.Controls.Add($nameLabel)

# Función para crear tarjeta de información
function Create-InfoCard {
    param($title, $subtitle, $xPos, $yPos, $iconColor)
    
    $panel = New-Object System.Windows.Forms.Panel
    $panel.Size = New-Object System.Drawing.Size(360, 180)
    $panel.Location = New-Object System.Drawing.Point($xPos, $yPos)
    $panel.BackColor = [System.Drawing.Color]::FromArgb(30, 41, 59)
    
    # Bordes redondeados para el panel
    $radius = 15
    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $path.AddArc(0, 0, $radius, $radius, 180, 90)
    $path.AddArc($panel.Width - $radius, 0, $radius, $radius, 270, 90)
    $path.AddArc($panel.Width - $radius, $panel.Height - $radius, $radius, $radius, 0, 90)
    $path.AddArc(0, $panel.Height - $radius, $radius, $radius, 90, 90)
    $path.CloseFigure()
    $panel.Region = New-Object System.Drawing.Region($path)
    
    # Icono circular de color
    $iconPanel = New-Object System.Windows.Forms.Panel
    $iconPanel.Size = New-Object System.Drawing.Size(50, 50)
    $iconPanel.Location = New-Object System.Drawing.Point(20, 20)
    $iconPanel.BackColor = [System.Drawing.Color]::FromArgb(30, 41, 59)
    
    # Crear círculo
    $circleRadius = 50
    $circlePath = New-Object System.Drawing.Drawing2D.GraphicsPath
    $circlePath.AddEllipse(0, 0, $circleRadius, $circleRadius)
    $iconPanel.Region = New-Object System.Drawing.Region($circlePath)
    $iconPanel.BackColor = $iconColor
    
    $panel.Controls.Add($iconPanel)
    
    # Título
    $titleLabel = New-Object System.Windows.Forms.Label
    $titleLabel.Text = $title
    $titleLabel.Font = New-Object System.Drawing.Font('Segoe UI', 14, [System.Drawing.FontStyle]::Bold)
    $titleLabel.ForeColor = [System.Drawing.Color]::White
    $titleLabel.Location = New-Object System.Drawing.Point(90, 20)
    $titleLabel.AutoSize = $true
    $panel.Controls.Add($titleLabel)
    
    # Subtítulo
    $subtitleLabel = New-Object System.Windows.Forms.Label
    $subtitleLabel.Text = $subtitle
    $subtitleLabel.Font = New-Object System.Drawing.Font('Segoe UI', 9)
    $subtitleLabel.ForeColor = [System.Drawing.Color]::FromArgb(148, 163, 184)
    $subtitleLabel.Location = New-Object System.Drawing.Point(90, 48)
    $subtitleLabel.AutoSize = $true
    $panel.Controls.Add($subtitleLabel)
    
    # Contenedor de información
    $infoContainer = New-Object System.Windows.Forms.Panel
    $infoContainer.Size = New-Object System.Drawing.Size(320, 80)
    $infoContainer.Location = New-Object System.Drawing.Point(20, 85)
    $infoContainer.BackColor = [System.Drawing.Color]::FromArgb(30, 41, 59)
    $panel.Controls.Add($infoContainer)
    
    $result = @{
        Panel = $panel
        Container = $infoContainer
    }
    return $result
}

# Función para agregar información a la tarjeta
function Add-CardInfo {
    param($container, $label, $value, $yPos)
    
    $labelText = New-Object System.Windows.Forms.Label
    $labelText.Text = $label
    $labelText.Font = New-Object System.Drawing.Font('Segoe UI', 9)
    $labelText.ForeColor = [System.Drawing.Color]::FromArgb(148, 163, 184)
    $labelText.Location = New-Object System.Drawing.Point(0, $yPos)
    $labelText.AutoSize = $true
    $container.Controls.Add($labelText)
    
    $valueText = New-Object System.Windows.Forms.Label
    $valueText.Text = $value
    $valueText.Font = New-Object System.Drawing.Font('Segoe UI', 11, [System.Drawing.FontStyle]::Bold)
    $valueText.ForeColor = [System.Drawing.Color]::White
    $valueText.Location = New-Object System.Drawing.Point(0, ($yPos + 20))
    $valueText.Size = New-Object System.Drawing.Size(320, 25)
    $container.Controls.Add($valueText)
    
    return $valueText
}

# Crear tarjetas (2 filas x 3 columnas)
$cpuCard = Create-InfoCard -title "CPU" -subtitle "Informacion del Procesador" -xPos 30 -yPos 100 -iconColor ([System.Drawing.Color]::FromArgb(59, 130, 246))
$form.Controls.Add($cpuCard.Panel)

$gpuCard = Create-InfoCard -title "GPU" -subtitle "Informacion Grafica" -xPos 410 -yPos 100 -iconColor ([System.Drawing.Color]::FromArgb(16, 185, 129))
$form.Controls.Add($gpuCard.Panel)

$memoryCard = Create-InfoCard -title "Memoria" -subtitle "Informacion de RAM" -xPos 790 -yPos 100 -iconColor ([System.Drawing.Color]::FromArgb(168, 85, 247))
$form.Controls.Add($memoryCard.Panel)

$systemCard = Create-InfoCard -title "Sistema" -subtitle "Informacion del SO" -xPos 30 -yPos 300 -iconColor ([System.Drawing.Color]::FromArgb(239, 68, 68))
$form.Controls.Add($systemCard.Panel)

$storageCard = Create-InfoCard -title "Almacenamiento" -subtitle "Informacion del Disco" -xPos 410 -yPos 300 -iconColor ([System.Drawing.Color]::FromArgb(245, 158, 11))
$form.Controls.Add($storageCard.Panel)

$motherboardCard = Create-InfoCard -title "Placa Base" -subtitle "Informacion de la Tarjeta" -xPos 790 -yPos 300 -iconColor ([System.Drawing.Color]::FromArgb(34, 197, 94))
$form.Controls.Add($motherboardCard.Panel)

# Variables para almacenar los labels de valores
$cpuModel = Add-CardInfo -container $cpuCard.Container -label "Modelo" -value "Cargando..." -yPos 0
$cpuCores = Add-CardInfo -container $cpuCard.Container -label "Nucleos" -value "..." -yPos 45

$gpuModel = Add-CardInfo -container $gpuCard.Container -label "Modelo" -value "Cargando..." -yPos 0
$gpuVram = Add-CardInfo -container $gpuCard.Container -label "VRAM" -value "..." -yPos 45

$memoryTotal = Add-CardInfo -container $memoryCard.Container -label "Memoria Total" -value "Cargando..." -yPos 0
$memoryType = Add-CardInfo -container $memoryCard.Container -label "Tipo" -value "..." -yPos 45

$systemOS = Add-CardInfo -container $systemCard.Container -label "Sistema Operativo" -value "Cargando..." -yPos 0
$systemVersion = Add-CardInfo -container $systemCard.Container -label "Version" -value "..." -yPos 45

$storageDisk = Add-CardInfo -container $storageCard.Container -label "Disco Principal" -value "Cargando..." -yPos 0
$storageSpace = Add-CardInfo -container $storageCard.Container -label "Espacio Total" -value "..." -yPos 45

$moboManufacturer = Add-CardInfo -container $motherboardCard.Container -label "Fabricante" -value "Cargando..." -yPos 0
$moboModel = Add-CardInfo -container $motherboardCard.Container -label "Modelo" -value "..." -yPos 45

# Botón de actualizar
$refreshButton = New-Object System.Windows.Forms.Button
$refreshButton.Text = 'ACTUALIZAR'
$refreshButton.Size = New-Object System.Drawing.Size(140, 45)
$refreshButton.Location = New-Object System.Drawing.Point(530, 510)
$refreshButton.BackColor = [System.Drawing.Color]::FromArgb(59, 130, 246)
$refreshButton.ForeColor = [System.Drawing.Color]::White
$refreshButton.FlatStyle = 'Flat'
$refreshButton.FlatAppearance.BorderSize = 0
$refreshButton.Cursor = 'Hand'
$refreshButton.Font = New-Object System.Drawing.Font('Segoe UI', 10, [System.Drawing.FontStyle]::Bold)

# Bordes redondeados para el botón
$btnRadius = 10
$btnPath = New-Object System.Drawing.Drawing2D.GraphicsPath
$btnPath.AddArc(0, 0, $btnRadius, $btnRadius, 180, 90)
$btnPath.AddArc($refreshButton.Width - $btnRadius, 0, $btnRadius, $btnRadius, 270, 90)
$btnPath.AddArc($refreshButton.Width - $btnRadius, $refreshButton.Height - $btnRadius, $btnRadius, $btnRadius, 0, 90)
$btnPath.AddArc(0, $refreshButton.Height - $btnRadius, $btnRadius, $btnRadius, 90, 90)
$btnPath.CloseFigure()
$refreshButton.Region = New-Object System.Drawing.Region($btnPath)

$form.Controls.Add($refreshButton)

# Panel de créditos
$footerPanel = New-Object System.Windows.Forms.Panel
$footerPanel.Size = New-Object System.Drawing.Size(1200, 120)
$footerPanel.Location = New-Object System.Drawing.Point(0, 580)
$footerPanel.BackColor = [System.Drawing.Color]::FromArgb(15, 23, 42)
$form.Controls.Add($footerPanel)

$separator = New-Object System.Windows.Forms.Label
$separator.Size = New-Object System.Drawing.Size(1140, 1)
$separator.Location = New-Object System.Drawing.Point(30, 0)
$separator.BackColor = [System.Drawing.Color]::FromArgb(51, 65, 85)
$footerPanel.Controls.Add($separator)

$creditLabel = New-Object System.Windows.Forms.Label
$creditLabel.Text = 'Creado por PICKLEOS'
$creditLabel.Font = New-Object System.Drawing.Font('Segoe UI', 11)
$creditLabel.ForeColor = [System.Drawing.Color]::FromArgb(148, 163, 184)
$creditLabel.AutoSize = $false
$creditLabel.Size = New-Object System.Drawing.Size(1200, 30)
$creditLabel.Location = New-Object System.Drawing.Point(0, 30)
$creditLabel.TextAlign = 'MiddleCenter'
$footerPanel.Controls.Add($creditLabel)

$linkLabel = New-Object System.Windows.Forms.LinkLabel
$linkLabel.Text = 'picklestore.org'
$linkLabel.Font = New-Object System.Drawing.Font('Segoe UI', 12, [System.Drawing.FontStyle]::Bold)
$linkLabel.LinkColor = [System.Drawing.Color]::FromArgb(96, 165, 250)
$linkLabel.ActiveLinkColor = [System.Drawing.Color]::FromArgb(147, 197, 253)
$linkLabel.VisitedLinkColor = [System.Drawing.Color]::FromArgb(96, 165, 250)
$linkLabel.AutoSize = $false
$linkLabel.Size = New-Object System.Drawing.Size(1200, 35)
$linkLabel.Location = New-Object System.Drawing.Point(0, 60)
$linkLabel.TextAlign = 'MiddleCenter'
$linkLabel.Cursor = 'Hand'
$linkLabel.Add_LinkClicked({
    Start-Process "https://picklestore.org/"
})
$footerPanel.Controls.Add($linkLabel)

# Función para obtener información del hardware
function Get-HardwareInfo {
    # CPU
    $cpu = Get-CimInstance -ClassName Win32_Processor | Select-Object -First 1
    $cpuModel.Text = $cpu.Name
    $cpuCores.Text = "$($cpu.NumberOfCores) Núcleos"
    
    # GPU
    $gpu = Get-CimInstance -ClassName Win32_VideoController | Select-Object -First 1
    $gpuModel.Text = $gpu.Name
    $vram = [math]::Round($gpu.AdapterRAM / 1GB, 2)
    if ($vram -eq 0) { $vram = "N/A" } else { $vram = "$vram GB" }
    $gpuVram.Text = $vram
    
    # Memory
    $memory = Get-CimInstance -ClassName Win32_PhysicalMemory
    $totalRAM = ($memory | Measure-Object -Property Capacity -Sum).Sum
    $totalRAMGB = [math]::Round($totalRAM / 1GB, 2)
    $memoryTotal.Text = "$totalRAMGB GB"
    $memType = $memory[0].SMBIOSMemoryType
    $memTypeString = switch ($memType) {
        26 { "DDR4" }
        34 { "DDR5" }
        default { "DDR3/Desconocido" }
    }
    $memoryType.Text = $memTypeString
    
    # System
    $os = Get-CimInstance -ClassName Win32_OperatingSystem
    $systemOS.Text = $os.Caption
    $systemVersion.Text = $os.Version
    
    # Storage
    $disk = Get-CimInstance -ClassName Win32_DiskDrive | Select-Object -First 1
    $storageDisk.Text = $disk.Model
    $diskSize = [math]::Round($disk.Size / 1GB, 0)
    $storageSpace.Text = "$diskSize GB"
    
    # Motherboard
    $mobo = Get-CimInstance -ClassName Win32_BaseBoard
    $moboManufacturer.Text = $mobo.Manufacturer
    $moboModel.Text = $mobo.Product
}

# Evento del botón
$refreshButton.Add_Click({
    Get-HardwareInfo
})

# Cargar información inicial
Get-HardwareInfo

# Mostrar el formulario
[void]$form.ShowDialog()