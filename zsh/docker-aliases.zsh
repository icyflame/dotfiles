check_docker () {
	if [ ! -x `which docker` ];
	then
		echo "ERROR: Docker is required for pandock"
		return 42
	fi

	docker version > /dev/null
	if [ $? -ne 0 ];
	then
		echo "ERROR: Docker executable exists. Docker daemon is not running."
		return 43
	fi
}

dock_excalidraw () {
	check_docker
	docker run --rm -dit --name excalidraw -p 5000:80 excalidraw/excalidraw:latest
}
