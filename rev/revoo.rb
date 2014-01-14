class Checkout
 
  def initialize(rules)
    @rules = rules
    @items = {}
  end
 
  def scan(item)
    @items[item] ||= 0
    @items[item] += 1
  end
 
  def total
    @items.map do |key,count|
      if @rules[key]
        @rules[key].(count, Items.const_get(key).price).to_f
      end
    end.map(&:to_f).inject(0,:+)
  end
 
end
 
module Items
  class FR1
    def self.price
      3.11
    end
  end
 
  class SR1
    def self.price
      5.00
    end
  end
 
  class CF1
    def self.price
      11.23
    end
  end
 
end
 
pricing_rules = {
  "FR1" => lambda{|count, price| ((count/2) + count%2) * price },
  "SR1" => lambda{|count, price| ((count > 2) ? count*0.9 : count) * price },
  "CF1" => lambda{|count, price| price }
}
 
# co = Checkout.new(pricing_rules)
# co.scan "FR1"
# co.scan "SR1"
# co.scan "FR1"
# co.scan "CF1"
# puts co.total
 
# co = Checkout.new(pricing_rules)
# co.scan "FR1"
# co.scan "FR1"
# puts co.total
 
# co = Checkout.new(pricing_rules)
# co.scan "SR1"
# co.scan "SR1"
# co.scan "FR1"
# co.scan "SR1"
# puts co.total