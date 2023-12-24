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

```
cue cmd -t env=dev -t tag=v0.1.0 -t app=test-app update-values
```

it will write `values/test-app/dev.yaml` file.
