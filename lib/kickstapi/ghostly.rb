module Kickstapi
  module Ghostly
    module Macros
      private
      def lazy_accessor(*names)
        names.each do |name|
          attr_writer name
          define_method(name) do
            load
            instance_variable_get("@#{name}")
          end
        end
      end
    end

    def self.included(other)
      other.extend(Macros)
    end

    attr_accessor :data_source
    attr_writer   :load_state

    def load_state
      @load_state ||= :ghost
    end

    def load
      return if load_state == :loaded
      data_source.load(self)
    end
  end
end
