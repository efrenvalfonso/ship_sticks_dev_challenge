class ProductType
  include Mongoid::Document

  has_many :products

  field :name, type: String

  index({ name: 1 }, { unique: true })
end
