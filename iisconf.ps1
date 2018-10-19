configuration IISWebsite {

    # The Node statement specifies which targets this configuration will be applied to.
    node ("localhost") {

        # The first resource block ensures that the Web-Server (IIS) feature is enabled.
        WindowsFeature WebServer {
            Ensure = "Present"
            Name   = "Web-Server"
            IncludeAllSubFeature = $true            
        }

        # The second resource block ensures that the website content copied to the website root folder.
        File WebsiteContent {
            Ensure = 'Present'            
            Contents = "Hello World"
            DestinationPath = 'c:\inetpub\wwwroot\default.html'
            DependsOn = "[WindowsFeature]WebServer"
        }
    }
}