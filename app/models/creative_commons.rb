class CreativeCommons
  def self.license_url(license)
    cc, by, version = license.split(' ')
    "http://creativecommons.org/licenses/#{by.downcase}/#{version}/"
  end
end