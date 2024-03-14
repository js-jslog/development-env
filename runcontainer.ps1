# Step 0: Make sure the lastest docker iamge is available
docker pull jslog/development-env:v12.1.0

# Step 1: List Docker Images with "development-env" tag
$imageNames = docker images --format "{{.Repository}}:{{.Tag}}" | Where-Object { $_ -like "*development-env*" }

# Present the image names with numeric options
Write-Host "Choose an image from the following list:"
for ($i = 0; $i -lt $imageNames.Count; $i++) {
    Write-Host ("[$i] " + $imageNames[$i])
}

# Prompt user for selection
$selectedOption = Read-Host -Prompt "Select the number corresponding to your chosen image"
$selectedImage = $imageNames[$selectedOption]

# Step 2: List Local Docker Volumes
$volumeNames = docker volume ls -f dangling=false --format "{{.Name}}"

# Present the volume names with numeric options
Write-Host "Choose a volume from the following list (or type 'n' for no volume):"
Write-Host ("[n] No volume")
for ($i = 0; $i -lt $volumeNames.Count; $i++) {
    Write-Host ("[$i] " + $volumeNames[$i])
}

# Prompt user for selection
$selectedOption = Read-Host -Prompt "Select the number corresponding to your chosen volume"
if ($selectedOption -eq 'n') {
    $selectedVolume = $null
} else {
    $selectedVolume = $volumeNames[$selectedOption]
}

# Step 3: Generate the container name and determine whether it already exists
$containerName = "devcon-$selectedVolume"
if (docker ps -a -q -f "name=$containerName") {
    $containerNameExists = $true
} else {
    $containerNameExists = $false
}

# Step 4: Create and run the container if the container name does not exist.
# Otherwise help the user take the next step.
$hostcliplistenport = "8121"
$devconcliplistenport = "8122"
$portMapping = "-p ${hostcliplistenport}:${hostcliplistenport} -p ${devconcliplistenport}:${devconcliplistenport}"
if ($selectedVolume) {
    $runCommand = "docker run -dit --name $containerName $portMapping -v '${selectedVolume}:/app' $selectedImage"
} else {
    $runCommand = "docker run -dit --name $containerName $portMapping $selectedImage"
}

if ($containerNameExists -eq $true) {
    Write-Host "-------------------------------------------------------------------------------------------------------------------------"
    Write-Host "EXITING EARLY:"
    Write-Host "Container $containerName already exists. Please use that container or delete and recreate."
    Write-Host "If you can't delete that container then you can modify the name in this command and run manually:"
    Write-Host "You can still create this container by another name without this helper script if you want to keep the existing container."
    Write-Host "$runCommand"
    Write-Host "-------------------------------------------------------------------------------------------------------------------------"
    Exit 1
} else {
    Write-Host "The Docker run command: ${runCommand}"
    Invoke-Expression $runCommand
}

# Step 5: Enter the container
$timeoutInSeconds = 5
$startTime = Get-Date
while ((Get-Date) -lt ($startTime.AddSeconds($timeoutInSeconds))) {
    $containerStatus = docker ps --filter "name=$containerName" --format "{{.Status}}"
    if ($containerStatus -like "Up*") {
        break
    }
    Start-Sleep -Seconds 1
}

# Check if the container is ready
if ($containerStatus -like "Up*") {
    Write-Host "Container $containerName is now running and ready."
    docker exec -it $containerName /bin/bash
} else {
    Write-Host "Container $containerName did not start within the specified timeout."
}
