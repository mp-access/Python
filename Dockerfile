FROM python:3.7-alpine as base

FROM base as builder

RUN mkdir /install
WORKDIR /install

# Required for numpy. Dependencies installed here through apk are not available in the final docker image
RUN apk update && apk --no-cache add g++

COPY requirements.txt /requirements.txt

RUN pip install --install-option="--prefix=/install" -r /requirements.txt

FROM base

ENV PYTHONUNBUFFERED 1

# Dependencies installed here through apk are available in the final docker image
RUN apk update && apk --no-cache add git

COPY --from=builder /install /usr/local

RUN addgroup python && adduser -S python -G python

RUN git config --global user.name "Student Code Execution" && git config --global user.email "no-reply@access"