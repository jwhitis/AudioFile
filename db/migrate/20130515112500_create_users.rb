class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :gracenote_id
    end
  end
end