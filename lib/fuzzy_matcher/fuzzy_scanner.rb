require 'tre-ruby'

class FuzzyScanner
  
  attr_accessor :regex
  
  # allow fuzziness of 2 by default
  def fscan!(str, fuzziness=2)
    str.gsub!(/\n/, " ")
    words = str.extend(TRE).ascan regex, TRE.fuzziness(fuzziness)
    words.uniq
  end

end