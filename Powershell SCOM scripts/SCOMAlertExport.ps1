

# Alert Params
param(
$parameters 
)

ipmo "C:\Program Files\Microsoft System Center 2012 R2\Operations Manager\Powershell\OperationsManager\OperationsManager.psm1"

$params = $parameters.split('##') | ? {$_ -ne ''}
 
# Build params (added commented blocks of Alert parameter data for your convenience)
$AlertID = $params[0] # $Data/Context/DataItem/AlertID$
$AlertName = $params[1] # $Data/Context/DataItem/AlertName$
$AlertDesc = $params[2]# $Data/Context/DataItem/AlertDescription$
$Path = $params[3] # $Data/Context/DataItem/ManagedEntityPath$
$DisplayName = $params[4] # $Data/Context/DataItem/ManagedEntityDisplayName$

$MonitorID = Get-scomalert -Id "$AlertID"
 
 
# Sharestuff
$share = "C:\temp\"
$date = get-date
$Alertfile = "SCOM Alert - $(get-date -Format "dd.MM.yyyy HH.mm.ss").log"
 
# Format AlertMessage
$AlertMessage = @()
 
$AlertMessage += "ID: $AlertID"
$AlertMessage += "Date: $date"
$AlertMessage += "DisplayName: $DisplayName"
$AlertMessage += "AlertName: $AlertName"
$alertMessage += "Path: $Path"
$AlertMessage += "Description: $AlertDesc"
$AlertMessage += "MonitoringID: $($MonitorID.MonitoringRuleId)"
 
# Output alert to textfile
$AlertMessage >> $share$alertfile