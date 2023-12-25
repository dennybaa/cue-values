package testapp
import (
    "this.sh/config"
)

// common configuration, project/env specific values
let cf = config.global

// env must be passed (as -t env=dev -t dev)
env: config.#Env @tag(env,short)

// The initial version sketch is created if no version file exists, i.e.
// created only once. This is because {env}.version.yaml is meant for
// direct editing (manually or by a CI tool).
InitVersion: {
    image: tag: "latest"
}

Values: {
    image: {
        registry: "ghcr.io"
        repository: "dennybaa/test-app"
    }

    service: ports: {
        http: 3000
    }

    ingress: {
        enabled: true
        // DRY value example (the default app hostname)
        hostname: *"test-app.\(cf.domains.default)" | string
    }

    resources: limits: resources.requests
    resources: requests: {
        cpu:    *"100m" | string
        memory: *"64Mi" | string
    }
}
