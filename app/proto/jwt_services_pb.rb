# Generated by the protocol buffer compiler.  DO NOT EDIT!
# Source: app/proto/jwt.proto for package 'auth'

require 'grpc'

module Auth
  module JwtService
    class Service
      include ::GRPC::GenericService

      self.marshal_class_method = :encode
      self.unmarshal_class_method = :decode
      self.service_name = 'auth.JwtService'

      rpc :ValidActivationToken, ::Google::Protobuf::Empty, ::Auth::ValidResponse
      rpc :ValidToken, ::Google::Protobuf::Empty, ::Auth::ValidResponse
    end

    Stub = Service.rpc_stub_class
  end
end
