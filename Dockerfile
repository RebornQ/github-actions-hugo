FROM alpine:latest

LABEL "name"="hugo-github-action"
LABEL "maintainer"="Reborn <ren_xiaoyao@outlook.com>"
LABEL "version"="0.1.0"

LABEL "com.github.actions.name"="Hugo GitHub Action"
LABEL "com.github.actions.description"="A GitHub action used to automatic generate and deploy hugo-based blog."
LABEL "com.github.actions.icon"="upload-cloud"
LABEL "com.github.actions.color"="green"

COPY README.md entrypoint.sh /

RUN apk update && apk add \
	git\
	openssh\
	curl\
	hugo\
	&& rm -rf /var/cache/apk/*

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]