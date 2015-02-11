require 'rails_helper'

RSpec.describe "cms_horizontal_links/index", :type => :view do
  before(:each) do
    assign(:cms_horizontal_links, [
      CmsHorizontalLink.create!(
        :recording => nil
      ),
      CmsHorizontalLink.create!(
        :recording => nil
      )
    ])
  end

  it "renders a list of cms_horizontal_links" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end