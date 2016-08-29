# Husk å bruk disse under expressions
# Property[@Name='State']

# Bruker denne under Alerting
# $Data/Context/Property[@Name='ShareError']$


$API = New-object -comObject "MOM.ScriptAPI"
$bag = $API.CreatePropertyBag()

$ShareName = "\\bgo-service01\public\ovs\"
$ErrorThrshld = "256"

try {
Get-ChildItem -literalpath \\bgo-service01\public\ovs\ -Hidden -ErrorAction Stop
}

catch {
$ErrorMsg = $_.exception.message
}

if ($errormsg){
$bag.AddValue("ShareError","$ErrorMsg") # Legg til Try Catch Feilmelding i Errorbag
$bag.AddValue("State","Warning")
}

else {
$colItems = (Get-ChildItem -literalpath \\bgo-service01\public\ovs\ -recurse | Measure-Object -property length -sum)
[int]$size = [math]::round($colItems.sum /1MB, 2)

if ($size -ge $ErrorThrshld){
    $ErrorThrshldMsg = "Diskplass overskredet terskelverdi $ErrorThrshld MB. Aktuell størrelse på mappen: $size MB"
    $bag.AddValue("ShareError","$ErrorThrshldMsg")
    $bag.AddValue("State","Critical")
}

Else {
    $bag.AddValue("State","Healthy")
    }
} # End Script


$bag