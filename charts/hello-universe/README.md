### Helm Commands

#### To generate Helm templates
```sh
cd charts/hello-universe
helm template -v 5 \
    --logtostderr \
    --debug \
    -s templates/configmap.yaml \
    -f values.yaml \
    -f values-secrets.yaml \
    hello-universe \
    .

helm template hello-universe \
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
helm install -v 3 \
    --atomic \
    --debug \
    --dry-run \
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
#     -f values-secrets.yaml \
#     -f values.yaml \
#     v1 \
#     .
```
