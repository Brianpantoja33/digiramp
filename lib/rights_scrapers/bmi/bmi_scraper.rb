require_relative '../web_browser'

##Usage:
#require 'pp'
#BMI::MemberWorkCollect 'everstar', 'Bmibmi1234' do |work|
#  pp work
#  puts "----------------------------\n"
#end

class BMI::MemberWorkCollect
  def BMI::MemberWorkCollect username, password, &block
    @collector = BMI::MemberWorkCollect.new
    @collector.login username, password
    @collector.check_is_multipage
    @collector.collect! &block
  end
  
  attr_reader :works

  def login username, password
    @browser = WebBrowser.open url: "https://applications.bmi.com/security/Login.aspx"
    @browser.text_field(id: "txtUserName").set username
    @browser.text_field(id: "txtPassword").set password
    @browser.checkbox(id: "checkBoxDisclaimer").set true
    @browser.button(id: "btnLogin").click
    raise "You need to verify your BMI email" if @browser.text.include? "Please confirm the email address"
    @browser.a(text: "Works Catalog").click
  end

  def check_is_multipage
    works_count = @browser.span(id: "lbCount").text.split(':').last.strip.to_i
    actual_works_on_page = @browser.table(id: "tblWorks").trs.length
    raise "Count doesn't match amount of works on page! Implement paginate bot here." if works_count != actual_works_on_page
  end
  
  def collect!
    @works = []
    @browser.table(id: "tblWorks").trs.each do |tr|
      open_work_tr tr
      work = {
        title:              get_work_title,
        bmi_work_id:        get_bmi_work_id,
        registration_date:  get_registration_date,
        iswc:               get_iswc,
        writers:            get_ipis(:writers),
        publishers:         get_ipis(:publishers)
      }
      yield work if block_given?
      @works << work
    end
    @works
  end

  #def open_work_index index
  #  tr = @browser.table(id: "tblWorks").trs[index]
  #  open_work_tr tr
  #end

  def open_work_tr tr
    bmi_work_id = tr.tds[2].text
    tr.a(class: "titleList").click
    @browser.div(id: "detailsdiv").wait_until_present
    Watir::Wait.until {
      raise "Error box popup on BMI" if @browser.div(id: "divError").present?
      get_bmi_work_id  == bmi_work_id
    }
  end

  def get_work_title
    @browser.span(id: "lbWorkTitle").text
  end

  def get_bmi_work_id
    @browser.span(id: "lbWorkNo").text
  end

  def get_registration_date
    @browser.span(id: "lbdatereg").text
  end

  def get_iswc
    @browser.span(id: "lbISWC").text
  end

  def get_ipis type
    id = case type
    when :writers;    "tblWriters"
    when :publishers; "tblPubs"
    end
  
    ipis = []
    @browser.table(id: id).trs.each do |tr|
      ipi = tr.tds.map &:text
      ipis << {name: ipi[0], society: ipi[1], share: ipi[2], ipi_number: ipi[3]}
    end
    ipis
  end
end