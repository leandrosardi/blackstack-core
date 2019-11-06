class Time
  # Converts a time object to an SQL friendy string: YYYY-MM-DD HH:mm:ss
  def to_sql()
    BlackStack::DateTime::Encoding::datetime_to_sql(self)
  end
  
  # Converts a time object to an API friendy string: YYYYMMDDHHmmss
  def to_api()
    BlackStack::Strings::DateTime::datetime_sql_to_api(self.to_sql)
  end
end # class DateTime