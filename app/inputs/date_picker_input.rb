class DatePickerInput < SimpleForm::Inputs::StringInput
  def input_html_options
    value = object.send(attribute_name)
    options = {
      value: value.nil?? nil : value.getlocal.strftime('%Y-%m-%d %H:%M'),
      data: { behaviour: 'datepicker' }
    }
    super.merge options
  end
end