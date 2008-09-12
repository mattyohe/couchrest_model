require "rubygems"
require 'json'
require 'rest_client'

$:.unshift File.dirname(__FILE__) unless
  $:.include?(File.dirname(__FILE__)) ||
  $:.include?(File.expand_path(File.dirname(__FILE__)))
  
  
require 'couchrest/monkeypatches'

module CouchRest
  autoload :Server,       'couchrest/core/server'
  autoload :Database,     'couchrest/core/database'
  autoload :Pager,        'couchrest/helper/pager'
  autoload :FileManager,  'couchrest/helper/file_manager'
  autoload :Streamer,     'couchrest/helper/streamer'
  
  # The CouchRest module methods handle the basic JSON serialization 
  # and deserialization, as well as query parameters.
  class << self
    
    def new(*opts)
      Server.new(*opts)
    end
    
    def put uri, doc = nil
      payload = doc.to_json if doc
      JSON.parse(RestClient.put(uri, payload))
    end

    def get uri
      JSON.parse(RestClient.get(uri), :max_nesting => false)
    end
  
    def post uri, doc = nil
      payload = doc.to_json if doc
      JSON.parse(RestClient.post(uri, payload))
    end
  
    def delete uri
      JSON.parse(RestClient.delete(uri))
    end
  
    def paramify_url url, params = nil
      if params
        query = params.collect do |k,v|
          v = v.to_json if %w{key startkey endkey}.include?(k.to_s)
          "#{k}=#{CGI.escape(v.to_s)}"
        end.join("&")
        url = "#{url}?#{query}"
      end
      url
    end
  end # class << self
end