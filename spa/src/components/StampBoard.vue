<template>
  <StampBoardPresent
    :gods="gods"
    :new-god="gods[2]"
  />
</template>
<script lang="ts">
import { God } from '@/types/god'
import StampBoardPresent from '@/components/StampBoardPresent.vue'

const gods: Array<God> = [
  {
    id: 'benzaiten',
    name: '弁財天',
    image: 'images/irasutoya/benzaiten.png',
    stamp: 'images/stamp/benzaiten.png',
    place: '鶴岡八幡宮',
    position: { x: 235, y: 50 },
    color: '#ff7777'
  },
  {
    id: 'juroujin',
    name: '寿老人',
    image: 'images/irasutoya/juroujin.png',
    stamp: 'images/stamp/juroujin.png',
    place: '妙隆寺',
    position: { x: 240, y: 190 },
    color: '#ab5239'
  },
  {
    id: 'hotei',
    name: '布袋尊',
    image: 'images/irasutoya/hotei.png',
    stamp: 'images/stamp/hotei.png',
    place: '浄智寺',
    position: { x: 185, y: 310 },
    color: '#ea9f53'
  },
  {
    id: 'fukurokuju',
    name: '福禄寿',
    image: 'images/irasutoya/fukurokuju.png',
    stamp: 'images/stamp/fukurokuju.jpg',
    place: '御霊神社',
    position: { x: 120, y: 0 },
    color: '#77bb77'
  },
  {
    id: 'daikokuten',
    name: '大黒天',
    image: 'images/irasutoya/daikokuten.png',
    stamp: 'images/stamp/daikokuten.jpg',
    place: '長谷寺',
    position: { x: 0, y: 190 },
    color: '#9999aa'
  },
  {
    id: 'bisyamonten',
    name: '毘沙門天',
    image: 'images/irasutoya/bisyamonten.png',
    stamp: 'images/stamp/bisyamonten.png',
    place: '宝戒寺',
    position: { x: 5, y: 50 },
    color: '#738eeb'
  },
  {
    id: 'ebisusama',
    name: '恵比寿',
    image: 'images/irasutoya/ebisusama.png',
    stamp: 'images/stamp/ebisusama.png',
    place: '宝戒寺',
    position: { x: 55, y: 310 },
    color: '#bb89ff'
  }
]
export default {
  components: { StampBoardPresent },
  setup () {
    return { gods }
  }
}
</script>
