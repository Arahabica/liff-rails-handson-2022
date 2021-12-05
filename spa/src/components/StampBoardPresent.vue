<template>
  <div id="app">
    <div v-show="showOverlap" class="overlap">
      <div class="stamp-desc">↑スタンプを押してね</div>
    </div>
    <h1>鎌倉七福神巡り</h1>
    <div id="stamps-board">
      <div class="god takarabune">
        <div>
          <img src="images/irasutoya/takarabune.png" width="110" height="110"/>
        </div>
      </div>
      <div v-for="god in gods" :key="god.id" class="god" :style="getGodPosition(god)">
        <div v-if="false" class="name">{{god.name}}</div>
        <div class="stamp-wrapper">
          <div class="stamp-back">
            <img v-if="false" :src="god.image" width="110" height="110"/>
          </div>
          <div v-if="god.stamp" class="stamp" :style="getGodStampStyle(god)">
            <img :src="god.stamp" width="110" height="110"/>
          </div>
        </div>
        <div class="place" :style="getGodPlaceStyle(god)">{{god.name}}</div>
      </div>
      <div
        v-if="newGod"
        v-show="showBigStamp"
        class="stamp stamp-animation"
        :style="style.stampAnimation"
        @click="pushStamp"
      >
        <img :src="newGod.stamp" width="110" height="110"/>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, PropType } from 'vue'
import { Howl } from 'howler'
import { God } from '@/types/god'

export default defineComponent({
  name: 'StampBoardPresent',
  props: {
    gods: {
      type: Object as PropType<Array<God>>,
      required: true
    },
    newGod: {
      type: Object as PropType<God | null>,
      required: true
    }
  },
  setup (props) {
    const stampSound = new Howl({
      src: ['audio/kotsudumi.mp3']
    })
    const getGodPosition = (god: God) => {
      return {
        top: god.position.y + 'px',
        left: god.position.x + 'px'
      }
    }
    const getGodStampStyle = (god: God) => {
      return {
        outline: `1px solid ${god.color}`
      }
    }
    const getGodPlaceStyle = (god: God) => {
      return {
        color: god.color
      }
    }
    const hasNewGod = Boolean(props.newGod)
    const showOverlap = ref(hasNewGod)
    const showBigStamp = ref(hasNewGod)
    const style = ref({
      stampAnimation: {
        outline: '1px solid #000000',
        top: '155px',
        left: '120px',
        transform: 'scale(3)'
      }
    })
    if (props.newGod) {
      style.value.stampAnimation.outline = `1px solid ${props.newGod.color}`
    }
    const pushStamp = () => {
      const god = props.newGod as God
      stampSound.play()
      style.value.stampAnimation = {
        outline: `1px solid ${god.color}`,
        // top: `${god.position.y + 27}.px`,
        top: `${god.position.y}.px`,
        left: `${god.position.x}.px`,
        transform: 'scale(1)'
      }
      showOverlap.value = false
      setTimeout(() => {
        showBigStamp.value = false
      }, 400)
    }
    return {
      style,
      showOverlap,
      showBigStamp,
      getGodPosition,
      getGodStampStyle,
      getGodPlaceStyle,
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
  .god
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
    .place
      text-align: center
      font-size: 12px
      font-weight: bold
      font-family: "游明朝", YuMincho, "Hiragino Mincho ProN W3", "ヒラギノ明朝 ProN W3", "Hiragino Mincho ProN", "HG明朝E", "ＭＳ Ｐ明朝", "ＭＳ 明朝", serif

  .stamp
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
  .stamp-animation
    position: absolute
    z-index: 3
    transition: 0.4s cubic-bezier(0.165, 0.840, 0.440, 1.000)
</style>
