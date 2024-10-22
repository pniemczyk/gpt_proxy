class CreateCapturedResponses < ActiveRecord::Migration[8.0]
  def change
    create_table :captured_responses do |t|
      t.references :captured_request, null: false, foreign_key: true
      t.integer :status
      t.text :headers
      t.text :body

      t.timestamps
    end
  end
end
