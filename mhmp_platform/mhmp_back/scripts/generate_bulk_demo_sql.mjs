import fs from 'node:fs'
import path from 'node:path'

const rootDir = path.resolve('d:/Vue_Workspace/mhmp_platform/mhmp_back')
const templateFile = path.join(rootDir, 'scripts', 'templates', 'bulk_demo_seed_20260408.base.sql')
const seniorResearchersSeedFile = path.join(rootDir, 'scripts', 'seed_demo_senior_researchers.sql')
const outputFile = path.join(rootDir, 'scripts', 'generated', 'bulk_demo_seed_20260408.sql')

function loadTemplate() {
  if (!fs.existsSync(templateFile)) {
    throw new Error(`Missing SQL template: ${templateFile}`)
  }
  return fs.readFileSync(templateFile, 'utf8').replace(/^\uFEFF/, '')
}

function loadSeniorResearchersSeed() {
  if (!fs.existsSync(seniorResearchersSeedFile)) {
    throw new Error(`Missing SQL seed file: ${seniorResearchersSeedFile}`)
  }
  return fs.readFileSync(seniorResearchersSeedFile, 'utf8')
    .replace(/^\uFEFF/, '')
    .trim()
}

function normalizeLegacyCategoryCodes(sqlText) {
  return sqlText
    .replaceAll("'BRONZE_WARE'", "'BRONZE'")
    .replaceAll("'PAINTING_CALLIGRAPHY'", "'PAINTING'")
    .replaceAll("'JADE_ARTIFACT'", "'JADE'")
}

function patchInventoryTaskBlocks(sqlText) {
  const lines = sqlText.split(/\r?\n/)
  let inventoryTaskCount = 0
  let patchedColumnCount = 0
  let patchedValueCount = 0

  for (let index = 0; index < lines.length; index += 1) {
    if (lines[index].trim() !== 'INSERT INTO inventory_task (') {
      continue
    }

    inventoryTaskCount += 1

    const columnLineIndex = index + 1
    const selectLineIndex = index + 3
    const valueLineIndex = index + 4

    if (lines[columnLineIndex]?.includes('principal_name, remark, create_by')) {
      lines[columnLineIndex] = lines[columnLineIndex].replace(
        'principal_name, remark, create_by',
        'principal_name, principal_user_id, remark, create_by'
      )
      patchedColumnCount += 1
    }

    if (lines[valueLineIndex]?.includes('批量生成的盘点任务数据。')) {
      const match = lines[valueLineIndex].match(
        /^(\s*)('(?:''|[^'])*'),\s*(COALESCE\(\(SELECT id FROM sys_user WHERE username = '(?:[^']+)' AND deleted = 0 LIMIT 1\), @seed_admin_id\)),\s*(.*)$/
      )
      if (!match) {
        throw new Error(`Failed to patch inventory_task value line: ${lines[valueLineIndex]}`)
      }
      const [, indent, remark, principalUserExpr, rest] = match
      lines[valueLineIndex] = `${indent}${principalUserExpr}, ${remark}, ${principalUserExpr}, ${rest}`
      patchedValueCount += 1
    }

    if (!lines[selectLineIndex]?.startsWith('SELECT ')) {
      throw new Error(`Unexpected inventory_task SELECT line near index ${selectLineIndex + 1}`)
    }
  }

  if (inventoryTaskCount === 0) {
    throw new Error('No inventory_task blocks were found in SQL template')
  }
  if (patchedColumnCount !== inventoryTaskCount || patchedValueCount !== inventoryTaskCount) {
    throw new Error(
      `Inventory task patch mismatch: blocks=${inventoryTaskCount}, columns=${patchedColumnCount}, values=${patchedValueCount}`
    )
  }

  return {
    content: lines.join('\n'),
    inventoryTaskCount
  }
}

function patchOutboundOrderBlocks(sqlText) {
  const lines = sqlText.split(/\r?\n/)
  let outboundTaskCount = 0
  let patchedColumnCount = 0
  let patchedValueCount = 0

  for (let index = 0; index < lines.length; index += 1) {
    if (lines[index].trim() !== 'INSERT INTO relic_outbound_order (') {
      continue
    }

    outboundTaskCount += 1
    const columnLineIndex = index + 1
    const valueLineIndex = index + 4

    if (lines[columnLineIndex]?.includes('destination, handler_name, outbound_time, apply_user_id')) {
      lines[columnLineIndex] = lines[columnLineIndex].replace(
        'destination, handler_name, outbound_time, apply_user_id',
        'destination, handler_user_id, handler_name, outbound_time, apply_user_id'
      )
      patchedColumnCount += 1
    }

    const currentLine = lines[valueLineIndex] || ''
    const match = currentLine.match(
      /^(\s*SELECT\s+'(?:''|[^'])*',\s+'(?:''|[^'])*',\s+'(?:''|[^'])*',\s+)('(?:''|[^'])*')(\s*,\s*'(?:''|[^'])*'\s*,\s*)(COALESCE\(\(SELECT id FROM sys_user WHERE username = '(?:[^']+)' AND deleted = 0 LIMIT 1\), @seed_admin_id\))(,.*)$/
    )
    if (match) {
      const [, prefix, handlerName, middle, applyUserExpr, suffix] = match
      lines[valueLineIndex] = `${prefix}${applyUserExpr}, ${handlerName}${middle}${applyUserExpr}${suffix}`
      patchedValueCount += 1
    }
  }

  if (outboundTaskCount === 0) {
    throw new Error('No relic_outbound_order blocks were found in SQL template')
  }
  if (patchedColumnCount !== outboundTaskCount || patchedValueCount !== outboundTaskCount) {
    throw new Error(
      `Outbound order patch mismatch: blocks=${outboundTaskCount}, columns=${patchedColumnCount}, values=${patchedValueCount}`
    )
  }

  return {
    content: lines.join('\n'),
    outboundTaskCount
  }
}

function injectSeniorResearchersSeed(sqlText, seedSqlText) {
  const commitMarker = '\nCOMMIT;'
  const commitIndex = sqlText.lastIndexOf(commitMarker)
  if (commitIndex === -1) {
    throw new Error('Unable to locate COMMIT marker in SQL template')
  }
  return `${sqlText.slice(0, commitIndex)}\n\n${seedSqlText}\n${sqlText.slice(commitIndex)}`
}

function main() {
  const template = normalizeLegacyCategoryCodes(loadTemplate())
  const seniorResearchersSeed = loadSeniorResearchersSeed()
  const { content: inventoryPatchedContent, inventoryTaskCount } = patchInventoryTaskBlocks(template)
  const { content: outboundPatchedContent, outboundTaskCount } = patchOutboundOrderBlocks(inventoryPatchedContent)
  const finalContent = injectSeniorResearchersSeed(outboundPatchedContent, seniorResearchersSeed)
  fs.mkdirSync(path.dirname(outputFile), { recursive: true })
  fs.writeFileSync(outputFile, `\uFEFF${finalContent}\n`, 'utf8')
  console.log(`Generated ${outputFile}`)
  console.log(`Patched inventory_task blocks: ${inventoryTaskCount}`)
  console.log(`Patched relic_outbound_order blocks: ${outboundTaskCount}`)
  console.log('Injected extra senior researchers seed')
}

main()
