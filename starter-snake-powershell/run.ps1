using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write Starting to the Azure Functions log stream.
Write-Information "PowerShell HTTP trigger function started processing a request."

# Import Handlers
. ((Get-Location).Path + "/starter-snake-powershell/handlers.ps1")

$statusCode = [HttpStatusCode]::OK

switch ($Request) {
    { $_.Method -eq 'GET' -and $_.Params.command -eq $null } {
        # https://docs.battlesnake.com/references/api#get
        $reply = Invoke-Info | ConvertTo-Json -Depth 2
    }
    { $_.Method -eq 'POST' -and $_.Params.command -eq 'start' -and $_.Body } {
        # https://docs.battlesnake.com/references/api#post-start
        $reply = Invoke-Start -GameState $_.Body | ConvertTo-Json -Depth 2
    }
    { $_.Method -eq 'POST' -and $_.Params.command -eq 'move' -and $_.Body } {
        # https://docs.battlesnake.com/references/api#post-move
        $reply = Invoke-Move -GameState $_.Body | ConvertTo-Json -Depth 2
    }
    { $_.Method -eq 'POST' -and $_.Params.command -eq 'end' -and $_.Body } {
        # https://docs.battlesnake.com/references/api#post-end
        $reply = Invoke-End -GameState $_.Body | ConvertTo-Json -Depth 2
    }
    Default {
        $statusCode = [HttpStatusCode]::BadRequest
        $reply = $null
    }
}

Write-Information "HHTP $statusCode : $($Request.Method.ToUpper()) to $($Request.Url)"

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = $statusCode
        Body       = $reply
    })

# Write Finished to the Azure Functions log stream.
Write-Information "PowerShell HTTP trigger function finished processing a request."
