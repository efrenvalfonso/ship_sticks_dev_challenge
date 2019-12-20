class Api::V1::ProductsController < ApplicationController
  before_action :set_product, only: [:show, :update, :destroy]

  def_param_group :product_details do
    param :id, String, desc: 'Product id', required: true
    param :product_type, Hash, desc: 'Product type', required: true do
      param :id, String, desc: 'Product type id', required: true
      param :slug, String, desc: 'Product type slug', required: true
      param :name, String, desc: 'Product type name', required: true
    end
    param :slug, String, desc: 'Product slug', required: true
    param_group :product_data, as: :create
  end

  def_param_group :product_editable do
    param :product_type_id, String, desc: 'Product type id'
    param_group :product_data
  end

  def_param_group :product_data do
    param :name, String, desc: 'Name of the product', required: true, action_aware: true
    param :length, :number, desc: 'Length of the product in <i>inches</i>', required: true, action_aware: true
    param :width, :number, desc: 'Width of the product in <i>inches</i>', required: true, action_aware: true
    param :height, :number, desc: 'Height of the product in <i>inches</i>', required: true, action_aware: true
    param :weight, :number, desc: 'Weight of the product in <i>pounds</i>', required: true, action_aware: true
  end

  api :GET, '/products', 'Get all products'
  returns array_of: :product_details, code: :ok, desc: 'All products'

  def index
    @products = Product.includes(:product_type).order("#{ProductType.collection_name}.name ASC").order(name: :asc)
  end

  api :GET, '/products/:id', 'Get a product'
  param :id, String, desc: 'Must be slug or id of the product', required: true
  error :not_found, 'Not Found'
  returns code: :ok do
    param_group :product_details
  end

  def show;
  end

  api :POST, '/products', 'Create a product'
  param_group :product_editable, as: :create

  def create
    @product = Product.new(product_params)

    if @product.save
      render :show, status: :created
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  api 'PUT/PATCH', '/products/:id', 'Update a product'
  param_group :product_editable
  error :not_found, 'Not Found'

  def update
    if @product.update(product_params)
      render :show
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  api :DELETE, '/products/:id', 'Delete a product'
  param :id, String, desc: 'Must be slug or id of the product', required: true
  error :not_found, 'Not Found'
  returns code: :no_content

  def destroy
    @product.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_product
    @product = Product.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def product_params
    params.require(:product).permit(:name, :product_type_id, :length, :width, :height, :weight)
  end
end
