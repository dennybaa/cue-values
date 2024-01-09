# CUE Configuration for Helm Applications Values

This repository serves as a concise representation ([DRY](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself)) of Helm values for a multi-environment project, leveraging CUE for value definition and subsequent Helm values generation.

In the configuration structure of the `cue-values` repository, common or project wide settings reside in [config.global](config/config.cue), while application-specific values are organized within individual app directories.

## TL;DR

Repository Structure:

- **config/{appDir}**: CUE configuration for a specific application.
- **config/{env}.cue**: CUE configuration for environment-specific settings.
- **values/{appDir}/{env}.yaml**: Resulting values for a HELM application.

To generate values, execute the following command:

```shell
cue cmd -t env=dev -t app=test-app update-values
```

This command yields output similar to the following:

```
✔ [test-app] Updated values/test-app/dev.yaml
✔ [test-app] Created version file values/test-app/dev.version.yaml
```

**Note:** The values configuration is bifurcated into two files. The latter file, [dev.version.yaml](values/test-app/dev.version.yaml), is created only once to establish the version structure for an application. This separation facilitates direct editing, either manually or potentially through a CI system, providing flexibility in managing versioning for complex applications.