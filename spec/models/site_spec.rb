require "spec_helper"

describe Site do
  
  it { should validate_presence_of(:name) }

end
