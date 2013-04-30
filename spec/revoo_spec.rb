require 'spec_helper'

describe Checkout do
  before do
    pricing_rules = {
      "FR1" => lambda{|count, price| ((count/2) + count%2) * price },
      "SR1" => lambda{|count, price| ((count > 2) ? count*0.9 : count) * price },
      "CF1" => lambda{|count, price| price }
    }
    @co = Checkout.new(pricing_rules)
  end

  it "should be a instance of Checkout class" do
    @co.class.to_s.should == "Checkout"
  end

  context "after initialize should set instance variables" do
    it "items as hash" do
      @co.instance_variable_get(:@items).class == Hash
    end

    it "rules as hash" do
      @co.instance_variable_get(:@rules).class == Hash
    end
  end

  context "#scan" do
    before do
      @co.scan "FR1"
      @co.scan "SR1"
      @co.scan "FR1"
    end

    it "items should hold name of rule" do
      @co.instance_variable_get(:@items).keys.should == ["FR1", "SR1"]
    end

    it "items should hold counter of rules" do
      @co.instance_variable_get(:@items).values.should == [2, 1]
    end
  end

  context "#total" do
    context "buy-one-get-one-free fruit tea" do
      it "price" do
        @co.scan "FR1"
        @co.scan "FR1"
        @co.total.should == 3.11
      end
    end

    context "3 or more strawberries" do
      it "price" do
        @co.scan "FR1"
        @co.scan "SR1"
        @co.scan "FR1"
        @co.scan "CF1"
        @co.total.should == 22.25
      end
    end

    context "last case" do
      it "price" do
        @co.scan "SR1"
        @co.scan "SR1"
        @co.scan "FR1"
        @co.scan "SR1"
        @co.total.should == 16.61
      end
    end
  end
  
end



describe Items do
  context "FR1" do
    context "#class methods" do
      it "#price should return" do
        Items::FR1.price.should eq(3.11)
      end
    end
  end

  context "SR1" do
    context "#class methods" do
      it "#price should return" do
        Items::SR1.price.should eq(5.00)
      end
    end
  end

  context "CF1" do
    context "#class methods" do
      it "#price should return" do
        Items::CF1.price.should eq(11.23)
      end
    end
  end

end
