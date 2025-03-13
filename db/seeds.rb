require "open-uri"

# Supprime les anciens produits pour éviter les doublons
Product.destroy_all

# Liste de noms aléatoires pour les chatons
chat_names = ["Milo", "Luna", "Simba", "Chaussette", "Félix", "Nala", "Tigrou", "Pacha", "Mimi", "Garfield"]

# Liste des images à associer
images = ["image.jpg", "image2.jpg", "image3.jpg", "image4.jpg", "image5.jpg"]

# Création des produits
5.times do |i|
  product = Product.create!(
    name: chat_names.sample, # Nom aléatoire
    description: "Magnifique photo de chaton #{i + 1} ❤️",
    price: rand(10..50) # Prix aléatoire entre 10€ et 50€
  )

  image_path = Rails.root.join("db/seeds/images/#{images[i]}")
  
  if File.exist?(image_path)
    product.image.attach(io: File.open(image_path), filename: images[i])
  else
    puts "⚠️ Image #{images[i]} introuvable !"
  end
end

puts "✅ Seed terminée : #{Product.count} photos de chats ajoutées !"
