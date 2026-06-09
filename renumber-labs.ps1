$folders = Get-ChildItem -Directory |
    Where-Object { $_.Name -match '^\d\d-' } |
    Sort-Object Name -Descending

foreach ($folder in $folders) {

    $num = [int]$folder.Name.Substring(0,2)

    if ($num -ge 3) {

        $newNum = "{0:d2}" -f ($num - 1)
        $rest = $folder.Name.Substring(3)

        git mv $folder.Name "$newNum-$rest"
    }
}