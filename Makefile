# Makefile to manage vnet
# P Walsh Jan 2016

# Targets
#   interactive
#   clean --- clean all modules
#   tidy --- indent code in all modules 
#   runtest --- run bats in all modules
#   cover --- run cover in all modules

# directory where scripts are located and temp files
SD=../../../Cew

MODULES=Demo/Verification/Lifo \
        Demo/Verification/SSet \
        Event/Verification/BOOT \
        Event/Verification/IDLE  \
        Event/Verification/NIC \
        Event/Verification/STDIN \
        Handler/Verification/ETHERNET \
        Handler/Verification/ICMP \
        Handler/Verification/ARPD \
        Handler/Verification/ARP \
        Handler/Verification/IP \
        Handler/Verification/P2P \
        Handler/Verification/PING \
        Handler/Verification/PINGD \
        Handler/Verification/STDIN \
        Handler/Verification/STDOUT \
        Record/Verification/Arp \
        Record/Verification/Nic \
        Record/Verification/Route \
        Table/Verification/ARP \
        Table/Verification/NIC \
        Table/Verification/QUEUE \
        Table/Verification/ROUTE \
        Collection/Verification/Line \
        Collection/Verification/Queue \
        Packet/Verification/Arp \
        Packet/Verification/Ethernet \
        Packet/Verification/Generic \
        Packet/Verification/Icmp \
        Packet/Verification/Ip \
        Packet/Verification/Udp \
        System/Verification/GRUB \
        System/Verification/HOST \
        Exc/Verification/Exception \
        Exc/Verification/TryCatch

interactive: vnet.pl
	perl vnet.pl

clean:
	@for m in $(MODULES); do \
		((cd $$m; $(MAKE) clean;) > /dev/null) \
	done

tidy:
	@for m in $(MODULES); do \
		((cd $$m; $(MAKE) tidy;) > /dev/null 2>&1) \
	done


runtest:
	@for m in $(MODULES); do \
		(cd $$m; $(MAKE) bats;) \
	done

cover:
	@for m in $(MODULES); do \
		(cd $$m; $(MAKE) cover;) \
	done

