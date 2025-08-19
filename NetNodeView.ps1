##################################################################################################################################################
#                                                                                                                                                #
#  This powershell script offers a few connectivity tests against a network node of your interest including internet nodes.                      #
#  Some of the available tests focus on TCP/IP port scans, sessions, web response headers, certificates, DNS, routes & icmp/ping.                #
#  The purpose of this creation is to assist middleware engineers, cloud computing administrators, cybersecurity testers and system architects.  #
#                                                                                                                                                #
##################################################################################################################################################
#                                                                                                                                                #
# script_name         = NetNodeView.ps1                                                                                                          #
# script_execution    = Launch Windows PowerShell ISE in your Server/WorkStation, open NetNodeView.ps1 and hit green play button to Run (F5)     #
# script_version      = 1.9.21                                                                                                                   #
# author              = agustin hernan borrajo ( https://www.linkedin.com/in/agustinborrajo/ )                                                   #
# original_repository = http://cloudconsulting.agustin.50megs.com/powershell-netnodeview                                                         #
#                                                                                                                                                #
##################################################################################################################################################

Set-Culture -CultureInfo en-US
$l00 = "------------------------------------------------------------------------------------------------------------------------------"
$l02 = "                        "
$l02 = "  |\ |   |\ |   \  /    "
$l03 = "  | \|ET | \|ODE \/IEW  "
$l04 = "------------------------"
$i00 = "                                                                                                                        "
$i01 = "          _                     ::     |       |     /\       ::   ___________     !!    !!      ________               "
$i02 = "        (( ))  [VPN]-[WS]       ::     |\     /|    //\\'     ::  |           |    !!    !!     |        |              "
$i03 = "      ((    )) /  _             ::     | \/^\/ |   //\/\\'    ::  |           |---<!! FW !!>----| SERVER |--------[WS]  "
$i04 = "    ((       ))) ( )_        ...::=====|\/   \/|__// LB \\____::__|    SERVER |    !!    !!     |     02 |          :   "
$i05 = "   ((          )))   )_    ..:  ::     |  WAF  |  \\ /\ //    ::  |        01 |    !! FW !!     |________|          :   "
$i06 = "  ((  internet   ))    )...:    ::     |  RPx  |   \\\///'    ::  |           |---<!!    !!>---------------[net>drive]  "
$i07 = " ((               ) api )       ::      \  _  /     \\//'     ::  |           |---<!! FW !!>---------------[API]        "
$i08 = "((_______________))_____)       ::DMZ    \/ \/       \/    DMZ::  |___________|    !!    !!                             "
$global:youarehere=[System.Net.Dns]::GetHostName()
$global:youare=whoami
$global:youarethis=$global:youare.split("\")
$global:youarethis=$global:youarethis[1]
clear-host


function DarkMag
{
    process { Write-Host $_ -ForegroundColor Magenta -BackgroundColor DarkMagenta }
}

function YellYell
{
    process { Write-Host $_ -ForegroundColor Yellow -BackgroundColor DarkYellow  }
}

function Yellow
{
    process { Write-Host $_ -ForegroundColor Yellow }
}

function Green
{
    process { Write-Host $_ -ForegroundColor Green }
}

function Blue
{
    process { Write-Host $_ -ForegroundColor Blue -BackgroundColor DarkBlue }
}

function Red
{
    process { Write-Host $_ -ForegroundColor Red -BackgroundColor White }
}

function netnodeviewtop
{
write-host -f red -b darkmagenta $l04; write-host -f magenta -b darkmagenta $l02;write-host -f yellow -b darkyellow $l03 -nonewline
write-host -f magenta " --> logged into " -nonewline ; write-host -f green $global:youarehere -nonewline; write-host -f magenta " as " -nonewline
write-host -f red $global:youarethis;write-host -f red -b darkmagenta $l04
}

function linescreen
{
write-host -f white $l00
}

function linescreen2
{
write-host -f blue -b darkblue $l00
}

function entertocontinue { Start-Sleep -Second .6 ; $entertocontinue = write-host -f green -b darkgreen "<ENTER>" -nonewline; Read-Host -Prompt ' to goto main menu' }

function presentation
{
clear-host
Start-Sleep -Second .6
netnodeviewtop
 
write-host -f white "$i01" ; write-host -f white "$i02" ; write-host -f white "$i03" ; write-host -f white "$i04"
write-host -f white "$i05" ; write-host -f white "$i06" ; write-host -f white "$i07" ; write-host -f white "$i08"
write-host -f white "$i00"

write-host -f yellow "This powershell script offers a few connectivity tests against a network node of your interest including internet nodes." 
write-host -f yellow "Some of the available tests focus on TCP/IP port scans, sessions, web response headers, certificates, DNS, routes & icmp/ping."
write-host -f yellow "The above diagram shows a case in which NetNodeView could be run from Server01 or Server02 or from end-user workstations [WS]."
write-host -f white $l00
}

function presentation1
{
$global:thehostofinterest = Read-Host -Prompt 'Enter your f.q.d.n. or hostname or IP of interest and hit <ENTER> :'
}

function presentation2
{
write-host -f white $l00
write-host -f white "[ 0 ] enter new node of interest                                                                                  [ x ] exit"
write-host -f white "[ 1 ] get network info about    " -nonewline;
write-host -f green -b black "[ $global:youarehere ]" -nonewline;
write-host -f magenta -b darkmagenta "[MAC][IP][GATEWAY][DHCP][DNS]"
write-host -f white "[ 2 ] scan a remote port        " -nonewline;
write-host -f green -b black "[ $global:youarehere ]" -nonewline;
write-host -f cyan -b black "--))--" -nonewline;
write-host -f magenta -b black "[ " -nonewline;
write-host -f yellow -b black "$global:thehostofinterest" -nonewline;
write-host -f magenta -b black ":" -nonewline
write-host -f green -b black "port" -nonewline
write-host -f magenta -b black " ]"
write-host -f white "[ 3 ] scan a remote port range  " -nonewline;
write-host -f green -b black "[ $global:youarehere ]" -nonewline;
write-host -f cyan -b black "--))--" -nonewline;
write-host -f magenta -b black "[ " -nonewline;
write-host -f yellow -b black "$global:thehostofinterest" -nonewline;
write-host -f magenta -b black ":" -nonewline
write-host -f red -b black "port_range" -nonewline
write-host -f magenta -b black " ]"
write-host -f white "[ 4 ] view connections " -nonewline;
write-host -f blue -b black "[process]" -nonewline;
write-host -f green -b black "[ $global:youarehere ]" -nonewline
write-host -f cyan -b black "======" -nonewline;
write-host -f magenta -b black "[ " -nonewline;
write-host -f yellow -b black "$global:thehostofinterest" -nonewline;
write-host -f magenta -b black " ]" -nonewline;
write-host -f blue -b black "[E|L|C|W]"
write-host -f white "[ 5 ] get web response " -nonewline;
write-host -f blue -b black "[headers]" -nonewline;
write-host -f green -b black "[ $global:youarehere ]" -nonewline;
write-host -f cyan -b black "--((--" -nonewline;
write-host -f magenta -b black "[ " -nonewline;
write-host -f yellow -b black "$global:thehostofinterest" -nonewline;
write-host -f magenta -b black ":" -nonewline
write-host -f green -b black "port" -nonewline
write-host -f cyan -b black "/path" -nonewline
write-host -f magenta -b black " ]"
write-host -f white "[ 6 ] get certificate fields    " -nonewline;
write-host -f green -b black "[ $global:youarehere ]" -nonewline;
write-host -f cyan -b black "-" -nonewline;
write-host -f yellow -b darkred "CERT" -nonewline;
write-host -f cyan -b black "-" -nonewline;
write-host -f magenta -b black "[ " -nonewline;
write-host -f yellow -b black "$global:thehostofinterest" -nonewline;
write-host -f magenta -b black ":" -nonewline
write-host -f green -b black "port" -nonewline
write-host -f magenta -b black " ]"
write-host -f white "[ 7 ] get DNS resolution/lookup " -nonewline;
write-host -f green -b black "[ $global:youarehere ]" -nonewline;
write-host -f cyan -b black "=(" -nonewline;
write-host -f yellow -b darkred "DNS" -nonewline;
write-host -f cyan -b black ")" -nonewline;
write-host -f magenta -b black "[ " -nonewline;
write-host -f yellow -b black "$global:thehostofinterest" -nonewline;
write-host -f magenta -b black " ]"
write-host -f white "[ 8 ] traceroute " -nonewline ; write-host -f blue -b black "[-hop1-2-3----]" -nonewline;
write-host -f green -b black "[ $global:youarehere ]" -nonewline;
write-host -f cyan -b black "=" -nonewline;
write-host -f yellow -b darkred "****" -nonewline;
write-host -f cyan -b black "=" -nonewline;
write-host -f magenta -b black "[ " -nonewline;
write-host -f yellow -b black "$global:thehostofinterest" -nonewline;
write-host -f magenta -b black " ]"
write-host -f white "[ 9 ] pathping   " -nonewline ; write-host -f blue -b black "[..lost/sent..]" -nonewline;
write-host -f green -b black "[ $global:youarehere ]" -nonewline;
write-host -f cyan -b black "=" -nonewline;
write-host -f yellow -b darkred "...." -nonewline;
write-host -f cyan -b black "=" -nonewline;
write-host -f magenta -b black "[ " -nonewline;
write-host -f yellow -b black "$global:thehostofinterest" -nonewline;
write-host -f magenta -b black " ]"


write-host -f white $l00; write-host -f magenta "Your current node of interest is --> " -NoNewline ; write-host -f yellow "$global:thehostofinterest" ; write-host -f white $l00
$global:netnodeviewoption = Read-Host -Prompt 'Choose an option and then hit <ENTER> :'

if ($global:netnodeviewoption -eq 1 ) {
    clear-host
    Start-Sleep -Second .6
    netnodeviewtop
    write-host -f white -b darkgreen "[ 1 ] get network info about    " -nonewline;
    write-host -f green -b black "[ $global:youarehere ]" -nonewline;
    write-host -f magenta -b darkmagenta "[MAC][IP][GATEWAY][DHCP][DNS]"
    linescreen

    $publicIpUrl = "https://ipapi.co/ip/"
try {
    $webClient = New-Object System.Net.WebClient -ErrorAction SilentlyContinue
    $publicIp = $webClient.DownloadString($publicIpUrl)
} catch {
        $publicIp = "Unable to retrieve public IP address."
}


   write-host -f cyan " Your " -nonewline ; write-host -f green -b black "[ $global:youarehere ]" -nonewline; write-host -f cyan " public IP address = " -nonewline ;  write-host -f yellow $publicIp
   linescreen
    try { $GNI = Get-NetIPConfiguration -ErrorAction Stop } catch { write-host -f red "Unable to get Net IP Configuration" }
    try { $GNIA = $GNI | Get-NetIPAddress -AddressFamily IPv4 -ErrorAction Stop } catch { write-host -f red "Unable to get Net IP Address Family " }
    try { $GDNS = Get-DnsClientServerAddress -AddressFamily IPv4 -ErrorAction Stop | where {$_.ServerAddresses -like "*.*" } }
    catch { write-host -f red "Unable to get DNS client server address" } 
    
    try { 
    write-host -f cyan " Your " -nonewline ; write-host -f green -b black "[ $global:youarehere ]" -nonewline; write-host -f cyan " Client Interface settings ( IP + Default Gateway + DNS Server ) : "
    linescreen
    $GNI
    Start-Sleep -Second 1  } catch { write-host -f red "Unable to display Net IP Configuration" }

    try {
    $GNIA | FT -AutoSize
    Start-Sleep -Second 1  } catch { write-host -f red "Unable to display Net IP Address Family " }
    try { 
    linescreen
    write-host -f cyan " Your " -nonewline ; write-host -f green -b black "[ $global:youarehere ]" -nonewline; write-host -f cyan " Client DNS settings : "
    linescreen
    $GDNS | FT -AutoSize 
    Start-Sleep -Second 1
    linescreen     } catch { write-host -f red "Unable to display DNS client server address" } 
    write-host -f cyan " Your " -nonewline ; write-host -f green -b black "[ $global:youarehere ]" -nonewline; write-host -f cyan " IPCONFIG /ALL settings : "
    linescreen2
    ipconfig /all ; write-host
    linescreen
    write-host -f cyan " Your " -nonewline ; write-host -f green -b black "[ $global:youarehere ]" -nonewline; write-host -f cyan " IP ROUTES : "
    linescreen2
    Get-NetRoute | Where-Object -FilterScript { $_.ValidLifetime -Eq ([TimeSpan]::MaxValue) } | FT -AutoSize ; Start-Sleep -Second 1    
    linescreen2
    entertocontinue
                                          }


if ($global:netnodeviewoption -eq 2 ) {
    clear-host
    Start-Sleep -Second .6
    netnodeviewtop
    write-host -f white -b darkgreen "  [ 2 ] scan a remote port " -nonewline;
    write-host -f green -b black "[ $global:youarehere ]" -nonewline;
    write-host -f cyan -b black "--))--" -nonewline;
    write-host -f magenta -b black "[ " -nonewline;
    write-host -f yellow -b black "$global:thehostofinterest" -nonewline;
    write-host -f magenta -b black ":" -nonewline
    write-host -f green -b black "port" -nonewline
    write-host -f magenta -b black " ]"
    linescreen
    Try { 
          $global:theportofinterest = Read-Host -Prompt 'Enter your destination port of interest and hit <ENTER> :'

          if ( $global:theportofinterest -eq "" ) { $global:theportofinterest = "80" }
    linescreen          
    Write-host -f red -b white "Scanning Network $global:thehostofinterest" -NoNewline
    Write-host -f white -b black ":" -NoNewline
    Write-host -f red -b white "$global:theportofinterest"
    $ErrorActionPreference= 'silentlycontinue'
    $t=Test-Connection -BufferSize 32 -Count 1 -quiet -ComputerName $global:thehostofinterest -ErrorAction Stop
    Write-host -f red -b white "Test Connection for $global:thehostofinterest:$global:theportofinterest is $t"
    Write-host -f white $i00
        If("$t") {
        try {
            $socket = New-Object System.Net.Sockets.TcpClient
            $socket.Connect($global:thehostofinterest, [int]$global:theportofinterest)
            If($socket.Connected) {
                Write-Output "Port $global:theportofinterest is either OPENED or FILTERED in $global:thehostofinterest"
                $socket.Close()
            } else {
                Write-host -f yellow -b black "Port $global:theportofinterest is NOT OPENED in $global:thehostofinterest"
            }
        } catch {
            Write-host -f yellow -b black "Port $global:theportofinterest is NOT OPENED in $global:thehostofinterest (connection refused)"
        }
    }

    Write-Output $i00
    $OriginalProgressPreference = $Global:ProgressPreference
    $Global:ProgressPreference = 'SilentlyContinue'
    try { Test-Netconnection $global:thehostofinterest -port $global:theportofinterest -InformationLevel "Detailed" } catch { write-host -f red "Unable to Test-Connection"  }
    $socket.Close()
           }  catch {
     write-Host -f Green  "clue : port # $global:theportofinterest might not be accessible in $global:thehostofinterest "
     Write-Host -f Yellow "An error occurred: $_"
                     }

     linescreen2     
     entertocontinue
                                       }

if ($global:netnodeviewoption -eq 3 ) {

    clear-host
    Start-Sleep -Second .6
    netnodeviewtop
    write-host -f white -b darkgreen "  [ 3 ] scan a remote port range  " -nonewline;
    write-host -f green -b black "[ $global:youarehere ]" -nonewline;
    write-host -f cyan -b black "--))--" -nonewline;
    write-host -f magenta -b black "[ " -nonewline;
    write-host -f yellow -b black "$global:thehostofinterest" -nonewline;
    write-host -f magenta -b black ":" -nonewline
    write-host -f red -b black "port_range" -nonewline
    write-host -f magenta -b black " ]"
    linescreen
    # $hitthe = " <<< [ hit any key to stop scan ] "
    $global:thelowportrangeofinterest = Read-Host -Prompt 'Enter your <LOWEST>  port in the range of interest and hit <ENTER> :'
    $global:thehighportrangeofinterest = Read-Host -Prompt 'Enter your <HIGHEST> port in the range of interest and hit <ENTER> :'
    $global:timeout_ms = Read-Host -Prompt 'Enter your preferred timeout between scans in miliseconds ( 300 is OK for slower networks ) and hit <ENTER> :'
    linescreen
    if ( $global:thelowportrangeofinterest -eq "" ) { $global:thelowportrangeofinterest = "80" }
    if ( $global:thehighportrangeofinterest -eq "" ) { $global:thehighportrangeofinterest = "80" }
    if ( $global:timeout_ms -eq "" ) { $global:timeout_ms = "300" }

    $range = $global:thelowportrangeofinterest..$global:thehighportrangeofinterest

    try {
    if (Test-Connection -BufferSize 32 -Count 1 -Quiet -ComputerName $global:thehostofinterest -ErrorAction SilentlyContinue)
    {
        Write-Host -f cyan "Node $global:thehostofinterest is alive... checking ports..." ; linescreen2

          foreach ($port in $range )
        {
            
            if ([console]::KeyAvailable) {
                $key = [console]::ReadKey($true)
                write-host -f yellow "Scan stopped by user."
                break
            }
            $ErrorActionPreference = 'SilentlyContinue'
            $socket = new-object System.Net.Sockets.TcpClient
            $connect = $socket.BeginConnect($global:thehostofinterest, $port, $null, $null)
            $tryconnect = Measure-Command { $success = $connect.AsyncWaitHandle.WaitOne($timeout_ms, $true) } | % totalmilliseconds
            $tryconnect | Out-Null

            if ($socket.Connected)
            {
                write-host -f green "Port $port on $global:thehostofinterest --> LISTENING !!! ( Response Time: $tryconnect miliseconds )"
                $socket.Close()
                $socket.Dispose()
                $socket = $null
            } else {
                write-host -f red "Port $port on $global:thehostofinterest --> NOT listening ( socket timeout is $global:timeout_ms miliseconds ) $hitthe"
                      }
            $ErrorActionPreference = 'Continue'
        }

      

    }
    } catch { }

     linescreen2     
     entertocontinue

}


if ($global:netnodeviewoption -eq 4 ) {

    clear-host
    Start-Sleep -Second .6
    netnodeviewtop
    write-host -f white -b darkgreen "  [ 4 ] view connections " -nonewline;
    write-host -f blue -b black "[process]" -nonewline;
    write-host -f green -b black "[ $global:youarehere ]" -nonewline
    write-host -f cyan -b black "======" -nonewline;
    write-host -f magenta -b black "[ " -nonewline;
    write-host -f yellow -b black "$global:thehostofinterest" -nonewline;
    write-host -f magenta -b black " ]" -nonewline;
    write-host -f blue -b black "[E|L|C|W]"
    linescreen
    write-host -f cyan "Connections against node name " -nonewline;write-host -f yellow -b black "$global:thehostofinterest"
    linescreen
    try { Get-NetTCPConnection | select local*,remote*,state,@{Name="Process";Expression={(Get-Process -Id $_.OwningProcess).ProcessName}},CreationTime | FT -autosize | findstr $global:thehostofinterest } catch
      { write-host -f red "Unable to Get TCP Connections"  }
    linescreen
    $oneormoreips = $global:thehostofinterest
    try { $oneormoreips = Resolve-DnsName -Name $global:thehostofinterest -ErrorAction Stop | select IP4Address | FT -HideTableHeaders | findstr -i "." } catch { $oneormoreips = $global:thehostofinterest }
    $oneormoreipstest = $oneormoreips -match '(?:[0-9]|[1-9][0-9]|1[0-9]{2}|2[0-5][0-5]|2[0-4][0-9])'
    $whennoips = $oneormoreips | findstr "." | Measure-Object -Character | findstr -i 10
    $whennoips = $whennoips -replace '\s',''
    $whenonesingleip = $oneormoreips | findstr "." | Measure-Object -Word | findstr -i 1
    $whenonesingleip = $whenonesingleip -replace '\s',''
    
    if ( $whennoips -eq "10" ) { $oneormoreips = $global:thehostofinterest }
    if ( $whenonesingleip -eq "1" ) { write-host -f cyan "Connections against IP " -nonewline ; write-host -f yellow -b black $oneormoreips ;linescreen } else {
    
    write-host -f cyan "Connections against IP(s) "
    linescreen2
    if ( $oneormoreipstest -ne "True" -and $oneormoreipstest -ne "False") { 
    
        $oneormoreipstestfalse = $oneormoreipstest | findstr -i False
    
    if ( $oneormoreipstestfalse -eq "False" ) { "Unable to get IP(s) from node name $global:thehostofinterest" } else { $oneormoreipstest }
    
    
     } else { $oneormoreips }
    linescreen2
    }
    try { Get-NetTCPConnection | select local*,remote*,state,@{Name="Process";Expression={(Get-Process -Id $_.OwningProcess).ProcessName}},CreationTime | FT -autosize | findstr -i "$oneormoreips" } catch {}
    
    linescreen2     
    entertocontinue

     }


if ($global:netnodeviewoption -eq 5 ) {

    clear-host
    Start-Sleep -Second .6
    netnodeviewtop
    write-host -f white -b darkgreen "[ 5 ] get web response   " -nonewline;
    write-host -f blue -b black "[headers]" -nonewline;
    write-host -f green -b black "[ $global:youarehere ]" -nonewline;
    write-host -f cyan -b black "--((--" -nonewline;
    write-host -f magenta -b black "[ " -nonewline;
    write-host -f yellow -b black "$global:thehostofinterest" -nonewline;
    write-host -f magenta -b black ":" -nonewline
    write-host -f green -b black "port" -nonewline
    write-host -f cyan -b black "/path" -nonewline
    write-host -f magenta -b black " ]"
    linescreen
    write-host -f cyan "DESTINATION URL = " -NoNewline
    write-host -f green -b darkgreen "protocol" -NoNewline
    write-host -f cyan -b black "://" -NoNewline
    write-host -f yellow -b black "$global:thehostofinterest" -nonewline; 
    write-host -f cyan -b black ":" -NoNewline
    write-host -f red -b black "port" -NoNewline
    write-host -f cyan -b black "/" -NoNewline
    write-host -f green "path" -NoNewline
    write-host -f cyan -b black "/" -NoNewline
    write-host -f blue "filename"
    linescreen
    write-host -f cyan "EXAMPLE URL     =    " -NoNewline
    write-host -f green -b darkgreen "https" -NoNewline
    write-host -f cyan -b black "://" -NoNewline
    write-host -f yellow -b black "$global:thehostofinterest" -nonewline; 
    write-host -f cyan -b black ":" -NoNewline
    write-host -f red -b black "8443" -NoNewline
    write-host -f cyan -b black "/" -NoNewline
    write-host -f green "adminconsole" -NoNewline
    write-host -f cyan -b black "/" -NoNewline
    write-host -f blue "portal.aspx"
    linescreen
    
    $global:theprotocol = Read-Host -Prompt 'Enter your PROTOCOL of interest and hit <ENTER> :'
        $global:theport = Read-Host -Prompt 'Enter your     PORT of interest and hit <ENTER> :'
        $global:thepath = Read-Host -Prompt 'Enter your     PATH of interest and hit <ENTER> :'
    $global:thefilename = Read-Host -Prompt 'Enter your     FILE of interest and hit <ENTER> :'
          $findthistext = Read-Host -Prompt 'Enter your     TEXT to be found and hit <ENTER> :'
    linescreen2
    if ( $global:theprotocol -eq "" ) { $global:theprotocol = "http" }
    if ( $global:theport -eq "" -and $global:theprotocol -eq "http" ) { $global:theport = "80" }
    if ( $global:theport -eq "" -and $global:theprotocol -eq "https" ) { $global:theport = "443" }
    if ( $findthistext -eq "" ) { $findthistext = "." }
    $global:theurl = $global:theprotocol+"://"+$global:thehostofinterest+":"+$global:theport+"/"+$global:thepath+"/"+$global:thefilename
    write-host -f cyan "Your URL of interest = " -nonewline ; write-host -f green $global:theurl
    linescreen2
            
    try { $webClient = New-Object System.Net.WebClient -ErrorAction SilentlyContinue } catch { write-host -f red "Unable to get a response from $global:theurl"  }
    try { $content = $webClient.DownloadString($global:theurl) ; Start-Sleep -Second 1 } catch { write-host -f red "Unable to get any content from $global:theurl"  }
    linescreen
    write-host -f cyan "Web Content matching " -nonewline ; write-host -f green $findthistext
    linescreen
    $content | select-string $findthistext
    write-host ""
    linescreen
    write-host -f cyan "Web Request Headers " -nonewline ; write-host -f green $global:theurl
    linescreen
    try { $therequest = Invoke-WebRequest $global:theurl -ErrorAction Stop } catch { write-host -f red "Unable to invoke Headers from $global:theurl"  }
    try { $therequest.Headers } catch { write-host -f red "Unable to obtain Headers from $global:theurl"  }
    linescreen2
      
    entertocontinue
                                      }


if ($global:netnodeviewoption -eq 6 ) {

    clear-host
    Start-Sleep -Second .6
    netnodeviewtop
    write-host -f white -b darkgreen "[ 6 ] get certificate fields    " -nonewline;
    write-host -f green -b black "[ $global:youarehere ]" -nonewline;
    write-host -f cyan -b black "-" -nonewline;
    write-host -f yellow -b darkred "CERT" -nonewline;
    write-host -f cyan -b black "-" -nonewline;
    write-host -f magenta -b black "[ " -nonewline;
    write-host -f yellow -b black "$global:thehostofinterest" -nonewline;
    write-host -f magenta -b black ":" -nonewline
    write-host -f green -b black "port" -nonewline
    write-host -f magenta -b black " ]"
    linescreen
    $global:theprotocol = "https"
        $global:theport = Read-Host -Prompt 'Enter your     PORT of interest and hit <ENTER> :'
        $global:thepath = Read-Host -Prompt 'Enter your     PATH of interest and hit <ENTER> :'
    linescreen2
    if ( $global:theport -eq "" ) { $global:theport = "443" }
    
    $global:theurl = $global:theprotocol+"://"+$global:thehostofinterest+":"+$global:theport+"/"+$global:thepath+"/"
    write-host -f yellow $global:theurl
    linescreen
    try { $WebRequest = [Net.WebRequest]::Create($global:theurl) ; Start-Sleep -Second 1 } catch { write-host -f red "Unable to create web request for $global:theurl" } 
    try { $Response = $WebRequest.GetResponse()	} catch { write-host -f red "Unable to get certificate response for $global:theurl" }
         
    try {$issuer = $WebRequest.ServicePoint.Certificate.GetIssuerName()
    write-host -f cyan "Cert Issuer = " -nonewline ; write-host -f yellow $issuer } catch { write-host -f red "Unable to Get Issuer" }
    try { $Subject = $WebRequest.ServicePoint.Certificate.Subject
    write-host -f cyan "Cert Subject = " -nonewline ; write-host -f yellow $Subject } catch { write-host -f red "Unable to Get Subject" }
    try { $Serial = $WebRequest.ServicePoint.Certificate.GetSerialNumber() 
    write-host -f cyan "Cert Serial Number = " -nonewline ; write-host -f yellow $Serial } catch { write-host -f red "Unable to Get Serial Number" }
    try { $Serialstring = $WebRequest.ServicePoint.Certificate.GetSerialNumberString()
    write-host -f cyan "Cert Serial Number String = " -nonewline ; write-host -f yellow $Serialstring } catch { write-host -f red "Unable to Get Serial Number String" } 
    try { $effective = $WebRequest.ServicePoint.Certificate.GetEffectiveDateString()
    write-host -f cyan "Cert Valid From Date = " -nonewline ; write-host -f yellow $effective } catch { write-host -f red "Unable to Get Effective Date String" }
    try { $expiration = $WebRequest.ServicePoint.Certificate.GetExpirationDateString() 
    write-host -f cyan "Cert Expiration Date = " -nonewline ; write-host -f yellow $expiration} catch { write-host -f red "Unable to Get Expiration Date String" }
    try { $public = $WebRequest.ServicePoint.Certificate.GetPublicKey() 
    write-host -f cyan "Cert Public Key = " -nonewline ; write-host -f yellow $public } catch { write-host -f red "Unable to Get Public Key" }
    try { $publicstring = $WebRequest.ServicePoint.Certificate.GetPublicKeyString()
    write-host -f cyan "Cert Public Key String = " -nonewline ; write-host -f yellow $publicstring } catch { write-host -f red "Unable to Get Public Key String" }
    try { $certhash = $WebRequest.ServicePoint.Certificate.GetCertHash() 
    write-host -f cyan "Cert Hash = " -nonewline ; write-host -f yellow $certhash } catch { write-host -f red "Unable to Get Certificate Hash" }
    try { $certhashstring = $WebRequest.ServicePoint.Certificate.GetCertHashString()
    write-host -f cyan "Cert Hash String = " -nonewline ; write-host -f yellow $certhashstring } catch { write-host -f red "Unable to Get Certificate Hash String" }
    try { $ka = $WebRequest.ServicePoint.Certificate.GetKeyAlgorithm() 
    write-host -f cyan "Cert Key Algorithm = " -nonewline ; write-host -f yellow $ka } catch { write-host -f red "Unable to Get Key Algorithm" }
    linescreen2
    try { $raw = $WebRequest.ServicePoint.Certificate.GetRawCertData()  } catch { write-host -f red "Unable to Get Raw Certificate Data" }
    write-host -f cyan "Cert Raw Data = " -nonewline ; write-host -f yellow $raw
    linescreen2


    if ($WebRequest.ServicePoint.Certificate -ne $null) {
        $Cert = [Security.Cryptography.X509Certificates.X509Certificate2]$WebRequest.ServicePoint.Certificate.Handle
        try {$SAN = ($Cert.Extensions | Where-Object {$_.Oid.Value -eq "2.5.29.17"}).Format(0) -split ", "
             write-host -f cyan "Cert Subject Alternative Name = " -nonewline
             write-host -f yellow  $SAN  | findstr -i "DNS=" | FT -AutoSize
            }
        catch {$SAN = $null}
                                                         }
    linescreen2

    

    entertocontinue


                                      }

if ($global:netnodeviewoption -eq 7 ) {
    clear-host
    Start-Sleep -Second .6
    netnodeviewtop
    write-host -f white -b darkgreen "  [ 7 ] get DNS resolution/lookup " -nonewline;
    write-host -f green -b black "[ $global:youarehere ]" -nonewline;
    write-host -f cyan -b black "=(" -nonewline;
    write-host -f yellow -b darkred "DNS" -nonewline;
    write-host -f cyan -b black ")" -nonewline;
    write-host -f magenta -b black "[ " -nonewline;
    write-host -f yellow -b black "$global:thehostofinterest" -nonewline;
    write-host -f magenta -b black " ]"
    linescreen
    write-host " DNS lookup"
    linescreen
    Try { 
    
    Resolve-DnsName -Name $global:thehostofinterest -ErrorAction Stop 
         
    }    catch { 
     write-Host -f Green  "clue : DNS name $global:thehostofinterest might not exist "
     Write-Host -f Yellow "An error occurred: $_"
         
          }
    linescreen
    write-host " DNS lookup based on cache "
    linescreen
    Try { 
    
    Resolve-DnsName -Name $global:thehostofinterest -CacheOnly -ErrorAction Stop
         
    }    catch { 
     write-Host -f Green  "clue : DNS name $global:thehostofinterest might not exist "
     Write-Host -f Yellow "An error occurred: $_"
         
          }

    linescreen
    write-host " DNS lookup skipping hosts file "
    linescreen
    Try { 
    
    Resolve-DnsName -Name $global:thehostofinterest -NoHostsFile -ErrorAction Stop
         
    }    catch { 
     write-Host -f Green  "clue : DNS name $global:thehostofinterest might not exist "
     Write-Host -f Yellow "An error occurred: $_"
         
          }
    linescreen
    write-host " DNS entries in hosts file for $global:thehostofinterest "
    linescreen

    type "C:\Windows\System32\drivers\etc\hosts" | findstr -i $global:thehostofinterest

     linescreen2     
     entertocontinue
     
                                       } 

if ($global:netnodeviewoption -eq 8 ) {
    clear-host
    Start-Sleep -Second .6
    netnodeviewtop
    write-host -f white -b darkgreen "  [ 8 ] traceroute       " -nonewline ; write-host -f blue -b black "[-hop1-2-3----]" -nonewline;
    write-host -f green -b black "[ $global:youarehere ]" -nonewline;
    write-host -f cyan -b black "=" -nonewline;
    write-host -f yellow -b darkred "...." -nonewline;
    write-host -f cyan -b black "=" -nonewline;
    write-host -f magenta -b black "[ " -nonewline;
    write-host -f yellow -b black "$global:thehostofinterest" -nonewline;
    write-host -f magenta -b black " ]"
    linescreen
    Try { 
    
    tracert -w 300 $global:thehostofinterest
    
     
    }    catch {

     write-Host -f Green  "clue : cannot trace or reach node $global:thehostofinterest  "
     Write-Host -f Yellow "An error occurred: $_"
              }
     
     linescreen2     
     entertocontinue
   
                                          }


if ($global:netnodeviewoption -eq 9 ) {
    clear-host
    Start-Sleep -Second .6
    netnodeviewtop
    write-host -f white -b darkgreen "  [ 9 ] pathping         " -nonewline ; write-host -f blue -b black "[..lost/sent..]" -nonewline;
    write-host -f green -b black "[ $global:youarehere ]" -nonewline;
    write-host -f cyan -b black "=" -nonewline;
    write-host -f yellow -b darkred "...." -nonewline;
    write-host -f cyan -b black "=" -nonewline;
    write-host -f magenta -b black "[ " -nonewline;
    write-host -f yellow -b black "$global:thehostofinterest" -nonewline;
    write-host -f magenta -b black " ]"
    linescreen
    
Try { 
    
try { test-connection -count 2 $global:thehostofinterest -BufferSize 8 -ThrottleLimit 1 -ErrorAction Stop } catch { write-host -f red " --> test 1/12 failed " }
try { test-connection -count 2 $global:thehostofinterest -BufferSize 16 -ThrottleLimit 1 -ErrorAction Stop } catch { write-host -f red " --> test 2/12 failed " }
try { test-connection -count 2 $global:thehostofinterest -BufferSize 32 -ThrottleLimit 1 -ErrorAction Stop } catch { write-host -f red " --> test 3/12 failed " }
try { test-connection -count 2 $global:thehostofinterest -BufferSize 64 -ThrottleLimit 1 -ErrorAction Stop } catch { write-host -f red " --> test 4/12 failed " }
try { test-connection -count 2 $global:thehostofinterest -BufferSize 128 -ThrottleLimit 1 -ErrorAction Stop } catch { write-host -f red " --> test 5/12 failed " }
try { test-connection -count 2 $global:thehostofinterest -BufferSize 256 -ThrottleLimit 1 -ErrorAction Stop } catch { write-host -f red " --> test 6/12 failed " }
try { test-connection -count 2 $global:thehostofinterest -BufferSize 512 -ThrottleLimit 1 -ErrorAction Stop } catch { write-host -f red " --> test 7/12 failed " }
try { test-connection -count 2 $global:thehostofinterest -BufferSize 1024 -ThrottleLimit 1 -ErrorAction Stop } catch { write-host -f red " --> test 8/12 failed " }
try { test-connection -count 2 $global:thehostofinterest -BufferSize 4096 -ThrottleLimit 1 -ErrorAction Stop } catch { write-host -f red " --> test 9/12 failed " }
try { test-connection -count 2 $global:thehostofinterest -BufferSize 8192 -ThrottleLimit 1 -ErrorAction Stop } catch { write-host -f red " --> test 10/12 failed " }
try { test-connection -count 2 $global:thehostofinterest -BufferSize 32768 -ThrottleLimit 1 -ErrorAction Stop } catch { write-host -f red " --> test 11/12 failed " }
try { test-connection -count 2 $global:thehostofinterest -BufferSize 65500 -ThrottleLimit 1 -ErrorAction Stop } catch { write-host -f red " --> test 12/12 failed " }

    
     
    }    catch {

     write-Host -f Green  "clue : cannot ping or reach node $global:thehostofinterest  "
     Write-Host -f Yellow "An error occurred: $_"
              }
Write-Host "" ; linescreen2

Try { 
    
pathping $global:thehostofinterest
   
     
    }    catch {

     write-Host -f Green  "clue : cannot ping or reach node $global:thehostofinterest  "
     Write-Host -f Yellow "An error occurred: $_"
              }

     linescreen2     
     entertocontinue
   
                                          }



     if ( $global:netnodeviewoption -eq "x" )
      { linescreen2; write-host -f blue "Thanks for using NetNodeView.ps1 " ; break;}

     if ( $global:netnodeviewoption -eq "0" )
      { linescreen2;
         write-host -f white -b blue "Enter your " -nonewline;
         write-host -f yellow -b black " NEW " -nonewline;
         write-host -f white -b blue " f.q.d.n. or hostname or IP of interest and hit <ENTER> " -nonewline;
      $global:thehostofinterest = Read-Host -Prompt ':' }
            
     
     
     } ##



     
     clear-host
     presentation
     presentation1
     presentation2
     
     

     DO {
     presentation
     presentation2
      } while ( $global:netnodeviewoption -ne "x" )
