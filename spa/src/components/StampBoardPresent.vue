<template>
  <div id="app">
    <div v-show="showOverlap" class="overlap">
      <div class="stamp-desc">↑スタンプを押してね</div>
    </div>
    <h1>鎌倉七福神巡り</h1>
    <div id="stamps-board">
      <div class="stamp takarabune">
        <div>
          <img src="images/irasutoya/takarabune.png" width="110" height="110"/>
        </div>
      </div>
      <div v-for="stamp in stamps" :key="stamp.id" class="stamp" :style="getStampPosition(stamp)">
        <div class="stamp-wrapper">
          <div class="stamp-back">
            <img v-if="!stamp.imprinted" :src="stamp.back_image" width="110" height="110"/>
          </div>
          <div v-if="stamp.imprinted" class="imprint" :style="getStampStampStyle(stamp)">
            <img :src="stamp.front_image" width="110" height="110"/>
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
        <img :src="newStamp.front_image" width="110" height="110"/>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, PropType, watch } from 'vue'
import { Howl } from 'howler'
import { Stamp } from '@/types/stamp'

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
    const getStampPosition = (stamp: Stamp) => {
      return {
        top: stamp.position.y + 'px',
        left: stamp.position.x + 'px'
      }
    }
    const getStampStampStyle = (stamp: Stamp) => {
      return {
        outline: `1px solid ${stamp.color}`
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
      stampAnimation: {
        outline: '1px solid #000000',
        top: '155px',
        left: '120px',
        transform: 'scale(3)'
      }
    })
    const syncNewStamp = (newStamp: Stamp) => {
      const hasNewStamp = Boolean(newStamp)
      showOverlap.value = hasNewStamp
      showBigStamp.value = hasNewStamp
      if (hasNewStamp) {
        style.value.stampAnimation.outline = `1px solid ${newStamp.color}`
      }
    }
    syncNewStamp(props.newStamp)
    const pushStamp = () => {
      const stamp = props.newStamp as Stamp
      stampSound.play()
      style.value.stampAnimation = {
        outline: `1px solid ${stamp.color}`,
        top: `${stamp.position.y}.px`,
        left: `${stamp.position.x}.px`,
        transform: 'scale(1)'
      }
      showOverlap.value = false
      showBigStamp.value = true
      setTimeout(() => {
        showBigStamp.value = false
        context.emit('pushed')
      }, 400)
    }
    watch(() => props.newStamp, (newStamp: Stamp) => {
      syncNewStamp(newStamp)
    })
    return {
      style,
      showOverlap,
      showBigStamp,
      getStampPosition,
      getStampStampStyle,
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
  height: 475px
  margin: 70px auto 0 auto
  .stamp
    width: 110px
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
      width: 110px
      height: 110px

    .stamp-back
      position: absolute
      img
        object-fit: contain
        filter: grayscale(100)
    .stamp-name
      text-align: center
      font-size: 12px
      font-weight: bold
      font-family: "游明朝", YuMincho, "Hiragino Mincho ProN W3", "ヒラギノ明朝 ProN W3", "Hiragino Mincho ProN", "HG明朝E", "ＭＳ Ｐ明朝", "ＭＳ 明朝", serif

  .imprint
    position: absolute
    width: 110px
    height: 110px
    border-radius: 55px
    overflow: hidden
    img
      object-fit: cover

  .takarabune
    position: absolute
    top: 170px
    left: 120px
  .imprint-animation
    position: absolute
    z-index: 3
    transition: 0.4s cubic-bezier(0.165, 0.840, 0.440, 1.000)
</style>
