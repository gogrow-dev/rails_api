# frozen_string_literal: true

User.create(email: 'user@example.com', password: 'password') if Rails.env.devlopment?
