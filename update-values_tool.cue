package main

import (
    "this.sh/config"
    "path"
    "encoding/yaml"
    "tool/exec"
    "tool/file"
    "tool/cli"
)

command: "update-values": {

    // required inputs
    env: config.#Env @tag(env,short)
    tag: string      @tag(tag)
    app: string      @tag(app)

    cueEval: exec.Run & {
        dir: "config/\(app)"
        cmd: [
            "cue", "export", "--out=yaml", "-t", "\(env)",
            "-t", "env=\(env)",
            "-t", "tag=\(tag)",
        ]
        stdout: string
    }

    values: yaml.Unmarshal(cueEval.stdout).Values
    appDir: path.Resolve("values", app, path.Unix)

    // Create clusters/{dest} directory
    mkDir: file.Mkdir & {
        $dep: cueEval.$done
        path: appDir
        createParents: true
    }

    writeValues: {
        stage: {
            valuesFile: path.Join([appDir, "\(env).yaml"], path.Unix)

            info: cli.Print & {
                text: "Updating \(app) (at \(valuesFile)) (env=\(env) tag=\(tag))..."
            }

            write: file.Create & {
                $dep: mkDir.$done
                filename: valuesFile
                contents: yaml.Marshal(values)
            }  
        }
    }
}
