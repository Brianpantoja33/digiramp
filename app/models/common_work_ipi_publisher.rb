class CommonWorkIpiPublisher < ActiveRecord::Base
  belongs_to :common_work_ipi
  belongs_to :publisher
  belongs_to :user
end
