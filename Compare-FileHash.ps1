function Compare-FileHash([string]$folder1, [string]$folder2)
{
  $hashes1 = Get-ChildItem -Path "$folder1" -Recurse | Get-FileHash
  $hashes2 = Get-ChildItem -Path "$folder2" -Recurse | Get-FileHash
  $files = $hashes1.Path + $hashes2.Path
  ""
  "Identical files:"
  foreach($h1 in $hashes1)
  {
    foreach($h2 in $hashes2)
    {
      if($h1.Hash -eq $h2.Hash)
      {
        $h1.Path + " == " + $h2.Path
        $files = $files -ne $h1.Path
        $files = $files -ne $h2.Path
      }
    }
  }
  ""
  "Unique files:"
  $files
 ""
}