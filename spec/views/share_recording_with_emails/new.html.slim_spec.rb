require 'rails_helper'

RSpec.describe "share_recording_with_emails/new", :type => :view do
  before(:each) do
    assign(:share_recording_with_email, ShareRecordingWithEmail.new(
      :user => nil,
      :recording => nil,
      :recipients => "MyText",
      :title => "MyString",
      :message => "MyText"
    ))
  end

  it "renders new share_recording_with_email form" do
    render

    assert_select "form[action=?][method=?]", share_recording_with_emails_path, "post" do

      assert_select "input#share_recording_with_email_user_id[name=?]", "share_recording_with_email[user_id]"

      assert_select "input#share_recording_with_email_recording_id[name=?]", "share_recording_with_email[recording_id]"

      assert_select "textarea#share_recording_with_email_recipients[name=?]", "share_recording_with_email[recipients]"

      assert_select "input#share_recording_with_email_title[name=?]", "share_recording_with_email[title]"

      assert_select "textarea#share_recording_with_email_message[name=?]", "share_recording_with_email[message]"
    end
  end
end