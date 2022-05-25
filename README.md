# BlackStack Core

This gem has been designed as a part of the **BlackStack** framework.

It has some commons functions that are needed for most of all the **BlackStack** services.

I ran tests in Windows environments only.

Email to me if you want to collaborate, by testing this library in any Linux platform.

## Installation

```
gem install blackstack-core
```

## Break Points

The `BlackStack::Debugging` can be configured to enable or disable [Pry](https://pry.github.io/)'s `binding.pry` breakpoints.

> `binding.pry` can be invoked in the middle of a running program. 
> 
> It opens a Pry session at the point it's called and makes all program state at that point available. 
> 
> When the session ends the program continues with any modifications you made to it.

The `binding.pry` works only if `BlackStack::Debugging::allow_breakpoints` has not been set as `false`.

If `BlackStack::Debugging::allow_breakpoints` has been set as `false`, then `BlackStack::Debugging` does a [monkey-patch](https://stackoverflow.com/a/17666791/14707410) to that [Pry](https://pry.github.io/)'s `binding.pry` method.

```ruby
require_relative 'blackstack-core'

BlackStack::Debugging.set({
    # set this to false to do a monkey-patch into the `binding.pry` method,
    # in order to disable the breakpoint functionality. 
    # 
    # activate this in your development environment only.
    # never activate it in production.
    :allow_breakpoints => true, # it is false by default
    # activate this to do a `print "Breakpoint are not allowed"` when calling `binding.pry` but `allow_breakpoints` is `false`
    :verbose => true, # it is false by default
})

(1..100).each do |i|
  binding.pry if i == 50
  puts i
end
```

The goal of using `BlackStack::Debugging.breakpoint` instead `binding.pry` is to keep the brakpoints in your source code being sure that they will work in your development environment only, by handling 2 differnet ruby configuration files (example: `config.dev.rb` and `config.prod.rb`)

For more information about Pry, refere to this URL: [https://pry.github.io/](https://pry.github.io/)

## Passwords Validation 

```ruby
require 'blackstack-core'

# returns true if the string meets all the security requirements for a password
puts ""
puts "Passwords"
a = ['Hello', 'HelloWorld12$3']
a.each { |s|
  print "'#{s}'.password?... "
  puts s.password?.to_s  
}
```

```
Passwords
'Hello'.password?... false
'HelloWorld12$3'.password?... true
```

## GUIDs Validation

```ruby
require 'blackstack-core'

# returns true if the string match with the regex of a GUID
puts ""
puts "GUIDs"
a = [
  '{331a92c3-5fe1-47a2-a31b-cfa439b5b4f9}',
  '331a92c3-5fe1-47a2-a31b-cfa439b5b4f9',
  '{331A92C3-5FE1-47A2-A31B-CFA439B5B4F9}',
  '331A92C3-5FE1-47A2-A31B-CFA439B5B4F9',
  '331A92C35FE147A2A31BCFA439B5B4F9',
]
a.each { |s|
  print "'#{s}'.guid?... "
  puts s.guid?.to_s  
}
```

```
GUIDs
'{331a92c3-5fe1-47a2-a31b-cfa439b5b4f9}'.guid?... true
'331a92c3-5fe1-47a2-a31b-cfa439b5b4f9'.guid?... true
'{331A92C3-5FE1-47A2-A31B-CFA439B5B4F9}'.guid?... true
'331A92C3-5FE1-47A2-A31B-CFA439B5B4F9'.guid?... true
'331A92C35FE147A2A31BCFA439B5B4F9'.guid?... false
```

## Filename Format Validation 

```ruby
require 'blackstack-core'

# returns true if the string match with the regex of a filename
puts ""
puts "Filenames"
a = [
  'filename.txt',
  'filename',
  'filename.txt.rar',
]
a.each { |s|
  print "'#{s}'.filename?... "
  puts s.filename?.to_s
}
```

```
Filenames
'filename.txt'.filename?... true
'filename'.filename?... false
'filename.txt.rar'.filename?... false
```

## Email Format Validation 

```ruby
require 'blackstack-core'

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
```

```
Emails
'tango@expandedventure.com'.email?... true
'tango@expandedventure.com.ar'.email?... true
'tango'.email?... false
'tango@'.email?... false
```

## Domain Name Format Validation 

```ruby
require 'blackstack-core'

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
```

```
Domains
'tango'.domain?... false
'tango@expandedventure'.domain?... false
'tango@expandedventure.com'.domain?... true
'tango@expandedventure.com.ar'.domain?... true
'expandedventure.com'.domain?... true
'expandedventure.com.ar'.domain?... true
'https://expandedventure.com.ar'.domain?... true
'www.expandedventure.com.ar'.domain?... true
'https://www.expandedventure.com.ar'.domain?... true
```

## Phone Number Format Validation 

```ruby
require 'blackstack-core'

# returns true if the string match with the regex of a phone number
puts ""
puts "Phone Numbers"
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
  print "'#{s}'.phone?... "
  puts s.phone?.to_s
}
```

```
Phone Numbers
'+54 9 11 5061 2148'.domain?... false
'545-5561-2148'.domain?... false
'545-561-2148'.domain?... true
'545 561 2148'.domain?... true
'54 545 561 2148'.domain?... true
'+54 545 561 2148'.domain?... true
'+54 545-561-2148'.domain?... true
'+54-545-561-2148'.domain?... true
```

## URL Format Validation 

```ruby
require 'blackstack-core'

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
```

```
URLs
'tango'.url?... false
'tango@expandedventure'.url?... false
'tango@expandedventure.com'.url?... true
'tango@expandedventure.com.ar'.url?... true
'expandedventure.com'.url?... true
'expandedventure.com.ar'.url?... true
'https://expandedventure.com.ar'.url?... true
'www.expandedventure.com.ar'.url?... true
'https://www.expandedventure.com.ar'.url?... true
```

## Fixnum Format Validation 

```ruby
require 'blackstack-core'

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
```

```
Fixnums
'5'.fixnum?... true
'5.5'.fixnum?... false
'5,5'.fixnum?... false
'5000'.fixnum?... true
'5,000'.fixnum?... false
'5.000'.fixnum?... false
```

## SQL Date-Time Format Validation 

```ruby
require 'blackstack-core'

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
```

```
SQL DateTimes
'20191106215030'.sql_datetime?... false
'20191106'.sql_datetime?... false
'2019-11-06'.sql_datetime?... false
'2019-11-06 21:50:30'.sql_datetime?... true
'2019-13-06 21:50:30'.sql_datetime?... false
'2019-11-06 25:50:30'.sql_datetime?... false
'2019-11-06 21:70:30'.sql_datetime?... false
'2019-11-06 21:50:70'.sql_datetime?... false
```

## BlackStack API Date-Time Format Validation

```ruby
require 'blackstack-core'

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
```

```
API DateTimes
'20191106215030'.api_datetime?... true
'20191106'.api_datetime?... false
'2019-11-06'.api_datetime?... false
'2019-11-06 21:50:30'.api_datetime?... false
'20191306215030'.api_datetime?... false
'20191106255030'.api_datetime?... false
'20191106217030'.api_datetime?... false
'20191106215070'.api_datetime?... false
```

## Convert SQL Date-Time Format String, to BlackStack's API Date-Time Format String

```ruby
require 'blackstack-core'

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
```

```
SQL DateTime -> API DateTime
'2019-11-06 21:50:30'.sql_to_api_datetime... 20191106215030
```

## Convert BlackStack's API Date-Time Format String, to SQL Date-Time Format String

```ruby
require 'blackstack-core'

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
```

```
API DateTime -> SQL DateTime
'20191106215030'.api_to_sql_datetime... 2019-11-06 21:50:30
```

## Convert SQL GUID to a Standard (Normalized) Format

```ruby
require 'blackstack-core'

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
```

```
Any GUID -> Normalized Guid
'{331a92c3-5fe1-47a2-a31b-cfa439b5b4f9}'.to_guid... 331A92C3-5FE1-47A2-A31B-CFA439B5B4F9
'331a92c3-5fe1-47a2-a31b-cfa439b5b4f9'.to_guid... 331A92C3-5FE1-47A2-A31B-CFA439B5B4F9
'{331A92C3-5FE1-47A2-A31B-CFA439B5B4F9}'.to_guid... 331A92C3-5FE1-47A2-A31B-CFA439B5B4F9
'331A92C3-5FE1-47A2-A31B-CFA439B5B4F9'.to_guid... 331A92C3-5FE1-47A2-A31B-CFA439B5B4F9
```

## Escape String with Simple-Quotes to SQL Format

```ruby
require 'blackstack-core'

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
```

```
Any String -> String with Escaped Quotes
'I'm BlackStack'.to_sql... I''m BlackStack
'Hello World!'.to_sql... Hello World!
```

## Check if String is a Valid Spintax

```ruby
require 'blackstack-core'

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
```

```
Spintax
'I'm BlackStack'.spintax?... false
'Hello World!'.spintax?... false
'{Hello|Hi} World!'.spintax?... true
'{Hello|Hi|Good {Morning|Afternoon}} World!'.spintax?... false
'{Hello|Hi World!'.spintax?... false
```

## Get Sample Text from Spintax

```ruby
require 'blackstack-core'

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
```

```
Spin
'{Hello|Hi|Good Morning|Good Afternoon} World!'.spin... Good Afternoon World!
'{Hello|Hi|Good Morning|Good Afternoon} World!'.spin... Hi World!
'{Hello|Hi|Good Morning|Good Afternoon} World!'.spin... Hello World!
'{Hello|Hi|Good Morning|Good Afternoon} World!'.spin... Good Morning World!
```

## Convert Ruby Time Object to SQL Friendy Date-Time String

```ruby
require 'blackstack-core'

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
```

```
Time object -> SQL
'2019-11-06 15:25:55 -0300'.to_sql... 2019-11-06 15:25:55
'2019-11-06T15:25:55+00:00'.to_sql... 2019-11-06 15:25:55
```

## Convert Sting to HTML Friendy String

```ruby
require 'blackstack-core'

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
```

```
Fixnum & Floats -> Screen Friendly Text
'64443'.to_label... 64,443
'64443.5454'.to_label... 64,443.5454
```

## Convert FixNum Minutes to String with Description of Time Spent 

```ruby
require 'blackstack-core'

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
```

```
Fixnum Minutes -> Time Spent (days, hours, minutes)
Minutes '59'.to_time_spent... 59 minutes
Minutes '60'.to_time_spent... 1 hours, 0 minutes
Minutes '61'.to_time_spent... 1 hours, 1 minutes
Minutes '600'.to_time_spent... 10 hours, 0 minutes
Minutes '601'.to_time_spent... 10 hours, 1 minutes
Minutes '1440'.to_time_spent... 1 days, 0 hours
Minutes '1441'.to_time_spent... 1 days, 0 hours
Minutes '1500'.to_time_spent... 1 days, 1 hours
Minutes '1501'.to_time_spent... 1 days, 1 hours
```

## OCRA Supporting Functions

OCRA files run into a temp folder, where the script is unpacked.
This function is useful to require a configuration file when the script is running inside an OCRA temp folder, since the local folder of the running command is not the folder where the exe file is hosted.
More information: https://stackoverflow.com/questions/1937743/how-to-get-the-current-working-directorys-absolute-path-from-irb

```ruby
require 'blackstack-core'
BlackStack::OCRA::require_in_working_path 'config.rb', ENV["OCRA_EXECUTABLE"] || __FILE__  
```

#

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the last [ruby gem](https://rubygems.org/gems/simple_command_line_parser). 

## Authors

* **Leandro Daniel Sardi** - *Initial work* - [LeandroSardi](https://github.com/leandrosardi)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details


