# encoding: UTF-8

require 'minitest_helper'

describe FuzzyPrice do
  
  before do
    @fp = FuzzyPrice.new 1
    @sample0 = "Total 71.75"
    @sample1 = ": % ` ’ ' Total .  k` 27.32“"
    @sample2 = "TofaI $26.18"
    @sample3 = "T0faI 55.IA"
    @sample4 = "T0faI 55.15"
    @sample5 = "Total   35—O3"
    @sample6 = "TOTAL $10.13"
  end
  
  describe "Finds price total" do 
    
    it "finds price total with fuzziness 1" do 
      price = @fp.to_price @sample0, FuzzyPrice::TOTAL_TEXT_REGEX
      price.length.must_equal 1
      price[0].must_equal 71.75
    end
    
    it "finds price total with fuzziness 2" do
      @fp.max_fuzz = 2
      price = @fp.to_price @sample2, FuzzyPrice::TOTAL_TEXT_REGEX
      price.length.must_equal 1
      price[0].must_equal 26.18
      
      price = @fp.to_price @sample5, FuzzyPrice::TOTAL_TEXT_REGEX
      price.length.must_equal 1
      price[0].must_equal 35.03
    end
    
    it "finds price total with fuzz 3" do     
      @fp.max_fuzz = 3
      price = @fp.to_price @sample4, FuzzyPrice::TOTAL_TEXT_REGEX
      price.length.must_equal 1
      price[0].must_equal 55.15
    end
    
  end
  
  describe "Cannot find price total" do
    
    it "cannot find price total with fuzziness 1" do
      @fp.max_fuzz = 1
      price = @fp.to_price @sample3, FuzzyPrice::TOTAL_TEXT_REGEX
      price.length.must_equal 0
    end
    
    it "cannot find price total with fuzz 2, text too messy" do
      price = @fp.to_price @sample1, FuzzyPrice::TOTAL_TEXT_REGEX
      price.length.must_equal 0
    end
    
  end
  
  
end