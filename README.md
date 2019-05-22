# rust-dockerify

Script allows in a single line pack your rust application into a docker container.

## Description

This script uses the [rust_musl_docker](https://github.com/golddranks/rust_musl_docker)
image to build rust application with statically linked libraries and generates dockerfile
with a following content:

```
FROM scratch
COPY ./artifacts/\* /usr/bin/
CMD ["/usr/bin/binary_name"]
```

## Usage

```
dockerify.sh -s source_directory -e binary name [-b] [-t container_tag]
```

Where

```
-s Path to source directory
-e Binary name to be used as CMD argument in Dockerfile
-b Run docker build immediately
-t Container tag (required for build)
```

## Known issues

  1. Tested only on really simple application
  2. Copies all temporary files to container and to current directory
  3. Basic error handling

## License

[MIT License](https://opensource.org/licenses/MIT)

## Changelog

#### 0.1.0

Basic functionality is implemented

## Credits

  * Alexander Serebryakov, author ([GitHub](https://github.com/aserebryakov))
