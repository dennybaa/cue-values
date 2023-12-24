package testapp
import (
    "this.sh/config"
)

// env must be passed (as -t env=dev -t dev)
env: config.#Env @tag(env,short)
tag: string @tag(tag)

// common configuration, project/env specific values
let cf = config.global

Values: {
    image: {
        registry: "ghcr.io"
        repository: "dennybaa/test-app"
        "tag": tag
    }

    service: ports: {
        http: 3000
    }

    ingress: {
        enabled: true
        // DRY value example
        hostname: "test-app.\(cf.domains.default)"
    }
}
