class Message < ApplicationRecord
  validates :body, presence: true
  belongs_to :user
  belongs_to :chat_group

  def post_time
    return created_at.strftime("%Y/%m/%d/ %H:%M:%S")
  end
end
