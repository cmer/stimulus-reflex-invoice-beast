module ApplicationHelper
  def primary_button_classes
    "inline-flex items-center rounded-md border border-transparent bg-indigo-600 px-3 py-2 text-sm font-medium leading-4 text-white shadow-sm hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
  end

  def secondary_button_classes
    "inline-flex items-center rounded-md border border-transparent bg-indigo-100 px-3 py-2 text-sm font-medium leading-4 text-indigo-700 hover:bg-indigo-200 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
  end

  def alt_button_classes
    "inline-flex items-center rounded-md border border-gray-300 bg-white px-3 py-2 text-sm font-medium leading-4 text-gray-700 shadow-sm hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
  end

  def text_link_classes
    "text-indigo-800 hover:text-indigo-900 hover:underline"
  end

  def text_input_classes
    "form-input rounded border-gray-300 focus:border-indigo-300"
  end

  def text_input_error_classes
    "form-input rounded border-rose-300 focus:border-indigo-300"
  end
end
