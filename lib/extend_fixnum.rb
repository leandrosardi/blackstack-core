class Fixnum
  # Converts number to a string with a format like xx,xxx,xxx.xxxx 
  def to_label()
    BlackStack::Number::Encoding::format_with_separator(self)
  end

  # Convierte una cantidad de minutos a una leyenda legible por el usuario.
  # Ejemplo: "2 days, 5 hours"
  # Ejemplo: "4 hours, 30 minutes"
  # Ejemplo: "3 days, 4 hour"
  def to_time_spent()
    BlackStack::Number::Encoding::encode_minutes(self)
  end
end # class String
