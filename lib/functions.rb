module BlackStack
  # ----------------------------------------------------------------------------------------- 
  # DateTime Functions
  # ----------------------------------------------------------------------------------------- 
  module DateTime    
    # ----------------------------------------------------------------------------------------- 
    # Encoding
    # ----------------------------------------------------------------------------------------- 
    module Encoding
      # Convierte un objeto date-time a un string con formato sql-datetime (yyyy-mm-dd hh:mm:ss).
      def self.datetime_to_sql(o)
        return o.strftime("%Y-%m-%d %H:%M:%S")
      end
    end # module Encode

    # ----------------------------------------------------------------------------------------- 
    # Miscelaneous
    # ----------------------------------------------------------------------------------------- 
    module Misc
      def self.datetime_values_check(year,month,day,hour,minute,second)
        if (year.to_i<1900 || year.to_i>=2100)
          return false
        end
      
        if (month.to_i<1 || month.to_i>12)
          return false
        end
      
        # TODO: Considerar la cantidad de dias de cada mes, y los anios biciestos. Buscar alguna funcion existente.
        if (day.to_i<1 || day.to_i>31)
          return false
        end
      
        if (hour.to_i<0 || hour.to_i>23)
          return false
        end
      
        if (minute.to_i<0 || minute.to_i>59)
          return false
        end
      
        if (second.to_i<0 || second.to_i>59)
          return false
        end
      
        return true
      end # datetime_values_check
    end # module Misc
  end # module DateTime

  # ----------------------------------------------------------------------------------------- 
  # Numeric Functions
  # ----------------------------------------------------------------------------------------- 
  module Number
    # ----------------------------------------------------------------------------------------- 
    # Encoding
    # ----------------------------------------------------------------------------------------- 
    module Encoding
      # Converts number to a string with a format like xx,xxx,xxx.xxxx 
      # number: it may be int or float
      def self.format_with_separator(number)
        whole_part, decimal_part = number.to_s.split('.')
        [whole_part.gsub(/(\d)(?=\d{3}+$)/, '\1,'), decimal_part].compact.join('.')
      end

      # Convierte una cantidad de minutos a una leyenda legible por el usuario.
      # Ejemplo: "2 days, 5 hours"
      # Ejemplo: "4 hours, 30 minutes"
      # Ejemplo: "3 days, 4 hour"
      def self.encode_minutes(n)
        # TODO: validar que n sea un entero mayor a 0      
        if (n<0)
          return "?"
        end
        if (n<60)
          return "#{n} minutes"
        elsif (n<24*60)
          return "#{(n/60).to_i} hours, #{n-60*(n/60).to_i} minutes"
        else
          return "#{(n/(24*60)).to_i} days, #{((n-24*60*(n/(24*60)).to_i)/60).to_i} hours"
        end
      end
    end # module Encode
  end # module Number

  # ----------------------------------------------------------------------------------------- 
  # String Functions
  # ----------------------------------------------------------------------------------------- 
  module Strings

    GUID_SIZE                     = 36
    MATCH_PASSWORD                = /(?=.*[a-zA-Z])(?=.*[0-9]).{6,}/ 
    MATCH_GUID                    = /{?[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]\-[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]\-[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]-[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]\-[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]}?/
    MATCH_FILENAME                = /[\w\-\_\.]+/
    MATCH_EMAIL                   = /[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}/
    MATCH_DOMAIN                  = /(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}/
    MATCH_DATE_STANDARD           = /\d{4}\-(0?[1-9]|1[012])\-(0?[1-9]|[12][0-9]|3[01])/
    MATCH_PHONE                   = /(?:\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}/
    MATCH_URL                     = /(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?/ # /(?:\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}/
    MATCH_LINKEDIN_COMPANY_URL    = /(https?:\/\/)?(www\\.)?linkedin\.com\/company\//
    MATCH_FIXNUM                  = /[0-9]+/
    MATCH_CONTENT_SPINNING        = /{[^}]+}/
    MATCH_SPINNED_TEXT            = /code me/ # TODO: define this regex for the issue #1226

    # ----------------------------------------------------------------------------------------- 
    # Fuzzy String Comparsion Functions: How similar are 2 strings that are not exactly equal.
    # ----------------------------------------------------------------------------------------- 
    module SQL
      def self.string_to_sql_string(s)
        #return s.force_encoding("UTF-8").gsub("'", "''").to_s
        return s.gsub("'", "''").to_s
      end
    end
    
    # ----------------------------------------------------------------------------------------- 
    # Fuzzy String Comparsion Functions: How similar are 2 strings that are not exactly equal.
    # ----------------------------------------------------------------------------------------- 
    module Comparing
      # retorna 0 si los strings son iguales
      # https://stackoverflow.com/questions/16323571/measure-the-distance-between-two-strings-with-ruby
      def self.levenshtein_distance(s, t)  
        s.downcase!
        t.downcase!
      
        m = s.length
        n = t.length
        return m if n == 0
        return n if m == 0
        d = Array.new(m+1) {Array.new(n+1)}
      
        (0..m).each {|i| d[i][0] = i}
        (0..n).each {|j| d[0][j] = j}
        (1..n).each do |j|
          (1..m).each do |i|
            d[i][j] = if s[i-1] == t[j-1]  # adjust index into string
                        d[i-1][j-1]       # no operation required
                      else
                        [ d[i-1][j]+1,    # deletion
                          d[i][j-1]+1,    # insertion
                          d[i-1][j-1]+1,  # substitution
                        ].min
                      end
          end
        end
        d[m][n]
      end
      
      # retorna la cantidad de palabras con mas de 3 caracteres que se encuentran en el parametro s
      def self.max_sardi_distance(s)
        s.downcase!
        s.gsub!(/-/,' ')
        ss = s.scan(/\b([a-z]+)\b/)
        n = 0
        ss.each { |x|
          x = x[0]
          if (x.size > 3) # para evitar keywords triviales como 'and'
            n += 1
          end
        }
        n
      end
      
      # retorna la cantidad de palabras con mas de 3 caracteres del parametro s que se encuentran en el parametro t
      def self.sardi_distance(s, t)
        s.downcase!
        t.downcase!
        s.gsub!(/-/,' ')
        t.gsub!(/-/,' ')
        max_distance = max_sardi_distance(s)  
        ss = s.scan(/\b([a-z]+)\b/)
        tt = t.scan(/\b([a-z]+)\b/)
        n = 0
        ss.each { |x|
          x = x[0]
          if (x.size > 3) # para evitar keywords triviales como 'and'
            if ( tt.select { |y| y[0] == x }.size > 0 )
              n += 1
            end
          end
        }
        return max_distance - n
      end
    end # module Comparing
    
    # ----------------------------------------------------------------------------------------- 
    # Encoding: Make a string nice to be shown into an HTML string.
    # ----------------------------------------------------------------------------------------- 
    module Encoding
      # Then it makes it compatible with UTF-8.
      # More details here: https://bitbucket.org/leandro_sardi/blackstack/issues/961  
      def self.encode_string(s)
        s.encode("UTF-8")
      end
  
      # Escape the string to be shown into an HTML screen.
      # Then it makes it compatible with UTF-8.
      # More details here: https://bitbucket.org/leandro_sardi/blackstack/issues/961  
      def self.encode_html(s)
        encode_string(CGI.escapeHTML(s.to_s))
      end

      # Generates a description string from an exception object.
      # Eescapes the string to be shown into an HTML screen.
      # Makes it compatible with UTF-8.
      # More details here: https://bitbucket.org/leandro_sardi/blackstack/issues/961  
      def self.encode_exception(e, include_backtrace=true)
        ret = encode_html(e.to_s) 
        if (include_backtrace == true)
          e.backtrace.each { |s|
            ret += "<br/>" + encode_html(s)
          } # e.backtrace.each
        end # if
        ret
      end

      # Returns a string with a description of a period of time, to be shown in the screen.
      # period: it may be 'H', 'D', 'W', 'M', 'Y'  
      # units: it is a positive integer  
      def self.encode_period(period, units)
        s = "Last "
        s += units.to_s + " " if units.to_i > 1
        s += "Hours" if period.upcase == "H" && units.to_i != 1
        s += "Days" if period.upcase == "D" && units.to_i != 1
        s += "Weeks" if period.upcase == "W" && units.to_i != 1
        s += "Months" if period.upcase == "M" && units.to_i != 1
        s += "Years" if period.upcase == "Y" && units.to_i != 1
        s += "Hour" if period.upcase == "H" && units.to_i == 1
        s += "Day" if period.upcase == "D" && units.to_i == 1
        s += "Week" if period.upcase == "W" && units.to_i == 1
        s += "Month" if period.upcase == "M" && units.to_i == 1
        s += "Year" if period.upcase == "Y" && units.to_i == 1
        s
      end

      #
      def self.encode_guid(s)
        return s.gsub('{',"").gsub('}',"").upcase
      end

      #
      def self.encode_javascript(s)
        s.to_s.gsub("'", "\\\\'").gsub("\r", "' + String.fromCharCode(13) + '").gsub("\n", "' + String.fromCharCode(10) + '")
      end

    end # module Encoding

    # ----------------------------------------------------------------------------------------- 
    # DateTime
    # ----------------------------------------------------------------------------------------- 
    module DateTime     
      # Check the string has the format yyyymmddhhmmss.
      # => Return true if success. Otherwise, return false.
      # => Year cannot be lower than 1900.
      # => Year cannot be higher or equal than 2100. 
      def self.datetime_api_check(s)
        return false if (s.size!=14)      
        year = s[0..3]
        month = s[4..5]
        day = s[6..7] 
        hour = s[8..9] 
        minute = s[10..11] 
        second = s[12..13]       
        BlackStack::DateTime::Misc::datetime_values_check(year,month,day,hour,minute,second)
      end # def datetime_api_check

      # Check the string has the format yyyy-mm-dd hh:mm:ss.
      # => Return true if success. Otherwise, return false.
      # => Year cannot be lower than 1900.
      # => Year cannot be higher or equal than 2100. 
      def self.datetime_sql_check(s)
        return false if (s.size!=19)
        year = s[0..3]
        month = s[5..6]
        day = s[8..9] 
        hour = s[11..12] 
        minute = s[14..15] 
        second = s[17..18] 
        BlackStack::DateTime::Misc::datetime_values_check(year,month,day,hour,minute,second)
      end # def datetime_sql_check
      
      # Convierte un string con formato api-datatime (yyyymmddhhmmss) a un string con formato sql-datetime (yyyy-mm-dd hh:mm:ss).
      def self.datetime_api_to_sql(s)
        raise "Wrong Api DataTime Format." if (datetime_api_check(s)==false)
        year = s[0..3]
        month = s[4..5]
        day = s[6..7] 
        hour = s[8..9] 
        minute = s[10..11] 
        second = s[12..13] 
        ret = "#{year}-#{month}-#{day} #{hour}:#{minute}:#{second}" 
        return ret
      end # def datetime_api_to_sql 
      
      # Convierte un string con formato sql-datatime a un string con formato sql-datetime.
      def self.datetime_sql_to_api(s)
        raise "Wrong SQL DataTime Format." if (datetime_sql_check(s)==false)
        year = s[0..3]
        month = s[5..6]
        day = s[8..9] 
        hour = s[11..12] 
        minute = s[14..15] 
        second = s[17..18] 
        ret = "#{year}#{month}#{day}#{hour}#{minute}#{second}" 
        return ret
      end # def datetime_sql_to_api
    end # module DateTime


    # ----------------------------------------------------------------------------------------- 
    # Spinning
    # ----------------------------------------------------------------------------------------- 
    module Spinning
      # Esta funcion retorna una variacion al azar del texto que se pasa.
      # Esta funcion se ocupa de dividir el texto en partes, para eviar el error "too big to product" que arroja la libraría.
      def self.random_spinning_variation(text)
        ret = text
        
        text.scan(MATCH_CONTENT_SPINNING).each { |s|
          a = ContentSpinning.new(s).spin
          rep = a[rand(a.size)]
          ret = ret.gsub(s, rep)
          a = nil
        }
      
        return ret
      end
      
      # retorna true si la sintaxis del texto spineado es correcta
      # caso contrario retorna false
      # no soporta spinnings anidados. ejemplo: {my|our|{a car of mine}}
      def self.valid_spinning_syntax?(s)
        # valido que exste
        n = 0
        s.split('').each { |c|
          n+=1 if c=='{'  
          n-=1 if c=='}'
          if n!=0 && n!=1
            #raise "Closing spining char '}' with not previous opening spining char '{'." if n<0
            #raise "Opening spining char '{' inside another spining block." if n>1
            return false if n<0 # Closing spining char '}' with not previous opening spining char '{'.
            return false if n>1 # Opening spining char '{' inside another spining block.
          end  
        }
      
        # obtengo cada uno de los spinnings
        s.scan(MATCH_CONTENT_SPINNING).each { |x|
          a = x.split('|')
          raise "No variations delimited by '|' inside spinning block." if a.size <= 1
        }
      
        true
      end
      
      # returns true if the text is spinned.
      # otherwise, returns false.
      def self.spintax?(s)
        s.scan(MATCH_CONTENT_SPINNING).size > 0
      end
    end # module Spinning
    
    
    # ----------------------------------------------------------------------------------------- 
    # Miscelaneus
    # ----------------------------------------------------------------------------------------- 
    module Misc
      # make a Ruby string safe for a filesystem.
      # References:
      # => https://stackoverflow.com/questions/1939333/how-to-make-a-ruby-string-safe-for-a-filesystem
      # => http://devblog.muziboo.com/2008/06/17/attachment-fu-sanitize-filename-regex-and-unicode-gotcha/
      def self.sanitize_filename(filename)
        ret = filename.strip do |name|
          # NOTE: File.basename doesn't work right with Windows paths on Unix
          # get only the filename, not the whole path
          name.gsub!(/^.*(\\|\/)/, '')
      
          # Strip out the non-ascii character
          name.gsub!(/[^0-9A-Za-z.\-]/, '_')
        end
        return ret
      end
    end # module Misc


    # ----------------------------------------------------------------------------------------- 
    # Email Appending Functions
    # ----------------------------------------------------------------------------------------- 
    module Appending
      APPEND_PATTERN_FNAME_DOT_LNAME = 0
      APPEND_PATTERN_FNAME = 1
      APPEND_PATTERN_LNAME = 2
      APPEND_PATTERN_F_LNAME = 3
      APPEND_PATTERN_F_DOT_LNAME = 4

      # 
      def self.name_pattern(pattern, fname, lname)
        if (pattern==APPEND_PATTERN_FNAME_DOT_LNAME)
          return "#{fname}.#{lname}"
        elsif (pattern==APPEND_PATTERN_FNAME)
          return "#{fname}"
        elsif (pattern==APPEND_PATTERN_LNAME)
          return "#{lname}"
        elsif (pattern==APPEND_PATTERN_F_LNAME)
          return "#{fname[0]}#{lname}"
        elsif (pattern==APPEND_PATTERN_F_DOT_LNAME)
          return "#{fname[0]}.#{lname}"
        else
          raise "getNamePattern: Unknown pattern code."
        end
      end

      # 
      def self.get_email_variations(first_name, last_name, domain, is_a_big_company)
        variations = Array.new
        variations << first_name + "." + last_name + "@" + domain
        variations << first_name[0] + last_name + "@" + domain
        variations << first_name + "_" + last_name + "@" + domain
        variations << first_name[0] + "." + last_name + "@" + domain      
        if (is_a_big_company == false)
          variations << last_name + "@" + domain
          variations << first_name + "@" + domain
        end
        #variations << first_name + "." + last_name + "@" + domain
        #variations << first_name + "_" + last_name + "@" + domain
        #variations << last_name + "." + first_name + "@" + domain
        #variations << last_name + "_" + first_name + "@" + domain
        #variations << first_name[0] + "." + last_name + "@" + domain
        #variations << first_name + "." + last_name[0] + "@" + domain
        #variations << last_name[0] + "." + first_name + "@" + domain
        #variations << last_name + "." + first_name[0] + "@" + domain
        #variations << first_name[0] + last_name + "@" + domain
        #variations << first_name + last_name[0] + "@" + domain
        #variations << last_name[0] + first_name + "@" + domain
        #variations << last_name + first_name[0] + "@" + domain
        #variations << first_name + "@" + domain
        #variations << last_name + "@" + domain
        return variations
      end
    end # module Appending
  end # module String
  
  # ----------------------------------------------------------------------------------------- 
  # Network
  # ----------------------------------------------------------------------------------------- 
  module Netting
    CALL_METHOD_GET = 'get'
    CALL_METHOD_POST = 'post'
    DEFAULT_SSL_VERIFY_MODE = OpenSSL::SSL::VERIFY_NONE
    SUCCESS = 'success'
    
    class ApiCallException < StandardError
      attr_accessor :description
      
      def initialize(s)
        self.description = s
      end
      
      def to_s
        self.description
      end
    end
    
    # New call_get
    def self.call_get(url, params = {}, ssl_verify_mode=BlackStack::Netting::DEFAULT_SSL_VERIFY_MODE) 
      uri = URI(url)
      uri.query = URI.encode_www_form(params)
      Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https', :verify_mode => ssl_verify_mode) do |http|
        req = Net::HTTP::Get.new uri
        #req.body = body if !body.nil?
        res = http.request req
        case res
        when Net::HTTPSuccess then res
        when Net::HTTPRedirection then BlackStack::Netting::call_get(URI(res['location']), params)
        else
          res.error!
        end
      end
    end
    
    # New call_post
    def self.call_post(url, params = {}, ssl_verify_mode=BlackStack::Netting::DEFAULT_SSL_VERIFY_MODE)
      uri = URI(url)
      Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https', :verify_mode => ssl_verify_mode) do |http|
        req = Net::HTTP::Post.new(uri)
        req['Content-Type'] = 'application/json'
        req.set_form_data(params)
        #req.body = body if !body.nil?
        res = http.request req
        case res 
        when Net::HTTPSuccess then res
        when Net::HTTPRedirection then BlackStack::Netting::call_post(URI(res['location']), params)
        else
          res.error!
        end
      end
    end

    # 
    def self.api_call(url, params={}, method=BlackStack::Netting::CALL_METHOD_POST, ssl_verify_mode=BlackStack::Netting::DEFAULT_SSL_VERIFY_MODE, max_retries=5)
      nTries = 0
      bSuccess = false
      parsed = nil
      sError = ""
      while (nTries < max_retries && bSuccess == false)
        begin
          nTries = nTries + 1
          uri = URI(url)
          res = BlackStack::Netting::call_post(uri, params, ssl_verify_mode) if method==BlackStack::Netting::CALL_METHOD_POST
          res = BlackStack::Netting::call_get(uri, params, ssl_verify_mode) if method==BlackStack::Netting::CALL_METHOD_GET
          parsed = JSON.parse(res.body)
          if (parsed['status']==BlackStack::Netting::SUCCESS)
            bSuccess = true
          else
            sError = "Status: #{parsed['status'].to_s}. Description: #{parsed['value'].to_s}." 
          end
        rescue Errno::ECONNREFUSED => e
          sError = "Errno::ECONNREFUSED:" + e.to_console
        rescue => e2
          sError = "Exception:" + e2.to_console
        end
      end # while
    
      if (bSuccess==false)
        raise "#{sError}"
      end
    end # apicall

    # Download a file from an url to a local folder.
    # url: must be somedomain.net instead of somedomain.net/, otherwise, it will throw exception.
    # to: must be a valid path to a folder.
    def self.download(url, to)
      uri = URI(url)
      domain = uri.host.start_with?('www.') ? uri.host[4..-1] : uri.host    
      path = uri.path
      filename = path.split("/").last
      Net::HTTP.start(domain) do |http|
        resp = http.get(path)
        open(to, "wb") do |file|
          file.write(resp.body)
        end
      end
    end

    # Return the extension of the last path into an URL.
    # Example: get_url_extension("http://connect.data.com/sitemap_index.xml?foo_param=foo_value") => ".xml"  
    def self.get_url_extension(url)
      return File.extname(URI.parse(url).path.to_s)
    end

    # Removes the 'www.' from an URL.
    def self.get_host_without_www(url)
      url = "http://#{url}" if URI.parse(url).scheme.nil?
      host = URI.parse(url).host.downcase
      host.start_with?('www.') ? host[4..-1] : host
    end

    # Get the final URL if a web page is redirecting.
    def self.get_redirect(url)
      uri = URI.parse(url)
      protocol = uri.scheme
      host = uri.host.downcase
      res = Net::HTTP.get_response(uri)
      "#{protocol}://#{host}#{res['location']}"
    end

    # returns the age in days of the given file
    def self.file_age(filename)
      (Time.now - File.ctime(filename))/(24*3600)
    end


    # TODO: Is not guaranteed this function works with 100% of the redirect-urls. This problem requires analysis and development of a general purpose algorith
    # This function gets the final url from a redirect url.
    # Not all the redirect-urls works the same way.
    # Below are 3 examples. Each one works with 1 of the 2 strategies applied by this funcion.
    # => url = "https://www.google.com.ar/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&cad=rja&uact=8&ved=0CB0QFjAAahUKEwjCg8zMsNvGAhXMMj4KHWBfA50&url=https%3A%2F%2Fwww.linkedin.com%2Fpub%2Fdavid-bell%2F5%2F76a%2F12&ei=IGalVcLzFMzl-AHgvo3oCQ&usg=AFQjCNGMbF2vRIOWsRjF-bjjoG6Nl1wg_g&sig2=ZP6ZbZxpmTHw82rIP7YYew&bvm=bv.97653015,d.cWw"
    # => url = "https://www.google.com.ar/url?q=https://www.linkedin.com/pub/mark-greene/2/bb8/b59&sa=U&ved=0CDoQFjAIahUKEwiqivi5sdvGAhWJg5AKHSzkB5o&usg=AFQjCNGE09H9hf92mfvwPVnComssDjBBCw"
    # If the url is not a redirect-url, this function returns the same url.
=begin
    def get_redirect(url)
      begin
        res = nil
        httpc = HTTPClient.new
        resp = httpc.get(url)
        res = resp.header['Location']
        
        if res.size == 0
          uri = URI.parse(url)
          uri_params = CGI.parse(uri.query)
          redirected_url = uri_params['url'][0]            
          
          if ( redirected_url != nil )
            res = redirected_url
          else
            res = url
          end
        else
          res = res[0]
        end
      rescue
        res = url
      end
      return res
    end
=end
    # returns a hash with the parametes in the url
    def self.params(url)
      # TODO: Corregir este parche:
      # => El codigo de abajo usa la URL de una busqueda en google. Esta url generara una excepcion cuando se intenta parsear sus parametros.
      # => Ejecutar las 2 lineas de abajo para verificar.
      # => url = "https://www.google.com/webhp#q=[lead+generation]+%22John%22+%22Greater+New+York+City+Area+*+Financial+Services%22+site:linkedin.com%2Fpub+-site:linkedin.com%2Fpub%2Fdir"
      # => p = CGI::parse(URI.parse(url).query)
      # => La linea de abajo hace un gsbub que hace que esta url siga funcionando como busqueda de google, y ademas se posible parsearla.
      url = url.gsub("webhp#q=", "webhp?q=")
    
      return CGI::parse(URI.parse(url).query)
    end
    
    # Add a parameter to the url. It doesn't validate if the param already exists.
    def self.add_param(url, param_name, param_value)
      uri = URI(url)
      params = URI.decode_www_form(uri.query || '')
      
      if (params.size==0)
        params << [param_name, param_value]
        uri.query = URI.encode_www_form(params)
        return uri.to_s
      else
        uri.query = URI.encode_www_form(params)
        return uri.to_s + "&" + param_name + "=" + param_value    
      end
    end
    
    # Changes the value of a parameter in the url. It doesn't validate if the param already exists.
    def self.change_param(url, param_name, param_value)
      uri = URI(url)
    #  params = URI.decode_www_form(uri.query || [])
      params = CGI.parse(uri.query)
      params["start"] = param_value
      uri.query = URI.encode_www_form(params)
      uri.to_s
    end
    
    # Change or add the value of a parameter in the url, depending if the parameter already exists or not.
    def self.set_param(url, param_name, param_value)
      params = BlackStack::Netting::params(url) 
      if ( params.has_key?(param_name) == true )
        newurl = BlackStack::Netting::change_param(url, param_name, param_value)
      else
        newurl = BlackStack::Netting::add_param(url, param_name, param_value)
      end
      return newurl
    end
    
    # get the domain from any url
    def self.getDomainFromUrl(url)
      if (url !~ /^http:\/\//i && url !~ /^https:\/\//i) 
        url = "http://#{url}"
      end
      
      if (URI.parse(url).host == nil)
        raise "Cannot get domain for #{url}" 
      end
    
      if (url.to_s.length>0)
        return URI.parse(url).host.sub(/^www\./, '')
      else
        return nil
      end
    end
  
    def self.getDomainFromEmail(email)
      if email.email?
        return email.split("@").last
      else
        raise "getDomainFromEmail: Wrong email format."
      end
    end
  
    def self.getWhoisDomains(domain, allow_heuristic_to_avoid_hosting_companies=false)
      a = Array.new
      c = Whois::Client.new
      r = c.lookup(domain)
    
      res = r.to_s.scan(/Registrant Email: (#{BlackStack::Strings::MATCH_EMAIL})/).first
      if (res!=nil)
        a << BlackStack::Netting::getDomainFromEmail(res[0].downcase)
      end
    
      res = r.to_s.scan(/Admin Email: (#{BlackStack::Strings::MATCH_EMAIL})/).first
      if (res!=nil)
        a << BlackStack::Netting::getDomainFromEmail(res[0].downcase)
      end
    
      res = r.to_s.scan(/Tech Email: (#{BlackStack::Strings::MATCH_EMAIL})/).first
      if (res!=nil)
        a << BlackStack::Netting::getDomainFromEmail(res[0].downcase)
      end
    
      # remover duplicados
      a = a.uniq
    
      # 
      if (allow_heuristic_to_avoid_hosting_companies==true)
        # TODO: develop this feature
      end
    
      return a
    end

  end # module Netting
  
end # module BlackStack
