class FuzzySub
  
  CHAR_2_NUM_SUB = {
    "A" => "4",
    "OoD" => "0",
    "liI," => "1",
    "q" => "4" #could be 9
  }

  attr_accessor :sub_hash
  
  def initialize(sub_hash)
    @sub_hash = sub_hash
  end
  
  def fsub!(word)
    sub_hash.each do |k, v|
      word.gsub!(/[#{k}]/, v)
    end
    word
  end
  
end

module FuzzySubString

  def fsub!(sub_hash)
    fs = FuzzySub.new sub_hash
    fs.fsub! self
  end
  
end

