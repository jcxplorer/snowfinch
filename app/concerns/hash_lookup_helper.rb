module HashLookupHelper
  extend ActiveSupport::Concern

  private

  def hash_lookup(hash, *keys)
    last_value = hash
    keys.each do |key|
      return unless last_value
      last_value = last_value[key]
    end
    last_value
  end
end
