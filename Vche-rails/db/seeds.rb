ActiveRecord::Base.transaction do
  ['db/fixtures/*.rb', "db/fixtures/#{Rails.env}/*.rb"].
    map { |path| File.join(Rails.root, path) }.
    flat_map { |path| Dir.glob(path).sort }.
    each do |seed|
    puts seed
    load seed
  end
end
