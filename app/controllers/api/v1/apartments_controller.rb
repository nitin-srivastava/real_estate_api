module Api
  module V1
    class ApartmentsController < ApplicationController

      before_action :set_apartment, only: [:show]

      def index
        @apartments = Apartment.order(:created_at)
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

      private

      def apartment_params
        params.require(:apartment).permit(:street, :city, :zip, :state, :beds, :baths, :sq_ft, :apartment_type, :price, :sale_date, :latitude, :longitude)
      end

      def set_apartment
        @apartment = Apartment.find(params[:id])
      end

    end
  end
end