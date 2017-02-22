FactoryGirl.define do
  factory :batch do
      barcode "1234567890123"
      quantity 5
      expiration_date { Date.today + 2.year }
      cost 1.23
      association :product
  end
end
