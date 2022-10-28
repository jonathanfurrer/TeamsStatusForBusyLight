

$IpAdress = "192.168.140.203"
$Username = "JonathanFurrer"
function setLight {
    param (
         $red,
         $green,
         $blue,
         $turn,
        [String]$IpAdress
    )

    If ($turn ){
        $t = "on"
    }else{
        $t = "off"
    }

    $uri =  "http://" + $IpAdress + "/color/0?turn="+$t+"&red="+$red+"&green="+$green+"&blue="+$blue
    Write-Host $uri
    Invoke-RestMethod -Method "get" -Uri $uri
};

while($true){
    if ($IpAdress -like "*192.168.140*") {
        $logfilePath = "C:\Users\" + $Username + "\AppData\Roaming\Microsoft\Teams\logs.txt" 
        $log = Get-Content $logfilePath -tail 1000
        $logString = [system.String]::Join(" ", $log)
        $lastIndex = $logString.LastIndexOf("StatusIndicatorStateService")
        $laststat = $logString.Substring( $lastIndex + 35 , 12 )                   
        Write-Host  $laststat               
        switch ($laststat)
        {
            {$_.contains("OnThePhone")} {
                "OnThePhone"
                setLight -red 10 -green 0 -blue 0 -turn 1 -IpAdress $IpAdress
            }
            {$_.contains("NewActivity")} {
                "NewActivity"
                setLight -red 0 -green 0 -blue 0 -turn 0 -IpAdress $IpAdress
            }
            {$_.contains("Presenting")} {
                "Presenting"
                setLight -red 10 -green 0 -blue 0 -turn 1 -IpAdress $IpAdress
            }
            {$_.contains("Unknown")} {
                "Unknown"
                setLight -red 0 -green 0 -blue 0 -turn 0 -IpAdress $IpAdress
            }
            {$_.contains("Offline")} {
                "Offline"
                setLight -red 0 -green 0 -blue 0 -turn 0 -IpAdress $IpAdress
            }
            {$_.contains("Away")} {
                "Away"
                setLight -red 0 -green 0 -blue 0 -turn 0 -IpAdress $IpAdress
            }
            {$_.contains("Available")} {
                "Available"
                setLight -red 0 -green 10 -blue 2 -turn 1 -IpAdress $IpAdress
            }
            {$_.contains("Busy")} {
                "Busy"
                setLight -red 10 -green 10 -blue 0 -turn 1 -IpAdress $IpAdress
            }
            {$_.contains("DoNotDisturb")} {
                "DoNotDisturb"  
                setLight -red 10 -green 0 -blue 0 -turn 1 -IpAdress $IpAdress
            } 
            {$_.contains("BeRightBack")} {
                "BeRightBack"
                setLight -red 0 -green 0 -blue 0 -turn 0 -IpAdress $IpAdress  
            }           
        }
    }else{
        exit
    }
    Start-Sleep(60)
}
