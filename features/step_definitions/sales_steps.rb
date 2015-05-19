Given(/^I am logged in as a salesperson with the email "(.*?)"$/) do |email|
  user = FactoryGirl.create(:user, email: email , password: 'salesale', role: 'Customer', salesperson: true)

  visit "/"
  visit "/login/new"
  fill_in 'sessions_email', with: email
  fill_in 'sessions_password', with: 'salesale'
  find_by_id('log_in_form_button').click
  find('.all-users')
  
  
end



Then(/^I fill the custom coupon form and save$/) do
  fill_in 'sales_coupon_batch_title', with: 'SPECIAL-PRICE'
  fill_in 'sales_coupon_batch_email', with: 'my-friend@buy-this.com'
  #fill_in 'sales_coupon_batch_body', with: 'this is for you'
  fill_in 'sales_coupon_batch_discount', with: 50
  fill_in 'sales_coupon_batch_percent_off', with: 100
  fill_in 'sales_coupon_batch_number_of_coupons', with: 20
  select 'repeating', :from => 'sales_coupon_batch_duration'
  fill_in 'sales_coupon_batch_duration_in_months', with: 6
  fill_in 'datetimepicker5', with: '2015/05/12'
  select 'DigiRAMP Pro', :from => 'sales_coupon_batch_plan_id'
  click_button 'Save'
end

Then(/^I can se the list of uniq coupon codes$/) do
 
  find('.uniq-codes')
end

Then(/^I can send the offer to an email$/) do
  pending # express the regexp above with the code you wish you had
end