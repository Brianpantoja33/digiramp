class MoodsImport < ActiveRecord::Base
  mount_uploader :csv_file , CsvUploader
end
