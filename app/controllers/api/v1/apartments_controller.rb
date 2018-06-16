module Api
  module V1
    class ApartmentsController < ApplicationController

      before_action :set_apartment, only: [:show, :update, :destroy]

      def index
        @apartments = Apartment.order(:created_at).page(current_page).per_page(per_page)
        render status: :ok
      end

      def show
        render status: :ok
      end

      def create
        @apartment = Apartment.new(apartment_params)
        if @apartment.save
          render status: :ok, json: { success: 'Apartment was created successfully.' }
        else
          render status: :unprocessable_entity, json: { errors: @apartment.errors.full_messages }
        end
      end

      def update
        if @apartment.update_attributes(apartment_params)
          render status: :ok, json: { success: 'Apartment was updated successfully.' }
        else
          render status: :unprocessable_entity, json: { errors: @apartment.errors.full_messages }
        end
      end

      def destroy
        if @apartment.destroy
          render status: :ok, json: { success: 'Apartment was deleted successfully.' }
        end
      end

      private

      def apartment_params
        params.require(:apartment).permit(:street, :city, :zip, :state, :beds, :baths, :area, :apartment_type, :price, :sale_date, :latitude, :longitude)
      end

      def set_apartment
        @apartment = Apartment.find(params[:id])
      rescue
        render status: :unprocessable_entity, json: { errors: 'Record not found' }
      end

      def current_page
        return params[:page].to_i unless params[:page].blank?
        1
      end

      def per_page
        return params[:per_page].to_i unless params[:per_page].blank?
        10
      end

    end
  end
end