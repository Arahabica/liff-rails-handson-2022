<template>
  <div id="app">
    <div v-show="showOverlap" class="overlap">
      <div class="stamp-desc">↑スタンプを押してね</div>
    </div>
    <h1>鎌倉七福神巡り</h1>
    <div id="stamps-board">
      <div class="stamp" :style="style.center">
        <div>
          <img src="images/irasutoya/takarabune.png" :width="size" :height="size"/>
        </div>
      </div>
      <div v-for="(stamp, i) in stamps" :key="stamp.id" class="stamp" :style="getStampPosition(i)">
        <div class="stamp-wrapper" :style="{ width: `${size}px`, height: `${size}px`}">
          <div class="stamp-back">
            <img v-if="!stamp.imprinted" :src="stamp.back_image" :width="size" :height="size"/>
          </div>
          <div v-if="stamp.imprinted" class="imprint" :style="getStampStyle(stamp)">
            <img :src="stamp.front_image" :width="size" :height="size"/>
          </div>
        </div>
        <div class="stamp-name" :style="getStampNameStyle(stamp)">{{stamp.name}}</div>
      </div>
      <div
        v-if="newStamp"
        v-show="showBigStamp"
        class="imprint imprint-animation"
        :style="style.stampAnimation"
        @click="pushStamp"
      >
        <img :src="newStamp.front_image" :width="size" :height="size"/>
      </div>
    </div>
    <h3>{{message}}</h3>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, PropType, watch, computed } from 'vue'
import { Howl } from 'howler'
import { Stamp } from '@/types/stamp'

const size = 88
const r = 120
const fullWidth = 350

export default defineComponent({
  name: 'StampBoardPresent',
  props: {
    stamps: {
      type: Object as PropType<Array<Stamp>>,
      required: true
    },
    newStamp: {
      type: Object as PropType<Stamp | null>,
      required: true
    }
  },
  setup (props, context) {
    const stampSound = new Howl({
      src: ['audio/kotsudumi.mp3']
    })
    const center = [fullWidth * 0.5, r + size * 0.5]
    const getStampPosition = (index: number) => {
      const result = []
      const rad = index / props.stamps.length * 2 * Math.PI
      const x = Math.round(center[0] + Math.sin(rad) * r - size * 0.5)
      const y = Math.round(center[1] + Math.cos(rad) * -r - size * 0.5)
      return {
        width: `${size}px`,
        top: `${y}px`,
        left: `${x}px`
      }
    }
    const getStampStyle = (stamp: Stamp) => {
      return {
        outline: `1px solid ${stamp.color}`,
        width: `${size}px`,
        height: `${size}px`,
        borderRadius: `${size * 0.5}px`
      }
    }
    const getStampNameStyle = (stamp: Stamp) => {
      return {
        color: stamp.color
      }
    }
    const showOverlap = ref(false)
    const showBigStamp = ref(false)
    const style = ref({
      center: {
        top: `${center[1] - size * 0.5}px`,
        left: `${center[0] - size * 0.5}px`,
        width: `${size}px`
      },
      stampAnimation: {
        outline: '1px solid #000000',
        top: '155px',
        left: '120px',
        transform: 'scale(3)',
        width: `${size}px`,
        height: `${size}px`
      }
    })
    const syncNewStamp = (newStamp: Stamp | null) => {
      const hasNewStamp = Boolean(newStamp)
      showOverlap.value = hasNewStamp
      showBigStamp.value = hasNewStamp
      if (newStamp) {
        style.value.stampAnimation.outline = `1px solid ${newStamp.color}`
      }
    }
    syncNewStamp(props.newStamp)
    const pushStamp = () => {
      const stamp = props.newStamp as Stamp
      stampSound.play()
      const index = props.stamps.findIndex(s => s.key === stamp.key)
      const position = getStampPosition(index)
      style.value.stampAnimation = {
        outline: `1px solid ${stamp.color}`,
        top: position.top,
        left: position.left,
        transform: 'scale(1)',
        width: `${size}px`,
        height: `${size}px`
      }
      showOverlap.value = false
      showBigStamp.value = true
      setTimeout(() => {
        showBigStamp.value = false
        context.emit('pushed')
      }, 400)
    }
    const message = computed(() => {
      const imprintedCount = props.stamps.filter(stamp => stamp.imprinted).length
      if (imprintedCount === 0) {
        return 'スタンプを7つ集めてクッキーをゲットしよう！'
      } else if (imprintedCount < 7) {
        return `スタンプはあと${7 - imprintedCount}つです`
      } else {
        return 'コンプリートおめでとう！'
      }
    })
    watch(() => props.newStamp, (newStamp: Stamp | null) => {
      syncNewStamp(newStamp)
    })
    return {
      style,
      size,
      message,
      showOverlap,
      showBigStamp,
      getStampPosition,
      getStampStyle,
      getStampNameStyle,
      pushStamp
    }
  }
})
</script>
<style scoped lang="sass">
#app
  position: relative
  h1
    text-align: center
    font-size: 22px
    font-weight: normal
    color: #212121
  .overlap
    position: absolute
    width: 100%
    height: 100%
    background-color: rgba(255, 255, 255, 0.8)
    z-index: 2
    display: flex
    justify-content: center
    align-items: center
    flex-direction: column
    .stamp-desc
      position: absolute
      bottom: 0
      left: 0
      width: 100%
      height: 40px
      font-size: 20px
      color: #222222
      text-align: center
#stamps-board
  position: relative
  width: 350px
  height: 350px
  margin: 35px auto 0 auto
  .stamp
    display: flex
    justify-content: center
    // margin: 5px 0 5px 0
    flex-direction: column
    position: absolute
    .name
      text-align: center
      font-size: 12px
      margin-bottom: 4px

    .stamp-wrapper
      position: relative

    .stamp-back
      position: absolute
      img
        object-fit: contain
        filter: grayscale(100)
    .stamp-name
      text-align: center
      font-size: 11px
      font-weight: bold
      font-family: "游明朝", YuMincho, "Hiragino Mincho ProN W3", "ヒラギノ明朝 ProN W3", "Hiragino Mincho ProN", "HG明朝E", "ＭＳ Ｐ明朝", "ＭＳ 明朝", serif

  .imprint
    position: absolute
    overflow: hidden
    img
      object-fit: cover

  .imprint-animation
    z-index: 3
    transition: 0.4s cubic-bezier(0.165, 0.840, 0.440, 1.000)
h3
  color: #666666
  font-size: 20px
  font-weight: normal
  text-align: center
</style>
