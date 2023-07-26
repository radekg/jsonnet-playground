# Jsonnet Playground

This is largely inspired by the work done on golang playground 
and takes advantage of the go-jsonnet program to give you
similar features. In memory and persistance via mysql are
supported.

## Run with Docker

```sh
docker run --rm -p 8080:8080 docker.io/radekg/jsonnet-playground:latest -in-memory
```

## Release

```sh
make tools docker-release
```
