# Nettoyage de la base
Product.destroy_all

puts "Création des produits..."

products = [
  { name: "Chaton en peluche", price: 19.99 },
  { name: "Griffoir en carton", price: 9.99 },
  { name: "Litière autonettoyante", price: 129.99 },
  { name: "Croquettes premium", price: 24.50 },
  { name: "Balle interactive", price: 5.99 }
]

products.each do |product|
  Product.create!(product)
end

puts "✅ 5 produits créés avec succès !"
