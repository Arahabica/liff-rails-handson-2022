json.array! @stamps do |stamp|
  imprinted = @imprinted_stamp_ids.include?(stamp.id)
  json.partial! "stamps/stamp", stamp: stamp, imprinted: imprinted, show_front_image: imprinted
end
