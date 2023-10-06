import path from "node:path"

export const storagePath = `${process.env.STORAGE_PATH || './sandbox'}`

export const lorasDirFilePath = path.join(storagePath, "loras")
export const modelsDirFilePath = path.join(storagePath, "models")

export const baseSDXLDir = path.join(modelsDirFilePath, "stable-diffusion-xl-base-1.0")
export const spatialUnetBaseGlobalVar = path.join(baseSDXLDir, "unet")
