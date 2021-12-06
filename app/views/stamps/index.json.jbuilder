json.array! @stamps do |stamp|
  show_front_image = @imprinted_stamp_ids.include?(stamp.id)
  json.partial! "stamps/stamp", stamp: stamp, show_front_image: show_front_image
end
