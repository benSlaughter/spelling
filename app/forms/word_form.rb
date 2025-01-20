class WordForm < ApplicationForm
  form do |word_form|
    word_form.text_field(
      name: :spelling,
      label: nil,
      required: true,
    )
  end
end
