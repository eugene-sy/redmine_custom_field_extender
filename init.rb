require 'redmine'
require 'dispatcher'
require 'patches/custom_field_patch'
require 'patches/custom_fields_helper_patch'
require 'patches/custom_field_format_patch'
require 'hooks/controller_issues_edit_before_save_hook'
require 'hooks/controller_issues_bulk_edit_before_save_hook'


Redmine::Plugin.register :redmine_custom_field_extender do
  name 'Redmine Custom Field Extender plugin'
  author 'Eugene Sypachev'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  #url 'http://example.com/path/to/plugin'
  #author_url 'http://example.com/about'

  # extend CustomFieldFormat map
  Redmine::CustomFieldFormat.map do |fields|
    fields.register Redmine::CustomFieldFormat.new('autoincrement', :label => :label_autoincrement, :only => %w(Issue), :order => 10)
  end

  # redmine class patches registration
  Dispatcher.to_prepare :redmine_custom_field_extender do
    CustomField.send(:include, RedmineCustomFieldExtender::Patches::CustomFieldPatch)
    CustomFieldsHelper.send(:include, RedmineCustomFieldExtender::Patches::CustomFieldsHelperPatch)
    Redmine::CustomFieldFormat.send(:include, RedmineCustomFieldExtender::Patches::CustomFieldFormatPatch)
  end
end
