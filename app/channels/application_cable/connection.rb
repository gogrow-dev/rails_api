# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = if token_auth_params?
                            find_verified_user_token
                          else
                            find_verified_user_devise
                          end
      logger.add_tags('ActionCable', current_user.email) if Rails.env.development?
    end

    protected

    def find_verified_user
      verified_user = User.find_by(id: signed_cookie['user.id'])
      if verified_user && signed_cookie['user.expires_at'] > Time.zone.now
        verified_user
      else
        reject_unauthorized_connection
      end
    end

    private

    def signed_cookie
      cookies.signed
    end

    def find_verified_user_devise
      verified_user = User.find_by(id: signed_cookie['user.id'])
      if verified_user && signed_cookie['user.expires_at'] > Time.zone.now
        verified_user
      else
        reject_unauthorized_connection
      end
    end

    def find_verified_user_token
      params = token_auth_params

      user = User.find_by(email: params[:uid])
      if user&.valid_token?(params[:access_token], params[:client])
        user
      else
        reject_unauthorized_connection
      end
    end

    def token_auth_params
      params = request.query_parameters

      {
        access_token: params['access-token'],
        uid: params['uid'],
        client: params['client']
      }
    end

    def token_auth_params?
      params = request.query_parameters

      %w[access-token uid client].all? { |key| params.key?(key) }
    end
  end
end
