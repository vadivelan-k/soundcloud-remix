class Remix < ActiveRecord::Base
  
  attr_accessor :file
  
  belongs_to :user
  has_many :votes
  
  validates_presence_of :title
  validates_presence_of :file
  
  cattr_reader :per_page
  @@per_page = 5
  
  def url
    "http://api.soundcloud.com/tracks/#{track_id}"
  end
  
  def available?
    consumer_key = YAML.load_file(File.join(Rails.root, "config", "soundcloud_auth.yml"))[RAILS_ENV]["key"]
    HTTParty.get("http://api.soundcloud.com/tracks/#{track_id}?consumer_key=#{consumer_key}").code == 404 ? false : true
  end
  
  def voted?(ip_address)
    Vote.find(:first, :conditions => {:remix_id => id, :ip_address => ip_address}) ? true : false
  end
  
end
