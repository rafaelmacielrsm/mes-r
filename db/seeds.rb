require 'ffaker'
def categories
  category_array = [
    'Medicamentos - Genérico',
    'Medicamentos - Similar',
    'Medicamentos - Éticos',
    'Medicamentos - Controlados',
    'Higiene',
    'Estético e Beleza',
    'Alimentos',
    'Fitness']

  category_array.each do |category|
    Category.create(name: category)
    puts "Categoria: #{category}"
  end
end

def products
  dosage = ["100MG", "150MG", "250MG", "300MG", "500MG", "600MG", "1MG/ML",
    "2MG/ML", "4MG/ML", "8MG/ML", "16MG/ML", "32MG/ML", "64MG/ML"]
  categories = Category.all.map { |x| x.id }
  1000.times do |x|
    Product.create(
      name: "#{FFaker::HealthcareIpsum.word} #{dosage.sample}",
      price: Random.rand(0.25..500.0),
      category_ids: categories.sample
    )
    puts "Produto #{x + 1} criado"
  end
end

# categories()
# products()
