module Spree
  module Admin
    ImagesController.class_eval do

      private

      def load_data
        @product = Spree::Product.find_by_permalink(params[:product_id])
      end

      def set_viewable
        @image.viewable = @product
        
        if params[:shareable_id] && !params[:shareable_id].blank? # Check if "Product" option was selected
          # Assign to product
          @image.products << @product unless @image.products.include?(@product)
          params.delete(:shareable_id)
        else # "Product" option not selected
          # Check if at least one variant selected, if not assign to "Product"
          variant_ids = params[:image][:variant_ids].detect {|i| !i.blank?}
          unless variant_ids
            @image.products << @product unless @image.products.include?(@product)
          else # "Product" option not selected, delete if it exists
            shares = @image.assets_shares.find_all_by_shareable_type('Product')
            shares.each{|s| s.destroy if s.shareable_id == @product.id} if shares.size > 0
          end
        end
      end

      def destroy_before
      end
    end
  end
end