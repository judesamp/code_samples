require 'scrypt'

class ClientSignup
	attr_accessor :password, :salt, :hashed_password, :message

	def initialize(client_data)
		@client_data = client_data
		@password = client_data[:password]
		@salt = generate_salt
		@hashed_password = hash_password
		@saved = false
		@message = nil
		create_client
	end

	def saved?
		@saved
	end

	private

	def generate_salt
		SCrypt::Engine.generate_salt(salt_size: 32)
	end

	def hash_password
		SCrypt::Engine.hash_secret(@password, @salt, 512)
	end

	def create_client
		client_hash = build_hash
		begin
			client = Client.create(client_hash)
    rescue DataMapper::SaveFailureError => e
    	@message = parse_exception_messages(e).to_json
    	return
		end
    @saved = true
    @message = client.to_json
	end

	def build_hash
		{ 
			email: @client_data[:email], 
			first_name: @client_data[:first_name], 
			last_name: @client_data[:last_name], 
			billing_street: @client_data[:billing_street], 
			billing_city: @client_data[:billing_city], 
			billing_state_provence: @client_data[:billing_state_provence],
			billing_zipcode: @client_data[:billing_zipcode], 
			phone: @client_data[:phone], 
			crypted_password: @hashed_password, 
			salt: @salt
		}
	end

	def parse_exception_messages(exception)
    { errors: exception.to_s.split("; ").map! {|m| { message: m.gsub!(/^([-\.\w]*[0-9a-zA-Z]:\s)/, '') } } }
	end
	
end