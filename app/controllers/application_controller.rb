class ApplicationController < ActionController::Base
  add_flash_types :alert

  def error_message(errors)
    errors.full_messages.join(', ')
  end
end
