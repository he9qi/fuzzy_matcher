require 'minitest_helper'

describe FuzzyWords do
  
  before do
    @fw = FuzzyWords.new
    @words = ["JALAPENO CHILE", "CHILE D/ARBOL", "GRAPEFRUIT LARGE", "HASS SML AVOCADO", "MICHL KORS MS",
              "LAUREN PETITE", "BROWN CHICKEN", "ASN/TAS DRIED NOODLE MED", "KOBE VENOMENON YOT"]
              
    @test1 = "          JALAPENO CHILE\n2.6l lb @ $O.69/lb $l.8O F\nCHILE D/ARBOL \nl.O8 lb @ $3,49/lb $3.77 F "          
    @test2 = " \n2.6l lb @ $O.69/lb $l.8O F\nCHIL \nl.O8 lb @ $3,49/lb $3.77 F "
    @test3 = File.read File.expand_path("../../fixtures/sample1.txt", __FILE__)
    @unreadable_test4 = File.read File.expand_path("../../fixtures/sample2.txt", __FILE__)
  end
  
  describe "Find text matches words" do
    
    it "finds the similar words" do
      words = @fw.find_words(@test1, @words)
      words.length.must_equal 2
    end
    
    it "finds the similar words" do
      words = @fw.find_words(@test3, ["BUTTERFLY PRINT TOP:MULTI"])
      words.length.must_equal 1
      words[0][:word].must_equal "BUTTERFLY PRINT TOP:MULTI"
      words[0][:matches].must_equal ["BUTTERFLY PRINT TOP:MULTI"]
    end
    
  end
  
  describe "Cannot find test matched words" do
    
    it "does not find the similar words" do
      words = @fw.find_words(@test2, @words)
      words.length.must_equal 0
    end
    
    it "does not find any words with max_fuzz 7" do
      @fw.max_fuzz = 7
      words = @fw.find_words(@unreadable_test4, @words)
      words.length.must_equal 0
    end
    
  end
  
end