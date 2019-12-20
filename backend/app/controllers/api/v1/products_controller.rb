class Api::V1::ProductsController < ApplicationController
  include Api::V1::Doc::ProductsControllerDoc

  before_action :set_product, only: [:show, :update, :destroy]

  def index
    @products = Product.includes(:product_type).order("#{ProductType.collection_name}.name ASC", name: :asc)
  end

  def show;
  end

  def find_best_fit
    params[:length] ||= 0
    params[:width] ||= 0
    params[:height] ||= 0
    params[:weight] ||= 0

    min_diff_product = Product.includes(:product_type).collection.
        aggregate([
                      {
                          '$match': {
                              '$and': [
                                  {length: {'$gte': params[:length].to_i}},
                                  {width: {'$gte': params[:width].to_i}},
                                  {height: {'$gte': params[:height].to_i}},
                                  {weight: {'$gte': params[:weight].to_i}}
                              ]
                          }
                      },
                      {
                          '$project': {
                              diff: {
                                  '$add': [
                                      {'$subtract': ['$length', params[:length].to_i]},
                                      {'$subtract': ['$width', params[:width].to_i]},
                                      {'$subtract': ['$height', params[:height].to_i]},
                                      {'$subtract': ['$weight', params[:weight].to_i]}
                                  ]
                              }
                          }
                      },
                      {
                          '$sort': {
                              'diff': 1
                          }
                      },
                      {
                          '$limit': 1
                      }
                  ]).first

    min_diff_product ||= {_id: nil}
    @product = Product.includes(:product_type).find(min_diff_product['_id'].to_s)

    render :show
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      render :show, status: :created
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      render :show
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_product
    @product = Product.includes(:product_type).find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def product_params
    params.require(:product).permit(:name, :product_type_id, :length, :width, :height, :weight)
  end
end
