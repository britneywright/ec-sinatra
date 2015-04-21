require 'github_api'

require_relative 'contributor'
require_relative 'repo'

class RealGithub
  def initialize
    # @store  = ActiveSupport::Cache::MemoryStore.new
    @github = Github.new do |config|
      # config.stack do |builder|
      #   builder.use Faraday::HttpCache, @store
      # end
    end
  end

  def ratelimit_remaining
    Github.ratelimit_remaining
  end

  def exercism_repos
    @exercism_repos ||= begin
      repos = []
      @github.repos.list(user: "exercism").to_a.delete_if {|x| x[:size] == 0}.each do |repo|
        repos << Repo.new(repo["name"],
                          repo["html_url"],
                          repo["description"],
                          repo["contributors_url"],
                          repo["commits_url"])
      end
      repos
    end
  rescue Exception => e
    require "pry"
    binding.pry
  end

  def exercism_contributors
    @exercism_contributors ||= begin
      exercism_repos.flat_map do |r|
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
  rescue Exception => e
    require "pry"
    binding.pry
  end
end
