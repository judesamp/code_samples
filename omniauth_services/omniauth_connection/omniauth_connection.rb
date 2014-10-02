class OmniauthConnection
	attr_accessor :authenticatable
	
	def initialize(session, provider, service, uid)
		@session = session
		@provider = provider
		@service = service
		@uid = uid
		@authenticatable = nil
		find_authenticatable
		set_uid
	end

	def set_uid
		if twitter?
			@authenticatable.twitter_uid = @uid
			@authenticatable.save
		else
			@authenticatable.facebook_uid = @uid
			@authenticatable.save
		end
	end

	def find_authenticatable
		if client?
			@authenticatable = Client.first(:id => @session[:client_id].to_i)
		else
			@authenticatable = Professional.first(:id => @session[:professional_id])
		end
	end

	def twitter?
		@provider == 'twitter'
	end

	def client?
		@service == 'client'
	end

end