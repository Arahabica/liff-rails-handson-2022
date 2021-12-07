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
import { PropType, ref, watchEffect } from 'vue'
import { Stamp, StampPresentation } from '@/types/stamp'
import { getNewStamp, getStamps, pushStamp } from '@/api/stamps'
import { buildStamp } from '@/utils/buildStamp'
import Login from '@/components/Login.vue'
import StampBoardPresent from '@/components/StampBoardPresent.vue'

export default {
  components: { StampBoardPresent, Login },
  props: {
    newStampId: {
      type: String as PropType<string>,
      required: true
    },
    activationKey: {
      type: String as PropType<string>,
      required: true
    }
  },
  setup (props) {
    const loggedIn = ref(false)
    const stamps = ref([] as Array<Stamp>)
    const newStamp = ref(null as Stamp | null)
    const newStampId = props.newStampId
    const activationKey = props.activationKey
    const login = async () => {
      loggedIn.value = true
      if (newStampId) {
        const newStampData = await getNewStamp(newStampId, activationKey)
        newStamp.value = buildStamp(newStampData)
      }
      const stampData = await getStamps()
      stamps.value = stampData.map(stamp => buildStamp(stamp))
    }
    const pushed = async () => {
      const index = stamps.value.findIndex(s => s.id === newStamp.value.id)
      stamps.value[index] = newStamp.value
      stamps.value[index].imprinted = true
      try {
        await pushStamp(newStamp.value.id, activationKey)
      } catch (e) {
        stamps.value[index].front_image = ''
        stamps.value[index].imprinted = false
      }
    }
    return {
      loggedIn,
      login,
      pushed,
      newStamp,
      stamps
    }
  }
}
</script>
