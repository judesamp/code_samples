##pulled from a project; won't function in place

require_relative '../../../spec/app/spec_helper.rb'

describe Authentication do

	attrs = { 		email: 'test@email.com', 
								password: 'password',
								first_name: 'Dakota',
						    last_name: "Fanning",
								billing_street: "123 main street",
								billing_city: "Atlanta",
								billing_state_provence: "Ga",
								billing_zipcode: "12345",
						    phone: "7082427232",
								crypted_password: "aeiou12345",
						}

	let(:client_signup) { ClientSignup.new( attrs ) }

	context "login" do

		context "with email absent" do

			it "responds appropriately to email's absence in params" do
				ClientSignup.new( attrs )
				authentication = Authentication.new({ email: '', password: 'password' }, "Client")
				expect(authentication.message).to eq "{\"errors\":[{\"message\":\"You need to supply both a password and an email.\"}]}"
			end

		end

		context "with password absent" do

			it "responds appropriately to password's absence in params" do
				ClientSignup.new( attrs )
				authentication = Authentication.new({ email: 'test@email.com', password: '' }, "Client")
				expect(authentication.message).to eq "{\"errors\":[{\"message\":\"You need to supply both a password and an email.\"}]}"
			end

		end

		context "client present in database" do

			it "validates email belongs to client in database" do
				ClientSignup.new( attrs )
				authentication = Authentication.new({ email: 'test2@email.com', password: 'password', }, "Client")
				expect(authentication.message).to eq "{\"errors\":[{\"message\":\"The email you supplied is not in our records.\"}]}"
			end

		end

		context "successful authentication" do

			it "authenticates client based on supplied password" do
				ClientSignup.new( attrs )
				authentication = Authentication.new({ email: 'test@email.com', password: 'password' }, "Client")
				expect(authentication.message).to eq "{\"success\":\"Your credentials have been verified.\"}"
			end

			it "authenticates client based on supplied password" do
				ClientSignup.new( attrs )
				authentication = Authentication.new({ email: 'test@email.com', password: 'password' }, "Client")
				expect(authentication.authenticated?).to eq true
			end

		end

		context "unsuccessful authentication" do

			it "declines to authenticate if password is incorrect" do
				ClientSignup.new( attrs )
				authentication = Authentication.new({ email: 'test@email.com', password: 'wrong_password' }, "Client")
				expect(authentication.authenticated?).to eq false
			end

			it "declines to authenticate if password is incorrect and returns appropriate message" do
				ClientSignup.new( attrs )
				authentication = Authentication.new({ email: 'test@email.com', password: 'wrong_password' }, "Client")
				expect(authentication.message).to eq "{\"errors\":[{\"message\":\"The password you supplied does not match our records.\"}]}"
			end

		end

	end

end

