class Exception
	def to_html(include_backtrace=true)
		BlackStack::Strings::Encoding.encode_exception(self, include_backtrace)
	end

  def to_console(include_backtrace=true)
    ret = self.to_s 
    ret += "\r\n" + self.backtrace.join("\r\n") if (include_backtrace == true)
    ret
  end # to_console
end