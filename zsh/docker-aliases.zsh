check_docker () {
	if [ ! -x `which docker` ];
	then
		echo "ERROR: Docker is required."
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

dock_readeck () {
	check_docker
	docker run --rm -dit --name readeck -p 8000:8000 -v readeck-data:/readeck codeberg.org/readeck/readeck:latest
}

dock_hledger () {
	check_docker
    docker run -i --rm -v "$(pwd):/data:ro" -w /data dastapov/hledger:1.42.1 hledger $@
}

dock_ledger () {
	check_docker
    docker run -i --rm -v "$(pwd):/data:ro" -w /data dcycle/ledger:1 $@
}

podman_hledger () {
    podman run -i --rm -v "$(pwd):/data:ro" -w /data docker.io/dastapov/hledger:1.42.1 hledger $@
}

podman_ledger () {
    podman run -i --rm -v "$(pwd):/data:ro" -w /data docker.io/dcycle/ledger:1 $@
}
