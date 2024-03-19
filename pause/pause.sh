#!/bin/bash

MANIFEST='
apiVersion: v1
kind: Service
metadata:
  name: pause-${ID}
spec:
  ports:
    - name: p0
      port: 80
  selector:
    app: pause-${ID}

---
apiVersion: v1
kind: Pod
metadata:
  labels:
    app: pause-${ID}
  name: pause-${ID}
spec:
  nodeSelector:
    role: master
  containers:
  - name: pause
    image: registry.k8s.io/pause:3.9
'

function apply() {
    START=$1
    END=$2
    for ID in $(seq ${START} ${END}); do
        export ID=${ID}
        echo "${MANIFEST}" | envsubst | kubectl apply -f -
    done;
}

function delete() {
    START=$1
    END=$2
    for ID in $(seq ${START} ${END}); do
        export ID=${ID}
        echo "${MANIFEST}" | envsubst | kubectl delete --force --grace-period 0 -f -
    done;
}

CMD="$1"
START="$2"
END="$3"
if [[ "${CMD}" == "" ]]; then
    CMD="apply"
fi
if [[ "${END}" == "" ]]; then
    END=${START}
fi
if [[ "${START}" == "" ]]; then
    echo "missing START/END argument"
    exit 1
fi

case "${CMD}" in
    "apply")
        apply ${START} ${END}
        ;;
    "delete")
        delete ${START} ${END}
        ;;
    *)
        echo "command not found"
        exit 1
        ;;
esac
