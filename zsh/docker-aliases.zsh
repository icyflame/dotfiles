# pandock: convert between several file-formats using the dockerized version of
# Pandoc.
# Available images: https://github.com/pandoc/dockerfiles#available-images

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

pandock () {
	check_docker
	docker run --rm --volume "$(pwd):/data" --user $(id -u):$(id -g) pandoc/latex:2.19.2-alpine $@
}

dock_pandoc () {
	pandock $@
}

dock_excalidraw () {
	check_docker
	docker run --rm -dit --name excalidraw -p 5000:80 excalidraw/excalidraw:latest
}

dock_pdflatex () {
	check_docker
	docker run --rm --volume "$(pwd):/data" --user $(id -u):$(id -g) --entrypoint pdflatex pandoc/latex:2.19.2-alpine $@
}
