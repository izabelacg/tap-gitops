#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

relocate_to="northamerica-northeast2-docker.pkg.dev/app-last-mile/icg-artifacts/tap"

for filename in $(find $DIR -name '*.yaml' -or -name '*.yml'); do
  # select(documentIndex == 0) it is being used to select the first yaml document in a file, since some
  # have also a second k8s resource like a Secret or Service
  has_template=$(yq 'select(documentIndex == 0) | .spec | has("template")' $filename)
  has_spec=$(yq 'select(documentIndex == 0) | .spec.template | has("spec")' $filename)
  if [[ "$has_template" == "true" ]] && [[ "$has_spec" == "true" ]]; then
    has_fetch=$(yq 'select(documentIndex == 0) | .spec.template.spec | has("fetch")' $filename)
    has_containers=$(yq 'select(documentIndex == 0) | .spec.template.spec | has("containers")' $filename)
    if [ "$has_fetch" == "true" ]; then
      query=".spec.template.spec.fetch[0].imgpkgBundle.image"
    elif [ "$has_containers" == "true" ]; then
      query=".spec.template.spec.containers[0].image"
    else
#      echo "skip (inner if) $filename"
      continue
    fi
  else
#    echo "skip (outer if) $filename"
    continue
  fi
#  echo "$filename"
  image=$(yq -e "${query}" $filename)
  yq_exit_status=$?
  if [ "$yq_exit_status" -ne 0 ]; then
    echo "error"
    continue
  fi
  #  if [[ "$image" == us.gcr.io* ]] || [[ "$image" == us.gcr.io* ]]; then
  #  fi
  destination=$(echo $image | sed "s|us.gcr.io/daisy-284300/icg-vmware\/|${relocate_to}\/|")
  crane copy $image $destination
#  imgpkg copy -b $image --to-repo $destination
  yq eval -i "select(documentIndex == 0) | (${query}) |= \"${destination}\"" "${filename}"
done