<template>
  <Login v-if="!loggedIn" @login="login"/>
  <StampBoardPresent
    v-if="loggedIn"
    :stamps="stamps"
    :new-stamp="newStamp"
    @pushed="pushed"
  />
</template>
<script lang="ts">
import { PropType, ref, defineComponent } from 'vue'
import { Stamp } from '@/types/stamp'
import * as api from '@/api/stamps'
import { buildStamp } from '@/utils/buildStamp'
import Login from '@/components/Login.vue'
import StampBoardPresent from '@/components/StampBoardPresent.vue'

export default defineComponent({
  components: { StampBoardPresent, Login },
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
        const newStampData = await api.getNewStamp(props.newStampId, props.activationKey)
        newStamp.value = buildStamp(newStampData)
      }
      const stampData = await api.getStamps()
      stamps.value = stampData.map(stamp => buildStamp(stamp))
    }
    const pushed = async () => {
      if (!newStamp.value) {
        throw new Error('new stamp is not found.')
      }
      await api.pushStamp(newStamp.value.id, props.activationKey)
      const stampData = await api.getStamps()
      stamps.value = stampData.map(stamp => buildStamp(stamp))
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
