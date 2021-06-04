variable "VERSION" {
  default = "0.1.1"
}

function "semver" {
  # IDX: MAJOR=0, MINOR=1, PATCH=2, SUFFIX=3
  params = [vers, idx]
  result = regex("^(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)(?:-((?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\\.(?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\\+([0-9a-zA-Z-]+(?:\\.[0-9a-zA-Z-]+)*))?$", "${vers}")[idx]
}

group "default" {
  targets = ["build"] 
}

target "build" {
  dockerfile = "Dockerfile"
  platforms = [
    "linux/amd64",
    "linux/arm64"
  ]
  tags = [
      "wamuir/simple-fop-server:latest",
      "wamuir/simple-fop-server:${VERSION}",
      "wamuir/simple-fop-server:${semver(VERSION, 0)}",
      "wamuir/simple-fop-server:${semver(VERSION, 0)}.${semver(VERSION, 1)}"
    ]
}
