require 'minitest_helper'

describe FuzzyScanner do
  
  before do
    @fs = FuzzyScanner.new
    @fs.regex = /([0 ][1-9]|1[012])[-\/.~X](0[1-9]|[12][0-9]|3[01])[-\/.~X]([0-9][0-9]$)/
  end
  
  describe "Fuzzily find matching text!" do
    
    describe "finds the matches" do
      
      it "finds perfectly matched text with fuzziness 0" do
        matches = @fs.fscan!("03/18/14", 0)
        matches.length.must_equal 1
        matches[0][0].must_equal "03/18/14"
      end
      
      it "finds 1-edit matched text with fuzziness 1" do
        matches = @fs.fscan!("03/I8/14", 1)
        matches.length.must_equal 1
        matches[0][0].must_equal "03/I8/14"
      end
      
    end
    
    describe "cannot find the matches" do
      
      it "cannot find 2-edit text with fuzziness 1" do
        matches = @fs.fscan!("03/18/IA", 1)
        matches.must_be_empty
      end
      
      it "cannot find matches with regex not matching" do
        matches = @fs.fscan!("18/18/14", 0)
        matches.must_be_empty
      end
      
    end
    
  end
  
end