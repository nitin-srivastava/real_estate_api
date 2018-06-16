module Api
  module V1
    class ApartmentsController < ApplicationController

      def index
        @apartments = Apartment.order(:created_at)
        render status: :ok
      end

    end
  end
end