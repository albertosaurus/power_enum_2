module PowerEnum::Reflection
  extend ActiveSupport::Concern

  module ClassMethods
    def reflect_on_all_enumerated
      # Need to give it a full namespace to avoid getting Rails confused in development
      # mode where all objects are reloaded on every request.
      reflections.values.grep(PowerEnum::Reflection::EnumerationReflection)
    end

    def reflect_on_enumerated enumerated
      reflections[enumerated.to_sym].is_a?(PowerEnum::Reflection::EnumerationReflection) ? reflections[enumerated.to_sym] : nil
    end
  end

  class EnumerationReflection < ActiveRecord::Reflection::MacroReflection
    def initialize name, options, active_record
      super :has_enumerated, name, options, active_record
    end
    
    def class_name
      @class_name ||= (@options[:class_name] || @name).to_s.camelize
    end
    
    def foreign_key
      @foreign_key ||= (@options[:foreign_key] || "#{@name}_id").to_s
    end
  end
end
