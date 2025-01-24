class DateTime
  # Converts a time object to an SQL friendy string
  def to_sql()
    BlackStack::DateTime::Encoding::datetime_to_sql(self)
  end
end # class DateTime