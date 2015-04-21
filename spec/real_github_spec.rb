require 'real_github'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock
end

RSpec.describe RealGithub do
  around do |spec|
    VCR.use_cassette 'everything' do
      spec.call
    end
  end

  describe 'exercism contributors' do
    it 'returns an array of contributors' do
      github = RealGithub.new
      github.exercism_contributors.each do |contributor|
        expect(contributor).to be_a_kind_of Contributor
      end
    end
  end
end
