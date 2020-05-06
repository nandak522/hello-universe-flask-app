### Helm Commands

#### To generate Helm templates
```sh
cd charts/hello-universe
helm template -v 5 \
    --logtostderr \
    --debug \
    -s templates/configmap.yaml \
    -f values-infra.yaml \
    -f values.yaml \
    -f values-secrets.yaml \
    hello-universe \
    .

helm template hello-universe \
    -f values-infra.yaml \
    -f values-secrets.yaml \
    -f values.yaml \
    -v 5 \
    --logtostderr \
    .
```

---
#### To make a Helm release
```sh
cd charts/hello-universe

# Prerequisite:
cat <<EOF | kubectl apply -f -
# Source: hello-universe/templates/namespace.yaml
kind: Namespace
apiVersion: v1
metadata:
  name: hello-universe
  annotations:
    meta.helm.sh/release-name: v1
    meta.helm.sh/release-namespace: hello-universe
  labels:
    app.kubernetes.io/managed-by: Helm

EOF

helm install -v 3 \
    --atomic \
    --namespace hello-universe \
    --debug \
    --dry-run \
    -f values-infra.yaml \
    -f values-secrets.yaml \
    -f values.yaml \
    v1 \
    .

# helm upgrade -v 3 \
#     --install \
#     --atomic \
#     --namespace hello-universe \
#     --debug \
#     --cleanup-on-fail \
#     -f values-infra.yaml \
#     -f values-secrets.yaml \
#     -f values.yaml \
#     v1 \
#     .
```
