def self.symbolize!(hash)
  hash.symbolize_keys!
  hash.each_value do |value|
    self.symbolize!(value) if value.kind_of?(Hash)
  end
end
models = YAML.load_file("#{Rails.root}/config/validation.yml")
self.symbolize!(models)
models.each do |model, columns|
  columns.each do |column, methods|
    methods.each do |method, hash|
      klass = model.to_s.camelcase.constantize
      str = hash.nil? ? "#{method} :#{column}" : "#{method} :#{column}, #{hash}"
      klass.class_eval(str)
    end
  end
end