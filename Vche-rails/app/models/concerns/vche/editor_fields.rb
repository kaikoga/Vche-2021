module Vche::EditorFields
  extend ActiveSupport::Concern

  included do
    belongs_to :created_user, -> { invite_or_over }, class_name: 'User', optional: true, inverse_of: "created_#{table_name}"
    belongs_to :updated_user, -> { invite_or_over }, class_name: 'User', optional: true, inverse_of: "updated_#{table_name}"
  end
end
