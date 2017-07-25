require 'warden' unless defined?(Warden)
require 'ysd-md-profile' unless defined?(Profile)

module ProfileWarden

  #
  # Warden Strategy for Social  
  #
  class ApiKeyWardenStrategy < Warden::Strategies::Base

    # Check if the request is valid
    #
    def valid?

      if env['HTTP_AUTHORIZATION']
        api_key, signature = env['HTTP_AUTHORIZATION'].split(':')
        if api_key.nil?
          return false
        end
        # Check the API Key
        user = Users::Profile.first(api_key: api_key)
        if user.nil?
          p "Authorization. User not found"
          return false
        end

        # Check signature
        data = request.path
        data = "#{data}?#{request.query_string}" if request.query_string.present?
        if ['POST', 'PUT', 'PATCH'].include? request.request_method
          request.body.rewind
          data += request.body.read
        end
        computed_signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), user.api_secret, data)

        if (computed_signature != signature)
          p "Authorization. Signature does not match #{computed_signature} #{signature}"
        end

        return computed_signature == signature

      else
        return false
      end

    end

    # Authenticate the user
    #
    def authenticate!

      api_key, signature = env['HTTP_AUTHORIZATION'].split(':')
      if user = Users::Profile.first(api_key: api_key)
        success!(user)
      else
        fail!("Api Key is not valid")
      end
    end
    
  end

end
