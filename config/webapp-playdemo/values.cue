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
    app: name: "webapp-playdemo"

    image: {
        registry: "c8n.io"
        repository: "dennybaa/webapp-playdemo"
    }

    service: ports: {
        http: 3000
    }

    ingress: {
        enabled: true
        // DRY value example (the default app hostname)
        hostname: *"webapp-playdemo.\(cf.domains.default)" | string
    }

    resources: limits: resources.requests
    resources: requests: {
        cpu:    *"100m" | string
        memory: *"64Mi" | string
    }
}
