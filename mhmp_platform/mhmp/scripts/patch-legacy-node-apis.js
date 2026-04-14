'use strict'

const fs = require('fs')
const path = require('path')

const projectRoot = path.resolve(__dirname, '..')
const targetDirs = ['node_modules/spdy', 'node_modules/spdy-transport']

let patchedFileCount = 0
let patchedTokenCount = 0

function patchFile(filePath) {
  const source = fs.readFileSync(filePath, 'utf8')

  if (!source.includes('util._extend')) {
    return
  }

  const matchCount = (source.match(/util\._extend/g) || []).length
  const patched = source.replace(/util\._extend/g, 'Object.assign')

  if (patched === source) {
    return
  }

  fs.writeFileSync(filePath, patched, 'utf8')
  patchedFileCount += 1
  patchedTokenCount += matchCount

  console.log(`[patch-legacy-node-apis] patched ${path.relative(projectRoot, filePath)}`)
}

function walk(dirPath) {
  const entries = fs.readdirSync(dirPath, { withFileTypes: true })

  entries.forEach((entry) => {
    const fullPath = path.join(dirPath, entry.name)

    if (entry.isDirectory()) {
      walk(fullPath)
      return
    }

    if (entry.isFile() && fullPath.endsWith('.js')) {
      patchFile(fullPath)
    }
  })
}

targetDirs.forEach((targetDir) => {
  const fullPath = path.join(projectRoot, targetDir)

  if (!fs.existsSync(fullPath)) {
    console.log(`[patch-legacy-node-apis] skipped ${targetDir}, not installed`)
    return
  }

  walk(fullPath)
})

if (patchedFileCount === 0) {
  console.log('[patch-legacy-node-apis] no deprecated util._extend usage found')
} else {
  console.log(
    `[patch-legacy-node-apis] updated ${patchedFileCount} files and ${patchedTokenCount} deprecated references`
  )
}
