class AddSecretToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :secret, :number
  end
end
