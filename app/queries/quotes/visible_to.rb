# app/queries/quotes/visible_to.rb
module Quotes
  class VisibleTo
    def initialize(user:, search: nil, relation: Quote.all)
      @user = user
      @search = search
      @relation = relation
    end

    def call
      scope = relation.where(company_id: user.company_id).ordered
      scope = scope.where("name ILIKE ?", "%#{search}%") if search.present?
      scope
    end

    private

    attr_reader :user, :search, :relation
  end
end
