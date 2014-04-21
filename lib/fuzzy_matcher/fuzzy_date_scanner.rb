# {
#   # 03/18/2014 or 3/18/2014
#   "%m/%d/%Y" => /([0 ][1-9]|1[012])[-\/.~X](0[1-9]|[12][0-9]|3[01])[-\/.~X](20[0-9][0-9]|[0-9][0-9]$)/,
#   
#   # 18/03/2014
#   "%d/%m/%Y" => /(0[1-9]|[12][0-9]|3[01])[-\/.~X](0[1-9]|1[012])[-\/.~X](20[0-9][0-9]|[0-9][0-9]$)/,
#
#   # 2014-04-14
#   "%Y-%m-%d" => /(20[0-9][0-9])[-.~](0[1-9]|1[012])[-.~](0[1-9]|[12][0-9]|3[01])/,
# 
#   # 10APR2014 or 4APR2014
#   "%d%b%Y" => /([0 ][1-9]|[12][0-9]|3[01])(JAN|FEB|MAR|APR|ApR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)(19|20[0-9][0-9])/,
# 
#   # April 7, 2014
#   "%B %d, %Y" => /(January|February|March|April|May|June|July|August|September|October|November|December) *(0?[1-9]|[12][0-9]|3[01])[,.]? *(19|20[0-9][0-9])/
# }

class FuzzyDateScanner < FuzzyScanner
  
  attr_accessor :format
  
  def initialize(format, regex)
    @format = format
    @regex  = regex
  end

end