module Checker

  def self.test_all
    constants = Object.constants.map{|name| Object.const_get(name)}
    constants.select{|c| c.class == Class and c < ActiveRecord::Base and !c.abstract_class?}
  end

  def test

    p "start test #{self.name}"
    has_manies = self.reflect_on_all_associations :has_many

    conn = self.connection
    error_count = 0
    has_manies.each do |association|
      name = "#{self.name }::#{association.name}"

      begin
        instance = self.new
        instance.id = 1
        relation = instance.send(association.name)
        conn.execute(relation.to_sql)
        p "success #{name}"
      rescue => exp
        p 'faild ' + name + ' => ' +  exp.message
        error_count += 1
      end

    end

    return error_count

  end

  # ----------------------------------------------------------------------------------------
  # @: The Anh
  # d: 141011
  # TODO: validating & converting params
  # ----------------------------------------------------------------------------------------
  def validateParam(validate, param, action, append_checker=true, is_api=true)
    hash = {}
    hash['failed'] = false if append_checker
    validate.each do |key, value|
      if !value.nil?
        hash[key] = {}
        case value['type']
          # validate array int
          when 'array_int'
            if value['require'][action] && param[key].nil?
              hash[key] = ''
              hash['failed'] = true
              render_failed(100, t('common.error.missing_param', {obj: key})) and return hash if is_api
            else
              if !param[key].nil?
                hash[key] = param[key].split(',').map {|x| Integer(x) rescue nil }.compact
                hash['failed'] = true and render_failed(101, t('common.error.not_valid', {obj: key})) and return hash if param[key].split(',').length > hash[key].length && is_api
              end
            end
          # validate int
          when 'int'
            if value['require'][action] && param[key].to_i < 1
              hash[key] = 0
              hash['failed'] = true
              render_failed(100, t('common.error.missing_param', {obj: key})) and return hash if is_api
            else
              hash[key] = param[key].to_i.abs
            end
          # validate email
          when 'email'
            if value['require'][action] && !valid_email?(param[key])
              hash[key] = ''
              hash['failed'] = true
              render_failed(101, t('common.error.not_valid', {obj: key})) and return hash if is_api
            else
              hash[key] = param[key]
            end
          # validate password
          when 'password'
            if value['require'][action]
              if param[key].nil?
                hash[key] = ''
                hash['failed'] = true
                render_failed(100, t('common.error.missing_param', {obj: key})) and return hash if is_api
              else
                if param[key].gsub('　', ' ').gsub(' ', '').length < 6
                     hash[key] = ''
                     hash['failed'] = true
                     render_failed(101, t('common.error.not_valid', {obj: key})) and return hash if is_api
                else
                  hash[key] = param[key]
                end
              end
            else
              hash[key] = param[key] || nil
            end
          when 'object'
            append_checker = false
            hash[key] = validateParam(value['sub_object'], param[key], action, append_checker) unless param[key].nil?
          when 'array_object'
            append_checker = false
            array_object = []
            if !param[key].nil?
              param[key].each do |k, v|
                array_object << validateParam(value['sub_object'], k, action, append_checker) unless param[key].nil?
              end
            end
            hash[key] = array_object
          else
            hash[key] = param[key] || nil
        end
      end
    end

    return hash
  end

end