class DateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add attribute, 'is not a valid date' unless
      begin
        value.to_date.class == Date
      rescue ArgumentError
        false
      end
  end
end
