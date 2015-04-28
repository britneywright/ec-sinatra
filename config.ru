require_relative 'app'

which_github = :httparty

class InjectGithub
  def initialize(app, github)
    @app, @github = app, github
  end

  def call(env)
    env[:github] = @github
    @app.call(env)
  end
end

case which_github
when :fake
  require_relative 'lib/fake_github'
  use InjectGithub, FakeGithub.new
when :query_api
  require_relative 'lib/real_github'
  use InjectGithub, RealGithub.new
when :httparty
  require_relative 'lib/httparty'
  use InjectGithub, HTTPartyGithub.new
end

run App
