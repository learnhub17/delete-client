date
$data=[environment]::GetEnvironmentVariable('clientpath', 'user')
$newversion=[environment]::GetEnvironmentVariable('clientversion', 'user')

echo "==========================="
docker ps | findstr mongo
$mongoservice=$LASTEXITCODE
docker ps | findstr daemon-client
$clientservice=$LASTEXITCODE

netstat -aon | findstr "27017"
$mongo=$LASTEXITCODE
netstat -aon | findstr "7000"
$client=$LASTEXITCODE

if ($mongoservice -ne 0) 
{ echo "Mongo container is not found, going to run mongo container !!!!"
docker run -idt --name mongo --volume mongo:/data/db --volume mongo:/data/configdb --restart=unless-stopped -p 27017:27017 mongo:4.0.4
}
else { echo "Mongo conatiner exist, going to check mongo service" }

if ($mongo -ne 0) 
{ echo "Mongo is not running, going to start Mongo !!!!"
docker start mongo
docker ps  
}
else { echo "Mongo is running" }
start-sleep -s 5

if ($clientservice -ne 0) 
{ echo "daemon-client container is not running, going to start daemon-client conatiner !!!!"
docker run -idt --name daemon-client -v ${data}:/data --link mongo:mongo --restart=unless-stopped -p 7000:7000 original4sure/daemon-client:$newversion 
}
else { echo "daemon-client conatiner exist, going to check daemon-client is service" }

if ($client -ne 0) 
{ echo "daemon-client is not running, going to start daemon-client !!!!"
docker start daemon-client
docker ps 
}
else { echo "daemon-client is running" }
