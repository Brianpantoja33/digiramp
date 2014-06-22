class CommonWorksImport < ActiveRecord::Base
  belongs_to :account
  #attr_accessible :title, :body, :imported_works, :in_progress, :params, :processed_works, :total_works, :updated_works
  has_many :common_works
  
  attr_accessor :user_name, :password
  
  serialize :params, Array 
  
  PROS = ['ASCAP', 'BMI']
  
  
  def parse_common_works
    
    self.imported_works = 0
    self.params.each do |param|
      
      #begin
        common_work = CommonWork.where( ascap_work_id:  param[:ascap_work_id].to_i,
                                        account_id:     self.account_id
                                      )
                                .first_or_create( ascap_work_id:  param[:ascap_work_id].to_i,
                                                  account_id:     self.account_id
                                                )
        
        common_work.title                   = param[:title]
        common_work.iswc_code               = param[:alternate_ids]["ISWC"]              if common_work[:alternate_ids] && common_work[:alternate_ids]["ISWC"]
        common_work.submitter_work_id       = param[:alternate_ids]["Submitter Work ID"] if common_work[:alternate_ids] && common_work[:alternate_ids]["Submitter Work ID"]
        common_work.common_works_import_id  = self.id
        common_work.account_id              = self.account_id
        
         
        # parse details
        if details    = param[:details]
          common_work.surveyed_work                         = details["Surveyed Work"]
          common_worklast_distribution                      = details["Last Distribution Yr/Qtr"]
          common_work.work_status                           = details["Work Status"]
          common_work.ascap_award_winner                    = details["ASCAP Award Winner"]
          
          # add to genre 
          if common_work.genre.to_s == ''
            # there is no genre so add it
            common_work.genre   = details["Genre"]
          elsif common_work.genre.include? details["Genre"]
            # do nothing genre is alreaddy added
          else
            # add as comma seperated list
            common_work.genre   += ','
            common_work.genre   += details["Genre"]
          end
          common_work.work_type                             = details["Work Type"]
          common_work.composite_type                        = details["Composite Type"]
          common_work.arrangement_of_public_domain_work     = details["Arrangement of Public Domain Work"]
        end
          
        # save
        common_work.save!common_work
        
        # parse ipis
        parse_ipis common_work.id, param[:ipis], common_work.ascap_work_id
        
        
        # set health
        common_work.update_completeness
        
        # update import count
        self.imported_works += 1
        
        # add to catalog
        add_to_catalog common_work, self.catalog_id

      #rescue
      #  puts '+++++++++++++++++++++++++++++++++++++++++++++++++'
      #  puts 'ERROR: Unable to parse ascap common work:' 
      #  puts 'In CommonWorksImport#parse_common_works'
      #  ap params
      #  puts '+++++++++++++++++++++++++++++++++++++++++++++++++'
      #end
    end
    # not in progress
    self.in_progress = false
    self.save!
    
    channel = 'digiramp_radio_' + user_email
    Pusher.trigger(channel, 'my_eventx', {"title" => 'Success', 
                                          "message" => 'Common Works imported', 
                                          "time"    => '5000', 
                                          "sticky"  => 'true', 
                                          "image"   => 'success'
                                          })
    
  end
  
  def add_to_catalog common_work, catalog_id

    if catalog_id
      CatalogItem.where(catalog_itemable_type: 'CommonWork', 
                        catalog_itemable_id: common_work.id, 
                        catalog_id: catalog_id)
                  .first_or_create(
                        catalog_itemable_type: 'CommonWork', 
                        catalog_itemable_id: common_work.id, 
                        catalog_id: catalog_id
                        )
    else
      puts '+++++++++++++++++++++++++++++++++++++++++++++++++'
      puts 'ERROR: Unable to add common work to catalog:' 
      puts 'In CommonWork#add_to_catalog'
      puts 'catalog_id cant be nil'
      puts '+++++++++++++++++++++++++++++++++++++++++++++++++'
    end
    
    
      
  end
  
  def parse_ipis common_work_id, ipis, ascap_work_id
    #puts '+++++++++++++++++++++  PARSE IPIS ++++++++++++++++++++++++++++'
    ipis.each do |ipi_scrape|
      ipi = Ipi.where(common_work_id: common_work_id, 
                      ipi_code: ipi_scrape[:ipi_number] )
               .first_or_create( common_work_id:  common_work_id, 
                                 ipi_code:        ipi_scrape[:ipi_number]
                                )
      
      ipi.full_name                 = ipi_scrape[:full_name]
      ipi.role                      = ipi_scrape[:role]
      ipi.pro                       = ipi_scrape[:society]
      ipi.perf_owned                = ipi_scrape[:own_percent]
      ipi.perf_collected            = ipi_scrape[:collect_percent]
      ipi.has_agreement             = ipi_scrape[:has_agreement]
      ipi.linked_to_ascap_member    = ipi_scrape[:linked_to_ascap_member]
      ipi.controlled_by_submitter   = ipi_scrape[:controlled_by_submitter]
      ipi.ascap_work_id             = ascap_work_id
      ipi.save!
      #puts '+++++++++++++++++++++++ LOGGING IPI ++++++++++++++++++++++++++'
      #ap ipi
      #puts '++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
    end
    
  end
  
  def self.post_started user_email
    
    ap user_email
    channel = 'digiramp_radio_' + user_email
    Pusher.trigger(channel, 'my_eventx', {"title" => 'FOBAR', 
                                          "message" => 'Unable to log in', 
                                          "time"    => '500', 
                                          "sticky"  => 'true', 
                                          "image"   => 'success'
                                          })
  
  end
  
  def self.post_info user_email, info
    
    ap info
    
    if info[:start]
      puts '*************************** starting ***********************************'
      puts user_email
      channel = 'digiramp_radio_' + user_email
      Pusher.trigger(channel, 'my_eventx', {"title" => 'Error', 
                                            "message" => 'Unable to log in', 
                                            "time"    => '500', 
                                            "sticky"  => 'true', 
                                            "image"   => 'error'
                                            })
    elsif info[:error]
      channel = 'digiramp_radio_' + user_email
      Pusher.trigger(channel, 'my_eventx', {"title" => 'Error', 
                                            "message" => 'Unable to log in', 
                                            "time"    => '500', 
                                            "sticky"  => 'true', 
                                            "image"   => 'error'
                                            })
    #elsif  [:html_work_detail_tbodies]
    #  channel = 'digiramp_radio_' + user_email
    #  Pusher.trigger(channel, 'my_eventx', {"title" => 'Info', 
    #                                        "message" => 'Common Work imported', 
    #                                        "time"    => '2000', 
    #                                        "sticky"  => 'false', 
    #                                        "image"   => 'progress'
    #                                        })
    #  
    end
    
    #channel = 'digiramp_radio_' + user_email
    #Pusher.trigger(channel, 'my_eventx', {"title" => 'Success', 
    #                                      "message" => 'import done', 
    #                                      "time"    => '500', 
    #                                      "sticky"  => 'false', 
    #                                      "image"   => 'progress'
    #                                      
    #                                      })
  end
  


end

