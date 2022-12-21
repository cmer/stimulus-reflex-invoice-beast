Invoice.destroy_all

20.times do |i|
  invoice_date = Faker::Date.between(from: 2.years.ago, to: Date.today)

  invoice = Invoice.create(
    invoice_number: i + 1,
    invoice_date:,
    due_date: invoice_date + 30.days,
    customer_name: Faker::Name.name,
    address: Faker::Address.street_address,
    city: Faker::Address.city,
    state: Faker::Address.state,
    zip: Faker::Address.zip
  )

  rand(1..10).times do
    invoice.line_items.build(
      description: Faker::Commerce.product_name,
      quantity: Faker::Number.between(from: 1, to: 10),
      price: Faker::Commerce.price + 1
    )
  end

  invoice.save!
end