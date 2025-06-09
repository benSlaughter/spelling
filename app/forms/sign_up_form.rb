class SignUpForm < ApplicationForm
  form do |sign_up_form|
    sign_up_form.text_field(name: :username, label: "Username", required: true, autofocus: true, autocomplete: "username", placeholder: "Enter your username")
    sign_up_form.text_field(name: :email_address, label: "Email", required: true, autocomplete: "email", placeholder: "Enter your email address", maxlength: 254)
    sign_up_form.text_field(name: :password, label: "Password", required: true, autocomplete: "password", placeholder: "Enter your password", maxlength: 72)
    sign_up_form.text_field(name: :password_confirmation, label: "Confirm password", required: true, autocomplete: "password", placeholder: "Re-enter your password", maxlength: 72)
    sign_up_form.text_field(name: :school_code, label: "School Code", required: true, placeholder: "Enter your school referral code", maxlength: 4, scope_name_to_model: false, value: @school_code)
    sign_up_form.group(layout: :horizontal) do |button_group|
      button_group.submit(name: :create_account, label: "Create account", scheme: :primary)
      button_group.button(name: :cancel, label: "Cancel", scheme: :secondary, href: "/session/new", tag: :a)
    end
  end

  def initialize(school_code: nil)
    @school_code = school_code
  end
end
