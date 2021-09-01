module Vche::Uid
  extend ActiveSupport::Concern

  UID_GENERATOR = PublicUid::Generators::HexStringSecureRandom.new(8)

  included do
    generate_public_uid column: :uid, generator: UID_GENERATOR
  end
end
