class NetworkService < BaseService
  class UserBlockedError < ServiceError
  end

  class AlreadyLinkedError < ServiceError
  end

  class IntegrationError < ServiceError
  end

  class UserSaveError < ServiceError
  end
end
