module RequestHelper
  def api_token(token)
    request.headers['X-Auth-Token'] = token
  end
end
