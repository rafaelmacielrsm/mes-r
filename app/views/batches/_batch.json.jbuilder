json.extract! batch, :id, :barcode, :expiration_date, :cost, :created_at, :updated_at
json.url batch_url(batch, format: :json)