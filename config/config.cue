package config

env: #Env
global: #Config

// Supported envs
#Env: "dev" | "prod"
#Config: {
    domains:
        default: *"\(env).kube.local" | string

}
