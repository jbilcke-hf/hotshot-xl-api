import fs from "fs"
import axios from "axios"

export async function downloadFile(url: string, filename: string) {
  const response = await axios.get(url, { responseType: 'stream' })
  const writer = fs.createWriteStream(filename)
  response.data.pipe(writer)

  return new Promise((resolve, reject) => {
    writer.on('finish', resolve)
    writer.on('error', reject)
  })
}