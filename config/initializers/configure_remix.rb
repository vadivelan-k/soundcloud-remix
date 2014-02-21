require 'yaml'
# TODO:: Temp fix for the yaml parser error
YAML::ENGINE.yamler = 'syck'
file = File.join(Rails.root, "config", "settings.yml")
p file

SETTINGS = YAML.load_file(file)

consumer_key = YAML.load_file(File.join(Rails.root, "config", "soundcloud_auth.yml"))[RAILS_ENV]["key"]

SETTINGS["group_id"] = HTTParty.get("http://api.soundcloud.com/resolve?url=#{SETTINGS["group"]}&consumer_key=#{consumer_key}", :format => :xml)["group"]["id"]

SETTINGS["admin_id"] = HTTParty.get("http://api.soundcloud.com/resolve?url=#{SETTINGS["admin"]}&consumer_key=#{consumer_key}", :format => :xml)["user"]["id"]

SETTINGS["instructions"] = File.read("#{RAILS_ROOT}/config/instructions.txt")