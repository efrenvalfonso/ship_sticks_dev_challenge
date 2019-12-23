module Api
  module V1
    module Doc
      module ProductsControllerDoc
        extend Apipie::DSL::Concern

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

        def index;
        end

        api :GET, '/products/:id', 'Get a product'
        param :id, String, desc: 'Must be slug or id of the product', required: true
        error :not_found, 'Not Found'
        returns code: :ok do
          param_group :product_details
        end

        def show;
        end

        api :GET,
            '/products/find-best-fit',
            "Get the product that best fits for the selected dimensions and weight. It gets the product with
dimensions and weight greater than params and with the minimum sum of differences: min(length - params[:length] +
width - params[:width] + height - params[:height] + weight - params[:weight]). If params have the exact dimensions and
weight of a product then the difference is zero and it returns that product, otherwise, it looks for a product with
the less useless space and the less useless weight."
        param :length, String, desc: 'Length in <i>inches</i>', required: true
        param :width, String, desc: 'Width in <i>inches</i>', required: true
        param :height, String, desc: 'Height in <i>inches</i>', required: true
        param :weight, String, desc: 'Weight in <i>pounds</i>', required: true
        error :not_found, 'Not Found'
        returns code: :ok do
          param_group :product_details
        end

        def find_best_fit;
        end

        api :POST, '/products', 'Create a product'
        param_group :product_editable, as: :create

        def create;
        end

        api 'PUT/PATCH', '/products/:id', 'Update a product'
        param_group :product_editable
        error :not_found, 'Not Found'

        def update;
        end

        api :DELETE, '/products/:id', 'Delete a product'
        param :id, String, desc: 'Must be slug or id of the product', required: true
        error :not_found, 'Not Found'
        returns code: :no_content

        def destroy;
        end
      end
    end
  end
end
