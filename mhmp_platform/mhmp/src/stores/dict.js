import { defineStore } from 'pinia'
import { getDictItemsApi, getDictTypesApi } from '@/api/dict'

export const useDictStore = defineStore('dict', {
  state: () => ({
    types: [],
    itemsMap: {}
  }),
  actions: {
    async ensureTypes() {
      if (this.types.length > 0) {
        return this.types
      }
      this.types = await getDictTypesApi()
      return this.types
    },
    async ensureItems(dictTypeCode) {
      if (this.itemsMap[dictTypeCode]) {
        return this.itemsMap[dictTypeCode]
      }
      const items = await getDictItemsApi(dictTypeCode)
      this.itemsMap = {
        ...this.itemsMap,
        [dictTypeCode]: items
      }
      return items
    },
    async ensureMultipleItems(typeCodes = []) {
      await Promise.all(typeCodes.map((typeCode) => this.ensureItems(typeCode)))
    }
  }
})
