class Admin < ActiveRecord::Base
  
  def self.cached_find(id)
    Rails.cache.fetch([name, id]) { find(id) }
  end
  
  def flush_cache
    Rails.cache.delete([self.class.name, id])
  end
  
  def raise_accounts_version
    flush_cache
    self.accounts_version += 1
    save!
  end
  
  def self.get_invoice_nr
    #!!! thread safe no?
    admin = Admin.first_or_create
    admin.update(orders_count: admin.orders_count + 1)
    admin.orders_count
  end
  
  #def self.stripe_fee
  #  admin = Admin.first_or_create
  #  admin.stripe_fee
  #end
  #
  #def self.digiramp_fee
  #  admin = Admin.first_or_create
  #  admin.digiramp_fee
  #end
  
  def self.commers_fee
    CommersFee.first_or_create
  end
  
  def self.application_percentate_fees
    commers_fee.digiramp_percentage_fee * 0.01
  end
  
  def self.application_flat_fees
    commers_fee.digiramp_flat_fee
  end
  
  def self.without_stripe_fees amount
    fee    = amount * commers_fee.stripe_percentage_fee * 0.01
    amount -= fee
    amount - commers_fee.stripe_flat_fee
  end
  
  def self.without_digiramp_fees amount
    fee = amount * commers_fee.digiramp_percentage_fee * 0.01
    amount -= fee
    amount - commers_fee.digiramp_flat_fee
  end
  
  def self.amount_without_fees amount
    digi_fee      = amount * commers_fee.digiramp_percentage_fee * 0.01
    amount        -= digi_fee
    stripe_fee    = amount * commers_fee.stripe_percentage_fee * 0.01
    amount        -= stripe_fee
  end
  
  # return the fees taken by DigiRAMP in a given input
  # 
  #  Admin.digiramp_fees 1000 # => 15.0
  def self.digiramp_fees amount
    fees =  amount * application_percentate_fees  
    fees + application_flat_fees
  end

  
end

# Admin.without_stripe_fees amount
# Admin.get_invoice_nr