# GET /
## https://docs.battlesnake.com/references/api#get

function Invoke-Info {

    return @{
        apiversion = "1"
        author     = "MyUsername"
        color      = "#888888"
        head       = "default"
        tail       = "default"
        version    = "0.0.1-beta"
    }

}

# START
## https://docs.battlesnake.com/references/api#post-start

function Invoke-Start {

    param(    
        [Parameter(Mandatory)]
        $GameState
    )
    
    return ""

}

# MOVE
## https://docs.battlesnake.com/references/api#post-move

function Invoke-Move {

    param(    
        [Parameter(Mandatory)]
        $GameState
    )

    $possibleMoves = @{
        up    = $true
        down  = $true
        left  = $true
        right = $true
    }

    $myHead = $GameState.you.head
    $myNeck = $GameState.you.body[1]

    # Step 0: Don't let your Battlesnake move back on it's own neck
    if ($myNeck.x -lt $myHead.x) {
        $possibleMoves.Remove('left')
    }
    elseif ($myNeck.x -gt $myHead.x) {
        $possibleMoves.Remove('right')
    }
    elseif ($myNeck.y -lt $myHead.y) {
        $possibleMoves.Remove('down')
    }
    elseif ($myNeck.y -gt $myHead.y) {
        $possibleMoves.Remove('up')
    }

    # TODO: Step 1 - Don't hit walls.
    # Use information in gameState to prevent your Battlesnake from moving beyond the boundaries of the board.
    # const boardWidth = gameState.board.width
    # const boardHeight = gameState.board.height

    # TODO: Step 2 - Don't hit yourself.
    # Use information in gameState to prevent your Battlesnake from colliding with itself.
    # const mybody = gameState.you.body

    # TODO: Step 3 - Don't collide with others.
    # Use information in gameState to prevent your Battlesnake from colliding with others.

    # TODO: Step 4 - Find food.
    # Use information in gameState to seek out and find food.

    # Finally, choose a move from the available safe moves.
    # TODO: Step 5 - Select a move to make based on strategy, rather than random.

    $moveToMake = Get-Random -InputObject ($possibleMoves.Keys | Out-String -Stream)

    Write-Information "$($GameState.game.id) MOVE $($GameState.turn): $moveToMake"

    return @{
        move  = $moveToMake
        shout = "$($GameState.you.name) is moving!"
    }
    
}

# END
## https://docs.battlesnake.com/references/api#post-end

function Invoke-End {

    param(    
        [Parameter(Mandatory)]
        $GameState
    )

    return ""

}