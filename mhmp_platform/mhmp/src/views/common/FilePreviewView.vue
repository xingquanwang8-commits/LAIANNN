<template>
  <div class="file-preview-page">
    <header class="preview-toolbar">
      <div class="preview-title">
        <span class="preview-title__label">文件预览</span>
        <strong class="preview-title__name" :title="fileName">{{ fileName }}</strong>
      </div>
      <el-button
        type="primary"
        :icon="Download"
        :loading="downloading"
        @click="downloadSourceFile"
      >
        下载源文件
      </el-button>
    </header>

    <main class="preview-body">
      <iframe
        v-if="previewMode === 'pdf'"
        class="preview-frame"
        :src="pdfPreviewUrl"
        :title="fileName"
      />

      <div v-else-if="previewMode === 'image'" class="image-preview">
        <img :src="accessUrl" :alt="fileName">
      </div>

      <section v-else-if="previewMode === 'text'" class="text-preview">
        <el-skeleton v-if="previewLoading" :rows="10" animated />
        <el-alert
          v-else-if="previewError"
          type="warning"
          :closable="false"
          :title="previewError"
        />
        <pre v-else class="text-preview__content">{{ previewContent }}</pre>
      </section>

      <el-empty
        v-else
        class="unsupported-preview"
        description="当前文件类型暂不支持在线预览，请下载源文件查看。"
      />
    </main>
  </div>
</template>

<script setup>
import { computed, ref, watch } from 'vue'
import { useRoute } from 'vue-router'
import { ElMessage } from 'element-plus'
import { Download } from '@element-plus/icons-vue'
import { getFilePreviewApi } from '@/api/file'
import {
  IMAGE_PREVIEW_SUFFIXES,
  PDF_PREVIEW_SUFFIXES,
  TEXT_PREVIEW_SUFFIXES,
  buildFileSourceUrl,
  ensureFileNameSuffix,
  resolveFileAccessUrl,
  resolveFileSuffix
} from '@/utils/filePreview'

const route = useRoute()
const previewLoading = ref(false)
const downloading = ref(false)
const previewContent = ref('')
const previewError = ref('')
let currentPreviewRequest = 0

const rawFileUrl = computed(() => (typeof route.query.fileUrl === 'string' ? route.query.fileUrl : ''))
const accessUrl = computed(() => resolveFileAccessUrl(rawFileUrl.value))
const queryFileName = computed(() => (typeof route.query.fileName === 'string' ? route.query.fileName : '文件预览'))
const suffix = computed(() => {
  const querySuffix = typeof route.query.fileSuffix === 'string' ? route.query.fileSuffix.trim().replace(/^\./, '').toLowerCase() : ''
  return querySuffix || resolveFileSuffix({ fileName: queryFileName.value, fileUrl: accessUrl.value })
})
const fileName = computed(() => ensureFileNameSuffix(queryFileName.value, suffix.value))
const previewFile = computed(() => ({
  fileName: fileName.value,
  fileUrl: accessUrl.value,
  fileSuffix: suffix.value
}))
const sourcePreviewUrl = computed(() => buildFileSourceUrl(previewFile.value))
const sourceDownloadUrl = computed(() => buildFileSourceUrl(previewFile.value, { download: true }))

const previewMode = computed(() => {
  if (!accessUrl.value) {
    return 'unsupported'
  }
  if (PDF_PREVIEW_SUFFIXES.has(suffix.value)) {
    return 'pdf'
  }
  if (IMAGE_PREVIEW_SUFFIXES.has(suffix.value)) {
    return 'image'
  }
  if (TEXT_PREVIEW_SUFFIXES.has(suffix.value)) {
    return 'text'
  }
  return 'unsupported'
})

const pdfPreviewUrl = computed(() => {
  if (!sourcePreviewUrl.value) {
    return ''
  }
  return `${sourcePreviewUrl.value}#toolbar=1&navpanes=0`
})

watch(fileName, (name) => {
  document.title = `${name} | 文件预览`
}, { immediate: true })

watch([previewMode, accessUrl], () => {
  if (previewMode.value === 'text') {
    loadTextPreview()
  } else {
    currentPreviewRequest += 1
    previewContent.value = ''
    previewError.value = ''
    previewLoading.value = false
  }
}, { immediate: true })

async function loadTextPreview() {
  if (!accessUrl.value) {
    previewError.value = '文件地址无效，无法预览'
    return
  }
  const requestId = ++currentPreviewRequest
  previewLoading.value = true
  previewError.value = ''
  previewContent.value = ''
  try {
    const result = await getFilePreviewApi(accessUrl.value)
    if (requestId !== currentPreviewRequest) {
      return
    }
    if (result?.previewType === 'TEXT') {
      previewContent.value = result.content || '未提取到可预览文本内容。'
    } else {
      previewError.value = result?.message || '当前文件类型暂不支持文本预览，请下载源文件查看。'
    }
  } catch (error) {
    if (requestId === currentPreviewRequest) {
      previewError.value = error?.userMessage || '文件预览失败，请下载源文件查看。'
    }
  } finally {
    if (requestId === currentPreviewRequest) {
      previewLoading.value = false
    }
  }
}

async function downloadSourceFile() {
  if (!accessUrl.value) {
    ElMessage.warning('文件地址无效，无法下载')
    return
  }
  downloading.value = true
  triggerDownload(sourceDownloadUrl.value, fileName.value)
  window.setTimeout(() => {
    downloading.value = false
  }, 300)
}

function triggerDownload(url, name) {
  const link = document.createElement('a')
  link.href = url
  link.download = sanitizeFileName(name)
  link.rel = 'noopener'
  document.body.appendChild(link)
  link.click()
  document.body.removeChild(link)
}

function sanitizeFileName(name) {
  return (name || '源文件').replace(/[\\/:*?"<>|]/g, '_').trim() || '源文件'
}
</script>

<style scoped>
.file-preview-page {
  min-height: 100vh;
  background:
    radial-gradient(circle at 10% 10%, rgba(72, 112, 84, 0.12), transparent 28%),
    linear-gradient(135deg, #f7f2e8 0%, #eef3e9 48%, #f7f7f2 100%);
  color: #26352a;
}

.preview-toolbar {
  position: sticky;
  top: 0;
  z-index: 5;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  padding: 14px 22px;
  background: rgba(255, 252, 245, 0.92);
  border-bottom: 1px solid rgba(97, 118, 90, 0.18);
  box-shadow: 0 12px 32px rgba(45, 61, 49, 0.08);
  backdrop-filter: blur(12px);
}

.preview-title {
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.preview-title__label {
  font-size: 12px;
  color: #70806f;
}

.preview-title__name {
  max-width: min(68vw, 980px);
  overflow: hidden;
  font-size: 17px;
  line-height: 1.45;
  color: #243629;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.preview-body {
  height: calc(100vh - 65px);
  padding: 16px;
}

.preview-frame {
  width: 100%;
  height: 100%;
  background: #fff;
  border: 1px solid rgba(97, 118, 90, 0.18);
  border-radius: 18px;
  box-shadow: 0 16px 36px rgba(47, 62, 52, 0.12);
}

.image-preview,
.text-preview,
.unsupported-preview {
  width: min(1120px, 100%);
  min-height: 100%;
  margin: 0 auto;
  padding: 22px;
  background: rgba(255, 255, 255, 0.9);
  border: 1px solid rgba(97, 118, 90, 0.16);
  border-radius: 18px;
  box-shadow: 0 16px 36px rgba(47, 62, 52, 0.1);
}

.image-preview {
  display: flex;
  align-items: center;
  justify-content: center;
}

.image-preview img {
  max-width: 100%;
  max-height: calc(100vh - 145px);
  object-fit: contain;
  border-radius: 12px;
}

.text-preview {
  overflow: auto;
}

.text-preview__content {
  margin: 0;
  color: #26352a;
  font-size: 14px;
  line-height: 1.85;
  tab-size: 4;
  white-space: pre-wrap;
  word-break: break-word;
}

@media (max-width: 720px) {
  .preview-toolbar {
    align-items: stretch;
    flex-direction: column;
    padding: 12px;
  }

  .preview-title__name {
    max-width: 100%;
  }

  .preview-body {
    height: calc(100vh - 112px);
    padding: 10px;
  }
}
</style>
