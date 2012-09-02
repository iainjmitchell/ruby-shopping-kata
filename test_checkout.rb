require 'test/unit'

class TestCheckout < Test::Unit::TestCase
	def get_sku_prices 
		sku_prices = Sku_Prices.new()
		sku_prices.add('A', 50)
		sku_prices.add('B', 35)
		sku_prices.add('C', 20)
		sku_prices.add('D', 15)
		return sku_prices
	end

	def get_special_offers
		Hash[
			'B', Special_Offer.new(2, 20),
			'A', Special_Offer.new(3, 30)
		]
	end

	def test_scan_one_a_total_equals_50 
		sku_code = 'A'
		sku_prices = get_sku_prices()
		checkout = Checkout.new(sku_prices, get_special_offers())
		checkout.scan(sku_code)
		assert_equal sku_prices.get_price_for(sku_code), checkout.total()
	end

	def test_scan_one_b_total_equals_35
		sku_code = 'B'
		sku_prices = get_sku_prices()
		checkout = Checkout.new(sku_prices, get_special_offers())
		checkout.scan(sku_code)
		assert_equal sku_prices.get_price_for(sku_code), checkout.total()
	end

	def test_scan_one_c_total_equals_20
		sku_code = 'C'
		sku_prices = get_sku_prices()
		checkout = Checkout.new(sku_prices, get_special_offers())
		checkout.scan(sku_code)
		assert_equal sku_prices.get_price_for(sku_code), checkout.total()
	end

	def test_scan_one_d_total_equals_15
		sku_code = 'D'
		sku_prices = get_sku_prices()
		checkout = Checkout.new(sku_prices, get_special_offers())
		checkout.scan(sku_code)
		assert_equal sku_prices.get_price_for(sku_code), checkout.total()
	end

	def test_scan_two_a_total_equals_100
		sku_code = 'A'
		sku_prices = get_sku_prices()
		checkout = Checkout.new(sku_prices, get_special_offers())
		checkout.scan(sku_code).scan(sku_code)
		assert_equal 100, checkout.total()
	end

	def test_scan_three_a_total_equals_120
		sku_code = 'A'
		sku_prices = get_sku_prices()
		checkout = Checkout.new(sku_prices, get_special_offers())
		checkout
			.scan(sku_code)
			.scan(sku_code)
			.scan(sku_code)
		assert_equal 120, checkout.total()
	end

	def test_scan_two_b_total_equals_50
		sku_code = 'B'
		sku_prices = get_sku_prices()
		checkout = Checkout.new(sku_prices, get_special_offers())
		checkout
			.scan(sku_code)
			.scan(sku_code)
		assert_equal 50, checkout.total()
	end

	def test_scan_1_b_and_2_a_total_equals_135
		sku_prices = get_sku_prices()
		checkout = Checkout.new(sku_prices, get_special_offers())
		checkout
			.scan('B')
			.scan('A')
			.scan('A')
		assert_equal 135, checkout.total()
	end

	def test_scan_6_a_total_equals_240
		sku_code = 'A'
		sku_prices = get_sku_prices()
		checkout = Checkout.new(sku_prices, get_special_offers())
		checkout
			.scan(sku_code)
			.scan(sku_code)
			.scan(sku_code)
			.scan(sku_code)
			.scan(sku_code)
			.scan(sku_code)
		assert_equal 240, checkout.total()
	end

	def test_scan_3_a_2_b_1_d_total_equals_240
		sku_prices = get_sku_prices()
		checkout = Checkout.new(sku_prices, get_special_offers())
		checkout
			.scan('A')
			.scan('B')
			.scan('C')
			.scan('A')
			.scan('B')
			.scan('A')
		assert_equal 190, checkout.total()
	end
end

class Checkout
	def initialize(sku_prices, special_offers)
		@totaller = Totaller.new()
		@scanner = Scanner.new(@totaller, sku_prices)
		@discounter = Discounter.new(@totaller, special_offers)
	end

	def scan(sku)
		@scanner.scan(sku)
		@discounter.apply_discount(sku)
		self
	end

	def total()
		@totaller.get_total()
	end
end

class Discounter 
	def initialize(totaller, special_offers)
		@totaller = totaller
		@special_offers = special_offers
		@sku_counts = Hash.new()
	end

	def apply_discount(sku)
		if (@special_offers.member?(sku))
			increment_sku_count(sku)
			@totaller.discount_by(@special_offers[sku].discount) if has_discount?(sku)	
		end
	end

	private

	def increment_sku_count(sku)
		if !@sku_counts.member?(sku)
			@sku_counts[sku] = 1
		else
			@sku_counts[sku]+=1
		end
	end

	def has_discount?(sku)
		(@sku_counts[sku] % @special_offers[sku].quanity == 0)
	end
end

class Totaller
	def initialize()
		@total = 0;
	end 

	def increment_by(amount)
		@total += amount
	end

	def discount_by(amount)
		@total -= amount
	end

	def get_total()
		@total 
	end
end

class Scanner
	def initialize(totaller, sku_prices)
		@totaller = totaller
		@sku_prices = sku_prices
	end

	def scan(sku)
		sku_price = @sku_prices.get_price_for(sku)
		@totaller.increment_by(sku_price)
	end
end

class Special_Offer
	attr_reader :quanity, :discount

	def initialize(quanity, discount)
		@quanity = quanity
		@discount = discount
	end
end

class Sku_Prices
	def initialize()
		@price_by_sku = Hash.new()
	end

	def add(sku, price)
		@price_by_sku[sku] = price
	end

	def get_price_for(sku)
		return @price_by_sku[sku]
	end
end