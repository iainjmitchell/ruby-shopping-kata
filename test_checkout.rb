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

	def test_scan_one_a_total_equals_50 
		sku_code = 'A'
		sku_prices = get_sku_prices()
		checkout = Checkout.new(sku_prices)
		checkout.scan(sku_code)
		assert_equal sku_prices.get_price_for(sku_code), checkout.total()
	end

	def test_scan_one_b_total_equals_35
		sku_code = 'B'
		sku_prices = get_sku_prices()
		checkout = Checkout.new(sku_prices)
		checkout.scan(sku_code)
		assert_equal sku_prices.get_price_for(sku_code), checkout.total()
	end

	def test_scan_one_c_total_equals_20
		sku_code = 'C'
		sku_prices = get_sku_prices()
		checkout = Checkout.new(sku_prices)
		checkout.scan(sku_code)
		assert_equal sku_prices.get_price_for(sku_code), checkout.total()
	end

	def test_scan_one_d_total_equals_15
		sku_code = 'D'
		sku_prices = get_sku_prices()
		checkout = Checkout.new(sku_prices)
		checkout.scan(sku_code)
		assert_equal sku_prices.get_price_for(sku_code), checkout.total()
	end

	def test_scan_two_a_total_equals_100
		sku_code = 'A'
		sku_prices = get_sku_prices()
		checkout = Checkout.new(sku_prices)
		checkout.scan(sku_code).scan(sku_code)
		assert_equal 100, checkout.total()
	end
end

class Checkout
	def initialize(sku_prices)
		@sku_prices = sku_prices
		@scanner = Scanner.new(sku_prices)
		@total = 0
	end

	def scan(sku)
		@total += @sku_prices.get_price_for(sku)
		self
	end

	def total()
		@total
	end
end

class Scanner
	def initialize(sku_prices)

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