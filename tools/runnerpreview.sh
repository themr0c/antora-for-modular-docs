#!/bin/sh
#
# Copyright (c) 2021 Red Hat, Inc.
# This program and the accompanying materials are made
# available under the terms of the Eclipse Public License 2.0
# which is available at https://www.eclipse.org/legal/epl-2.0/
#
# SPDX-License-Identifier: EPL-2.0
#

# Detect available runner
if command -v podman > /dev/null
  then RUNNER=podman
elif command -v docker > /dev/null
  then RUNNER=docker
else echo "No installation of podman or docker found in the PATH" ; exit 1
fi

# Fail on errors
set -e

# Set the IMAGE environment variable to override the default
if [ -z "$IMAGE" ]
then
  IMAGE="quay.io/antoraformodulardocs/antora-for-modular-docs"
  ${RUNNER} pull -q ${IMAGE}
fi

# Display command
set -x
${RUNNER} run --rm -ti \
  --name "${PWD##*/}" \
  -v "$PWD:/projects:z" -w /projects \
  -p 4000:4000 -p 35729:35729 \
  --entrypoint="./tools/preview.sh" \
  "${IMAGE}"
