require "gruf"

Gruf.configure do |c|
  c.grpc_logger = Logger.new(STDOUT)
  c.logger = Logger.new(STDOUT)

  # Set up rpc server host
  c.server_binding_url = if Rails.env.production?
    server_port = Rails.application.credentials.rpc.try(:[], 'server_port')

    "localhost:#{server_port}"
  else
    "localhost:#{ENV['RPC_SERVER_PORT']}"
  end

  # Set up rpc client host
  c.default_client_host = if Rails.env.production?
    client_host = Rails.application.credentials.rpc.try(:[], 'client_host')
    client_port = Rails.application.credentials.rpc.try(:[], 'client_port')

    "#{client_host}:#{client_port}"
  else
    "localhost:#{ENV['RPC_CLIENT_PORT']}"
  end

  Dir.glob(Rails.root.join("app/proto/*_pb.rb")).each do |file|
    require file
  end
end
