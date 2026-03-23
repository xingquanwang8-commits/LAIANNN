<template>
  <el-tag :type="type" effect="light" round>
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
