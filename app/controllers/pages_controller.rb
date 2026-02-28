class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
  end

  def react_quotes
    @company_id = current_company&.id
  end
end
