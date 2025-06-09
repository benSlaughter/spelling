class ForgotPasswordForm < ApplicationForm
  form do |forgot_password_form|
    forgot_password_form.text_field(
      name: :email_address,
      label: nil,
      required: true,
      type: :email,
      autofocus: true,
      autocomplete: "username",
      placeholder: "Enter your email address"
    )

    forgot_password_form.submit(name: :submit, label: "Email reset instructions", scheme: :primary)
  end
end
