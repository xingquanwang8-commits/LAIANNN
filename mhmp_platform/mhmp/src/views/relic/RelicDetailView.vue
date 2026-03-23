<template>
  <div class="page-shell" v-loading="loading">
    <section class="page-card page-card--section">
      <PageHeader
        :title="detail?.name || '文物详情'"
        description="展示文物基础信息、保存状态与附件数据。"
      >
        <template #extra>
          <el-button @click="router.push('/relic/list')">返回列表</el-button>
          <el-button
            v-if="authStore.hasPermission('relic:edit') && detail"
            type="primary"
            @click="router.push(`/relic/edit/${detail.id}`)"
          >
            编辑文物
          </el-button>
        </template>
      </PageHeader>
    </section>

    <section v-if="detail" class="page-grid relic-detail-grid">
      <article class="page-card page-card--section">
        <div class="relic-detail__media">
          <img v-if="detail.imageUrl" :src="detail.imageUrl" alt="文物主图" class="relic-detail__image">
          <div v-else class="relic-detail__placeholder">暂无文物主图</div>
        </div>
      </article>

      <article class="page-card page-card--section">
        <el-descriptions :column="2" border>
          <el-descriptions-item label="文物编号">{{ detail.relicNo }}</el-descriptions-item>
          <el-descriptions-item label="文物名称">{{ detail.name }}</el-descriptions-item>
          <el-descriptions-item label="文物类别">
            {{ resolveDictLabel(categoryOptions, detail.categoryCode) }}
          </el-descriptions-item>
          <el-descriptions-item label="文物材质">
            {{ resolveDictLabel(materialOptions, detail.materialCode) }}
          </el-descriptions-item>
          <el-descriptions-item label="馆藏位置">
            {{ resolveDictLabel(locationOptions, detail.storageLocationCode) }}
          </el-descriptions-item>
          <el-descriptions-item label="当前状态">
            <StatusTag
              :status="detail.currentStatus"
              :label="resolveDictLabel(statusOptions, detail.currentStatus)"
            />
          </el-descriptions-item>
          <el-descriptions-item label="保存状态">
            {{ resolveDictLabel(preservationOptions, detail.preservationStatusCode) }}
          </el-descriptions-item>
          <el-descriptions-item label="年代">{{ detail.era || '--' }}</el-descriptions-item>
          <el-descriptions-item label="来源">{{ detail.source || '--' }}</el-descriptions-item>
          <el-descriptions-item label="保护级别">{{ detail.protectionLevel || '--' }}</el-descriptions-item>
          <el-descriptions-item label="创建时间">{{ formatDateTime(detail.createTime) }}</el-descriptions-item>
          <el-descriptions-item label="更新时间">{{ formatDateTime(detail.updateTime) }}</el-descriptions-item>
          <el-descriptions-item label="保存条件" :span="2">{{ detail.storageCondition || '--' }}</el-descriptions-item>
          <el-descriptions-item label="注意事项" :span="2">{{ detail.attentionNote || '--' }}</el-descriptions-item>
          <el-descriptions-item label="文物描述" :span="2">{{ detail.description || '--' }}</el-descriptions-item>
          <el-descriptions-item label="备注" :span="2">{{ detail.note || '--' }}</el-descriptions-item>
          <el-descriptions-item label="鉴定报告" :span="2">
            <a v-if="detail.appraisalReportUrl" :href="detail.appraisalReportUrl" target="_blank" rel="noreferrer">
              查看鉴定报告
            </a>
            <span v-else>--</span>
          </el-descriptions-item>
        </el-descriptions>
      </article>
    </section>

    <section class="page-card page-card--section">
      <PageHeader
        title="附件资料"
        description="附件数据来自文物附件接口，支持图片与鉴定报告地址查看。"
      />

      <el-table v-if="attachments.length" :data="attachments">
        <el-table-column prop="attachmentType" label="附件类型" min-width="120" />
        <el-table-column prop="fileName" label="文件名称" min-width="240" />
        <el-table-column label="文件大小" min-width="120">
          <template #default="{ row }">
            {{ row.fileSize ? `${(row.fileSize / 1024).toFixed(1)} KB` : '--' }}
          </template>
        </el-table-column>
        <el-table-column prop="remark" label="备注" min-width="160" />
        <el-table-column label="操作" width="120">
          <template #default="{ row }">
            <a :href="row.fileUrl" target="_blank" rel="noreferrer">打开文件</a>
          </template>
        </el-table-column>
      </el-table>
      <el-empty v-else class="empty-block" description="暂无附件资料" />
    </section>
  </div>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { getRelicAttachmentsApi, getRelicDetailApi } from '@/api/relic'
import PageHeader from '@/components/common/PageHeader.vue'
import StatusTag from '@/components/common/StatusTag.vue'
import { useAuthStore } from '@/stores/auth'
import { useDictStore } from '@/stores/dict'
import { formatDateTime, resolveDictLabel } from '@/utils/format'

const route = useRoute()
const router = useRouter()
const authStore = useAuthStore()
const dictStore = useDictStore()

const loading = ref(false)
const detail = ref(null)
const attachments = ref([])

const categoryOptions = computed(() => dictStore.itemsMap.relic_category || [])
const materialOptions = computed(() => dictStore.itemsMap.relic_material || [])
const statusOptions = computed(() => dictStore.itemsMap.relic_status || [])
const locationOptions = computed(() => dictStore.itemsMap.storage_location || [])
const preservationOptions = computed(() => dictStore.itemsMap.preservation_status || [])

async function loadDetail() {
  loading.value = true
  try {
    const [detailData, attachmentData] = await Promise.all([
      getRelicDetailApi(route.params.id),
      getRelicAttachmentsApi(route.params.id)
    ])
    detail.value = detailData
    attachments.value = attachmentData
  } finally {
    loading.value = false
  }
}

onMounted(async () => {
  await dictStore.ensureMultipleItems([
    'relic_category',
    'relic_material',
    'relic_status',
    'storage_location',
    'preservation_status'
  ])
  await loadDetail()
})
</script>

<style scoped>
.relic-detail-grid {
  grid-template-columns: 320px 1fr;
}

.relic-detail__media {
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 320px;
  border: 1px solid var(--border-line);
  border-radius: 14px;
  background: linear-gradient(180deg, #faf8f8, #f4f4f6);
}

.relic-detail__image {
  width: 100%;
  max-height: 320px;
  object-fit: contain;
}

.relic-detail__placeholder {
  color: var(--text-second);
}

@media (max-width: 1080px) {
  .relic-detail-grid {
    grid-template-columns: 1fr;
  }
}
</style>
