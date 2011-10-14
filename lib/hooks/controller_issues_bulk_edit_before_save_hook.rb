require 'processors/autoincrement_processor'

module RedmineCustomFieldExtender
  module Hooks
    class ControllerIssuesBulkEditBeforeSaveHook < Redmine::Hook::ViewListener

      # add some logic to your custom field type by processor classes

      # method controller_issues_bulk_edit_before_save will be called
      # right before saving changes in several issues using bulk edit

      def controller_issues_bulk_edit_before_save(context={})
        RedmineCustomFieldExtender::AutoincrementProcessor.process(context)
      end

    end
  end
end