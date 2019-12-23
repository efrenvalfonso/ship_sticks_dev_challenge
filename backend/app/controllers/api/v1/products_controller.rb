class Api::V1::ProductsController < ApplicationController
  include Api::V1::Doc::ProductsControllerDoc

  before_action :set_product, only: [:show, :update, :destroy]

  def index
    @products = Product.includes(:product_type).order("#{ProductType.collection_name}.name ASC", name: :asc)
  end

  def show;
  end

  # Get the product that best fits for the selected dimensions and weight based in that with shipping packages,
  # you can always go bigger, but you can’t go smaller (i.e. if an item is 5"x5"x5", you will need the 6"x5"x6" package,
  # not the 4"x5"x5" package). This is also the case for weight.
  #
  # Heuristic finds the product with dimensions and weight greater than params and with the minimum sum of differences:
  #
  #   min(length - params[:length] + width - params[:width] + height - params[:height] + weight - params[:weight])
  #
  # If params have the exact dimensions and weight of a product then the difference is zero and it returns that
  # product, otherwise, it looks for a product with the less useless space and the less useless weight.
  #
  # All the calculations were delegated to database engine instead the api server.
  def find_best_fit
    # if param cannot be converted to float it returns 0
    params[:length] = params[:length].to_f
    params[:width] = params[:width].to_f
    params[:height] = params[:height].to_f
    params[:weight] = params[:weight].to_f

    min_diff_product = Product.collection.aggregate([
                      {
                          # find products with dimensions and weight greater than given in params
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
                          # map products to a field with the sum of differences
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
                          # sort ascending by differences
                          '$sort': {
                              'diff': 1
                          }
                      },
                      {
                          # get the first result, the minimum difference
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
