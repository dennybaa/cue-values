package config

env: #Env
global: #Config

// Supported envs
#Env: "dev" | "prod"
#Config: {
    domains:
        default: *"\(env).k8s.local" | string
}
