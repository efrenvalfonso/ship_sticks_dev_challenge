class ProductType
  include Mongoid::Document
  include Mongoid::Slug

  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :products

  field :name, type: String
  slug :name

  index({ name: 1 }, { unique: true })
end
