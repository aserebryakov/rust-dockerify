# rust-dockerify

Target of this script is in a single line pack your rust application into a docker container.

### Usage

```
dockerify.sh <source_directory> <container_tag> <binary_name>
```

### Known issues

  1. Tested only on really simple application
  2. Copies all temporary files to container
  3. Absent error handling
  4. Positional arguments
