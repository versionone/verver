module Verver::Loader::Utility

  def meta_friendly_name(name)
    name.to_s.split('_').map(&:capitalize).join
  end

  def ruby_friendly_name(name)
    name.to_s.gsub(/[A-Z]/) {|s| '_' + s.to_s.downcase}.gsub(/\./,'').sub('_','')
  end

end
