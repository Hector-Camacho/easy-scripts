import nmap 

nm = nmap.PortScanner()
scan = nm.scan('utt.edu.mx')

for host in nm.all_hosts():
	print('----------------------------------------------------')
	print('Host : %s (%s)' % (host, nm[host].hostname()))
 	print('Estado : %s' % nm[host].state())
 	for proto in nm[host].all_protocols():
 		print('----------')
    	print('Protocolo : %s' % proto)
    	lport = nm[host][proto].keys()
    	lport.sort()
    	for port in lport:
        	print ('Puerto : %s\tEstado : %s\tUtilizado para: %state - %s' % (port, nm[host][proto][port]['state'], nm[host][proto][port]['product'], nm[host][proto][port]['version']))
       	     