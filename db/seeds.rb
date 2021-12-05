# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
stamps = [
  {
    key: 'benzaiten',
    name: '弁財天',
    back_image: 'images/irasutoya/benzaiten.png',
    front_image: 'images/stamp/benzaiten.png'
  },
  {
    key: 'juroujin',
    name: '寿老人',
    back_image: 'images/irasutoya/juroujin.png',
    front_image: 'images/stamp/juroujin.png'
  },
  {
    key: 'hotei',
    name: '布袋尊',
    back_image: 'images/irasutoya/hotei.png',
    front_image: 'images/stamp/hotei.png'
  },
  {
    key: 'fukurokuju',
    name: '福禄寿',
    back_image: 'images/irasutoya/fukurokuju.png',
    front_image: 'images/stamp/fukurokuju.jpg'
  },
  {
    key: 'daikokuten',
    name: '大黒天',
    back_image: 'images/irasutoya/daikokuten.png',
    front_image: 'images/stamp/daikokuten.jpg'
  },
  {
    key: 'bisyamonten',
    name: '毘沙門天',
    back_image: 'images/irasutoya/bisyamonten.png',
    front_image: 'images/stamp/bisyamonten.png'
  },
  {
    key: 'ebisusama',
    name: '恵比寿',
    back_image: 'images/irasutoya/ebisusama.png',
    front_image: 'images/stamp/ebisusama.png'
  }
]
Stamp.create(stamps)