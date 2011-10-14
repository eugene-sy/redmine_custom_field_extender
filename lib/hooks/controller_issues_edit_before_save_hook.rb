require 'processors/autoincrement_processor'

module RedmineCustomFieldExtender
  module Hooks
    class ControllerIssuesEditBeforeSaveHook < Redmine::Hook::ViewListener

      # add some logic to your custom field type by processor classes

      # method controller_issues_edit_before_save will be called
      # right before saving changes in issue

      def controller_issues_edit_before_save(context={})
        if (context[:params] && context[:params][:issue])
          RedmineCustomFieldExtender::AutoincrementProcessor.process(context)
        end
      end

      alias_method :controller_issues_new_before_save, :controller_issues_edit_before_save

    end
  end
end