object @product

node(:id) { |product| product.id.to_s }
child(:product_type) do
  node(:id) { |product_type| product_type.id.to_s }
  attributes :slug, :name
end
attributes :slug, :name, :length, :width, :height, :weight