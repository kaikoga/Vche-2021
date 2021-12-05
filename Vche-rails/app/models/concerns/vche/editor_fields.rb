module Vche::EditorFields
  extend ActiveSupport::Concern

  included do
    belongs_to :created_user, class_name: 'User', optional: true
    belongs_to :updated_user, class_name: 'User', optional: true
  end
end
