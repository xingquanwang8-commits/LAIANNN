<template>
  <div class="page-toolbar">
    <div>
      <h1 class="page-title">{{ title }}</h1>
      <p v-if="description" class="page-subtitle">{{ description }}</p>
    </div>
    <div v-if="$slots.extra">
      <slot name="extra" />
    </div>
  </div>
</template>

<script setup>
defineProps({
  title: {
    type: String,
    required: true
  },
  description: {
    type: String,
    default: ''
  }
})
</script>

<style scoped>
.page-toolbar {
  align-items: flex-end;
  padding-bottom: 4px;
}

.page-title {
  position: relative;
  padding-left: 14px;
}

.page-title::before {
  content: '';
  position: absolute;
  left: 0;
  top: 50%;
  width: 6px;
  height: 18px;
  border-radius: 999px;
  background: linear-gradient(180deg, var(--primary), var(--accent));
  transform: translateY(-50%);
}

.page-subtitle {
  max-width: 100%;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
</style>
