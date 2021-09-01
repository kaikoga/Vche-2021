module Vche::UidQuery
  extend ActiveSupport::Concern

  included do
    def to_key
      [uid]
    end

    def to_param
      uid
    end
  end
end
