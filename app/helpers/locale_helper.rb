module LocaleHelper
  def locale(key)
    # ob = JSON.parse(self.name).inject({}){ |hash, (k, v)| hash.merge( k.to_sym => v )  }
    # locale_name = ob[I18n.locale]
    ob = JSON.parse(key)
    locale_name = ob[I18n.locale.to_s]

    return locale_name
  end
end
