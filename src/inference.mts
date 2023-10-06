import fs from "fs"
import path from "path"
import { promises as fsPromises } from "fs"
import { file } from "tmp-promise"

import { hashURL } from "./utils/hashURL.mts"
import { downloadFile } from "./utils/downloadFile.mts"
import { executeCommand } from "./utils/executeCommand.mts"

const dataPath = "/data/"

const lorasStorageDir = path.join(dataPath, "loras")
const modelsStorageDir = path.join(dataPath, "models")

const baseSDXLDir = path.join(modelsStorageDir, "stable-diffusion-xl-base-1.0")
const spatialUnetBaseGlobalVar = path.join(baseSDXLDir, "unet")

export async function inference(params: { prompt: string, lora: string }) {
  const loraPath = path.join(lorasStorageDir, hashURL(params.lora) + ".safetensors")

  if (!fs.existsSync(loraPath)) {
    await fsPromises.mkdir(path.dirname(loraPath), {recursive: true})
    await downloadFile(params.lora, loraPath)
  }

  const output = await file({ postfix: ".gif" });

  const cmd = `
    cd Hotshot-XL &&
    python inference.py \
    --prompt="${params.prompt}" \
    --output="${output.path}" \
    --spatial_unet_base="${spatialUnetBaseGlobalVar}" \
    --lora="${loraPath}"
  `;

  await executeCommand(cmd.trim())

  const gifBuffer = await fsPromises.readFile(output.path)
  // base64 encoded output
  const outputAsBase64URL = `data:image/gif;base64,${gifBuffer.toString('base64')}`

  return outputAsBase64URL
}
