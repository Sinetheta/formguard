class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    begin
      URI.parse(value).kind_of?(URI::HTTP)
    rescue
      record.errors.add attribute, (options[:message] || "is not a valid http url") 
    end
  end
end
