class ApplicationController < ActionController::Base
  protect_from_forgery
  
  # This is needed because by default, all Helpers are available
  # in the views, but not the controllers.  By explicitly including 
  # the sessions helper here, we make sure it is available in both
  include SessionsHelper
 
end
