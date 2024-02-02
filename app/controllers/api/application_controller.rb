# frozen_string_literal: true

module Api
  class ApplicationController < ActionController::API
    before_action :authenticate_user!

    rescue_from ActiveRecord::RecordNotFound,        with: :render_not_found
    rescue_from ActiveRecord::RecordInvalid,         with: :render_record_invalid
    rescue_from ActionController::ParameterMissing,  with: :render_parameter_missing
    rescue_from ActionController::BadRequest,        with: :render_bad_request

    private

    def render_not_found(exception)
      Rails.logger.info { exception }
      render json: { error: "Couldn't find the resource" }, status: :not_found
    end

    def render_record_invalid(exception)
      Rails.logger.info { exception }
      render json: { errors: exception.record.errors.as_json }, status: :bad_request
    end

    def render_parameter_missing(exception)
      Rails.logger.info { exception }
      render json: { error: 'A required parameter is missing' }, status: :unprocessable_entity
    end

    def render_bad_request(exception)
      Rails.logger.info { exception }
      render json: { error: exception.message }, status: :bad_request
    end
  end
end
