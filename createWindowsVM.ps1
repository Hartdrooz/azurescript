$resourceGroup= "hgsoftwares"
$location="canadaeast"
$useCLI=$true

if($useCLI)
{
    az group create -n $resourceGroup -l $location
}
else
{

}



