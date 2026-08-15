Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# --- MAIN WINDOW FRAMEWORK ---
$form = New-Object System.Windows.Forms.Form
$form.Text = "Windows 10 Transformation Tool"
$form.Size = New-Object System.Drawing.Size(440, 460)
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
$form.MaximizeBox = $false
$form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
$form.BackColor = [System.Drawing.Color]::FromArgb(243, 243, 243)

# Shared Header Title Component
$title = New-Object System.Windows.Forms.Label
$title.Text = "Win10 Visual Mod Tool"
$title.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
$title.ForeColor = [System.Drawing.Color]::FromArgb(0, 120, 215)
$title.Size = New-Object System.Drawing.Size(380, 35)
$title.Location = New-Object System.Drawing.Point(20, 15)
$form.Controls.Add($title)

# --- PANEL CONTAINERS (THE 3 SCREENS) ---
$screen1 = New-Object System.Windows.Forms.Panel
$screen1.Size = New-Object System.Drawing.Size(400, 350)
$screen1.Location = New-Object System.Drawing.Point(10, 60)

$screen2 = New-Object System.Windows.Forms.Panel
$screen2.Size = New-Object System.Drawing.Size(400, 350)
$screen2.Location = New-Object System.Drawing.Point(10, 60)
$screen2.Visible = $false

$screen3 = New-Object System.Windows.Forms.Panel
$screen3.Size = New-Object System.Drawing.Size(400, 350)
$screen3.Location = New-Object System.Drawing.Point(10, 60)
$screen3.Visible = $false

$form.Controls.Add($screen1)
$form.Controls.Add($screen2)
$form.Controls.Add($screen3)

# --- REUSABLE FACTORY FUNCTIONS ---
function Create-Btn ($text, $left, $top, $w, $h, $bgColor) {
    $btn = New-Object System.Windows.Forms.Button
    $btn.Text = $text
    $btn.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
    $btn.Size = New-Object System.Drawing.Size($w, $h)
    $btn.Location = New-Object System.Drawing.Point($left, $top)
    $btn.BackColor = $bgColor
    $btn.ForeColor = [System.Drawing.Color]::White
    $btn.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $btn.FlatAppearance.BorderSize = 0
    $btn.Cursor = [System.Windows.Forms.Cursors]::Hand
    return $btn
}

function Create-Chk ($text, $top, $parentPanel) {
    $chk = New-Object System.Windows.Forms.CheckBox
    $chk.Text = $text
    $chk.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Regular)
    $chk.Size = New-Object System.Drawing.Size(360, 25)
    $chk.Location = New-Object System.Drawing.Point(15, $top)
    $chk.Checked = $true
    $parentPanel.Controls.Add($chk)
    return $chk
}

# --- SCREEN 1: MAIN NAVIGATION DASHBOARD ---
$lblS1 = New-Object System.Windows.Forms.Label
$lblS1.Text = "Welcome! Select an operation path below to begin system styling configuration modifications."
$lblS1.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$lblS1.Size = New-Object System.Drawing.Size(360, 45)
$lblS1.Location = New-Object System.Drawing.Point(15, 10)
$screen1.Controls.Add($lblS1)

$btnGoToInstall = Create-Btn "Install Modifications" 15 80 360 55 ([System.Drawing.Color]::FromArgb(0, 120, 215))
$btnGoToUninst  = Create-Btn "Uninstall / Revert Tool" 15 155 360 55 ([System.Drawing.Color]::FromArgb(100, 100, 100))
$screen1.Controls.Add($btnGoToInstall)
$screen1.Controls.Add($btnGoToUninst)

# Navigation triggers
$btnGoToInstall.Add_Click({ $screen1.Visible = $false; $screen2.Visible = $true })
$btnGoToUninst.Add_Click({  $screen1.Visible = $false; $screen3.Visible = $true })


# --- SCREEN 2: OPTION SPECIFICATION & INSTALL ---
$lblS2 = New-Object System.Windows.Forms.Label
$lblS2.Text = "Choose parameters to tweak onto your local configuration environment:"
$lblS2.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$lblS2.Size = New-Object System.Drawing.Size(360, 25)
$lblS2.Location = New-Object System.Drawing.Point(15, 5)
$screen2.Controls.Add($lblS2)

# Checkboxes
$chkLeft   = Create-Chk "Move Start Button to Left" 45 $screen2
$chkMenu   = Create-Chk "Restore Classic Right-Click Menu" 85 $screen2
$chkBloat  = Create-Chk "Disable Widgets & Task View Icons" 125 $screen2
$chkBing   = Create-Chk "Kill Start Menu Bing Search" 165 $screen2

$btnApplyInstall = Create-Btn "Apply" 15 220 175 45 ([System.Drawing.Color]::FromArgb(0, 120, 215))
$btnBackFromS2   = Create-Btn "Back" 200 220 175 45 ([System.Drawing.Color]::FromArgb(140, 140, 140))
$screen2.Controls.Add($btnApplyInstall)
$screen2.Controls.Add($btnBackFromS2)

$btnBackFromS2.Add_Click({ $screen2.Visible = $false; $screen1.Visible = $true })

# Install Logic Block
$btnApplyInstall.Add_Click({
    $advPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
    if ($chkLeft.Checked) { Set-ItemProperty -Path $advPath -Name "TaskbarAl" -Value 0 -Force }
    if ($chkMenu.Checked) {
        $clsidPath = "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}"
        if (-not (Test-Path $clsidPath)) { New-Item -Path $clsidPath -Force | Out-Null }
        New-Item -Path "$clsidPath\InprocServer32" -Value "" -Force | Out-Null
    }
    if ($chkBloat.Checked) {
        Set-ItemProperty -Path $advPath -Name "TaskbarDa" -Value 0 -Force
        Set-ItemProperty -Path $advPath -Name "ShowTaskViewButton" -Value 0 -Force
    }
    if ($chkBing.Checked) {
        $searchPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search"
        if (-not (Test-Path $searchPath)) { New-Item -Path $searchPath -Force | Out-Null }
        Set-ItemProperty -Path $searchPath -Name "BingSearchEnabled" -Value 0 -Force
    }
    
    [System.Windows.Forms.MessageBox]::Show("Configurations injected! The tool will close and your desktop will refresh now.", "Success", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    
    # Clean Close Application first to prevent crashing/freezing
    $form.Close()
    
    # Smooth restart background task shell loop
    Stop-Process -Name explorer -Force
})


# --- SCREEN 3: UNINSTALL CONFIRMATION SCREEN ---
$lblS3Title = New-Object System.Windows.Forms.Label
$lblS3Title.Text = "Confirm System Restoration"
$lblS3Title.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$lblS3Title.ForeColor = [System.Drawing.Color]::FromArgb(204, 0, 0)
$lblS3Title.Size = New-Object System.Drawing.Size(360, 25)
$lblS3Title.Location = New-Object System.Drawing.Point(15, 10)
$screen3.Controls.Add($lblS3Title)

$lblS3Desc = New-Object System.Windows.Forms.Label
$lblS3Desc.Text = "Are you sure? This action will strip away all injected registry entries, restore default web searching channels, center the taskbar layout, and reset Windows 11 defaults."
$lblS3Desc.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$lblS3Desc.Size = New-Object System.Drawing.Size(360, 80)
$lblS3Desc.Location = New-Object System.Drawing.Point(15, 40)
$screen3.Controls.Add($lblS3Desc)

$btnConfirmUninst = Create-Btn "Confirm Uninstall" 15 140 360 50 ([System.Drawing.Color]::FromArgb(204, 0, 0))
$btnBackFromS3    = Create-Btn "Cancel and Go Back" 15 205 360 45 ([System.Drawing.Color]::FromArgb(140, 140, 140))
$screen3.Controls.Add($btnConfirmUninst)
$screen3.Controls.Add($btnBackFromS3)

$btnBackFromS3.Add_Click({ $screen3.Visible = $false; $screen1.Visible = $true })

# Uninstall Logic Block
$btnConfirmUninst.Add_Click({
    $advPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
    Set-ItemProperty -Path $advPath -Name "TaskbarAl" -Value 1 -Force
    $clsidPath = "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}"
    if (Test-Path $clsidPath) { Remove-Item -Path $clsidPath -Recurse -Force | Out-Null }
    Set-ItemProperty -Path $advPath -Name "TaskbarDa" -Value 1 -Force
    Set-ItemProperty -Path $advPath -Name "ShowTaskViewButton" -Value 1 -Force
    $searchPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search"
    if (Test-Path $searchPath) { Set-ItemProperty -Path $searchPath -Name "BingSearchEnabled" -Value 1 -Force }

    [System.Windows.Forms.MessageBox]::Show("Configurations stripped successfully! The tool will close and your desktop will refresh now.", "Restored", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    
    # Clean Close Application first to prevent crashing/freezing
    $form.Close()
    
    # Smooth restart background task shell loop
    Stop-Process -Name explorer -Force
})

# Render interactive form window
[System.Windows.Forms.Application]::Run($form)
