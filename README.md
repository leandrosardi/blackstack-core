# BlackStack Core

This gem has been designed as a part of the **BlackStack** framework.

It has some commons functions that are needed for most of all the **BlackStack** projects.

I ran tests on:

- Ubuntu 18.04,
- Ubuntu 20.04, and
- Windows 7 only.

Email to me if you want to collaborate.

**Outline**

1. [Installation](#1-installation)
2. [Sandbox](#2-sandbox)
3. [Internal API](#3-internal-api)
4. [Break Points](#4-break-points)
5. [Passwords Validation](#5-passwords-validation)
6. [GUIDs Validation](#6-guids-validation)
7. [Filenames Validation](#7-filenames-validation)
8. [Emails Validation](#8-emails-validation)
9. [Domains Validation](#9-domains-validation)
10. [Phone Numbers Validation](#10-phone-numbers-validation)
11. [URLs Validation](#11-urls-validation)
12. [Integers Validation](#12-integers-validation)
13. [SQL Date-Times Validation](#13-sql-date-times-validation)
14. [GUID Normalization](#14-guid-normalization)
15. [SQL Encoding](#15-sql-encoding)
16. [Spintax Validation](#16-spintax-validation)
17. [Spintax Errors](#17-spintax-errors)
18. [Spintax Sampling](#18-spintax-sampling)
19. [Numbers Labeling](#19-numbers-labeling)
20. [Time Spent Labeling](#20-time-spent-labeling)
21. [Exceptions Encoding](#21-exceptions-encoding)
22. [Encoding Strings](#22-encoding-strings)

## 1. Installation

```
gem install blackstack-core
```

Require `blackstack-core` in your Ruby scripts.

```ruby
require 'blackstack-core
```

## 2. Sandbox

This function returns true if there is a `.sandbox` file in the current folder `./`.

It is often used by [my.saas](https://github.com/leandrosardi/my.saas) and by many [micro-services](https://github.com/leandrosardi/micro.template), to switch configurations between **development environment** and **production environment**.

You can create the `.sandbox` file using the `touch` command, like is shown below:

```
touch .sandbox
```

You can check if the `.sandbox` file exists, using the Ruby code below.

```ruby
puts BlackStack.sandbox?
# => true
```

## 3. Internal API

This module is used by [my.saas](https://github.com/leandrosardi/my.saas) and by many [micro-services](https://github.com/leandrosardi/micro.template) for internal communication between them.

This module is to register the API key and URL of the **my.saas**, where all **micro-services** must submit the results of their jobs.

```ruby
# Setup connection to the API, in order get micro-services requesting and pushing data from/to the my.saas.
#
BlackStack::API::set_api_url({
  :api_key => '118f3c32-****-****-****-************', 
  :api_protocol => BlackStack.sandbox? ? 'http' : 'https',
  :api_domain => BlackStack.sandbox? ? '127.0.0.1' : 'connectionsphere.com', 
  :api_port => BlackStack.sandbox? ? '3000' : '443',
  :api_less_secure_port => '3000',
})
```

Getting the api-key anywhere:

```ruby
puts BlackStack::API.api_key
# => 118f3c32-****-****-****-************
```

Getting secure API URL:

```ruby
puts BlackStack::API.api_url
# => https://connectionspher.com:443
```

Getting secure API less secure URL:

```ruby
puts BlackStack::API.api_less_secure_url
# => http://connectionspher.com:3000
```

## 4. Break Points

The `BlackStack::Debugging` can be configured to enable or disable [Pry](https://pry.github.io/)'s `binding.pry` breakpoints.

> `binding.pry` can be invoked in the middle of a running program. 
> 
> It opens a Pry session at the point it's called and makes all program state at that point available. 
> 
> When the session ends the program continues with any modifications you made to it.

The `binding.pry` works only if `BlackStack::Debugging::allow_breakpoints` has not been set as `false`.

If `BlackStack::Debugging::allow_breakpoints` has been set as `false`, then `BlackStack::Debugging` does a [monkey-patch](https://stackoverflow.com/a/17666791/14707410) to that [Pry](https://pry.github.io/)'s `binding.pry` method.

**Example:**

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

The goal of using `BlackStack::Debugging` instead of the original `binding.pry` function, is to keep the brakpoints in your source off when running on production.

To accomplish with that, we combine `BlackStack::Debugging` with `BlackStack.sandbox?`.

**Example:**

```ruby
require_relative 'blackstack-core'

BlackStack::Debugging.set({
    # set this to false to do a monkey-patch into the `binding.pry` method,
    # in order to disable the breakpoint functionality. 
    # 
    # activate this in your development environment only.
    # never activate it in production.
    :allow_breakpoints => BlackStack.sandbox?, # it is false by default
    # activate this to do a `print "Breakpoint are not allowed"` when calling `binding.pry` but `allow_breakpoints` is `false`
    :verbose => true, # it is false by default
})
```

## 5. Passwords Validation

Use the `password?` method to check if a password meets with **stregth standard** of BlackStack.

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

## 6. GUIDs Validation

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

## 7. Filenames Validation

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

## 8. Emails Validation

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

## 9. Domains Validation

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

## 10. Phone Numbers Validation

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

## 11. URLs Validation

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

## 12. Integers Validation

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

## 13. SQL Date-Times Validation

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

## 14. GUID Normalization

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

## 15. SQL Encoding

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

## 16. Spintax Validation

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

## 17. Spintax Errors

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
  puts s.valid_spinning_syntax?.to_s  
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

## 18. Spintax Sampling

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

## 19. Numbers Labeling

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

## 20. Time Spent Labeling

Convert FixNum Minutes to String with Description of Time Spent 

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

## 21. Exceptions Encoding

How an exception message.

```ruby
print 'Do something... '
begin
  raise "An error happened here"
  puts 'done'
rescue => e
  puts e.to_console
end
```

By default, `to_console` includes all the backtrace. You can disable it.

```ruby
print 'Do something... '
begin
  raise "An error happened here"
  puts 'done'
rescue => e
  puts e.to_console(false)
end
```

If you want to show the backtrace into a webpage, use `to_html` instead, in order to encode the content properly.

```ruby
print 'Do something... '
begin
  raise "An error happened here"
  puts 'done'
rescue => e
  puts e.to_html
end
```

## 22. Encoding Strings

To show any string into an HTML page, you have to encode it properly.

```ruby
<%
lesson = 'Use HTML entieties (e.g.: &cent;) and tabas (e.g.: <h1>title</h1>) in your HTML code.'
%>
<h1>Introduction to HTML</h1>
<p><%=lesson%></p>
```

## Change Log

| Version |                                                          |
|---------|----------------------------------------------------------|
| 1.1.x   | Supporting Ruby 2.2.4                                    |
| 1.2.x   | Supporting Ruby 3.1.2 (refer to https://github.com/leandrosardi/blackstack-core/issues/3 for more information) |

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the last [ruby gem](https://rubygems.org/gems/simple_command_line_parser). 

## Authors

* **Leandro Daniel Sardi** - *Initial work* - [LeandroSardi](https://github.com/leandrosardi)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details


