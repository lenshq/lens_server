# == Schema Information
#
# Table name: application_users
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  application_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class ApplicationUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :application
end
