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
