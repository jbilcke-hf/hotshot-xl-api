import fs from "fs"
import path from "path"
import { promises as fsPromises } from "fs"
import { file } from "tmp-promise"

import { hashURL } from "./utils/hashURL.mts"
import { downloadFile } from "./utils/downloadFile.mts"
import { executeCommand } from "./utils/executeCommand.mts"
import { lorasDirFilePath, spatialUnetBaseGlobalVar } from "./config.mts"
import { deleteFileIfExists } from "./utils/deleteFileIfExists.mts"

export async function inference(params: { prompt: string, lora: string }) {
  const loraPath = path.join(lorasDirFilePath, hashURL(params.lora) + ".safetensors")

  await downloadFile(params.lora, loraPath)

  const output = await file({ postfix: ".gif" })

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

  await deleteFileIfExists(output.path)

  return outputAsBase64URL
}
