<template>
  <div class="for-test">
    <div class="test-title">
      <div @click="() => showContent = !showContent">テスト用</div>
    </div>
    <div v-show="showContent" class="test-content">
      <a href="/?sid=1&act_key=2150A828-B031-4D98-BC61-78CD4A5FD525">福禄寿</a>
      <a href="/?sid=2&act_key=1D0A5038-1256-4291-968D-93915DAC8EDC">弁財天</a>
      <a href="/?sid=3&act_key=7762F1F0-9A3A-4D89-A4D5-EB3F8BFE1C60">寿老人</a>
      <a href="/?sid=4&act_key=32887E87-8E93-4AA8-8C98-2F5C958F52DE">布袋尊</a>
      <a href="/?sid=5&act_key=B889E58D-22AF-4192-A13A-6F3DD2592115">恵比寿</a>
      <a href="/?sid=6&act_key=1257CC71-2100-4F6D-B2EA-CE22F85952D3">大黒天</a>
      <a href="/?sid=7&act_key=9FB2BF2D-EE62-4C2C-B78D-C83F1C75901D">毘沙門天</a>
    </div>
  </div>
</template>
<script lang="ts">
import { ref, defineComponent } from 'vue'
export default defineComponent({
  setup () {
    const showContent = ref(false)
    return { showContent }
  }
})
</script>
<style scoped lang="sass">
.for-test
  position: fixed
  bottom: 0
  left: 0
  .test-title
    display: flex
    div
      margin: 0 0 0 4px
      padding: 2px 12px 2px 12px
      background-color: #bababa
      color: #ffffff
  .test-content
    border-top: 1px solid #bababa
    padding: 8px 8px 8px 8px
  a
    margin-left: 12px
    display: inline-block
</style>
