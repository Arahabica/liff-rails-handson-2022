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
import { getNewStamp, getStamps, pushStamp } from '@/api/stamps'
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
        const newStampData = await getNewStamp(props.newStampId, props.activationKey)
        newStamp.value = buildStamp(newStampData)
      }
      const stampData = await getStamps()
      stamps.value = stampData.map(stamp => buildStamp(stamp))
    }
    const pushed = async () => {
      const newStampValue = newStamp.value
      if (!newStampValue) {
        throw new Error('new stamp is not found.')
      }
      const index = stamps.value.findIndex(s => s.id === newStampValue.id)
      stamps.value[index] = newStampValue
      stamps.value[index].imprinted = true
      try {
        await pushStamp(newStampValue.id, props.activationKey)
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
})
</script>
