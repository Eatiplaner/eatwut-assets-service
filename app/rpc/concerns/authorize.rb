class AuthMetaInterceptor < Gruf::Interceptors::ClientInterceptor
  def initialize(token_key)
    @token_key = token_key
    super
  end

  def call(request_context:)
    request_context.metadata['authorization'] = @token_key
    yield
  end
end

module Concerns
  module Authorize
    def authorize_request!
      client = ::Gruf::Client.new(
        service: ::Auth::JwtService,
        client_options: {
          interceptors: [AuthMetaInterceptor.new(request.metadata['authorization'])]
        }
      )

      response = client.call(:ValidToken)

      raise Gruf::Client::Error, 'Token is invalid' unless response.message.valid
    rescue Gruf::Client::Error => e
      set_debug_info(e.message, e.backtrace[0..4])
      fail!(:unauthenticated, :unauthenticated, "ERROR: #{e.message}")
    end
  end
end
