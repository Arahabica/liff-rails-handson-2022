import { StampData, Stamp } from '@/types/stamp'
import { stampPresentations } from '@/stampPresentations'

export const buildStamp = (data: StampData): Stamp => {
  const presentation = stampPresentations.find(s => s.key === data.key)
  if (!presentation) {
    throw new Error('stamp presentation is not found')
  }
  return {
    id: data.id,
    key: data.key,
    name: data.name,
    front_image: data.front_image || '',
    back_image: data.back_image || '',
    imprinted: data.imprinted,
    color: presentation.color
  }
}
