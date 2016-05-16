class BasePresenter < SimpleDelegator
  attr_reader :object

  def initialize(object)
    @object = object
    super(object)
  end
end
