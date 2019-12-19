class ProductType
  include Mongoid::Document

  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :products

  field :name, type: String

  index({ name: 1 }, { unique: true })
end
