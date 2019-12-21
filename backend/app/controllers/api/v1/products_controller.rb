class Api::V1::ProductsController < ApplicationController
  include Api::V1::Doc::ProductsControllerDoc

  before_action :set_product, only: [:show, :update, :destroy]

  def index
    @products = Product.includes(:product_type).order("#{ProductType.collection_name}.name ASC", name: :asc)
  end

  def show;
  end

  def find_best_fit
    # if param cannot be converted to float it returns 0
    params[:length] = params[:length].to_f
    params[:width] = params[:width].to_f
    params[:height] = params[:height].to_f
    params[:weight] = params[:weight].to_f

    min_diff_product = Product.includes(:product_type).collection.
        aggregate([
                      {
                          '$match': {
                              '$and': [
                                  {length: {'$gte': params[:length]}},
                                  {width: {'$gte': params[:width]}},
                                  {height: {'$gte': params[:height]}},
                                  {weight: {'$gte': params[:weight]}}
                              ]
                          }
                      },
                      {
                          '$project': {
                              diff: {
                                  '$add': [
                                      {'$subtract': ['$length', params[:length]]},
                                      {'$subtract': ['$width', params[:width]]},
                                      {'$subtract': ['$height', params[:height]]},
                                      {'$subtract': ['$weight', params[:weight]]}
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
