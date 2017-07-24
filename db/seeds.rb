User.create!(first_name: "Faithes", last_name: "Atara",
  email: "fy@email.com",
  agent_id: "1",
  admin: true,
  activated: true,
  password: "password", password_confirmation: "password")
User.create!(first_name: "Yuuko", last_name: "Aioi",
  email: "ya@email.com",
  agent_id: "1.1",
  admin: false,
  activated: true,
  password: "password", password_confirmation: "password")
User.create!(first_name: "Mio", last_name: "Naganohara",
  email: "mn@email.com",
  agent_id: "1.2",
  admin: false,
  activated: true,
  password: "password", password_confirmation: "password")
User.create!(first_name: "Mai", last_name: "Minakami",
  email: "mai@email.com",
  agent_id: "1.3",
  admin: false,
  activated: true,
  password: "password", password_confirmation: "password")

Product.create!(sid: "MJ000-001",
  name: "LAVENDER GARDEN FULL SET",
  description: "",
  suggested_price: 320.00)
Product.create!(sid: "MJ000-002",
  name: "LAVENDER GARDEN BASIC SET",
  description: "",
  suggested_price: 170.00)
Product.create!(sid: "MJ000-003",
  name: "LAVENDER GARDEN CLAY MASK",
  description: "",
  suggested_price: 80.00)
Product.create!(sid: "MJ000-004",
  name: "LAVENDER GARDEN HANDCRAFTED LUXURY FACIAL SOAP",
  description: "",
  suggested_price: 40.00)
Product.create!(sid: "MJ000-005",
  name: "LAVENDER GARDEN LUXURY HANDCRAFTED FACE OIL",
  description: "",
  suggested_price: 60.00)
Product.create!(sid: "MJ000-006",
  name: "LAVENDER GARDEN COLLAGEN SERUM SPF 30",
  description: "",
  suggested_price: 150.00)
