<template>
  <button @click="handleLogout()">Logout</button>
</template>

<script lang="ts">
import { defineComponent } from 'vue'
import { logout } from '@/api/auth'
import router from '@/router'

export default defineComponent({
  name: 'Home',
  setup () {
    const handleLogout = () => {
      logout().then(() => {
        router.push('/about')
      })
    }
    return {
      handleLogout
    }
  }
})
console.log(process.env.VUE_APP_API_BASE)
</script>
