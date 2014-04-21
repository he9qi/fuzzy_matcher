class FuzzyWords
  
  attr_accessor :max_fuzz
  
  def initialize(max_fuzz=4)
    @max_fuzz = max_fuzz
  end
  
  def find_words(file, words)
    words.map do |w|
      matches = find_word file, w
      { word: w, matches: matches } if !matches.empty?
    end.compact
  end
  
  def find_word(text, word)
    matches = []
    fuzz = 1
    while fuzz <= @max_fuzz do
      matches = text.extend(TRE).ascan word, TRE.fuzziness(fuzz)
      break if !matches.empty?
      fuzz = fuzz + 1
    end
    matches
  end

end

module FuzzyWordsString
  
  def fuzzy_match_words(words, max_fuzz=4)
    FuzzyWords.new(max_fuzz).find_words(self, words)
  end
  
end


