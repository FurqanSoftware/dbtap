FROM alpine:3.6

RUN apk --no-cache add ca-certificates mongodb-tools openssh-client python py-pip

RUN pip install awscli
