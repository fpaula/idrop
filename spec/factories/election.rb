FactoryGirl.define do
  factory :election do
    start_date 1.day.ago
    finish_date Time.now + 1.day
    status '1'
  end
end