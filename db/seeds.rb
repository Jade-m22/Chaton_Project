require "open-uri"

# Supprime tous les produits existants
Product.delete_all

# Liste des noms des chats
chat_names = ["Milo", "Luna", "Simba", "Chaussette", "Félix", "Snow", "Tommy", "Babe", "Plume", "Boule", "June", "Flocon"].shuffle

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

# mug
mug_product = Product.create!(
  name: "Mug Chaton",
  description: "Un mug adorable avec une illustration de chaton.",
  price: rand(15..30),
  category: "Dérivé"
)

mug_image_path = Rails.root.join("db/seeds/images/mug.jpg")

if File.exist?(mug_image_path)
  mug_product.images.attach(io: File.open(mug_image_path), filename: "mug.jpg")
else
  puts "⚠️ Image manquante : #{mug_image_path}"
end

# sweat
sweat_product = Product.create!(
  name: "Sweat Chaton",
  description: "Un adorable sweat avec une illustration de chaton.",
  price: rand(15..30),
  category: "Dérivé"
)

sweat_image_path = Rails.root.join("db/seeds/images/sweat.jpg")

if File.exist?(sweat_image_path)
  sweat_product.images.attach(io: File.open(sweat_image_path), filename: "sweat.jpg")
else
  puts "⚠️ Image manquante : #{sweat_image_path}"
end

# totebag
totebag_product = Product.create!(
  name: "Totebag Chaton",
  description: "Un adorable totebag avec une illustration de chaton.",
  price: rand(15..30),
  category: "Dérivé"
)

totebag_image_path = Rails.root.join("db/seeds/images/totebag.jpg")

if File.exist?(totebag_image_path)
  totebag_product.images.attach(io: File.open(totebag_image_path), filename: "totebag.jpg")
else
  puts "⚠️ Image manquante : #{totebag_image_path}"
end

# tshirt
tshirt_product = Product.create!(
  name: "Tshirt Chaton",
  description: "Un adorable tshirt avec une illustration de chaton.",
  price: rand(15..30),
  category: "Dérivé"
)

tshirt_image_path = Rails.root.join("db/seeds/images/tshirt.jpg")

if File.exist?(tshirt_image_path)
  tshirt_product.images.attach(io: File.open(tshirt_image_path), filename: "tshirt.jpg")
else
  puts "⚠️ Image manquante : #{tshirt_image_path}"
end


puts "✅ Seed terminé : #{Product.count} produits créés avec leurs images !"