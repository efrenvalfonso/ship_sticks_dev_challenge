class Product
  include Mongoid::Document

  belongs_to :product_type

  field :name, type: String
  field :length, type: Integer, default: 0
  field :width, type: Integer, default: 0
  field :height, type: Integer, default: 0
  field :weight, type: Integer, default: 0

  index({ product_type_id: 1, name: 1 }, { unique: true })
end
