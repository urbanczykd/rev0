# notonthehighstreet.com is an online marketplace, here is a
# sample of some of the products available on our site: 
# Product code | Name | Price 
# ---------------------------------------------------------- 
# 001 | Travel Card Holder | £9.25 
# 002 | Personalised cufflinks | £45.00 
# 003 | Kids T-shirt | £19.95 
# Our marketing team want to offer promotions as an incentive for our customers to purchase these items.  If you spend over £60, then you get 10% 
# off your purchase 
# If you buy 2 or more travel card holders then the price 
# drops to £8.50. 
# Our check-out can scan items in any order, and because our 
# promotions will change, it needs to be flexible regarding 
# our promotional rules. 
# The interface to our checkout looks like this (shown in 
# Ruby): 
#  co = Checkout.new(promotional_rules) 
#  co.scan(item) 
#  co.scan(item) 
#  price = co.total 

# Implement a checkout system that fulfills these 
# requirements. 

# Test data 
# --------- 
# Basket: 001,002,003 
# Total price expected: £66.78 
# Basket: 001,003,001 
# Total price expected: £36.95 
# Basket: 001,002,001,003 
# Total price expected: £73.76

class Checkout 

  def initialize(rules)
    @rules = rules
    @products = {}
  end

  def scan(product)
    @products[product] ||= 0
    @products[product] += 1
  end

  def total

    price = @products.map do |key, count|
      if @rules["X" << key.to_s]
        @rules["X" << key.to_s].(count, Products.const_get("X"<< key.to_s).price) * count
      else
        Products.const_get("X"<< key.to_s).price * count
      end
    end.inject(:+)
    @rules["overal"].(price).round(2)
  end

end

module Products
  class X1
    def self.price
      9.25
    end
    def self.name
      "Travel Card Holder"
    end
  end

  class X2
    def self.price
      45.00
    end
    def self.name
      "Personalised cufflinks"
    end
  end

  class X3
    def self.price
      19.95
    end
    def self.name
      "Kids T-shirt"
    end
  end

end

  promotional_rules = {
    "overal" => lambda{|price| price > 60 ? price * 0.9 : price},
    "X1" => lambda{|price, count| count > 2 ? 8.20 : price}
  }


co = Checkout.new(promotional_rules)
co.scan(001)
co.scan(002)
co.scan(003)
price = co.total
puts price