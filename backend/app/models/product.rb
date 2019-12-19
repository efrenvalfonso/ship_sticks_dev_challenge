class Product
  include Mongoid::Document

  validates_presence_of :product_type, :name, :length, :width, :height, :weight
  validates_uniqueness_of :name, scope: :product_type
  validates_numericality_of :length, greater_than: 0
  validates_numericality_of :width, greater_than: 0
  validates_numericality_of :height, greater_than: 0
  validates_numericality_of :weight, greater_than: 0

  belongs_to :product_type

  field :name, type: String
  field :length, type: Integer, default: 0
  field :width, type: Integer, default: 0
  field :height, type: Integer, default: 0
  field :weight, type: Integer, default: 0

  index({ product_type_id: 1, name: 1 }, { unique: true })
end
