# Scriptet er ment for å sjekke servicestatus.
# Husk å dokumentere bruk når dette er testet OK.

$API = new-object -comObject "MOM.ScriptAPI"
$bag = $api.CreatePropertyBag()

$Servicename = "Spooler"
$StoppedServices = GWMI -class win32_service | where { $_.name -eq $servicename -and $_.startmode -eq 'Auto' -and $_.State -ne 'Running'}

if ($StoppedServices) # Hvis det finnes noen servicer som har noen annen status enn Running, OG har startmode Auto
    {
    $serviceList=$null # Opprett tom serviceliste
    foreach ($service in $StoppedServices)
        {$servicelist= $servicelist + "`n" + "Servicename: " + $($service.displayname) + "`n" + "Servicestate: " + $($service.state) } # Legg til hver service som er stoppet opp, legg til linebreak
 
    $bag.AddValue("StoppedServices","$serviceList") # Legg til listen med servicer i bag
    $bag.addvalue("State","Critical")
    }

else {$bag.addvalue("State","Healthy")}  # Hvis det ikke finnes stoppede servicer, er alt i orden.


$bag