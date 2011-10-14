module RedmineCustomFieldExtender
  module Patches
    module CustomFieldPatch

      def self.included(base)
        base.extend(ClassMethods)
        base.send(:include, InstanceMethods)
        base.class_eval do
          unloadable
          alias_method_chain :cast_value, :extended
          alias_method_chain :order_statement, :extended
        end
      end

      module ClassMethods

      end

      module InstanceMethods
        # extends default cast_value method with new custom field type
        def cast_value_with_extended(value)
          casted = nil
          unless value.blank?
            case field_format
            when 'string', 'text', 'list'
              casted = value
            when 'date'
              casted = begin; value.to_date; rescue; nil end
            when 'bool'
              casted = (value == '1' ? true : false)
            when 'int'
              casted = value.to_i
            when 'float'
              casted = value.to_f
            when 'user', 'version'
              casted = (value.blank? ? nil : field_format.classify.constantize.find_by_id(value.to_i))
            when 'autoincrement'
              casted = value.to_i
            end
          end
          casted
        end
      end

      # extends default order_statement method with new custom field type
      def order_statement_with_extended
        case field_format
          when 'string', 'text', 'list', 'date', 'bool', 'user', 'version'
            # COALESCE is here to make sure that blank and NULL values are sorted equally
            "COALESCE((SELECT cv_sort.value FROM #{CustomValue.table_name} cv_sort" +
              " WHERE cv_sort.customized_type='#{self.class.customized_class.name}'" +
              " AND cv_sort.customized_id=#{self.class.customized_class.table_name}.id" +
              " AND cv_sort.custom_field_id=#{id} LIMIT 1), '')"
          when 'int', 'float', 'autoincrement'
            # Make the database cast values into numeric
            # Postgresql will raise an error if a value can not be casted!
            # CustomValue validations should ensure that it doesn't occur
            "(SELECT CAST(cv_sort.value AS decimal(60,3)) FROM #{CustomValue.table_name} cv_sort" +
              " WHERE cv_sort.customized_type='#{self.class.customized_class.name}'" +
              " AND cv_sort.customized_id=#{self.class.customized_class.table_name}.id" +
              " AND cv_sort.custom_field_id=#{id} AND cv_sort.value <> '' AND cv_sort.value IS NOT NULL LIMIT 1)"
            #here must be database cast options for user and version lists
          else
            nil
        end
      end

    end
  end
end