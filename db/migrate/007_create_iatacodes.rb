class CreateIatacodes < ActiveRecord::Migration


  def change
    create_table :iatacodes do |t|
      t.string :code
    end
end
