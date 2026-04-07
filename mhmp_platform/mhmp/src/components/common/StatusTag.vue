<template>
  <el-tag class="status-tag" :type="type" effect="light" round>
    {{ label || status || '--' }}
  </el-tag>
</template>

<script setup>
import { computed } from 'vue'
import { resolveStatusTagType } from '@/utils/format'

const props = defineProps({
  status: {
    type: String,
    default: ''
  },
  label: {
    type: String,
    default: ''
  }
})

const type = computed(() => resolveStatusTagType(props.status))
</script>

<style scoped>
.status-tag {
  border: none;
  font-weight: 700;
  letter-spacing: 0.01em;
  box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.45);
}
</style>
