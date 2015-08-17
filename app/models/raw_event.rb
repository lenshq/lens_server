class RawEvent < ActiveRecord::Base
  include AASM

  belongs_to :application

  validates :application, presence: true
  validates :data, presence: true

  aasm column: :state do
    state :created, initial: true
    state :in_process
    state :finished
    state :failed

    event :to_process do
      transitions from: :created, to: :in_process
      transitions from: :failed, to: :in_process
    end

    event :to_finish do
      transitions from: :in_process, to: :finished
    end

    event :to_fail do
      transitions from: :in_process, to: :failed
    end
  end
end
