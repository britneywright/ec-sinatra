require 'httparty'

require_relative 'contributor'
require_relative 'repo'

class HTTPartyGithub
  include HTTParty
  base_uri 'https://api.github.com'

  def initialize
    @options = {query: {per_page: 100}}
    @headers = { :headers => {"User-Agent" => "HTTPARTY"} }
  end

  def exercism_repos
    self.class.get("/users/exercism/repos",@headers)
  end

  def exercism_contributors
    self.class.get("/repos/exercism/exercism.io/contributors",@options,@headers)
  end

  def number_of_pages
    self.headers["link"].split(",")[1].match(/&page=(\d+)/)[1]
  end

  def ratelimit_remaining
    12
  end
end
