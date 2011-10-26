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
  description 'Plugin for Redmine that helps you to create new types of custom fields'
  version '0.1.1'
  url 'https://github.com/Axblade/redmine_custom_field_extender'
  author_url 'http://www.redmine.org/users/35480'
  

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
