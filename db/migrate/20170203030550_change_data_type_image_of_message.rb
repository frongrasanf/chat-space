class ChangeDataTypeImageOfMessage < ActiveRecord::Migration[5.0]
  def change
    change_column :messages, :image, :binary
  end
end
