# frozen_string_literal: true

# This generator is used for creating the model Address
class AddressGenerator < Rails::Generators::Base
  include Rails::Generators::Migration
  # source_root is used to tell Rails where to look for the template files
  source_root File.expand_path('templates', __dir__)

  def file_name
    'address'
  end

  def self.next_migration_number(_path)
    Time.current.strftime('%Y%m%d%H%M%S')
  end

  def copy_address_file
    template 'address.rb.tt', File.join('app/models', "#{file_name}.rb")
  end

  def copy_address_factory_file
    template 'addresses.rb.tt', File.join('spec/factories', "#{file_name.pluralize}.rb")
  end

  def copy_address_spec_file
    template 'address_spec.rb.tt', File.join('spec/models', "#{file_name}_spec.rb")
  end

  def copy_serializer_file
    template 'address_serializer.rb.tt', File.join('app/serializers', "#{file_name}_serializer.rb")
  end

  def create_migration_file
    copy_migration('create_addresses')
  end

  private

  def copy_migration(filename)
    if self.class.migration_exists?('db/migrate', filename)
      say_status('skipped', "Migration #{filename}.rb already exists")
    else
      migration_template "#{filename}.rb.tt", File.join('db/migrate', "#{filename}.rb")
    end
  end
end
