# frozen_string_literal: true

if Rails.env.development?
  User.create(email: 'user@example.com', password: 'password')
  AdminUser.create(email: 'admin@example.com', password: 'password',
                   password_confirmation: 'password')
end
