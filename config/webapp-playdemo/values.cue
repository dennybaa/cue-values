package values
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
    replicaCount: *1 | int & >0 | null
    podAntiAffinityPreset: *"soft" | "hard"

    image: {
        registry: "c8n.io"
        repository: "dennybaa/webapp-playdemo"
    }

    pdb?: {
        minAvailable?: int & >0 | string
        maxUnavailable?: int & >0 | string

        if minAvailable != _|_ && maxUnavailable != _|_ {
            _fail: "minAvailable and maxUnavaliable are mutually exclusive" & _|_
        }
    }

    containerPorts: http: 3000
    service: ports: http: {
        port: 3000
        targetPort: "http"
    }

    ingress: {
        enabled: true
        // DRY value example (the default app hostname)
        hostname: *"webapp.\(cf.domains.default)" | string
    }

    resources: limits: resources.requests
    resources: requests: {
        cpu:    *"100m" | string
        memory: *"64Mi" | string
    }

    readinessProbe: {
        enabled: true
        httpGet: {
            path: "/"
            port: "http"
        }
    }
}
