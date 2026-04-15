import fs from 'node:fs'
import path from 'node:path'

const rootDir = path.resolve('d:/Vue_Workspace/mhmp_platform/mhmp_back')
const templateFile = path.join(rootDir, 'scripts', 'templates', 'bulk_demo_seed_20260408.base.sql')
const outputFile = path.join(rootDir, 'scripts', 'generated', 'bulk_demo_seed_20260408.sql')

function loadTemplate() {
  if (!fs.existsSync(templateFile)) {
    throw new Error(`Missing SQL template: ${templateFile}`)
  }
  return fs.readFileSync(templateFile, 'utf8').replace(/^\uFEFF/, '')
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

function main() {
  const template = loadTemplate()
  const { content, inventoryTaskCount } = patchInventoryTaskBlocks(template)
  fs.mkdirSync(path.dirname(outputFile), { recursive: true })
  fs.writeFileSync(outputFile, `\uFEFF${content}\n`, 'utf8')
  console.log(`Generated ${outputFile}`)
  console.log(`Patched inventory_task blocks: ${inventoryTaskCount}`)
}

main()
