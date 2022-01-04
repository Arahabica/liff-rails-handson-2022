<template>
  <div>認証中...</div>
</template>

<script lang="ts">
import { defineComponent, onMounted } from 'vue'

export default defineComponent({
  name: 'Login',
  setup: function (_, context) {
    onMounted(async () => {
      // 認証処理をスキップ
      context.emit('login')
    })
  }
})
</script>
