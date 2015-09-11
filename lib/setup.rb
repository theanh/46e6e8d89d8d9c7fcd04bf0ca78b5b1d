include ActionView::Helpers
class Setup
  def self.run
    conn = ActiveRecord::Base.connection
    # conn.execute('SET FOREIGN_KEY_CHECKS = 0')

    self.clear_tables

    # load from csv
    transaction do
      self.tables.each do |table|
        connection.execute("SET CONSTRAINTS #{table} DEFERRED;")
        
        next unless File.exist?("db/csv/#{table}.csv")
        self.load_from_csv(table)
        p "initialized #{table}"
      end
    end

    # conn.execute('SET FOREIGN_KEY_CHECKS = 1')
    p "setup finished successfully"
  end

  def self.load_from_csv(table)
    path = "db/csv/#{table}.csv"
    klass = table.classify.constantize
    instances = []
    CSV.foreach(path,{headers: true, quote_char: '|', col_sep: ';'}) do |row|
      hash = {}
      row.each do |cell|
        if ['description', 'requirement' ,'intro'].include? cell[0]
          hash[cell[0].to_sym] = self.split_paragraphs(cell[1])
        else
          hash[cell[0].to_sym] =cell[1]
        end
        # puts(cell[0].to_sym)
      end
      # puts hash
      instances << klass.new(hash)
    end
    # puts instances
    result = klass.import instances
    if result.failed_instances.present?
      raise "Table #{table} some record failed."
    end
  end

  def self.tables
    conn = ActiveRecord::Base.connection
    result = conn.select('select version();')
    hash_array = conn.select('show tables')
    tables = []
    hash_array.each do |hash|
      next if hash.values[0] == 'schema_migrations'
      tables << hash.values[0]
    end
    return tables
  end

  def self.clear_tables
    conn = ActiveRecord::Base.connection
    self.tables.each do |table|
      conn.execute("DELETE FROM #{table};")
      result = conn.select('select version();')
      version = result.rows[0][0][0,3]
      if version == '5.6'
        conn.execute("ALTER TABLE #{table} ALGORITHM = COPY, AUTO_INCREMENT = 1;")
      else
        conn.execute("ALTER TABLE #{table} AUTO_INCREMENT = 1;")
      end
      p "cleared #{table}"
    end
  end
  def self.split_paragraphs(text)
    return [] if text.blank?
    text = Helpers.simple_format(text)
    text = text.to_str.gsub('- ','<br/>- ').gsub('+ ','<br/>+ ').gsub('● ','<br/> ● ').gsub('■ ','<br/> ■ ').gsub('★','<br/> ★ ').gsub('<p><br/>-','<p>-').gsub('*','<br/> * ').gsub('・','<br/> ・ ').gsub(' --','<br/>')
    return text
  end
  module Helpers
    extend ActionView::Helpers::TextHelper
  end
end