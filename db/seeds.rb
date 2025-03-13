require "open-uri"

# Supprime tous les produits existants pour éviter les doublons
Product.delete_all

# Liste de noms uniques pour les affiches de chats
chat_names = ["Milo", "Luna", "Simba", "Chaussette", "Félix", "Nala", "Tigrou", "Pacha", "Mimi", "Garfield"].shuffle

# Liste des images à associer
images = ["image.jpg", "image2.jpg", "image3.jpg", "image4.jpg", "image5.jpg"]

# Template de description
def generate_description(name)
  "Apportez une touche de douceur et de mystère à votre intérieur avec cette superbe affiche mettant en valeur #{name}, un félin majestueux.\n\n" \
  "📏 Dimension unique en 30x40 cm\n" \
  "🖼 Impression haute définition avec des couleurs éclatantes et des détails précis\n" \
  "📜 Sur papier premium mat 250 g/m², épais et résistant, offrant un rendu élégant sans reflets\n" \
  "🌱 Impression respectueuse de l’environnement avec des encres non toxiques\n\n" \
  "Idéale pour les amoureux des félins, cette affiche s’intègre parfaitement dans tout type de décoration : salon cosy, chambre apaisante ou bureau inspirant.\n" \
  "À encadrer ou à accrocher directement au mur pour un effet minimaliste et moderne."
end

# Création des produits
5.times do |i|
  name = "#{chat_names.pop}" # Nom unique

  product = Product.create!(
    name: name,
    description: generate_description(name),
    price: rand(15..50) # Prix aléatoire entre 15€ et 50€
  )

  # Attachement de l'image si elle existe
  image_path = Rails.root.join("db/seeds/images/#{images[i]}")
  
  if File.exist?(image_path)
    product.image.attach(io: File.open(image_path), filename: images[i])
  else
    puts "⚠️ Image #{images[i]} introuvable !"
  end
end

puts "✅ Seed terminée : #{Product.count} affiches de chats ajoutées !"
