require 'rails_helper'

RSpec.describe User, type: :model do
  it "derives a display name from the email prefix" do
    user = build(:user, email: "accountant@example.com")
    expect(user.name).to eq("Accountant")
  end
end
