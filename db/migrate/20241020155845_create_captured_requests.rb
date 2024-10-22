class CreateCapturedRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :captured_requests do |t|
      t.string :ref_id
      t.string :method
      t.string :url
      t.text :headers
      t.text :body

      t.timestamps
    end
  end
end
