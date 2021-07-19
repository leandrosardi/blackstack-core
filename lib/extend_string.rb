class String
  # returns true if the string meets all the security requirements for a password
  def password?
    return true if self.to_s =~ /^#{BlackStack::Strings::MATCH_PASSWORD}$/
    return false
  end

  # returns true if the string match with the regex of a GUID
  def guid?
    return true if self.to_s =~ /^#{BlackStack::Strings::MATCH_GUID}$/
    return false
  end

  # returns true if the string match with the regex of a filename
  def filename?
    return true if self.to_s =~ /^#{BlackStack::Strings::MATCH_FILENAME}$/
    return false
  end

  # returns true if the string match with the regex of an email
  def email?
    return true if self.to_s =~ /^#{BlackStack::Strings::MATCH_EMAIL}$/
    return false
  end

  # returns true if the string match with the regex of a domain
  def domain?
    return true if self.to_s =~ /^#{BlackStack::Strings::MATCH_DOMAIN}$/  
    return false
  end

  # returns true if the string match with the regex of a phone number
  def phone?
    return true if self.to_s =~ /^#{BlackStack::Strings::MATCH_PHONE}$/
    return false
  end

  # returns true if the string match with the regex of a URL
  def url?
    return true if self.to_s =~ /^#{BlackStack::Strings::MATCH_URL}$/
    return false
  end

  # returns true if the string match with the regex of a number
  def fixnum?
    return true if self.to_s =~ /^#{BlackStack::Strings::MATCH_FIXNUM}$/    
    return false
  end

  # returns true if the string match with the regex of a datetime used in the BlackStack's API
  def api_datetime?
    BlackStack::Strings::DateTime::datetime_api_check(self.to_s)        
  end

  #
  def sql_datetime?
    BlackStack::Strings::DateTime::datetime_sql_check(self.to_s)            
  end

  # Convierte un string con formato sql-datatime a un string con formato sql-datetime.
  def sql_to_api_datetime
    BlackStack::Strings::DateTime::datetime_sql_to_api(self.to_s)    
  end

  # Convierte un string con formato api-datatime (yyyymmddhhmmss) a un string con formato sql-datetime (yyyy-mm-dd hh:mm:ss).
  def api_to_sql_datetime
    BlackStack::Strings::DateTime::datetime_api_to_sql(self.to_s)
  end

  # Rewrite a GUID as a standard format.
  # Example: {331a92c3-5fe1-47a2-a31b-cfa439b5b4f9} -> 331A92C3-5FE1-47A2-A31B-CFA439B5B4F9
  def to_guid
    BlackStack::Strings::Encoding::encode_guid(self.to_s)
  end
  
  # Escape simple-quotes too add the string into literal-string of a dynamic query build into the Ruby code.
  # Example: "I'm BlackStack" -> "I''m BlackStack" 
  def to_sql
    BlackStack::Strings::SQL::string_to_sql_string(self.to_s)
  end
  
  # 
  def spintax?
    BlackStack::Strings::Spinning::spintax?(self.to_s)
  end

  # 
  def spintax?
    BlackStack::Strings::Spinning::valid_spinning_syntax?(self.to_s) &&
    BlackStack::Strings::Spinning::spintax?(self.to_s)
  end
  
  # Returns a random spin from a spintax
  def spin
    BlackStack::Strings::Spinning::random_spinning_variation(self.to_s)
  end
  
  # Then it makes it compatible with UTF-8.
  # More details here: https://bitbucket.org/leandro_sardi/blackstack/issues/961  
  def encode_string()
    BlackStack::Strings::Encoding::encode_string(self.to_s)
  end
  
  # Escape the string to be shown into an HTML screen.
  # Then it makes it compatible with UTF-8.
  # More details here: https://bitbucket.org/leandro_sardi/blackstack/issues/961  
  def encode_html()
    BlackStack::Strings::Encoding::encode_html(self.to_s)    
  end
  
  # Escapes carriage returns and single and double quotes for JavaScript segments.
  # reference: https://api.rubyonrails.org/classes/ActionView/Helpers/JavaScriptHelper.html
  #
  # Example: 
  # <%
  # s = 'Hello World!'
  # %>
  # text = "<%=s.escape_javascript%>"
  # 
  # Never use single-quotation marks, because this method is not supporting it.
  # <%
  # s = 'Hello World!'
  # %>
  # text = '<%=s.escape_javascript%>'
  # 
  def escape_javascript
    s = self.dup
	  js_escape_map = { 
      '\\' => '\\\\', 
      "</" => '<\/', 
      "\r\n" => '\n', 
      "\n" => '\n', 
      "\r" => '\n', 
      '"' => '\\"', 
      "'" => "\'", 
      "`" => "\`", 
      "$" => "\\$", 
    }
	  js_escape_map.each { | x, y | s.gsub!(x,y) }
	  s
  end
  
end # class String
