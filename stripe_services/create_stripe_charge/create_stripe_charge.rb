# in progress...not quite finished

class CreateStripeCharge

	def initialize(options)
		@amount = options[:amount]
		@client = options[:client]
		@job = options[:job]
		@message = nil
		@success = false
		create_stripe_charge
	end

	def success?
		@success
	end

	def create_stripe_charge
		Stripe.api_key = ENV['STRIPE_TEST_KEY']  
    @amount = 500
      
    begin
    	stripe_customer = Stripe::Customer.retrieve(@client.stripe_id)

      charge = Stripe::Charge.create(
        :amount      => @amount,
        :description => 'Sinatra Charge',
        :currency    => 'usd',
        :customer    => stripe_customer.id
      )
      puts charge.inspect

    rescue Stripe::StripeError => e

    	# need to decide what to do with these errors; will these errors pertain to customer or Stripe API?
    	# I suspect front-end errors (delivered after first hit on API) pertain to customer while these might just need to return generic "something went wrong to customer" and then notify developers
      @message = e
    else 
    	#save_charge_data(charge)
    end
	end

	def save_charge_data(charge)
		#save transaction (associate with job/client)
	end

end