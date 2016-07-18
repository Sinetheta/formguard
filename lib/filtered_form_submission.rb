class FilteredFormSubmission
  include ActiveModel::Model

  attr_accessor :start_date, :end_date, :form_action, :filters_applied
  validates :start_date, :end_date, date: true, allow_nil: true
  validates :form_action, presence: true
  validates_with DateRangeValidator, attributes: [:start_date, :end_date]

  def initialize(attributes={})
    super
    @filters_applied ||= ""
  end

  def submissions
    submissions =
      FormSubmission
        .where(form_action_id: form_action.id)
        .order(:created_at)

    filter!(submissions)
  end

  private

  def filter!(submissions)
    filters =
      [start_date && method(:from), end_date && method(:to)]

    filters.each do |filter|
      submissions = filter.call(submissions) unless filter.nil?
    end

    submissions
  end

  def from(submissions)
    @filters_applied += "from:#{start_date} "
    submissions.from_date(start_date)
  end

  def to(submissions)
    @filters_applied += "to:#{end_date} "
    submissions.until_date(end_date)
  end

end
