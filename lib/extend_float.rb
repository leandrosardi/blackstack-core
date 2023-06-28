class oat
  # Converts number to a string with a format like xx,xxx,xxx.xxxx 
  def to_label()
    BlackStack::Number::Encoding::format_with_separator(self)
  end
end # class String
