# frozen_string_literal: true

class HeaderComponent < ViewComponent::Base
  attr_reader :subtitle

  def initialize(title:, subtitle:)
    @title = title
    @subtitle = subtitle
  end
  
  def heading
    render(Primer::Beta::Subhead.new(hide_border: true)) do |component|
      component.with_heading(tag: :h1) do
        title
      end
      component.with_description() do
        subtitle
      end
    end
  end

  def title
    @title || "Spellings"
  end
end
