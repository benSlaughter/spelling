class UpdatePasswordForm < ApplicationForm
  form do |update_password_form|
    update_password_form.text_field(
      name: :password,
      type: :password,
      label: nil,
      required: true,
      autofocus: true,
      autocomplete: "new-password",
      placeholder: "Enter new password",
      maxlength: 72
    )

    update_password_form.text_field(
      name: :password_confirmation,
      type: :password,
      label: nil,
      required: true,
      autocomplete: "new-password",
      placeholder: "Repeat new password",
      maxlength: 72
    )

    update_password_form.submit(name: :submit, label: "Save")
  end
end
