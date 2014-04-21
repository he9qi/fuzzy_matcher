require 'date'

class FuzzyDate
  
  FORMAT_2_REGEX = {
    # 03/18/2014 or 3/18/2014
    "%m/%d/%Y" => /(0?[1-9]|1[012])[-\/.~X](0?[1-9]|[12][0-9]|3[01])[-\/.~X](20[0-9][0-9]|[0-9][0-9]$)/,

    # 18/03/2014
    "%d/%m/%Y" => /(0[1-9]|[12][0-9]|3[01])[-\/.~X](0[1-9]|1[012])[-\/.~X](20[0-9][0-9]|[0-9][0-9]$)/,
    
    # 2014-04-14
    "%Y-%m-%d" => /(20[0-9][0-9])[-.~](0[1-9]|1[012])[-.~](0[1-9]|[12][0-9]|3[01])/,

    # 10APR2014 or 4APR2014
    "%d%b%Y" => /(0?[1-9]|[12][0-9]|3[01])(JAN|FEB|MAR|APR|ApR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)(19|20[0-9][0-9])/,

    # April 7, 2014
    "%B %d, %Y" => /(January|February|March|April|May|June|July|August|September|October|November|December) *(0?[1-9]|[12][0-9]|3[01])[,.]? *(19|20[0-9][0-9])/
  }
  
  attr_accessor :max_fuzz
  
  def initialize(max_fuzz=2)
    @fsub     = FuzzySub.new FuzzySub::CHAR_2_NUM_SUB
    @max_fuzz = max_fuzz
    @scanners = [] 
    FORMAT_2_REGEX.each do |key, value|
      register key, value
    end
  end
  
  def register(format, regex)
    @scanners << FuzzyDateScanner.new(format, regex)
  end
  
  # allow fuzziness of 2 by default
  def fscan(string, fuzziness=2)
    @scanners.map do |fdscan|
      matches = fdscan.fscan!(string, fuzziness)
      [matches, fdscan.format] if !matches.empty?
    end.compact
  end
  
  def validaterize(m, format)
    str    = m[0]
    
    case format
    when "%Y-%m-%d"
      date = @fsub.fsub!(m[3])
      mont = @fsub.fsub!(m[2])
      year = @fsub.fsub!(m[1])
      str  = "#{year}-#{mont}-#{date}"
    when "%m/%d/%Y"
      date = @fsub.fsub!(m[2])
      mont = @fsub.fsub!(m[1])
      year = @fsub.fsub!(m[3])
      format = "%m/%d/%y" if year.length < 4
      str    = "#{mont}/#{date}/#{year}"
    when "%d/%m/%Y"
      date = @fsub.fsub!(m[1])
      mont = @fsub.fsub!(m[2])
      year = @fsub.fsub!(m[3])
      format = "%d/%m/%y" if year.length < 4
      str    = "#{date}/#{mont}/#{year}"
    when "%d%b%Y"
      date = @fsub.fsub!(m[1])
      mont = m[2].upcase
      year = @fsub.fsub!(m[3])
      format = "%d%b%y"   if year.length < 4
      str    = "#{date}#{mont}#{year}"
    end
    
    [str.strip, format]
  end
  
  def matches_to_dates(matches)
    dates = []
    matches.each do |m|
      # p "#{self.class.to_s} match: #{m[0]} with format #{m[1]}"
      strings = m[0]
      format  = m[1]
      
      strings.each do |str|
        k = validaterize str, format
        # p "#{k[0]}, #{k[1]}"
        begin
          date = Date.strptime(k[0], k[1])
          dates << date
        rescue ArgumentError
          # p "String #{k[0]} is not valide date for date format #{k[1]}"
        end
      end
    end
    dates
  end
  
  # iteratively find the dates, try fuzziness 1 and then 2
  def to_date(string)
    dates = []
    fuzz = 1
    while fuzz <= @max_fuzz do
      matches = fscan string, fuzz
      dates   = matches_to_dates matches
      break if !dates.empty?
      fuzz = fuzz + 1
    end
    dates
  end
  
end

module FuzzyDateString

  def to_date(max_fuzz=2)
    FuzzyDate.new(max_fuzz).to_date self
  end
  
end