# Step 0: Make sure the lastest docker iamge is available
Write-Host "docker pull: Ensuring you have the latest image available."
docker pull jslog/development-env:v13.0.0
Write-Host ""

# Step 1: Check whether there are already any container running on the clipboard ports.
# Even if you aren't using the clipboard, this is a fingerprint of our containers and
# the end product of this script will fail if these ports are blocked.
# Action 1: Offer the user to attach to that container if its already running
# Action 2: Exit the script and tell them to stop that container before trying to start another
$hostcliplistenport = "8121"
$devconcliplistenport = "8122"
$containerNamesOnRequiredPorts = @(docker ps --filter "expose=$hostcliplistenport" --filter "expose=$devconcliplistenport" --format "{{.Names}}")
if ($containerNamesOnRequiredPorts.Count -gt 0) {
    Write-Host "There are already containers running on required ports."
    Write-Host ("[n] Don't use existing container, and exit")
    for ($i = 0; $i -lt $containerNamesOnRequiredPorts.Count; $i++) {
        Write-Host ("[$i] " + $containerNamesOnRequiredPorts[$i])
    }
    $selectedOption = Read-Host -Prompt "Select the container number to attach to or type 'n' to exit"
    $selectedContainer = $containerNamesOnRequiredPorts[$selectedOption]
    if ($selectedOption -eq 'n') {
        Write-Host "Exiting early. Please stop the existing container and try again."
        Exit 1
    } else {
        Write-Host "Attaching to the existing container $selectedContainer"
        docker exec -it $selectedContainer /bin/bash
        Exit 0
    }
}
Write-Host ""

# Step 2: List Docker Images with "development-env" tag
$imageNames = @(docker images --format "{{.Repository}}:{{.Tag}}" | Where-Object { $_ -like "*development-env*" })

# Present the image names with numeric options
Write-Host "Choose an image from the following list:"
for ($i = 0; $i -lt $imageNames.Count; $i++) {
    Write-Host ("[$i] " + $imageNames[$i])
}

# Prompt user for selection
$selectedOption = Read-Host -Prompt "Select the number corresponding to your chosen image"
$selectedImage = $imageNames[$selectedOption]
Write-Host ""

# Step 3: List Local Docker Volumes
$volumeNames = @(docker volume ls -f dangling=false --format "{{.Name}}")

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
Write-Host ""

# Step 4: Generate the container name and determine whether it already exists
$containerName = "devcon-$selectedVolume"
if (docker ps -a -q -f "name=$containerName") {
    $containerNameExists = $true
} else {
    $containerNameExists = $false
}

# Step 5: Allow additional port mappings & environment variables to be specified
$additionalPortMappings = Read-Host -Prompt "Define additional port mappings in the form `-p <host>:<container> -p <host>:<container>`. Leave blank to skip"
$portMapping = "-p ${hostcliplistenport}:${hostcliplistenport} -p ${devconcliplistenport}:${devconcliplistenport} $additionalPortMappings"
$envVars = Read-Host -Prompt "Define additional environment variables in the form `-e <key>=<value> -e <key>=<value>`. Leave blank to skip"

# Step 6: Create and run the container if the container name does not exist.
# Otherwise help the user take the next step.
if ($selectedVolume) {
    $runCommand = "docker run -dit --name $containerName $portMapping $envVars -v '${selectedVolume}:/app' $selectedImage"
} else {
    $runCommand = "docker run -dit --name $containerName $portMapping $envVars $selectedImage"
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
Write-Host ""

# Step 7: Enter the container
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
Write-Host ""
