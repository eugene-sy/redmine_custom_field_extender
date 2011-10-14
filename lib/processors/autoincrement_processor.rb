module RedmineCustomFieldExtender

  class AutoincrementProcessor

    # method finds any included in issue custom fields by autoincrement type
    # if any it checks last value and value of it check_box
    # if check_box value is true increments last value by 1
    # else value of field is saved without any changes
    def self.process(context={})
      field_values = context[:issue].custom_values
      field_values.each do |f|
        custom_field = CustomField.find_by_id(f.custom_field_id)
        if custom_field.field_format.eql?("autoincrement")
          puts "Custom field #{custom_field.id} is autoincrement"
          field_values = CustomValue.find(:all, :conditions => {:custom_field_id => custom_field.id})
          max_value = 0
          field_values.each do |fv|
            max_value = (fv.value.to_i > max_value) ? fv.value.to_i : max_value
          end
          if !f.value.nil? && f.value.to_i == 1
            f.value = max_value + 1
          end
        end
      end
    end
  end

end