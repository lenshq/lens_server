module ServiceLocator
  module Services
    def self.github
      @github ||= GithubService.new
    end
  end

  def self.services
    Services
  end
end
