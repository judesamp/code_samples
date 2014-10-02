class OmniauthAuthentication
	attr_accessor :authenticatable

	def initialize(provider, service, uid)
		@provider = provider
		@service = service
		@uid = uid
		@authenticatable = find_authenticatable
	end

	def find_authenticatable
		@authenticatable = nil

		if professional?
			if twitter?
      	@authenticatable = Professional.first(:twitter_uid => @uid)
      else
      	@authenticatable = Professional.first(:facebook_uid => @uid)
      end
    else
			if twitter?
    		authenticatable = Client.first(:twitter_uid => @uid)
    	else
    		@authenticatable = Client.first(:facebook_uid => @uid)
    	end
    end
	end

	def professional?
		@service == 'professional'
	end

	def twitter?
		@provider == 'twitter'
	end
end