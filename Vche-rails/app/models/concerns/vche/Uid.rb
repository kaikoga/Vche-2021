module Vche::Uid
  extend ActiveSupport::Concern

  UID_RANGE = ('a'..'z').to_a + ('0'..'9').to_a
  UID_GENERATOR = PublicUid::Generators::RangeString.new(8, UID_RANGE)

  included do
    generate_public_uid column: :uid, generator: UID_GENERATOR
  end
end
