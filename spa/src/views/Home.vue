<template>
  <StampBoard
    :new-stamp-id="newStampId"
    :activation-key="activationKey"
  />
</template>

<script lang="ts">
import { defineComponent } from 'vue'
import { useRoute } from 'vue-router'
import StampBoard from '@/components/StampBoard.vue'

export default defineComponent({
  name: 'Home',
  components: { StampBoard },
  setup () {
    const route = useRoute()
    const newStampId = Number(route.query.sid || null)
    const activationKey = route.query.act_key || null
    return {
      newStampId,
      activationKey
    }
  }
})
</script>
