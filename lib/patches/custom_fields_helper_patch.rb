module RedmineCustomFieldExtender
  module Patches
    module CustomFieldsHelperPatch

      def self.included(base)
        base.extend(ClassMethods)
        base.send(:include, InstanceMethods)
        base.class_eval do
          unloadable
          alias_method_chain :custom_field_tag, :extend
          alias_method_chain :custom_field_tag_for_bulk_edit, :extend
          alias_method_chain :custom_field_tag_with_label, :extend
        end
      end

      module ClassMethods

      end

      module InstanceMethods

        # custom field render method extending
        # to add new custom field type just add new when selector and describe behavior for rendering

        def custom_field_tag_with_extend(name, custom_value)
          custom_field = custom_value.custom_field
          field_name = "#{name}[custom_field_values][#{custom_field.id}]"
          field_id = "#{name}_custom_field_values_#{custom_field.id}"

          field_format = Redmine::CustomFieldFormat.find_by_name(custom_field.field_format)

          case field_format.try(:edit_as)
          when "date"
            text_field_tag(field_name, custom_value.value, :id => field_id, :size => 10) +
            calendar_for(field_id)
          when "text"
            text_area_tag(field_name, custom_value.value, :id => field_id, :rows => 3, :style => 'width:90%')
          when "bool"
            hidden_field_tag(field_name, '0') + check_box_tag(field_name, '1', custom_value.true?, :id => field_id)
          when "list"
            blank_option = custom_field.is_required? ?
                             (custom_field.default_value.blank? ? "<option value=\"\">--- #{l(:actionview_instancetag_blank_option)} ---</option>" : '') :
                             '<option></option>'
            select_tag(field_name, blank_option + options_for_select(custom_field.possible_values_options(custom_value.customized), custom_value.value), :id => field_id)
          when "autoincrement"
             (!custom_value.value.blank? || custom_value.value.to_i >= 1) ?
                 text_field_tag(field_name, custom_value.value, :id => field_id, :disabled => true) :
                 check_box_tag(field_name, '1', false, :id => field_id)
          else
            text_field_tag(field_name, custom_value.value, :id => field_id)
          end
        end

        def custom_field_tag_for_bulk_edit_with_extend(name, custom_field, projects=nil)
          field_name = "#{name}[custom_field_values][#{custom_field.id}]"
          field_id = "#{name}_custom_field_values_#{custom_field.id}"
          field_format = Redmine::CustomFieldFormat.find_by_name(custom_field.field_format)
          case field_format.try(:edit_as)
            when "date"
              text_field_tag(field_name, '', :id => field_id, :size => 10) +
              calendar_for(field_id)
            when "text"
              text_area_tag(field_name, '', :id => field_id, :rows => 3, :style => 'width:90%')
            when "bool"
              select_tag(field_name, options_for_select([[l(:label_no_change_option), ''],
                                                         [l(:general_text_yes), '1'],
                                                         [l(:general_text_no), '0']]), :id => field_id)
            when "list"
              select_tag(field_name, options_for_select([[l(:label_no_change_option), '']] + custom_field.possible_values_options(projects)), :id => field_id)
            when "autoincrement"
              check_box_tag(field_name, '1', false, :id => field_id)
            else
              text_field_tag(field_name, '', :id => field_id)
          end
        end

        def custom_field_tag_with_label_with_extend(name, custom_value)
          custom_field_label_tag(name, custom_value) + custom_field_tag_with_extend(name, custom_value)
        end
      end
    end
  end
end