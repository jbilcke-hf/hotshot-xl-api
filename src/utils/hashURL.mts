import crypto from "crypto"

// Hash the url to get a unique filename for caching
export function hashURL(url: string): string {
  const hash = crypto.createHash('sha1')
  hash.update(url)
  return hash.digest('hex')
}
