<template>
  <div class="page-shell">
    <section class="page-card page-card--section home-hero">
      <div class="home-hero__content">
        <div class="home-hero__eyebrow">{{ homeInfo.badge || `${APP_SHORT_NAME} Operations Hub` }}</div>
        <h1 class="home-hero__title">{{ homeInfo.title || APP_TITLE }}</h1>
        <p class="home-hero__desc">{{ homeInfo.description }}</p>
      </div>
      <div class="home-hero__mark">
        <span>{{ APP_SHORT_NAME }}</span>
      </div>
    </section>

    <section class="home-grid">
      <article
        v-for="item in homeInfo.cards"
        :key="item.title"
        class="page-card page-card--section home-card"
      >
        <div class="home-card__index">{{ item.orderNo }}</div>
        <h2 class="home-card__title">{{ item.title }}</h2>
        <p class="home-card__desc">{{ item.description }}</p>
      </article>
    </section>

    <section class="page-card page-card--section home-note">
      <PageHeader
        title="使用说明"
        description="左侧导航栏会根据当前账号权限展示可访问功能；点击功能后，页面会在上方标签栏生成对应标签，便于在多个业务页面之间快速切换。"
      />
      <div class="home-note__list">
        <span>首页标签固定保留，不能关闭。</span>
        <span>其他标签可点击右侧叉号关闭。</span>
        <span>关闭当前标签后会自动回到相邻标签或首页。</span>
      </div>
    </section>
  </div>
</template>

<script setup>
import { onMounted, ref } from 'vue'
import { getDashboardHomeApi } from '@/api/dashboard'
import PageHeader from '@/components/common/PageHeader.vue'
import { APP_SHORT_NAME, APP_TITLE } from '@/constants/menu'

const fallbackHomeInfo = {
  badge: `${APP_SHORT_NAME} Operations Hub`,
  title: APP_TITLE,
  description: '本系统围绕博物馆文物全生命周期管理建设，覆盖馆藏建档、库存流转、盘点核验、修复闭环、角色权限和操作留痕等核心业务。',
  cards: [
    {
      orderNo: '01',
      title: '文物档案统一管理',
      description: '集中维护文物基础信息、图片资料、鉴定报告、保存状态、库位和相关附件。'
    },
    {
      orderNo: '02',
      title: '库存流转闭环',
      description: '支持入库、出库、归还、馆内转存和盘点任务，保证文物流向清晰可追踪。'
    },
    {
      orderNo: '03',
      title: '修复过程可追溯',
      description: '覆盖修复申请、审批、过程记录、验收和历史归档，便于答辩演示完整业务链路。'
    },
    {
      orderNo: '04',
      title: '权限与日志联动',
      description: '基于角色、菜单和按钮权限控制功能入口，并通过操作日志记录关键业务行为。'
    }
  ]
}

const homeInfo = ref(fallbackHomeInfo)

onMounted(async () => {
  try {
    homeInfo.value = await getDashboardHomeApi()
  } catch (error) {
    homeInfo.value = fallbackHomeInfo
  }
})
</script>

<style scoped>
.home-hero {
  position: relative;
  min-height: 260px;
  overflow: hidden;
  background:
    radial-gradient(circle at 82% 12%, rgba(184, 138, 68, 0.28), transparent 24%),
    radial-gradient(circle at 10% 90%, rgba(123, 44, 42, 0.12), transparent 28%),
    linear-gradient(135deg, rgba(255, 251, 246, 0.98), rgba(246, 238, 229, 0.94));
}

.home-hero::after {
  content: '';
  position: absolute;
  right: -80px;
  bottom: -120px;
  width: 360px;
  height: 360px;
  border: 1px solid rgba(123, 44, 42, 0.08);
  border-radius: 50%;
}

.home-hero__content {
  position: relative;
  z-index: 1;
  max-width: 760px;
}

.home-hero__eyebrow {
  color: var(--primary);
  font-size: 13px;
  font-weight: 800;
  letter-spacing: 0.08em;
  text-transform: uppercase;
}

.home-hero__title {
  margin: 16px 0 0;
  color: var(--primary-deep);
  font-size: clamp(30px, 4vw, 52px);
  line-height: 1.08;
}

.home-hero__desc {
  margin: 20px 0 0;
  color: rgba(55, 49, 45, 0.82);
  font-size: 16px;
  line-height: 1.9;
}

.home-hero__mark {
  position: absolute;
  right: 34px;
  bottom: 28px;
  z-index: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 108px;
  height: 108px;
  border: 1px solid rgba(123, 44, 42, 0.1);
  border-radius: 32px;
  background: rgba(255, 255, 255, 0.58);
  box-shadow: 0 24px 44px rgba(79, 49, 31, 0.12);
  color: rgba(123, 44, 42, 0.76);
  font-size: 28px;
  font-weight: 900;
}

.home-grid {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 16px;
}

.home-card {
  min-height: 210px;
  background:
    radial-gradient(circle at top right, rgba(184, 138, 68, 0.12), transparent 30%),
    linear-gradient(180deg, rgba(255, 255, 255, 0.98), rgba(248, 242, 235, 0.94));
}

.home-card__index {
  color: rgba(123, 44, 42, 0.32);
  font-size: 34px;
  font-weight: 900;
  line-height: 1;
}

.home-card__title {
  margin: 18px 0 0;
  color: var(--primary-deep);
  font-size: 18px;
}

.home-card__desc {
  margin: 12px 0 0;
  color: var(--text-second);
  font-size: 14px;
  line-height: 1.8;
}

.home-note__list {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  margin-top: 16px;
}

.home-note__list span {
  padding: 8px 12px;
  border: 1px solid rgba(123, 44, 42, 0.08);
  border-radius: 999px;
  background: rgba(123, 44, 42, 0.06);
  color: var(--primary-deep);
  font-size: 13px;
  font-weight: 600;
}

@media (max-width: 1180px) {
  .home-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 720px) {
  .home-hero__mark {
    display: none;
  }

  .home-grid {
    grid-template-columns: 1fr;
  }
}
</style>
