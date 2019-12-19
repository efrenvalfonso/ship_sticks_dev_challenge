data = JSON.parse(File.read("#{File.dirname(__FILE__ )}/data/products.json"))
data['products'].each do |product_data|
  product_type = ProductType.find_or_create_by(name: product_data['type'])

  puts 'Creating product: ' + product_data['type'] + ' - ' + product_data['name']
  Product.create product_type: product_type,
                 name: product_data['name'],
                 length: product_data['length'],
                 width: product_data['width'],
                 height: product_data['height'],
                 weight: product_data['weight']
end
