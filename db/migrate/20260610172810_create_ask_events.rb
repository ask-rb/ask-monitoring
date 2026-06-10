class CreateAskEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :ask_events do |t|
      t.string  :name,          null: false
      t.string  :provider
      t.string  :model
      t.float   :duration
      t.integer :input_tokens
      t.integer :output_tokens
      t.decimal :cost,          precision: 12, scale: 6, default: 0.0
      t.text    :error
      t.jsonb   :metadata,      default: {}

      t.timestamps
    end

    add_index :ask_events, :name
    add_index :ask_events, :provider
    add_index :ask_events, :model
    add_index :ask_events, :created_at
    add_index :ask_events, [:provider, :model]
    add_index :ask_events, :cost
  end
end
