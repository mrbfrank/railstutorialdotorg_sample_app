FactoryGirl.define do
  factory :user do
    name     "Meredith Frank"
    email    "missmatters@gmail.com"
    password "foobar"
    password_confirmation "foobar"
  end
end