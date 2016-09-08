$API = new-object -comObject "MOM.ScriptAPI"
$bag = $api.CreatePropertyBag()

# Variables
$Servicename = "Spooler"
$Clustername = "SQL11"
$clusternodes = @(
"sql1";
"brumlebass"
)

try {
    test-connection -cn $Clustername -count 1 -erroraction STOP
	}

catch {
    $TryError = $_.exception.message
    }

if ($TryError){
    $bag.addvalue("ServiceError","Problemer med å nå kommunisere med $($Clustername). Feilmelding: $TryError")
    $bag.addvalue("State","NoContact")
    $bag
    break
}

$ServiceStatus = get-service -cn $clusternodes -name $Servicename

if ($ServiceStatus.status -notcontains "Stopped"){
    $ServiceError=$null
        foreach ($service in $ServiceStatus){
            $ServiceError = "Tjenesten $servicename kjører på begge clusternodene: $($clusternodes[0]) og $($clusternodes[1])"
        }
        $bag.Addvalue("ServiceError","$ServiceError")
        $bag.addvalue("State","AllRunning")
        
}

elseif ($ServiceStatus.status -notcontains "Running"){
    $ServiceError=$null
        foreach ($service in $ServiceStatus){
            $ServiceError = "Tjenesten $ServiceName er stoppet på begge clusternodene: $($clusternodes[0]) og $($clusternodes[1])"
        }
        $bag.Addvalue("ServiceError","$ServiceError")
        $bag.addvalue("State","AllStopped")
        
}

else {$bag.addvalue("State","Healthy")}  # Hvis det ikke finnes stoppede servicer, er alt i orden.

$bag
