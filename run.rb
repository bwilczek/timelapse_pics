require 'dropbox_api'
require 'selenium-webdriver'
require 'fileutils'

dropbox_key = ENV.fetch('DROPBOX_TIMELAPSEPICS_TOKEN')
cam_url = ENV.fetch('CAM_URL')
cam_username = ENV.fetch('CAM_USERNAME')
cam_password = ENV.fetch('CAM_PASSWORD')

download_dir_base = "#{Dir.pwd}/tmp"
download_dir = "#{download_dir_base}/download"

FileUtils.rm_rf download_dir
FileUtils.mkdir_p download_dir

# Set Firefox preferences for downloading files automatically
options = Selenium::WebDriver::Firefox::Options.new
profile = Selenium::WebDriver::Firefox::Profile.new

# Set preferences for auto-downloading PNG files
profile['browser.download.folderList'] = 2 # Use custom download path
profile['browser.download.dir'] = download_dir
profile['browser.download.useDownloadDir'] = true
profile['browser.download.manager.showWhenStarting'] = false
profile['browser.helperApps.neverAsk.saveToDisk'] = 'image/png'
profile['pdfjs.disabled'] = true # Disable PDF viewer if needed

options.profile = profile
options.add_argument('-headless')

driver = Selenium::WebDriver.for :firefox, options: options

begin
  # Navigate to the page
  driver.navigate.to cam_url

  driver.find_element(id: 'login_user').send_keys(cam_username)
  driver.find_element(id: 'login_psw').send_keys(cam_password)
  driver.find_element(xpath: "//a[@title='Login']").click
  sleep 5 # Replace with proper waiting logic if needed
  driver.find_element(xpath: "//a[@title='Snapshot']").click
  sleep 5 # Replace with proper waiting logic if needed
ensure
  driver.quit
end

puts "File should be downloaded to #{download_dir}"
local_file_name = filename = Dir["#{download_dir}/*"].select { |f| File.file?(f) }.first

puts "Uploading #{local_file_name} to dropbox..."

dbx = DropboxApi::Client.new(dropbox_key)
dbx.upload "/#{File.basename(local_file_name)}", File.read(local_file_name)
