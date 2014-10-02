class Authentication
	attr_accessor :message, :authenticatable

	def initialize(params, auth_class)
		@params = params
		@message = nil
		@complete = false
		@authenticatable = nil
		@authenticated = false
		@auth_class = get_class(auth_class)
		authenticate
	end

	def authenticated?
		@authenticated
	end

	private

	def complete?
		@complete
	end

	def authenticate
		validate_params
		return if complete?
		confirm_email
		return if complete?
		verify_credentials
	end

	def validate_params
		begin
		raise(AuthenticationError, "AuthenticationError: You need to supply both a password and an email.") unless params_valid? 
		rescue AuthenticationError => e
			@complete = true
			@message = parse_exception_messages(e).to_json
			return
		end
	end

	def confirm_email
		begin
			@authenticatable = @auth_class.first(email: @params[:email])
		raise(AuthenticationError, "AuthenticationError: The email you supplied is not in our records.") if @authenticatable.nil? 
		rescue AuthenticationError => e
			@complete = true
			@message = parse_exception_messages(e).to_json
			return
		end
	end

	def params_valid?
		!@params[:email].empty? && !@params[:password].empty?	
	end

	def verify_credentials
		new_hashed_pass = SCrypt::Engine.hash_secret(@params[:password], @authenticatable.salt, 512)
  	
	  if password_matches?(new_hashed_pass)
	  	@message = {:success => "Your credentials have been verified."}.to_json
	    @authenticated = true
	  else
	  	begin
      raise(AuthenticationError, "AuthenticationError: The password you supplied does not match our records.")
    	rescue AuthenticationError => e
      	@message = parse_exception_messages(e).to_json
      end
	  end
	end

	def password_matches?(hashed_pass)
		hashed_pass == @authenticatable.crypted_password
	end

	def get_class(auth_class)
		Object.const_get(auth_class)
	end

	def parse_exception_messages(exception)
    { errors: exception.to_s.split("; ").map! {|m| { message: m.gsub!(/^([-\.\w]*[0-9a-zA-Z]:\s)/, '') } } }
  end

end