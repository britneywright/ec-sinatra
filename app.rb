require 'sinatra/base'
require 'pry'
require 'rerun'
require 'rack/cache'
require 'faraday-http-cache'
require 'active_support/all'

class App < Sinatra::Base
  use Rack::Cache

  helpers do
    def github
      env[:github]
    end
  end

  before do
    expires 3600, :public
  end

  get '/' do
    erb :index
  end

  get '/contributors/:login' do
    @contributor = github.exercism_contributors.get(params[:login])
    erb :contributor
  end
end
