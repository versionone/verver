module Verver::Loader::Utility

  def meta_friendly_name(name)
    meta_friendly_name = name.to_s.split('_').collect(&:capitalize)
    meta_friendly_name.join
  end

  def ruby_friendly_name(name)
    name.to_s.gsub(/[A-Z]/) {|s| '_' + s.to_s.downcase}.gsub(/\./,'').sub('_','')
  end

end
