class MakeEpicStoriesFocused
  include Interactor

  def perform
    Story.epic.update_all(focus: true)
  end
end
