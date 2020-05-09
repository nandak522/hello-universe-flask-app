### Hello Universe
* A simple app based on [Flask](https://flask.palletsprojects.com/en/1.1.x/) running on Ubuntu 20.04.
* Docker Image size is just 67 Megs (compressed).
* Full Source code, along with Helm chart.
* (Helm) Chart containing
    * Infrastructure Configurations (like Db, Cache etc..), separated from App Configurations. Refer `values-infra.yaml`.
    * Pod Annotations that change when configmaps/secrets change. No need to roll the pods manually 😎. Refer the generated deployment spec.
    * Environment Level overrides (like `replicas=10` for prod, but `replicas=2` for dev/qa environments). Refer `env-overrides/values-prod.yaml` for example.
* Validating helm templates on every push, using Github Actions.
* Refer `commands.md` for all Helm commands.
