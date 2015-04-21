require 'sinatra'
require 'pry'
require 'github_api'
require 'rerun'
require 'rack/cache'
require 'faraday-http-cache'
require 'active_support/all'

use Rack::Cache

class Repo
  attr_accessor :name, :html_url, :description, :contributors_url, :commits_url

  def initialize(name, html_url, description, contributors_url, commits_url)
    @name = name
    @html_url = html_url
    @description = description
    @contributors_url = contributors_url
    @commits_url = commits_url
  end
end

class Contributor
  attr_accessor :login, :avatar_url, :contributions, :repo_name

  def initialize(login, avatar_url, contributions, repo_name)
    @login = login
    @avatar_url = avatar_url
    @contributions = contributions
    @repo_name = repo_name
  end
end

helpers do
  def exercism_repos
    @store = ActiveSupport::Cache::MemoryStore.new
    @github = Github.new do |config|
      config.stack do |builder|
        builder.use Faraday::HttpCache, @store
      end
    end
    repos = []
    @github.repos.list(user: "exercism").to_a.delete_if {|x| x[:size] == 0}.each do |repo|
      repos << Repo.new(repo["name"],repo["html_url"],repo["description"],repo["contributors_url"],repo["commits_url"])
    end
  end

  def exercism_contributors
    @repos.map do |r|
      1.upto(Float::INFINITY).with_object([]) do |pagenum, contributors|
        page = Github.new.repos.list_contributors('exercism', r.name, page: pagenum)
        page.each { |c| contributors << Contributor.new(c["login"],c["avatar_url"],c["contributions"],r.name)}
        link = page.response.headers['link']
        last_pagenum = if link
          last_link = link.split(',').grep(/rel="last"/).first
          last_link ||= "page=#{pagenum}"
          last_link[/page=(\d+)/,1].to_i
        else
          pagenum
        end
        break contributors if pagenum == last_pagenum
      end
    end
  end

end

before do
  expires 3600, :public
end

get '/' do
  @repos = exercism_repos 
  @contributors = exercism_contributors
  erb :index
end

get '/contributors/:login' do
  @contributor = exercism_contributors.get(params[:login])
  erb :contributor
end
