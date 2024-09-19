docker run   -e "DISPLAY=$DISPLAY"   -v "$HOME/.Xauthority:/root/.Xauthority:ro"   --network host -it bbbb:latest
