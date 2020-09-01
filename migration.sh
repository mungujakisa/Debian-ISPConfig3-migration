#!/bin/bash
#
  echo "############################################################"
  echo "##                   Herzlich Willkommen                  ##"
  echo "##   Please follow all instructions and recommendations   ##"
  echo "##                                                        ##"
  echo "##   If you have any questions or problems you can always ##"
  echo "##   contact us on http://wiki.teris-cooper.de            ##"
  echo "##                                                        ##"
  echo "##  You are also welcome to send an email to:             ##"
  echo "##  admin [at] teris-cooper [dot] de   (original coder)   ##"
  echo "##   or ceo at berocomputers dot com			  ##"
  echo "############################################################"
  echo ""
  echo "Please enter the server address of your master server first:"
  read main_server

  
#common_args='-aPv --delete'
#common_args='-aPv --dry-run'
common_args='-aPv'
install_rsync="apt-get -y install rsync"
www_start="service apache2 start"
www_stop="service apache2 stop"
db_start="service mysql start"
db_stop="service mysql stop"

function menu {
	clear
	echo "############################################################"
	echo "##                    Main Menu                           ##"
	echo "##                                                        ##"
	echo "##Start the installation of RSync on the remote server (1)##"
	echo "##MySql Syncronisation start                           (2)##"
	echo "##Web Directory Syncronisation start                   (3)##"
	echo "##E-Mail Syncronisation start                          (4)##"
	echo "##Passwords and User Account Syncronisation start      (5)##"
	echo "##MailMan Syncronisation start                         (6)##"
	echo "##Exit Program                                         (0)##"
	echo "############################################################"
	read -n 1 eingabe
}

function install {
	clear
	echo "Installation of Rsync on the Remote Server..."
	ssh $main_server "$install_rsync"
	echo "Ending"
	menu
}

function db_migration {
	clear
  echo "############################################################"
  echo "############################################################"
  echo "##############Start MySql Migration            #############"
  echo "##############Step1:                           #############"
  echo "##############Create backup on remote server   #############"
  echo "############################################################"
  echo "##############Step2:                           #############"
  echo "##############MySql database copy              #############"
  echo "############################################################"
  echo "#############Step3:                            #############"
  echo "#############MySql Import Database	       #############"
  echo "############################################################"
  echo "############################################################"
  echo " "
  echo "Create database backup................................................................"
  echo "Bplease enter the MySql password for the user ROOT on the server $ main_server:"
  read mysqlext
  ssh $main_server "mysqldump -u root -p$mysqlext --all-databases > fulldump.sql"
  clear
  echo "Copy the backup....................................................................."
  rsync $common_args $main_server:/root/mysql/ /root/mysql/
  clear
  echo "Backup import........................................................................"
  echo "Please enter the MySql password for the user ROOT:............................."
  read mysql2
  mysql -u root -p$mysql2 < /root/mysql/fulldump.sql
  clear
  echo "Run MySql check.................................................................."
  mysqlcheck -p -A --auto-repair
  echo "############################################################"
  echo "############################################################"
  menu
}

function www_migration {
	clear

  echo "############################################################"
  echo "############################################################"
  echo "##################Start Web Migration     ######################"
  echo "##################Step1:                  ##################"
  echo "##################Stop the Web Server     ##################"
  echo "############################################################"
  echo "##################Step2:                  ##################"
  echo "##################Start Migration         ##################"
  echo "############################################################"
  $www_stop
  rsync $common_args --compress --delete $main_server:/var/www/ /var/www
  rsync $common_args --compress --delete $main_server:/var/log/ispconfig/httpd/ /var/log/ispconfig/httpd
  $www_start
  echo "############################################################"
  echo "############################################################"
  menu
}
 
function mail_migration {
	clear
  echo "---- Starting Mail migration..."
  echo "############################################################"
  echo "############################################################"
  echo "##################Start Mail Migartion    ##################"
  echo "##################Step1:                  ##################"
  echo "##################Migration vmail         ##################"
  echo "############################################################"
  echo "##################Step2:                  ##################"
  echo "##################Migration vmail Logs    ##################"
  echo "############################################################"
  rsync $common_args --compress --delete $main_server:/var/vmail/ /var/vmail
  rsync $common_args --compress --delete $main_server:/var/log/mail.* /var/log/
  echo "############################################################"
  echo "############################################################"
  menu
}

function files_migration {
	clear
  echo "############################################################"
  echo "############################################################"
  echo "#############Start user and group migration          #######"
  echo "#############Step1:                                  #######"
  echo "#############Copy Backup                             #######"
  echo "############################################################"
  echo "#############Step2:                                  #######"
  echo "#############Copy Passwd in /root/old-server         #######"
  echo "############################################################"
  echo "#############Step3:                                  #######"
  echo "#############Copy group in /root/old-server          #######"
  echo "############################################################"
  echo "#############Bitte Manuel migriren                   #######"
  echo "#############mehr auf http://wiki.teris-cooper.de    #######"
  echo "############################################################"
  rsync $common_args $main_server:/var/backup/ /var/backup
  rsync $common_args $main_server:/etc/passwd /root/old-server/
  rsync $common_args $main_server:/etc/group  /root/old-server/
  echo "############################################################"
  echo "############################################################"
  menu
}

function mailman_migration {
	clear
  echo "############################################################"
  echo "############################################################"
  echo "############Starte Mailman migration           #############"
  echo "############################################################"
  rsync $common_args --compress --delete $main_server:/var/lib/mailman/lists /var/lib/mailman
  rsync $common_args --compress --delete $main_server:/var/lib/mailman/data /var/lib/mailman
  rsync $common_args --compress --delete $main_server:/var/lib/mailman/archives /var/lib/mailman
  cd /var/lib/mailman/bin && ./genaliases
  echo "############################################################"
  echo "############################################################"
  menu
}
function beenden {
		clear
		exit
}
menu
while [ $eingabe != "0" ]
do
case $eingabe in
        0) beenden
		    ;;
        1) install
            ;;
        2) db_migration
            ;;
        3) www_migration
            ;;
		4) mail_migration
			;;
		5) files_migration
			;;
		6) mailman_migration
			;;
esac	
done
