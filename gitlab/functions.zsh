vpn() {
	nordlayer login --email skannan@gitlab.com --organization gitlab && nordlayer connect gitlab-japan-CQJSrwg0
}

openduo() {
	~/code/open-source/openduo/bin/openduo $@
}

openduo-gitlab-read() {
	GITLAB_TOKEN=$(pass show auto-deploy-view/com/ro) ~/code/open-source/openduo/bin/openduo $@
}
