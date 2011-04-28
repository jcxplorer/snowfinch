FactoryGirl.define do

  sequence :email do |i|
    "user-#{i}@snowfinch.net"
  end

  factory :user do
    email
    password "123456"
  end

  factory :site do
    name "Snowfinch"
    time_zone "Helsinki"
  end

  factory :sensor do
    name "Social Media"
    type "host"
    site
  end

  factory :sensor_host do
    host "google.com"
    sensor
  end

end
