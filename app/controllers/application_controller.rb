class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  http_basic_authenticate_with name: Figaro.env.ADM_LOG, password: Figaro.env.ADM_PASS
end
