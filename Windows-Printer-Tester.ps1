echo "************************************************"
echo "***      Windows Printer Tester	           ***"
echo "***                                          ***"
echo "************************************************"

#Declaring ping object
$ping = new-object system.Net.NetworkInformation.Ping

#erase the output file
echo " "  > ExportedPrinters.txt
#set the name of coloumns
echo "PRINTER,STATUS,SERVER"  >> ExportedPrinters.txt

#array of printer server to scan
$printer_servers = @("FOOWIN01","FOOWIN02", "FOOWIN03")

$domain = "foosite.org"




Foreach ($server in $printer_servers)
{
 #NET VIEW  => return the share related for a server
   $cmd = "net view "  + $server
  
	Foreach ($item in Invoke-Expression $cmd )
	{

		if ($item.Contains("Print"))
			{	
			    	#split the string in order to take the first element and attach the domain
            	        	$k =  $item.Split(" ")[0] + "." + $domain
			
			try 
          		 { 
				   $returnping = $ping.Send($k)
    	 
    			    if ($returnping.Status –eq [System.Net.NetworkInformation.IPStatus]::Success) 
					   {
						 #only print if the ping is ok
						  echo  $k  " OK" 
						          		  }
       	    		else 
				 		{
				    		 $k = $k + "," + "Error" + "," + $server
						 echo $k >> "ExportedPrinters.txt"
						 echo  $k
				  								}   
										
											  }
       			 catch 
				 {
			          #the exception could be generated if the hostname is wrong
					  $k = $k + "," + "Exception(check the hostname)" + "," + $server 
				     	  echo $k >> "ExportedPrinters.txt" 
					  echo  $k
					   				} 
	 
					sleep(1)	
		}
	}
}

echo "END"
