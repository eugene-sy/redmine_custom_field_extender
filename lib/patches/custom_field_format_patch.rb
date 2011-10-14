module RedmineCustomFieldExtender
  module Patches
    module CustomFieldFormatPatch

      def self.included(base)
        base.extend(ClassMethods)
        base.send(:include, InstanceMethods)
        base.class_eval do
          #  Never do it unloadable!
        end
      end

      module ClassMethods

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