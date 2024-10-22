class CreateCapturedEndpoints < ActiveRecord::Migration[8.0]
  def change
    create_table :captured_endpoints do |t|
      t.string :method
      t.string :url
      t.text :params
      t.text :headers
      t.text :payload
      t.integer :status
      t.text :body

      t.timestamps
    end
  end
end
