class CreateFrontEndContents < ActiveRecord::Migration
  def change
    create_table :front_end_contents do |t|
      t.string :identifyer
      t.string :page1_title_1
      t.string :page1_title_2
      t.string :page1_title_3
      t.text :page_1_body
      t.string :page_1_image
      t.string :page2_title
      t.text :page_2_headline
      t.string :page_2_option_1_title
      t.string :page_2_option_1_headline
      t.text :page_2_option_1_body
      t.string :page_2_option_2_title
      t.string :page_2_option_2_headline
      t.text :page_2_option_2_body
      t.string :page_2_option_3_title
      t.string :page_2_option_3_headline
      t.text :page_2_option_3_body
      t.string :page_3_title
      t.string :page_3_headline
      t.string :page_3_option_1_title
      t.text :page_3_option_1_body
      t.string :page_3_option_2_title
      t.text :page_3_option_2_body
      t.string :page_3_image
      t.string :page_4_title
      t.text :page_4_body
      t.string :page_4_account_1_title
      t.string :page_4_account_1_title
      t.string :page_4_account_1_price
      t.string :page_4_account_1_option_1
      t.string :page_4_account_1_option_2
      t.string :page_4_account_1_option_3
      t.string :page_4_account_1_option_4
      t.string :page_4_account_1_option_5
      t.string :page_4_account_1_option_6
      t.string :page_4_account_2_title
      t.string :page_4_account_2_price
      t.string :page_4_account_2_option_1
      t.string :page_4_account_2_option_2
      t.string :page_4_account_2_option_3
      t.string :page_4_account_2_option_4
      t.string :page_4_account_2_option_5
      t.string :page_4_account_2_option_6
      t.string :page_4_account_3_title
      t.string :page_4_account_3_price
      t.string :page_4_account_3_option_1
      t.string :page_4_account_3_option_2
      t.string :page_4_account_3_option_3
      t.string :page_4_account_3_option_4
      t.string :page_4_account_3_option_5
      t.string :page_4_account_3_option_6
      t.string :page_4_account_4_title
      t.string :page_4_account_4_price
      t.string :page_4_account_4_option_1
      t.string :page_4_account_4_option_2
      t.string :page_4_account_4_option_3
      t.string :page_4_account_4_option_4
      t.string :page_4_account_4_option_5
      t.string :page_4_account_4_option_6
      t.string :page_5_title
      t.text :page_5_body
      t.string :page_5_image_1
      t.string :page_5_image_2
      t.string :page_5_image_3
      t.string :page_5_image_4
      t.string :page_5_image_5
      t.string :page_5_image_6
      t.string :page_6_testimonial_1_image
      t.string :page_6_testimonial_1_name
      t.string :page_6_testimonial_1_headline
      t.text :page_6_testimonial_1_body
      t.string :page_6_testimonial_2_image
      t.string :page_6_testimonial_2_name
      t.string :page_6_testimonial_2_headline
      t.text :page_6_testimonial_2_body
      t.string :page_6_testimonial_3_image
      t.string :page_6_testimonial_3_name
      t.string :page_6_testimonial_3_headline
      t.text :page_6_testimonial_3_body
      t.string :page_6_testimonial_4_image
      t.string :page_6_testimonial_4_name
      t.string :page_6_testimonial_4_headline
      t.text :page_6_testimonial_4_body
      t.string :page_6_testimonial_5_image
      t.string :page_6_testimonial_5_name
      t.string :page_6_testimonial_5_headline
      t.text :page_6_testimonial_5_body
      t.string :page_6_testimonial_6_image
      t.string :page_6_testimonial_6_name
      t.string :page_6_testimonial_6_headline
      t.text :page_6_testimonial_6_body
      t.string :page_7_title
      t.string :page_7_headline
      t.text :page_7_body
      t.string :page_7_image
      t.string :page_8_title
      t.text :page_8_body

      t.timestamps
    end
  end
end
