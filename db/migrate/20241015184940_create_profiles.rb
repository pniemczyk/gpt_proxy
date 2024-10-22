class CreateProfiles < ActiveRecord::Migration[8.0]
  def change
    create_table :profiles, id: :string, force: :cascade do |t|
      t.string :name
      t.string :description
      t.text :content
      t.text :providers

      t.timestamps
    end
  end
end
