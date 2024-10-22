class CreateProviders < ActiveRecord::Migration[8.0]
  def change
    create_table :providers, id: :string, force: :cascade do |t|
      t.string :name
      t.text :info
      t.string :api_key
      t.string :url
      t.string :chat_path
      t.string :models_path
      t.string :default_model
      t.text :models
      t.boolean :profilable
      t.text :payload_options
      t.text :headers_options

      t.timestamps
    end
  end
end
