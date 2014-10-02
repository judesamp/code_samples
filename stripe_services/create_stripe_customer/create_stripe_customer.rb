class CreateStripeCustomer
	attr_accessor :message, :success

	def initialize(options)
		@email = options[:email]
		@token = options[:token]
		@client = options[:client]
		@message = nil
		@success = false
		create_stripe_customer
	end

	def success?
		@success 
	end

	private

	def create_stripe_customer
		Stripe.api_key = ENV['STRIPE_TEST_KEY']

		puts 'herish'
		puts @token.inspect
      
    begin
      customer = Stripe::Customer.create(
        :email => @email,
        :card  => @token
      )
    rescue Stripe::StripeError => e
    	# need to decide what to do with these errors; will these errors pertain to customer or Stripe API?
    	# I suspect front-end errors (delivered after first hit on API) pertain to customer while these might just need to return generic "something went wrong to customer" and then notify developers
      @message = e
    else 
    	save_customer_data(customer)
    end

	end

	def save_customer_data(customer)
		@client.stripe_id = customer[:id]
		begin
			@client.save
    rescue DataMapper::SaveFailureError => e
      @message =  parse_exception_messages(e).to_json
    else
    	@success = true
    	@message = {success: 'New Stripe customer saved successfully'}
		end
	end

	def parse_exception_messages(exception)
	  { errors: exception.to_s.split("; ").map! {|m| { message: m.gsub!(/^([-\.\w]*[0-9a-zA-Z]:\s)/, '') } } }
	end
end