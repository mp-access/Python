FROM python:3.7-alpine as base

FROM base as builder

RUN mkdir /install
WORKDIR /install

# Required for numpy
RUN apk update && apk --no-cache add g++

COPY requirements.txt /requirements.txt

RUN pip install --install-option="--prefix=/install" -r /requirements.txt

FROM base

ENV PYTHONUNBUFFERED 1

COPY --from=builder /install /usr/local

RUN addgroup python && adduser -S python -G python