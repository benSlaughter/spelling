class SignInForm < ApplicationForm
  form do |sign_in_form|
    sign_in_form.text_field(name: :username, label: "Username", required: true, autofocus: true, autocomplete: "username", placeholder: "Enter your username")
    sign_in_form.text_field(name: :password, type: :password, label: "Password", required: true, autocomplete: "password", placeholder: "Enter your password", maxlength: 72)
    sign_in_form.submit(name: :sign_in, label: "Sign in", scheme: :primary)
  end
end
