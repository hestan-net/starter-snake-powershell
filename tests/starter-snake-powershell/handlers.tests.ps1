Describe "Test PowerShell Starter Battlesnake - Handler Functions" {

    BeforeAll {
        # Import
        . ((Get-Location).Path + "/starter-snake-powershell/handlers.ps1")
    
        # Sample Move Request - Used as GameState
        $sampleMoveRequest = Get-Content -Raw 'tests\starter-snake-powershell\sample-move-request.jsonc' | ConvertFrom-Json -Depth 10
    }

    Context "Invoke-Info" {
        It "Should return information object with required properties." {
            $infoObject = Invoke-Info
            $infoObject.apiversion | Should -Not -BeNullOrEmpty
            $infoObject.author     | Should -Not -BeNullOrEmpty
            $infoObject.color      | Should -Not -BeNullOrEmpty
            $infoObject.head       | Should -Not -BeNullOrEmpty
            $infoObject.tail       | Should -Not -BeNullOrEmpty
            $infoObject.version    | Should -Not -BeNullOrEmpty
        }
    }
    Context "https://docs.battlesnake.com/references/api/sample-move-request" {
        Context "Invoke-Start -GameState `$sampleMoveRequest" {
            It "Should return empty string." {
                $return = Invoke-Start -GameState $sampleMoveRequest
                $return | Should -BeOfType String
                $return | Should -BeNullOrEmpty
            }
        }
        Context "Invoke-Move -GameState `$sampleMoveRequest" {
            It "Should return reply object with legal move and shout properites." {
                $reply = Invoke-Move -GameState $sampleMoveRequest
                $reply.move  | Should -Not -BeNullOrEmpty
                $reply.shout | Should -Not -BeNullOrEmpty

                $reply.move  | Should -BeIn @('up', 'down', 'left', 'right')
                $reply.shout | Should -BeOfType String
            }
        } 
        Context "Invoke-End -GameState `$sampleMoveRequest" {
            It "Should return empty string." {
                $return = Invoke-End -GameState $sampleMoveRequest
                $return | Should -BeOfType String
                $return | Should -BeNullOrEmpty
            }
        } 
    }  
}