read -p 'Enter Turtlebot IP: ' turtlebotip

tee -a ~/.ssh/config << END
Host turtlebot $turtlebotip
	HostName $turtlebotip
	IdentityFile ~/.ssh/turtlebot_rsa
	User pi
END


gnome-terminal -- /bin/sh -c 'echo "------ ADD RSA / SET TURTLEBOT IP ------\n";cp turtlebot_rsa ~/.ssh; ssh-add ~/.ssh/turtlebot_rsa; exec bash'
