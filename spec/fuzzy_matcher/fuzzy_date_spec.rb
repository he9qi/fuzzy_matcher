require 'minitest_helper'

describe FuzzyDate do
  
  before do
    @sample1 = "Re9 Trans Dafe/TIme CashIer\n003 7269 2014-O4-1q l8:21 O1972808\n610984528 BCCESSORIES $20,00 $12 DO\nTrans DIscounf $8.00"
    @sample2 = " 4/17/2014 1:23 PM }"
    @sample3 = "4ApR2O,4"
    @fd = FuzzyDate.new 1
  end
  
  
  describe "it scans the dates from text" do
    
    it "gets dates matches for %Y-%m-%d with default fuzziness 1" do 
      matches = @fd.fscan @sample1
      matches.length.must_equal 2
      matches[0][1].must_equal "%Y-%m-%d"
      matches[1][0][0][0].must_equal "21 O19" #unfortunately scanned a wrong date becoz fuzzy is 2
    end

    it "gets dates matches for %d%b%Y with default fuzziness 1" do 
      matches = @fd.fscan @sample3
      matches.length.must_equal 1
      matches[0][1].must_equal "%d%b%Y"
      matches[0][0][0][0].must_equal "4ApR2O,4" #unfortunately scanned a wrong date becoz fuzzy is 2
    end
    
    it "gets dates matches for %m/%d/%Y with fuzziness 1" do
      matches = @fd.fscan @sample2, 1
      matches.length.must_equal 1
      matches[0][1].must_equal "%m/%d/%Y"
    end
    
  end
  
  describe "it returns date" do
    
    it "scans and find the date with max fuzziness 1" do
      @fd.max_fuzz = 3
      dates = @fd.to_date @sample3
      dates.length.must_equal 1
      dates[0].to_s.must_equal "2014-04-04"
    end

    it "scans and find the date with max fuzziness 2" do
      dates = @fd.to_date @sample2
      dates.length.must_equal 1
      dates[0].to_s.must_equal "2014-04-17"
    end
    
  end
  
  describe "it scans but cannot find date with fuzziness 1" do
    
    it "scans and returns the date with max fuzziness 1" do
      @fd.max_fuzz = 1
      dates = @fd.to_date @sample1
      dates.length.must_equal 0
    end
    
    it "scans and returns the date with max fuzziness 1" do
      @fd.max_fuzz = 2
      dates = @fd.to_date @sample1
      dates.length.must_equal 1
      dates[0].to_s.must_equal "2014-04-14"
    end
    
    it "string can extend this module scans and returns the date with max fuzziness 1" do
      dates = @sample1.extend(FuzzyDateString).to_date 2
      dates.length.must_equal 1
    end
    
  end
  
  
end