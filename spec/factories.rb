FactoryGirl.define do
  factory :user do
    name     "Johannes Engl"
    email    "johannes.engl@googlemail.com"
    password "46chromosomen"
    password_confirmation "46chromosomen"
  end

  # factory :workshop do
  #   name     "Sample Workshop"
  #   from = Time.now.to_f
  #   to   = 2.years.from_now.to_f
  #   date	Time.at(from + rand * (to - from))
  #   description "Sample Description"
  #   venue		"Sample Venue"
  # end
end