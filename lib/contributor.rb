class Contributor
  attr_accessor :login, :avatar_url, :contributions, :repo_name

  def initialize(login, avatar_url, contributions, repo_name)
    @login = login
    @avatar_url = avatar_url
    @contributions = contributions
    @repo_name = repo_name
  end
end
