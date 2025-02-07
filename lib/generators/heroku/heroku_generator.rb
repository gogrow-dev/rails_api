# frozen_string_literal: true

class HerokuGenerator < Rails::Generators::Base
  desc "Creates Heroku files for deployment"
  class_option :app_name, type: :string, default: nil, desc: "Name of the Heroku app"

  source_root File.expand_path("templates", __dir__)

  def copy_files
    @app_name = options[:app_name]

    copy_file "Procfile"
    copy_file "Aptfile"
    copy_file "release.sh"
    template "app.json.erb", "app.json"
  end
end
