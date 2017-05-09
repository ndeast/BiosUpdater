# ndeast
# 04/17/17
# InstallBios 1.0
# A PS Script to automate the install of bios updates. 
# Needs to be acompanied with the BiosFiles folder in the same directory as the script

$pinvokes = @'
    [DllImport("user32.dll", CharSet=CharSet.Auto)]
    public static extern IntPtr FindWindow(string className, string windowName);

    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool SetForegroundWindow(IntPtr hWnd);
'@

# Prompt user to enter admin password
function pwPrompt {
    $SecurePass = Read-Host 'Please Enter the Admin Password' -AsSecureString
    $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecurePass)
    $UnsecurePass = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
        
    return $UnsecurePass
}

# Delete the script from the path it was executed from
function Delete {
    #Path
    $Path = (Get-Location).Path + "\InstallBios.ps1"
    #Name
    Write-Host $Path 

    Remove-Item $Path
    write-host  "Deleted"
}

# navigates bios installer 
function installBios { 
    param($biosprocess, $pass)
    
    # get process from launched bios installer
    $h = (get-process $biosprocess).MainWindowHandle
   
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -MemberDefinition $pinvokes -Name NativeMethods -Namespace MyUtils
    
    [MyUtils.NativeMethods]::SetForegroundWindow($h)
    Start-Sleep -s 1
    [System.Windows.Forms.SendKeys]::SendWait($pass)
    [System.Windows.Forms.SendKeys]::SendWait("~")
    Start-Sleep -s 1
    
    echo "setting foreground"
    $h = (get-process $biosprocess).MainWindowHandle
    [MyUtils.NativeMethods]::SetForegroundWindow($h)
    Start-Sleep -s 1
    
    echo "sending enter"
    [System.Windows.Forms.SendKeys]::SendWait("~")
    Start-Sleep -s 1
    
    $h = (get-process $biosprocess).MainWindowHandle
    [MyUtils.NativeMethods]::SetForegroundWindow($h)
    Start-Sleep -s 1
    
    echo "sending enter"
    [System.Windows.Forms.SendKeys]::SendWait("~")
    
    # Deletes itself once installation starts. Uncomment to enable.
    #Delete
}

function bios990 {
    $biosName = "O990-A19"
    $filebase = (Get-Location).Path + "\BiosFiles\" + $biosName + ".exe"
    $pass = pwPrompt
    Start-Process -FilePath $filebase
    Start-Sleep -s 1
    
    installBios $biosName $pass
}

function bios9010 {
    $biosName = "O9010A25"
    $filebase = (Get-Location).Path + "\BiosFiles\" + $biosName + ".exe"
    $pass = pwPrompt
    Start-Process -FilePath $filebase
    Start-Sleep -s 1
    
    installBios $biosName $pass
}

function bios9020 {
    
    $biosName = "O9020A18"
    $filebase = (Get-Location).Path + "\BiosFiles\" + $biosName + ".exe"
    $pass = pwPrompt
    Start-Process -FilePath $filebase
    Start-Sleep -s 1
    
    installBios $biosName $pass
}

# Find Computer Model and execute corresponding bios install
$pcModel = (Get-WmiObject -Class:Win32_ComputerSystem -ComputerName:localhost).Model
echo $pcModel

Switch -wildcard ($pcModel)
{
    "*990*"        { bios990 }
    "*9010*"       { bios9010 }
    "*9020*"       { bios9020 }
}

  



