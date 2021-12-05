<template>
  <StampBoard />
</template>

<script lang="ts">
import { defineComponent } from 'vue'
import StampBoard from '@/components/StampBoard.vue'

export default defineComponent({
  name: 'Home',
  components: { StampBoard }
})
</script>
