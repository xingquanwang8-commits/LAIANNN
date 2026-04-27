<template>
  <el-dialog
    v-model="dialogVisible"
    :title="dialogTitle"
    width="78%"
    top="4vh"
    destroy-on-close
    class="file-preview-dialog"
  >
    <div v-if="currentFile" class="detail-stack">
      <div class="overview-panel overview-panel--compact">
        <div class="overview-panel__top">
          <div>
            <div class="overview-panel__eyebrow">MHMP File Preview</div>
            <h3 class="overview-panel__title file-preview__title">{{ currentFile.fileName || '文件预览' }}</h3>
            <p class="overview-panel__desc">
              系统支持直接预览 PDF、Word 和常见文本文件；如果文件版式较复杂或类型暂不支持，
              仍可通过“打开原件”查看完整内容。
            </p>
          </div>
          <div class="overview-panel__meta file-preview__actions">
            <span class="overview-chip">{{ previewTypeLabel }}</span>
            <el-button
              plain
              type="primary"
              :icon="TopRight"
              @click="handleOpenOriginal"
            >
              打开原件
            </el-button>
          </div>
        </div>
      </div>

      <div v-loading="loading" class="file-preview__body">
        <template v-if="previewMode === 'pdf'">
          <iframe :src="currentFile.fileUrl" class="file-preview__frame" title="文件预览" />
        </template>

        <template v-else-if="previewMode === 'image'">
          <div class="file-preview__image-wrap">
            <img :src="currentFile.fileUrl" :alt="currentFile.fileName || '文件预览'" class="file-preview__image">
          </div>
        </template>

        <template v-else-if="previewMode === 'word' || previewMode === 'text'">
          <div class="soft-note soft-note--accent">
            <div class="soft-note__title">{{ previewMode === 'word' ? 'Word 文档预览说明' : '文本文件预览说明' }}</div>
            <div class="soft-note__desc">{{ previewMessage }}</div>
          </div>
          <pre class="file-preview__text">{{ previewContent || '当前文件暂无可显示内容。' }}</pre>
        </template>

        <el-empty
          v-else-if="!loading"
          class="empty-block"
          :description="previewMessage || '当前文件类型暂不支持在线预览，请打开原件查看。'"
        />
      </div>
    </div>
  </el-dialog>
</template>

<script setup>
import { computed, ref, watch } from 'vue'
import { ElMessage } from 'element-plus'
import { TopRight } from '@element-plus/icons-vue'
import { getFilePreviewApi } from '@/api/file'
import { IMAGE_PREVIEW_SUFFIXES, buildPreviewFile, openOriginalFile, resolveFileAccessUrl, resolveFileSuffix } from '@/utils/filePreview'

const props = defineProps({
  modelValue: {
    type: Boolean,
    default: false
  },
  file: {
    type: Object,
    default: null
  }
})

const emit = defineEmits(['update:modelValue'])

const loading = ref(false)
const previewData = ref(null)

const dialogVisible = computed({
  get: () => props.modelValue,
  set: (value) => emit('update:modelValue', value)
})

const currentFile = computed(() => (props.file ? buildPreviewFile(props.file) : null))
const fileSuffix = computed(() => resolveFileSuffix(currentFile.value))
const dialogTitle = computed(() => currentFile.value?.fileName || '文件预览')

const previewMode = computed(() => {
  if (IMAGE_PREVIEW_SUFFIXES.has(fileSuffix.value)) {
    return 'image'
  }
  if (previewData.value?.previewType === 'PDF') {
    return 'pdf'
  }
  if (previewData.value?.previewType === 'WORD') {
    return 'word'
  }
  if (previewData.value?.previewType === 'TEXT') {
    return 'text'
  }
  return 'unsupported'
})

const previewTypeLabel = computed(() => {
  if (previewMode.value === 'pdf') {
    return 'PDF 预览'
  }
  if (previewMode.value === 'word') {
    return 'Word 文本预览'
  }
  if (previewMode.value === 'text') {
    return '文本预览'
  }
  if (previewMode.value === 'image') {
    return '图片预览'
  }
  return '暂不支持'
})

const previewContent = computed(() => previewData.value?.content || '')
const previewMessage = computed(() => previewData.value?.message || '当前文件类型暂不支持在线预览，请打开原件查看。')

watch(
  () => [dialogVisible.value, currentFile.value?.fileUrl],
  async ([visible, fileUrl]) => {
    previewData.value = null
    if (!visible || !fileUrl) {
      return
    }
    if (IMAGE_PREVIEW_SUFFIXES.has(fileSuffix.value)) {
      return
    }
    loading.value = true
    try {
      previewData.value = await getFilePreviewApi(resolveFileAccessUrl(fileUrl))
    } catch (error) {
      previewData.value = {
        previewType: 'UNSUPPORTED',
        previewable: false,
        message: error?.userMessage || '文件预览失败，请打开原件查看。'
      }
    } finally {
      loading.value = false
    }
  },
  { immediate: true }
)

function handleOpenOriginal() {
  if (!openOriginalFile(currentFile.value)) {
    ElMessage.warning('浏览器阻止了新页面打开，请允许弹出窗口后重试')
  }
}
</script>

<style scoped>
.file-preview__title {
  font-size: 22px;
  line-height: 1.4;
  word-break: break-word;
}

.file-preview__actions {
  align-items: center;
}

.file-preview__body {
  min-height: 420px;
}

.file-preview__frame {
  width: 100%;
  min-height: 72vh;
  border: 1px solid var(--border-line);
  border-radius: 18px;
  background: #fff;
}

.file-preview__text {
  margin: 0;
  padding: 20px;
  min-height: 420px;
  max-height: 70vh;
  overflow: auto;
  border: 1px solid var(--border-line);
  border-radius: 18px;
  background: linear-gradient(180deg, rgba(255, 255, 255, 0.98), rgba(249, 246, 240, 0.96));
  color: var(--text-main);
  font-size: 14px;
  line-height: 1.9;
  white-space: pre-wrap;
  word-break: break-word;
  font-family: "Microsoft YaHei", "PingFang SC", sans-serif;
}

.file-preview__image-wrap {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 420px;
  padding: 20px;
  border: 1px solid var(--border-line);
  border-radius: 18px;
  background: linear-gradient(180deg, rgba(255, 255, 255, 0.98), rgba(249, 246, 240, 0.96));
}

.file-preview__image {
  max-width: 100%;
  max-height: 68vh;
  object-fit: contain;
  border-radius: 12px;
}

@media (max-width: 768px) {
  .file-preview__frame {
    min-height: 60vh;
  }

  .file-preview__text {
    min-height: 320px;
    max-height: 58vh;
  }
}
</style>
