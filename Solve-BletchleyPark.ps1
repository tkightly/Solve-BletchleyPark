function Solve-BletchleyPark {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Collections.Generic.List[Object]]$Matrix,
        [Parameter(Mandatory = $true)]
        [string]$Clue,
        [Parameter(Mandatory = $true)]
        [string]$Code
    )

    switch ($Clue) {
        
        # If the clue is numerical. 6 is excluded.
        { $_ -in 1..5 } {

            # Initialise our blank object to be outputted
            $Output = @{
                Up    = ''
                Right = ''
                Down  = ''
                Left  = ''
            }

            # Copy the keys/properties to a new object
            [array]$Keys = $Output.Keys

            # Iterate through each key/property
            foreach ($Key in $Keys) {
            
                # Loop through each character in our code
                foreach ($Character in $Code.ToCharArray()) {

                    # Find the transposed value for the current character based on the direction and amount of spaces to move
                    $Output.$Key += Move-InsideMatrix -Matrix $Matrix -Direction $Key -CurrentChar $Character -Amount $Clue
                }
            }          

            # Output the object
            $Output  
        }

        # If the clue is directional
        { $_ -in ('Up', 'Right', 'Left', 'Down') } {

            # Create a new ordered hashtable. We want the properties to stay in the same order
            $Output = [ordered]@{}
            
            # Add a key/property for each number between 1 and 5. As above, no need to solve for 6
            Foreach ($num in $(1..5)) {
                $Output.Add("$num", '')
            }

            # Copy the keys/properties to a new object
            [array]$Keys = $Output.Keys

            # Iterate through each key/property
            foreach ($Key in $Keys) {

                # Loop through each character in our code
                foreach ($Character in $Code.ToCharArray()) {

                    # Find the transposed value for the current character based on the direction and amount of spaces to move
                    $Output.$Key += Move-InsideMatrix -Matrix $Matrix -Direction $Clue -CurrentChar $Character -Amount $Key
                }
            }
            
            # Output the object
            $Output
        }

        # If the clue is X
        'X' {
            
            # Create a new object
            $Output = @{
                X = ''
            }

            # Iterate through each key/property
            foreach ($Character in $Code.ToCharArray()) {

                # Identify the array index of the current character
                $currIndex = $matrix.findIndex( { $args -eq $Character })             

                # Get the character that exists at the index 35 subtract the index of our current character
                $Output.X += $Matrix[$(35 - $currIndex)]
            }

            # Output the object
            $Output
        }
    }
}

function Move-InsideMatrix {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Collections.Generic.List[Object]]$Matrix,
        [Parameter(Mandatory = $true)]
        [String]$CurrentChar,
        [Parameter(Mandatory = $true)]
        [String]$Direction,
        [Parameter(Mandatory = $true)]
        [int]$Amount
    )
    
    # Identify the array index of the current character
    $currIndex = $matrix.findIndex( { $args -eq $CurrentChar })

    switch ($direction) {
        'Up' { 
            # We are going up a row, and there are 6 columns in the matrix. Also make negative the resultant value negative so we are going back not forwards
            $amount = $amount * -6
            
            # If the resulting value would take us off the matrix, put us back on the other side
            if (($currIndex + $amount) -lt 0) {
                $Amount = $Amount + 36
            }
        }
        'Right' {
            # If we would move off the current row, subtract 6 to keep us on the current row.
            if ([math]::floor($currIndex / 6) -lt [math]::floor(($currIndex + $amount) / 6)) {
                $Amount = $Amount - 6
            }
        }
        'Down' {
            # We are going down a row, and there are 6 columns in the matrix.
            $amount = $amount * 6
            
            # If the resulting value would take us off the matrix, put us back on the other side
            if (($currIndex + $amount) -gt 35) {
                $Amount = $Amount - 36
            } 
        }
        'Left' {
            # Make negative so we are going back
            $amount = $amount * -1

            # If we would move off the current row, subtract 6 to keep us on the current row.
            if ([math]::floor($currIndex / 6) -gt [math]::floor(($currIndex + $amount) / 6)) {
                $Amount = $Amount + 6
            }
        }
    }

    # do a final check that our code doesn't try to give us a character that isn't on the matrix
    if (($currIndex + $amount) -notin 0..35) {
        throw "Tried to index out of bounds. $($currIndex + $amount) is not a valid index"
    }

    # Output the character
    $matrix[$currIndex + $amount]
}

# In case there's an error, stop execution and throw an exception
$ErrorActionPreference = 'Stop'

# Define some examples
$Examples = @(
    @{
        Clue = 'X'
        Code = 'GIUD9 GTAHH J9UHJ UVHPG KKKKK'
    }
    @{
        Clue = '3'
        Code = 'XQHL5 XATUU C5HUC HWU3X SSSSS'
    }
    @{
        Clue = '1'
        Code = '4SO1J478009JO09O60N4MMMMM'
    }
    @{
        Clue = '2'
        Code = '3KFZX362BBVXFBVFJBE3IIIII'
    }
    @{
        Clue = 'Left'
        Code = '59R8I5Y7OO0IRO0RMOX5EEEEE'
    }
    @{
        Clue = 'Right'
        Code = 'XQHL5XATUUC5HUCHWU3XSSSSS'
    }
    @{
        Clue = '3'
        Code = 'OAPJ2OQI33D2P3DP83UO77777'
    }
    @{
        Clue = '1'
        Code = 'IG6VSIFB22ZS62Z6D25I33333'
    }
    @{
        Clue = 'Left'
        Code = 'XQHL5XATUUC5HUCHWU3XSSSSS'
    }
    @{
        Clue = 'Down'
        Code = 'OAPJ2OQI33D2P3DP83UO77777'
    }
    @{
        Clue = 'UP'
        Code = 'A4VEYAZGKK5YVK5VUK6AHHHHH'
    }
)

# Define our matrix
[Collections.Generic.List[Object]]$Matrix = @('3', 'e', 's', 'i', '5', 'x', 'w', 'j', '4', 'n', 'd', 'm', 'f', 'y', 'a', '6', 'r', 'h', 't', '2', 'o', 'u', 'b', '7', '0', 'c', 'v', '8', 'l', 'z', 'k', '1', 'p', 'g', '9', 'q')

$i = 1
foreach ($Example in $Examples) {
    Write-Output "######################"
    Write-Output "Processing code $i"
    $Example.Code = $Example.Code.Replace(' ', '')
    Write-Output "Code: $($Example.Code)"
    Write-Output "Clue: $($Example.Clue)"
    Solve-BletchleyPark -Matrix $Matrix -Clue $Example.Clue -Code $Example.Code | ft
    $i++
}