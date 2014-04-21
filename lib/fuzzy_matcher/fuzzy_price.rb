# encoding: UTF-8

require 'tre-ruby'

class Regexp
  def +(r)
    Regexp.new(source + r.source)
  end
end

class FuzzyPrice
  
  FUZZY_PRICE_REGEX = /\$?([1-9]*[0-9])[._-—]([0-9][0-9])/
  TOTAL_TEXT_REGEX = /(Total|TOTAL|Total Applied) +/
  
  attr_accessor :max_fuzz, :price_regex
  
  def initialize(max_fuzz=2)
    @max_fuzz = max_fuzz
    @fsub     = FuzzySub.new FuzzySub::CHAR_2_NUM_SUB
  end
  
  def price_regex
    @price_regex ||= FUZZY_PRICE_REGEX
  end
  
  def find_price(file, text_regex, fuzzy_thresh=2)
    prices = []
    regex = text_regex + FUZZY_PRICE_REGEX
    
    words = file.split("\n")
    words.each do |word|
      # p "check word => #{word}"
      
      matches = word.extend(TRE).ascan regex, TRE.fuzziness(fuzzy_thresh)
      matches.each do |match|
        
        # match the price regex separately again to improve accuracy
        match = (match[0].extend(TRE).ascan price_regex, TRE.fuzziness(fuzzy_thresh))[0]
        next if !match
        
        a = match[1]
        b = match[2]
        # p match
      
        a = @fsub.fsub!(a)
        b = @fsub.fsub!(b)
        
        next if a.empty? || b.empty?
        
        w = "#{a}.#{b}"
        
        # remove $
        w.gsub!("$", "")
        
        # p "---> #{w}"
        prices << w.to_f
      end

    end
    prices
  end
  
  def to_price(string, regex)
    prices = []
    fuzz = 1
    while fuzz <= @max_fuzz do
      prices = find_price string, regex, fuzz
      break if !prices.empty?
      fuzz = fuzz + 1
    end
    prices
  end
  
end

module FuzzyPriceString
  
  def to_price(regex, max_fuzz=2)
    FuzzyPrice.new(max_fuzz).to_price self, regex
  end
  
end