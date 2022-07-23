class BaseController < Gruf::Controllers::Base
  include Gruf::Controllers::Callbacks
  include Concerns::Authorize
end
