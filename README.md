# A simple CUE configuration Helm applications values

Technically this is a repository containing the Helm values for a multi environment project. Here we use CUE to define the values whereas the resulting Helm values are generated.

Configuration in cue-values repository is split into common settings (config.global) and application specific values (app directories).
The idea of this repo is solely to represent CUE in action which allows to have our values DRY.

## TL;DR

Structure:

- *config/{appDir}* - CUE configuration for an application.
- *config/config.cue* and *config/{env}.cue* - CUE configuration for project env-level specific settings.
- *values/{appDir}/{env}.yaml* - resulting values for a HELM application.

The command to generate values:

```shell
cue cmd -t env=dev -t app=test-app update-values
```

You will get the similar output as bellow:

```
✔ [test-app] Updated values/test-app/dev.yaml
✔ [test-app] Created version file values/test-app/dev.version.yaml
```

**Note that** the values configuration is split into two files. The later file ([dev.version.yaml](values/test-app/dev.version.yaml)) is created only once, to provide the versions structure for an application (technically there can be several version tags for a complex app). The version file is intentionally separated to allow means for the direct editing (either manual or possibly editing by a CI system).
