<template>
  <div>
    <label for="email">
      Email
    </label>
    <input v-model="email" id="Email" type="text" placeholder="Email">
  </div>
  <div>
    <label for="password">
      Password
    </label>
    <input v-model="password" id="password" type="password" placeholder="******************">
  </div>
  <button @click="handleLogin()">
    Sign In
  </button>
</template>

<script lang="ts">
import { defineComponent, reactive, toRefs } from 'vue'
import { login } from '@/api/auth'

export default defineComponent({
  name: 'Home',
  setup (_, context) {
    const formData = reactive({
      email: '',
      password: ''
    })

    return {
      ...toRefs(formData),
      handleLogin: async (): Promise<void> => {
        try {
          const res = await login(formData.email, formData.password)
          if (res?.status !== 200) {
            alert('メールアドレスかパスワードが間違っています。')
            return
          }
          console.log(res)
          context.emit('login')
          return
        } catch (e) {
          alert('ログインに失敗しました。')
        }
      }
    }
  }
})
</script>
