class Event < ApplicationRecord
  belongs_to :admin, class_name: 'User'
  has_many :attendances
  has_many :participants, through: :attendances, source: :user

  validates :start_date, presence: true
  validate :start_date_cannot_be_in_the_past
  validate :duration_must_be_multiple_of_five 

  validates :title, presence: true, length: { minimum: 5, maximum: 140 }
  validates :description, presence: true, length: { minimum: 20, maximum: 1000 }
  validates :price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 1000 }
  validates :location, presence: true

  has_one_attached :avatar

  private

  def start_date_cannot_be_in_the_past
    if start_date < Time.now
      errors.add(:start_date, "can't be in the past")
    end
  end

  def duration_must_be_multiple_of_five
    if duration.present? && duration % 5 != 0
      errors.add(:duration, "must be a multiple of 5")
    end
  end

end
