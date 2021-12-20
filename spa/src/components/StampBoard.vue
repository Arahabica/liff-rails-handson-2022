<template>
  <Login v-if="!loggedIn" @login="login"/>
  <StampBoardPresent
    v-if="loggedIn"
    :stamps="stamps"
    :new-stamp="newStamp"
    @pushed="pushed"
  />
  <ForTest v-if="loggedIn"/>
</template>
<script lang="ts">
import { PropType, ref, defineComponent } from 'vue'
import { Stamp } from '@/types/stamp'
import api from '@/api/api'
import Login from '@/components/Login.vue'
import StampBoardPresent from '@/components/StampBoardPresent.vue'
import ForTest from '@/components/ForTest.vue'

export default defineComponent({
  components: { ForTest, StampBoardPresent, Login },
  props: {
    newStampId: {
      type: Object as PropType<number>,
      required: true
    },
    activationKey: {
      type: Object as PropType<string>,
      required: true
    }
  },
  setup (props) {
    const loggedIn = ref(false)
    const stamps = ref([] as Array<Stamp>)
    const newStamp = ref(null as Stamp | null)
    const login = async () => {
      loggedIn.value = true
      if (props.newStampId) {
        newStamp.value = await api.getNewStamp(props.newStampId, props.activationKey)
      }
      stamps.value = await api.getStamps()
    }
    const pushed = async () => {
      if (!newStamp.value) {
        throw new Error('new stamp is not found.')
      }
      await api.pushStamp(newStamp.value.id, props.activationKey)
      stamps.value = await api.getStamps()
    }
    return {
      loggedIn,
      login,
      pushed,
      newStamp,
      stamps
    }
  }
})
</script>
