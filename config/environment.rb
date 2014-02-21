RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  
  %w(observers sweepers mailers middleware).each do |dir|
    config.load_paths << "#{RAILS_ROOT}/app/#{dir}"
  end
  
  config.time_zone = 'UTC'
  
end