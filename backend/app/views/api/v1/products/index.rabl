collection @products

attributes :name, :length, :width, :height, :weight
node(:type) { |product| product.product_type.name}
