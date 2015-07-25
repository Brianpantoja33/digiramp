class Shop::OrderItem < ActiveRecord::Base
  include ErrorNotification
  
  belongs_to :shop_order,    class_name: "Shop::Order"
  belongs_to :shop_product,  class_name: "Shop::Product"
  has_many   :stripe_transfers, class_name: "Shop::StripeTransfer"
  
  validates_with OrderItemValidator


  after_commit :flush_cache

  def self.cached_find(id)
    Rails.cache.fetch([name, id]) { find(id) }
  end
  
  # transfer payment to all stakeholders
  # called when payments success
  def charge_succeeded( amount, stripe_charge_id)
    if product = self.shop_product
      product.stakeholders.each do |stakeholder|
        stakeholder.charge_succeeded self.id,  amount, stripe_charge_id 
      end
    else
      post_error "OrderItem#charge_succeeded: product not found"
    end
    self.sold = true
    self.save
  end
  
  def seller_info
    seller = self.shop_product.seller_info
    if seller[:id] == 'error'
      post_error "Shop::OrderItem id: #{self.id} is not for sale "
    end
    seller
  end
  
  def last
    Shop::OrderItem.order(:created_at).last
  end
  
  def first
    Shop::OrderItem.order(:created_at).first
  end
  


  private 
  


  def flush_cache
    Rails.cache.delete([self.class.name, id])
  end
end
