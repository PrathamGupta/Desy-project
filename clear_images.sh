function clearContainers() {
  docker rm -f $(docker ps -aq --filter label=service=hyperledger-fabric) 2>/dev/null || true
  docker rm -f $(docker ps -aq --filter name='dev-peer*') 2>/dev/null || true
}

# Delete any images that were generated as a part of this setup
# specifically the following images are often left behind:
# This function is called when you bring the network down
function removeUnwantedImages() {
  docker image rm -f $(docker images -aq --filter reference='dev-peer*') 2>/dev/null || true
}

clearContainers
removeUnwantedImages
