require 'minitest_helper'

describe FuzzySub do
  
  before do
    @fs = FuzzySub.new({ "A" => "4" })
  end
  
  describe "Find text to sub!" do
    
    it "must only sub the should subbed words" do
      @fs.fsub!("O3/18/1A").must_equal "O3/18/14"
    end
    
  end
  
  describe "String extends fuzzy sub" do
    
    it "String extends fuzzy sub should be able to do fuzzy sub!" do
      "O3/18/1A".extend(FuzzySubString).fsub!({ "A" => "4" }).must_equal "O3/18/14"
    end
    
  end
  
end