json.extract! stamp, :id, :name, :back_image
if show_front_image
  json.front_image stamp.front_image
end
