json.extract! stamp, :id, :key, :name, :back_image, :color
json.imprinted imprinted
if show_front_image
  json.front_image stamp.front_image
end
