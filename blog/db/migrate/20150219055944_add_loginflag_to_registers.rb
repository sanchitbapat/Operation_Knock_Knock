class AddLoginflagToRegisters < ActiveRecord::Migration
  def change
    add_column :registers, :loginflag, :number
    add_column :registers, :knock1, :number
    add_column :registers, :knock2, :number
    add_column :registers, :knock3, :number
    add_column :registers, :knock4, :number
  end
end
