$UTCNow = (Get-Date).ToUniversalTime()

$UTCTimeTick = $UTCNow.Ticks.tostring()

az group deployment create --resource-group mksm-resource-group --template-uri "https://raw.githubusercontent.com/kryvoplias/arm-template/master/template.json" --parameters currentDateTimeInTicks=$UTCTimeTick

az group deployment create --resource-group mksm-resource-group --template-uri "https://raw.githubusercontent.com/kryvoplias/arm-template/master/template-lb.json"