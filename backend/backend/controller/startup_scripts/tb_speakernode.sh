gnome-terminal --tab -- /bin/sh -c 'echo "------ TURTLEBOT SPEAKERNODE ------\n";ssh -t turtlebot "~/BringupScripts/tb_speakernode.sh"; exec bash'