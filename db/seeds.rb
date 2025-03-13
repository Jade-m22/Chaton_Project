require "open-uri"

# Supprime tous les produits existants
Product.delete_all

# Liste des noms des chats
chat_names = ["Milo", "Luna", "Simba", "Chaussette", "Félix"].shuffle

# Création des produits avec deux images associées
chat_names.each_with_index do |name, index|
  product = Product.create!(
    name: name,
    description: "Apportez une touche de douceur avec l'affiche de #{name} !",
    price: rand(15..50)
  )

  # Définition des chemins d'images (imageX.jpg et imageX_1.jpg)
  images = [
    Rails.root.join("db/seeds/images/image#{index + 1}.jpg"),
    Rails.root.join("db/seeds/images/image#{index + 1}_1.jpg")
  ]

  # Attachement des images si elles existent
  images.each do |image_path|
    if File.exist?(image_path)
      product.images.attach(io: File.open(image_path), filename: File.basename(image_path))
    else
      puts "⚠️ Image manquante : #{image_path}"
    end
  end
end

puts "✅ Seed terminé : #{Product.count} produits créés avec leurs images !"
