module RedmineCustomFieldExtender
  module Patches
    module CustomFieldFormatPatch

      def self.included(base)
        base.extend(ClassMethods)
        base.send(:include, InstanceMethods)
        base.class_eval do
          #  Never do it unloadable!
		  class << self
            alias_method_chain :format_value, :extended
          end
        end
      end

      module ClassMethods
		    #fix for error while sending emails
		    def format_value_with_extended(value, field_format)
          return "" unless value && !value.blank?

          if format_type = find_by_name(field_format)
            format_type.format(value)
          else
            value
          end
        end
		
      end

      module InstanceMethods
        # define new method for formatting values of new custom field type
        # definition can be done with define_method
        # "define_method("format_as_you_want") { format logic }"
        # or with direct definition
        # "def format_as_you_want
        #   format logic
        # end "

        define_method("format_as_autoincrement") {|value| return value}

      end
    end
  end
end