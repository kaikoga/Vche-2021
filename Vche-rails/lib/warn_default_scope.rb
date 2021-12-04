module WarnDefaultScope
  def warn_default_scope
    where.not
  end

  class Hook < Numeric
    def initialize(value)
      super(value.to_s)
    end
    def to_s
      unless @logged
        Rails.logger.info 'Using default scope.'
        Rails.logger.debug { Thread.current.backtrace.join("\n") }
        @logged = true
      end
      super
    end
  end
end
