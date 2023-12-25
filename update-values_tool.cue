package main

import (
    "this.sh/config"
    "path"
    // "strings"
    // "encoding/yaml"
    "tool/exec"
    "tool/file"
    "tool/cli"
)

command: "update-values": {
    // required inputs
    env: config.#Env @tag(env,short)
    app: string      @tag(app)

    valuesDir: path.Resolve("values", app, path.Unix)
    versionFile: path.Join([valuesDir, "\(env).version.yaml"], path.Unix)

    cueExport: [
        "cue", "export", "--out=yaml", "-t", "\(env)",
        "-t", "env=\(env)"
    ]

    // Create values/{app} directory
    mkDir: file.Mkdir & {
        path: valuesDir
        createParents: true
    }

    // Generate values via CUE
    genValues: exec.Run & {
        $dep: mkDir.$done
        cmd: cueExport + ["-e", "Values"]
        dir: "config/\(app)"
        stdout: string
    }

    // Check if version file exists
    noVersionFile: exec.Run & {
        $dep: mkDir.$done
        cmd: ["sh", "-c", "[ ! -f '\(versionFile)' ] >/dev/null 2>&1"]
        mustSucceed: false
    }

    if noVersionFile.success != _|_ {
        if noVersionFile.success {
            infoVersion: cli.Print & {
                $dep: writeVersion.$done
                text: "✔ [\(app)] Created version file \(versionFile)"
            }

            initVersion: exec.Run & {
                cmd: cueExport + ["-e", "InitVersion"]
                dir: "config/\(app)"
                stdout: string
            }

            writeVersion: file.Create & {
                filename: versionFile
                contents: initVersion.stdout
            }
        }
    }

    writeValues: {
        valuesFile: path.Join([valuesDir, "\(env).yaml"], path.Unix)

        infoValues: cli.Print & {
            $dep: writeValues.$done
            text: "✔ [\(app)] Updated \(valuesFile)"
        }

        writeValues: file.Create & {
            $dep: genValues.$done
            filename: valuesFile
            contents: genValues.stdout
        }
    }
}
