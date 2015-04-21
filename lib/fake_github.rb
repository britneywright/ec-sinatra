require_relative 'contributor'
require_relative 'repo'

class FakeGithub
  def exercism_repos
    @exercism_repos ||= [
      Repo.new('exercism.io',
               'example.com',
               'The main exercism repo',
               'example.com/contributors_url',
               'example.com/commits_url'
              ),
      Repo.new('command-line-app',
               'example.com',
               'The command line client for Exercism.',
               'example.com/contributors_url',
               'example.com/commits_url'
              ),
    ]
  end

  def exercism_contributors
    @exercism_contributors ||= [
      Contributor.new('britneywright',
                      'example.com/avatar/britneywright',
                      100,
                      'exercism.io'),
      Contributor.new('kytrinyx',
                      'example.com/avatar/kytrinyx',
                      100100,
                      'exercism.io'),
      Contributor.new('JoshCheek',
                      'example.com/avatar/joshcheek',
                      5,
                      'exercism.io'),
      Contributor.new('kytrinyx',
                      'example.com/avatar/kytrinyx',
                      123123,
                      'command-line-app'),
    ]
  end

  def ratelimit_remaining
    12
  end
end
