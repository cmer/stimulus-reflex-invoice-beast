# frozen_string_literal: true

class LineItemRowComponent < ViewComponent::Base
  attr_reader :line_item, :omit_outer_element

  def initialize(line_item, omit_outer_element: false)
    @line_item = line_item
    @omit_outer_element = omit_outer_element
  end

  def field_name(attribute)
    "invoice[line_items][#{line_item.id}][#{attribute}]"
  end

  def dataset
    "##{dom_id(line_item)} ##{dom_id(line_item.invoice, :items)}"
  end

  def text_input_classes_for(attribute)
    if line_item.errors[attribute].any?
      helpers.text_input_error_classes
    else
      helpers.text_input_classes
    end
  end
end
