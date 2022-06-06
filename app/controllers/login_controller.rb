class LoginController < ApplicationController
  def create
    try_to_log_in(params[:login], params[:passphrase])
  end

  private

  def try_to_log_in(login, password)
    # it is dummy method
  end
end
