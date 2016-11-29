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


# categories()
