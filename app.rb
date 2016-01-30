require "oauth2"
require "sinatra"
require "sinatra/config_file"

enable :sessions
config_file File.expand_path("config.yml", File.dirname(__FILE__))

before do
  request.path_info.start_with?("/auth") or authenticate
end

get "/auth/callback/?" do
  return_to = session.delete(:return_to) || "/"
  slim :callback, :locals => { :return_to => return_to }
end

post "/auth/token/?" do
  session[:access_token] = request["access_token"]
end

get "/" do
  "It's working. Now go build something."
end

get "/profile/?" do
  res = token.get("/profiles/me")
  res.body
end

private

def authenticate
  authenticated? and return

  redirect_url = config.fetch(:redirect_url)
  scope = config.fetch(:scope, "all")
  session[:return_to] = request.fullpath

  redirect oauth_client.implicit.authorize_url(:redirect_url => redirect_url, :scope => scope)
end

def authenticated?
  session[:access_token] && !token.expired?
end

def token
  @token ||= begin
    query_string = "access_token=#{session[:access_token]}"
    OAuth2::AccessToken.from_kvform(oauth_client, query_string)
  end
end

def oauth_client
  @oauth_client ||= begin
    client_id = config.fetch(:client_id).to_s
    client_secret = config.fetch(:client_secret)
    site = config.fetch(:site)
    OAuth2::Client.new(client_id, client_secret, :site => site)
  end
end

def config
  @config ||= {
    :client_id => settings.client_id,
    :client_secret => settings.client_secret,
    :site => settings.site,
    :redirect_url => settings.redirect_url
  }
end
