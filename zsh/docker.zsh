docker_stop_all () {
	docker ps --all --format '{{ .Names }}' | xargs docker container stop
}

docker_rm_all () {
	docker ps --all --format '{{ .Names }}' | xargs docker container rm
}

docker_stop_and_rm_all () {
	docker_stop_all && docker_rm_all
}
