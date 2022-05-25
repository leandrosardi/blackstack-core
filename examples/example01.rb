require_relative '../lib/blackstack-commons'

# returns true if the string meets all the security requirements for a password
puts ""
puts "Passwords"
a = ['Hello', 'HelloWorld12$3']
a.each { |s|
  print "'#{s}'.password?... "
  puts s.password?.to_s  
}

# returns true if the string match with the regex of a GUID
puts ""
puts "GUIDs"
a = [
  '{{331a92c3-5fe1-47a2-a31b-cfa439b5b4f9}',
  '{331a92c3-5fe1-47a2-a31b-cfa439b5b4f9}',
  '331a92c3-5fe1-47a2-a31b-cfa439b5b4f9',
  '{331A92C3-5FE1-47A2-A31B-CFA439B5B4F9}',
  '{331A92C3-5FE1-47A2-A31B-CFA439B5B4F9}}',
  '331A92C3-5FE1-47A2-A31B-CFA439B5B4F9',
  '331A92C3-5FE1-47A2-A31B-CFA439B5B4F9-fgf',
  '331A92C35FE147A2A31BCFA439B5B4F9',
]
a.each { |s|
  print "'#{s}'.guid?... "
  puts s.guid?.to_s  
}

# returns true if the string match with the regex of a filename
puts ""
puts "Filenames"
a = [
  'c:\filename.txt',
  'c:/filename.txt',
  'filename_1.txt',
  'filename-1.txt',
  'filename+1.txt',
  'filename?1.txt',
  'filename*1.txt',
  'filename.txt',
  'filename',
  'filename.txt.rar',
]
a.each { |s|
  print "'#{s}'.filename?... "
  puts s.filename?.to_s
}

# returns true if the string match with the regex of an email
puts ""
puts "Emails"
a = [
  'tango@expandedventure.com',
  'tango@expandedventure.com.ar',
  'tango',
  'tango@',
]
a.each { |s|
  print "'#{s}'.email?... "
  puts s.email?.to_s
}

# returns true if the string match with the regex of a domain
puts ""
puts "Domains"
a = [
  'tango',
  'tango@expandedventure',
  'tango@expandedventure.com',
  'tango@expandedventure.com.ar',
  'expandedventure.com',
  'expandedventure.com.ar',
  'https://expandedventure.com.ar',
  'www.expandedventure.com.ar',
  'https://www.expandedventure.com.ar',
]
a.each { |s|
  print "'#{s}'.domain?... "
  puts s.domain?.to_s
}

# returns true if the string match with the regex of a phone number
puts ""
puts "Domains"
a = [
  '+54 9 11 5061 2148',
  '545-5561-2148',
  '545-561-2148',
  '545 561 2148',
  '54 545 561 2148',
  '+54 545 561 2148',
  '+54 545-561-2148',
  '+54-545-561-2148',
]
a.each { |s|
  print "'#{s}'.domain?... "
  puts s.phone?.to_s
}

# returns true if the string match with the regex of a URL
puts ""
puts "URLs"
a = [
  'tango',
  'tango@expandedventure',
  'tango@expandedventure.com',
  'tango@expandedventure.com.ar',
  'expandedventure.com',
  'expandedventure.com.ar',
  'https://expandedventure.com.ar',
  'www.expandedventure.com.ar',
  'https://www.expandedventure.com.ar',
]
a.each { |s|
  print "'#{s}'.url?... "
  puts s.url?.to_s
}

# returns true if the string match with the regex of a number
puts ""
puts "Fixnums"
a = [
  '5',
  '5.5',
  '5,5',
  '5000',
  '5,000',
  '5.000',
]
a.each { |s|
  print "'#{s.to_s}'.fixnum?... "
  puts s.fixnum?.to_s
}

# returns true if the string match with the regex of a datetime used in the BlackStack's API
puts ""
puts "SQL DateTimes"
a = [
  '20191106215030',
  '20191106',
  '2019-11-06',
  '2019-11-06 21:50:30',
  '2019-13-06 21:50:30', # invalid month
  '2019-11-06 25:50:30', # invalid hour
  '2019-11-06 21:70:30', # invalid minute
  '2019-11-06 21:50:70', # invalid second
]
a.each { |s|
  print "'#{s.to_s}'.sql_datetime?... "
  puts s.sql_datetime?.to_s
}

#
puts ""
puts "API DateTimes"
a = [
  '20191106215030',
  '20191106',
  '2019-11-06',
  '2019-11-06 21:50:30',
  '20191306215030', # invalid month
  '20191106255030', # invalid hour
  '20191106217030', # invalid minute
  '20191106215070', # invalid second
]
a.each { |s|
  print "'#{s.to_s}'.api_datetime?... "
  puts s.api_datetime?.to_s
}

# Convierte un string con formato sql-datatime a un string con formato sql-datetime.
puts ""
puts "SQL DateTime -> API DateTime"
a = [
  '2019-11-06 21:50:30',
]
a.each { |s|
  print "'#{s.to_s}'.sql_to_api_datetime... "
  puts s.sql_to_api_datetime.to_s
}

# Convierte un string con formato api-datatime (yyyymmddhhmmss) a un string con formato sql-datetime (yyyy-mm-dd hh:mm:ss).
puts ""
puts "API DateTime -> SQL DateTime"
a = [
  '20191106215030',
]
a.each { |s|
  print "'#{s.to_s}'.api_to_sql_datetime... "
  puts s.api_to_sql_datetime.to_s
}

# Rewrite a GUID as a standard (normalized) format.
puts ""
puts "Any GUID -> Normalized Guid"
a = [
  '{331a92c3-5fe1-47a2-a31b-cfa439b5b4f9}',
  '331a92c3-5fe1-47a2-a31b-cfa439b5b4f9',
  '{331A92C3-5FE1-47A2-A31B-CFA439B5B4F9}',
  '331A92C3-5FE1-47A2-A31B-CFA439B5B4F9',
]
a.each { |s|
  print "'#{s}'.to_guid... "
  puts s.to_guid.to_s  
}

# Escape simple-quotes too add the string into literal-string of a dynamic query build into the Ruby code.
# Example: "I'm BlackStack" -> "I''m BlackStack" 
puts ""
puts "Any String -> String with Escaped Quotes"
a = [
  "I'm BlackStack",
  "Hello World!",
]
a.each { |s|
  print "'#{s}'.to_sql... "
  puts s.to_sql.to_s  
}

# 
puts ""
puts "Spintax"
a = [
  "I'm BlackStack",
  "Hello World!",
  "{Hello|Hi} World!",
  "{Hello|Hi|Good {Morning|Afternoon}} World!", # Nexted spintax. Not supported.
  "{Hello|Hi World!", # wrong syntax.
]
a.each { |s|
  print "'#{s}'.spintax?... "
  puts s.spintax?.to_s  
}

# Returns a random spin from a spintax
puts ""
puts "Spin"
a = [
  "{Hello|Hi|Good Morning|Good Afternoon} World!",
  "{Hello|Hi|Good Morning|Good Afternoon} World!",
  "{Hello|Hi|Good Morning|Good Afternoon} World!",
  "{Hello|Hi|Good Morning|Good Afternoon} World!",
]
a.each { |s|
  print "'#{s}'.spin... "
  puts s.spin  
}

# Converts a time object to an SQL friendy string
puts ""
puts "Time object -> SQL"
a = [
  Time.new(2019,11,6,15,25,55),
  DateTime.new(2019,11,6,15,25,55),
]
a.each { |o|
  print "'#{o.to_s}'.to_sql... "
  puts o.to_sql  
}

# Converts number to a string with a format like xx,xxx,xxx.xxxx 
puts ""
puts "Fixnum & Floats -> Screen Friendly Text"
a = [
  64443,
  64443.5454,
]
a.each { |i|
  print "'#{i.to_s}'.to_label... "
  puts i.to_label
}

# Converts number to a string with a format like xx,xxx,xxx.xxxx 
puts ""
puts "Fixnum Minutes -> Time Spent (days, hours, minutes)"
a = [
  59,
  60,
  61,
  600,
  601,
  1440,
  1441,
  1500,
  1501,
]
a.each { |i|
  print "Minutes '#{i.to_s}'.to_time_spent... "
  puts i.to_time_spent
}


=begin # TODO: Pending
encode_string
encode_html
encode_exception
encode_period
encode_javascript
=end