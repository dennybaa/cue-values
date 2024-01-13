@if(prod)
package values

// Prod specific
Values: {
    resources: requests: memory: "128Mi"

    // By way of illustration only, since we can't change it
    // for a single-node k3d cluster
    podAntiAffinityPreset: "soft"

    pdb: {
        create: true
        maxUnavailable: "20%"
        // minAvailable: 2
    }

    autoscaling: {
        enabled: true
        minReplicas: 2
        maxReplicas: 6
        targetCPU: 80
        targetMemory: 70
    }

    autoscaling: behavior: scaleDown: {
        selectPolicy: "Min"
        policies: [
            {
                type: "Percent"
                value: 20
                periodSeconds: 60
            },
            {
                type: "Pods"
                value: 2
                periodSeconds: 60
            }
        ]
    }
}
