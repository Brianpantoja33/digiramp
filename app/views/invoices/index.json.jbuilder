json.array!(@invoices) do |invoice|
  json.extract! invoice, :id, :stripe_id, :stripe_object, :livemode, :amount_due, :attempted, :closed, :currency, :stripe_customer_id, :date, :forgiven, :lines, :paid, :period_start, :period_end, :starting_balance, :subtotal, :total, :application_fee, :charge, :description, :discount, :ending_balance, :receipt_number, :statement_descriptor, :subscription_id, :metadata, :tax, :tax_percent, :user_id, :account_id
  json.url invoice_url(invoice, format: :json)
end
