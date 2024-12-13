# Prompt for directory
$dir_path = Read-Host "Please enter the full path to the directory containing tags.txt"

# Validate directory
if (-Not (Test-Path $dir_path)) {
    Write-Host "Invalid directory path provided."
    pause
    exit
}

# Check for tags.txt
$tags_file = Join-Path $dir_path "tags.txt"
if (-Not (Test-Path $tags_file)) {
    Write-Host "tags.txt not found in the specified directory."
    pause
    exit
}

# Output XML file path
$output_file = Join-Path $dir_path "tags.xml"

# Create XML document
$xmlDoc = New-Object System.Xml.XmlDocument
$xmlDeclaration = $xmlDoc.CreateXmlDeclaration("1.0", "UTF-8", $null)
$xmlDoc.AppendChild($xmlDeclaration) | Out-Null

# Create root Tags element
$tagsElement = $xmlDoc.CreateElement("Tags")
$xmlDoc.AppendChild($tagsElement) | Out-Null

# Create Tag element
$tagElement = $xmlDoc.CreateElement("Tag")
$tagsElement.AppendChild($tagElement) | Out-Null

# Read and process tags from file
$tags = Get-Content $tags_file

foreach ($line in $tags) {
    # Split the line by the first colon
    $splitIndex = $line.IndexOf(":")
    if ($splitIndex -ge 0) {
        $tag = $line.Substring(0, $splitIndex).Trim()
        $value = $line.Substring($splitIndex + 1).Trim()

        # Create Simple element
        $simpleElement = $xmlDoc.CreateElement("Simple")
        $tagElement.AppendChild($simpleElement) | Out-Null

        # Create Name element
        $nameElement = $xmlDoc.CreateElement("Name")
        $nameElement.InnerText = $tag
        $simpleElement.AppendChild($nameElement) | Out-Null

        # Create String element
        $stringElement = $xmlDoc.CreateElement("String")
        $stringElement.InnerText = $value
        $simpleElement.AppendChild($stringElement) | Out-Null
    }
}

# Save the XML file
$xmlDoc.Save($output_file)

Write-Host "Conversion complete. XML tags file created at $output_file"