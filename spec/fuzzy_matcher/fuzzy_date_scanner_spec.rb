require 'minitest_helper'

describe FuzzyDateScanner do
  
  before do
    # 03/18/2014 or 3/18/2014
    @fs1 = FuzzyDateScanner.new "%m/%d/%Y", /([0 ][1-9]|1[012])[-\/.~X](0[1-9]|[12][0-9]|3[01])[-\/.~X](20[0-9][0-9]|[0-9][0-9]$)/
      
    # 18/03/2014
    @fs2 = FuzzyDateScanner.new "%d/%m/%Y", /(0[1-9]|[12][0-9]|3[01])[-\/.~X](0[1-9]|1[012])[-\/.~X](20[0-9][0-9]|[0-9][0-9]$)/
  end
  
  describe "Fuzzily find matching date!" do
    
    describe "finds the matches" do
      
      describe "m/d/Y" do
        it "finds perfectly matched text for %m/%d/%y with fuzziness 0" do
          matches = @fs1.fscan!("03/18/14", 0)
          matches.length.must_equal 1
          matches[0][0].must_equal "03/18/14"
        end

        it "finds perfectly matched text for %m/%d/%Y with fuzziness 0" do
          matches = @fs1.fscan!("03/18/2014", 0)
          matches.length.must_equal 1
          matches[0][0].must_equal "03/18/2014"
        end
      
        it "finds 1-edit matched text with fuzziness 1" do
          matches = @fs1.fscan!("03/18/201A", 1)
          matches.length.must_equal 1
          matches[0][0].must_equal "03/18/201A"
        end
      end
      
      describe "d/m/Y" do
        it "finds perfectly matched text for %d/%m/%y with fuzziness 0" do
          matches = @fs2.fscan!("23/08/14", 0)
          matches.length.must_equal 1
          matches[0][0].must_equal "23/08/14"
        end

        it "finds perfectly matched text for %d/%m/%Y with fuzziness 0" do
          matches = @fs2.fscan!("13/08/2014", 0)
          matches.length.must_equal 1
          matches[0][0].must_equal "13/08/2014"
        end
      
        it "finds 1-edit matched text with fuzziness 1" do
          matches = @fs2.fscan!("18/01/201A", 1)
          matches.length.must_equal 1
          matches[0][0].must_equal "18/01/201A"
        end
      end
      
    end
    
    describe "cannot find the matches" do
      
      describe "m/d/Y" do
        it "cannot find 1-subbed text with fuzziness 0 (by default one sub costs 1)" do
          matches = @fs1.fscan!("18/18/14", 0)
          matches.must_be_empty
        end
      
        it "cannot find 2-subbed text with fuzziness 1 (by default one sub costs 1)" do
          matches = @fs1.fscan!("18/18/I4", 1)
          matches.must_be_empty
        end

        it "cannot find 2-subbed text with fuzziness 1 (by default one sub costs 1)" do
          matches = @fs1.fscan!(" 3/I6/2DI4", 1)
          matches.must_be_empty
        end
      end
      
      describe "d/m/Y" do
        it "cannot find 1-subbed text with fuzziness 0 (by default one sub costs 1)" do
          matches = @fs2.fscan!("08/18/14", 0)
          matches.must_be_empty
        end
      
        it "cannot find 2-subbed text with fuzziness 1 (by default one sub costs 1)" do
          matches = @fs2.fscan!("08/18/I4", 1)
          matches.must_be_empty
        end

        it "cannot find 2-subbed text with fuzziness 1 (by default one sub costs 1)" do
          matches = @fs2.fscan!("13/I6/20I4", 1)
          matches.must_be_empty
        end
      end
      
    end
    
  end
  
end