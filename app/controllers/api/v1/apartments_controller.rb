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

      private

      def set_apartment
        @apartment = Apartment.find(params[:id])
      end

    end
  end
end