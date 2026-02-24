mkdir -p sigstore
docker inspect --format='{{index .RepoDigests 0}}' urf-core:v1.0.1-core-frozen \
  | tee sigstore/image.digest
test -s sigstore/image.digest
