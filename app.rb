require 'sinatra/base'
require 'pry'
require 'thin'
require 'rerun'

class App < Sinatra::Base

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
