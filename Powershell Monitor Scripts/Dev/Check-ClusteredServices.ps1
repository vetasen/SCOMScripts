$API = new-object -comObject "MOM.ScriptAPI"
$bag = $api.CreatePropertyBag()

$clusternodes = @(
"sql1";
"brumlebass"
)
$Servicename = "Spooler"

$ServiceStatus = get-service -cn $clusternodes -name $Servicename

if ($ServiceStatus.status -notcontains "Stopped"){
    $ServiceList=$null
        foreach ($service in $ServiceStatus){
            $serviceList = "Tjenesten Spooler kjører på begge clusternodene."
        }
        $bag.Addvalue("ServiceError","$Servicelist")
        $bag.addvalue("State","AllRunning")
        
}

elseif ($ServiceStatus.status -notcontains "Running"){
    $ServiceList=$null
        foreach ($service in $ServiceStatus){
            $serviceList = "Tjenesten Spooler er stoppet på begge clusternodene"
        }
        $bag.Addvalue("ServiceError","$Servicelist")
        $bag.addvalue("State","AllStopped")
        
}

else {$bag.addvalue("State","Healthy")}  # Hvis det ikke finnes stoppede servicer, er alt i orden.


$bag