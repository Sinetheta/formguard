class DateRangeValidator < ActiveModel::EachValidator
  def validate(record)
    record.errors.add :base, 'This record is invalid' unless
    non_negative_date_range(record)
  end

  def non_negative_date_range(record)
    return true if record.start_date.nil? || record.end_date.nil?
      record.end_date >= record.start_date
  end
end
