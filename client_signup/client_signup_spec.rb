require_relative '../../../spec/app/spec_helper.rb'

describe ClientSignup do

	context 'creation' do
		attrs = { 		email: 'test@email.com', 
									password: 'password',
									first_name: 'Dakota',
							    last_name: "Fanning",
									billing_street: "123 main street",
									billing_city: "Atlanta",
									billing_state_provence: "Ga",
									billing_zipcode: "12345",
							    phone: "7082427232"
						}

		invalid_attrs = { 
													first_name: 'Dakota',
											    last_name: "Fanning"
										}

		let(:client_signup) { ClientSignup.new( attrs ) }

		it "should exist" do
			expect(client_signup).to_not be nil
		end

		it "should set password to instance variable" do
			expect(client_signup.password).to eq 'password'
		end

		it "generates and sets a salt" do
			expect(client_signup.salt.length).to eq 73 
		end

		it "hashes the password" do
			expect(client_signup.hashed_password.length).to eq 1098
		end

		it "creates a new client" do
			expect{
				ClientSignup.new(attrs)
			}.to change{Client.count}.by(1)
		end

		it "marks client as saved if it is saved successfully" do
			client_signup = ClientSignup.new(attrs)
			expect(client_signup.saved?).to be true
		end

		it "if client is saved successfully, message should be json hash representing client object" do
			client_signup = ClientSignup.new(attrs)
			client = Client.first(email: 'test@email.com')
			expect(client_signup.message).to eq client.to_json
		end

		it "sets email" do
			ClientSignup.new(attrs) 
			client = Client.first(email: 'test@email.com')
			expect(client.email).to eq 'test@email.com'
		end

		it "sets crypted_password" do
			ClientSignup.new(attrs) 
			client = Client.first(email: 'test@email.com')
			expect(client.crypted_password.length).to eq 1098
		end

		it "sets salt" do
			ClientSignup.new(attrs) 
			client = Client.first(email: 'test@email.com')
			expect(client.salt.length).to eq 73
		end

		it "sets first name" do
			ClientSignup.new(attrs) 
			client = Client.first(email: 'test@email.com')
			expect(client.first_name).to eq 'Dakota'
		end

		it "sets last name" do
			ClientSignup.new(attrs) 
			client = Client.first(email: 'test@email.com')
			expect(client.last_name).to eq 'Fanning'
		end

		it "sets billing street" do
			ClientSignup.new(attrs) 
			client = Client.first(email: 'test@email.com')
			expect(client.billing_street).to eq "123 main street"
		end

		it "sets billing city" do
			ClientSignup.new(attrs) 
			client = Client.first(email: 'test@email.com')
			expect(client.billing_city).to eq "Atlanta"
		end

		it "sets billing state provence" do
			ClientSignup.new(attrs) 
			client = Client.first(email: 'test@email.com')
			expect(client.billing_state_provence).to eq "Ga"
		end

		it "sets billing zip code" do
			ClientSignup.new(attrs) 
			client = Client.first(email: 'test@email.com')
			expect(client.billing_zipcode).to eq "12345"
		end

		it "sets phone" do
			ClientSignup.new(attrs)
			client = Client.first(email: 'test@email.com')
			expect(client.phone).to eq "7082427232"
		end

		it "marks saved as false if client fails to save" do
			client_signup = ClientSignup.new(invalid_attrs)
			expect(client_signup.saved?).to be false
		end

		it "returns validation message if save fails" do
			client_signup = ClientSignup.new(invalid_attrs)
			expect(client_signup.message).to eq "{\"errors\":[{\"message\":\"Email must not be blank\"}]}"
		end

	end

end