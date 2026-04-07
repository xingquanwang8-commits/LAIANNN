function escapeHtml(value) {
  return String(value ?? '')
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;')
    .replaceAll("'", '&#39;')
}

function buildInfoGrid(items = []) {
  return items
    .map((item) => `
      <div class="info-card">
        <div class="info-card__label">${escapeHtml(item.label)}</div>
        <div class="info-card__value">${escapeHtml(item.value || '--')}</div>
      </div>
    `)
    .join('')
}

function buildTable(headers = [], rows = [], emptyText = '暂无数据') {
  const headHtml = headers.map((item) => `<th>${escapeHtml(item)}</th>`).join('')
  const bodyHtml = rows.length
    ? rows.map((row) => `<tr>${row.map((cell) => `<td>${escapeHtml(cell || '--')}</td>`).join('')}</tr>`).join('')
    : `<tr><td colspan="${headers.length}" class="empty-cell">${escapeHtml(emptyText)}</td></tr>`

  return `
    <table class="ledger-table">
      <thead>
        <tr>${headHtml}</tr>
      </thead>
      <tbody>
        ${bodyHtml}
      </tbody>
    </table>
  `
}

function buildLedgerHtml(ledger) {
  return `
    <!DOCTYPE html>
    <html lang="zh-CN">
      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>${escapeHtml(ledger.title || '文物业务台账')}</title>
        <style>
          * {
            box-sizing: border-box;
          }

          body {
            margin: 0;
            padding: 32px;
            font-family: "Microsoft YaHei", "PingFang SC", sans-serif;
            color: #1f2937;
            background: #f4f1ed;
          }

          .ledger {
            max-width: 1100px;
            margin: 0 auto;
            padding: 36px;
            background: #ffffff;
            border-radius: 24px;
            box-shadow: 0 18px 40px rgba(102, 79, 53, 0.12);
          }

          .ledger-header {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 24px;
            padding-bottom: 24px;
            border-bottom: 2px solid #eadfd3;
          }

          .ledger-title {
            margin: 0;
            font-size: 30px;
            line-height: 1.2;
            color: #7b2c2a;
          }

          .ledger-subtitle {
            margin-top: 10px;
            color: #6b7280;
            line-height: 1.8;
            font-size: 14px;
          }

          .ledger-meta {
            min-width: 220px;
            padding: 16px 18px;
            border: 1px solid #eadfd3;
            border-radius: 16px;
            background: #faf7f2;
          }

          .ledger-meta div + div {
            margin-top: 8px;
          }

          .section {
            margin-top: 28px;
          }

          .section-title {
            margin: 0 0 14px;
            font-size: 18px;
            color: #111827;
          }

          .section-desc {
            margin: -2px 0 14px;
            color: #6b7280;
            font-size: 13px;
          }

          .info-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 12px;
          }

          .info-card {
            padding: 14px 16px;
            border: 1px solid #eadfd3;
            border-radius: 16px;
            background: #fcfaf7;
          }

          .info-card__label {
            color: #6b7280;
            font-size: 12px;
          }

          .info-card__value {
            margin-top: 8px;
            font-size: 15px;
            font-weight: 700;
            line-height: 1.6;
            word-break: break-all;
          }

          .ledger-table {
            width: 100%;
            border-collapse: collapse;
            table-layout: fixed;
          }

          .ledger-table th,
          .ledger-table td {
            padding: 12px 14px;
            border: 1px solid #eadfd3;
            text-align: left;
            vertical-align: top;
            font-size: 13px;
            line-height: 1.7;
            word-break: break-word;
          }

          .ledger-table th {
            background: #f8f4ee;
            font-weight: 700;
            color: #374151;
          }

          .empty-cell {
            text-align: center;
            color: #9ca3af;
          }

          @media print {
            body {
              padding: 0;
              background: #ffffff;
            }

            .ledger {
              max-width: none;
              padding: 18px;
              border-radius: 0;
              box-shadow: none;
            }

            .section {
              break-inside: avoid;
            }
          }

          @media (max-width: 900px) {
            body {
              padding: 12px;
            }

            .ledger {
              padding: 20px;
            }

            .ledger-header {
              flex-direction: column;
            }

            .info-grid {
              grid-template-columns: repeat(2, minmax(0, 1fr));
            }
          }
        </style>
      </head>
      <body>
        <main class="ledger">
          <header class="ledger-header">
            <div>
              <h1 class="ledger-title">${escapeHtml(ledger.title || '文物业务台账')}</h1>
              <div class="ledger-subtitle">${escapeHtml(ledger.subtitle || '用于展示文物档案信息、待办业务和完整业务时间线，便于业务复盘与答辩演示。')}</div>
            </div>
            <div class="ledger-meta">
              <div>文物编号：${escapeHtml(ledger.relicNo || '--')}</div>
              <div>文物名称：${escapeHtml(ledger.relicName || '--')}</div>
              <div>导出时间：${escapeHtml(ledger.generatedAt || '--')}</div>
            </div>
          </header>

          <section class="section">
            <h2 class="section-title">基础信息</h2>
            <div class="info-grid">${buildInfoGrid(ledger.basicInfo || [])}</div>
          </section>

          <section class="section">
            <h2 class="section-title">待办业务</h2>
            <div class="section-desc">汇总该文物当前尚未闭环的审批、归还和验收事项。</div>
            ${buildTable(
              ['业务名称', '状态', '业务时间', '说明'],
              (ledger.pendingBusinesses || []).map((item) => [item.title, item.status, item.eventTime, item.description]),
              '当前没有待办业务'
            )}
          </section>

          <section class="section">
            <h2 class="section-title">附件资料</h2>
            <div class="section-desc">展示文物档案附件与修复材料索引。</div>
            ${buildTable(
              ['附件类型', '文件名称', '文件大小', '备注'],
              (ledger.attachments || []).map((item) => [item.type, item.fileName, item.fileSize, item.remark]),
              '暂无附件资料'
            )}
          </section>

          <section class="section">
            <h2 class="section-title">业务时间线</h2>
            <div class="section-desc">覆盖入库、出库、馆内转存、盘点、修复与验收全过程记录。</div>
            ${buildTable(
              ['时间', '业务节点', '状态', '详情'],
              (ledger.timeline || []).map((item) => [item.eventTime, item.title, item.status, item.description]),
              '暂无业务记录'
            )}
          </section>
        </main>
      </body>
    </html>
  `
}

export function downloadRelicLedger(ledger, fileName = 'relic-ledger.html') {
  const html = buildLedgerHtml(ledger)
  const blob = new Blob([html], { type: 'text/html;charset=utf-8' })
  const url = window.URL.createObjectURL(blob)
  const link = document.createElement('a')
  link.href = url
  link.download = fileName
  document.body.appendChild(link)
  link.click()
  document.body.removeChild(link)
  window.URL.revokeObjectURL(url)
}

export function printRelicLedger(ledger) {
  const html = buildLedgerHtml(ledger)
  const printWindow = window.open('', '_blank', 'noopener,noreferrer')
  if (!printWindow) {
    throw new Error('PRINT_WINDOW_BLOCKED')
  }
  printWindow.document.open()
  printWindow.document.write(html)
  printWindow.document.close()
  printWindow.onload = () => {
    printWindow.focus()
    printWindow.print()
  }
}
