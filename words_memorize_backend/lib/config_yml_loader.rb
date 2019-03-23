require 'erb'
require 'yaml'

module ConfigYmlLoader
  extend self

  def load_yml(file_name, options={})
    file_path = File.join((options[:dir] || config_dir), file_name)
    result = load_raw_yml(file_path)

    env = ENV['RAILS_ENV'] || 'development'
    result[env].deep_symbolize_keys
  end

  def load_raw_yml(file_path)
    file_path += '.yml' unless file_path =~ /\.(yml|yaml)$/

    YAML.load(ERB.new(File.read(file_path)).result)
  end

  def config_dir
    @config_dir ||= File.expand_path('../../config/', __FILE__)
  end

end