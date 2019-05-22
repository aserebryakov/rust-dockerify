# rust-dockerify

Script allows in a single line pack your rust application into a docker container.

### Usage

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

### Known issues

  1. Tested only on really simple application
  2. Copies all temporary files to container
  3. Basic error handling

