# dock_pandoc: convert between several file-formats using the dockerized version of
# Pandoc.
# Available images: https://github.com/pandoc/dockerfiles#available-images

dock_pandoc_help () {
	cat <<EOF
dock_pandoc

    Use pandoc conveniently, using containers

    Wrapper around a docker container running the pandoc/extra container image.

    Volumes are not used; this is intentional. The docker container can not write arbitrary files to
    the host filesystem. Only the specified output file will be copied back to the host
    filesystem. If the output file was not created due to an error inside pandoc, nothing will be
    copied.

    This wrapper will keep the pandoc container running after it is initially started. This is
    intentional; some of the conversion tools used by Pandoc store local state (such as the pdf
    engine tectonic). This state includes dependencies which are downloaded when a conversion
    command is run the first time around. Later runs rely on the dependencies which were downloaded
    earlier if they are present. Deleting the container and recreating it from scratch will cause
    every conversion run to take a long amount of time. If you want to start fresh, then you can
    remove the container using standard docker utilities (such as "docker container rm -f").

Usage

    dock_pandoc command [command-specific options]

Arguments

    command: 2 possible options: exec, convert

Examples

    exec: Execute something directly by passing options to pandoc

        dock_pandoc exec --help
        dock_pandoc exec --list-output-formats
        dock_pandoc exec --list-input-formats

    convert: Convert a file

        dock_pandoc convert input-file-path output-file-path [pandoc-options]
        dock_pandoc convert input-file-path output-file-path --from org --to pdf --pdf-engine tectonic
EOF
}

dock_pandoc_run_container () {
	check_docker

	if [[ $(docker container inpsect pandoc-container) -gt 0 ]];
	then
		docker rm -f pandoc-container
		docker run --name pandoc-container --detach --workdir /src --entrypoint tail pandoc/extra:3.2.0.0 -f
	fi
}

dock_pandoc () {
	if [[ "$#" == "0" ]];
	then
		dock_pandoc_help
		return
	fi

	dock_pandoc_run_container

	command="$1"
	shift

	case "$command" in
		"convert")
			local input_file="$1"
			shift
			local output_file="$1"
			shift

			if [[ -f "$input_file" ]];
			then
				docker cp $input_file pandoc-container:/src/$(basename $input_file)
				docker exec --workdir /src pandoc-container pandoc $@ --output $(basename $output_file) $(basename $input_file)
				docker cp pandoc-container:/src/$(basename $output_file) $output_file
			else
				echo "ERROR: The specified input file ($input_file) is not a file."
				return 41
			fi
			;;
		"exec")
			docker exec --workdir /src pandoc-container pandoc $@
			;;
		*)
			echo "ERROR: Unrecognized command ($command)"
			return 42
	esac
}
