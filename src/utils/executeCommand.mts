import { exec } from "child_process"
import path from "path"

export async function executeCommand(cmd: string): Promise<string> {
  return new Promise((resolve, reject) => {
    console.log("current working dir:", process.cwd())
    const hotshotDir = path.join(process.cwd(), "Hotshot-XL")
    console.log("hotshot working dir: " + hotshotDir)
    console.log("executing command: " + cmd)
    exec(cmd, {
      cwd: hotshotDir,
      maxBuffer: 1024 * 500
    }, (error, stdout, stderr) => {
      if (error) {
        reject(error.message)
      } else if (stderr) {
        reject(stderr)
      } else {
        resolve(stdout)
      }
    })
  })
}