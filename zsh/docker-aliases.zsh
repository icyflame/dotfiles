# pandock: convert between several file-formats using the dockerized version of
# Pandoc.
# Available images: https://github.com/pandoc/dockerfiles#available-images

pandock () {
	if [ ! -x `which docker` ];
	then
		echo "ERROR: Docker is required for pandock"
	fi
	docker run --rm --volume "$(pwd):/data" --user $(id -u):$(id -g) pandoc/latex:2.19.2-alpine $@
}

dock_pandoc () {
	pandock $@
}

dock_excalidraw () {
	docker run --rm -dit --name excalidraw -p 5000:80 excalidraw/excalidraw:latest
}
