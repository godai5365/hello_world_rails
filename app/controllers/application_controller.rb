class ApplicationController < ActionController::Base
  # CSRF対策をoffにする
  protect_from_forgery with: :null_session
end
