<template>
  <div>認証中...</div>
</template>

<script lang="ts">
import { defineComponent, onMounted } from 'vue'
import api from '@/api/api'
import liff from '@line/liff'
export default defineComponent({
  name: 'Login',
  setup: function (_, context) {
    onMounted(async () => {
      const liffId = await api.getLiffId()
      console.log({ liffId })
      await liff.init({ liffId })
      // LINEアプリ外で開いた時はログイン処理をする
      if (!liff.isLoggedIn()) {
        liff.login()
        return
      }
      const liffContext = liff.getContext()
      if (!liffContext || !liffContext.userId) {
        window.alert('コンテキストの取得に失敗しました。')
        return
      }
      const userId = liffContext.userId
      const accessToken = await liff.getAccessToken()
      if (!accessToken) {
        window.alert('LIFFの認証に失敗しました。')
        return
      }
      const res1 = await api.signIn(userId, accessToken)
      if (res1 && res1.status === 200) {
        context.emit('login')
        return
      }
      const res2 = await api.signUp(userId, accessToken)
      if (res2 && res2.status === 200) {
        context.emit('login')
        return
      }
      window.alert('認証に失敗しました。')
    })
  }
})
</script>
