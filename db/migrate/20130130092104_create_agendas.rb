class CreateAgendas < ActiveRecord::Migration
  def change
    create_table :agendas do |t|
      t.string :description
      t.integer :event_id
      t.timestamps
    end
  end
end
