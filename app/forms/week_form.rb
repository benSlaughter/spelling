class WeekForm < ApplicationForm
  form do |week_form|
    week_form.group(layout: :horizontal) do |week_group|
      week_group.text_field(
        name: :date,
        label: "Date",
        required: true,
        type: :date,
        caption: "The date (normally Monday) that the spellings were given on.",
      )
      week_group.text_field(
        name: :note,
        label: "Note",
        required: true,
        caption: "What type of spellings are these",
      )
    end

    week_form.fields_for(:words) do |builder|
      WordForm.new(builder)
    end

    week_form.submit(name: :submit, label: "Submit")
  end
end
