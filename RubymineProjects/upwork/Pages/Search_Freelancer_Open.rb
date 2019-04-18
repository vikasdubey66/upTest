# ##########################################################################################
# Upwork freelanceer profile search according to keyword provided,
# Done using a single page script which can be later broken down in to its own class and actions
# For now kept it simple as i am switching to Ruby(just one day old :) )
# Logger used to log stdio
#

require 'rubygems'
require 'Selenium-webdriver'
require_relative 'log'
Dir[File.join(__dir__, '..', '*.rb')].each(&method(:require))

class SearchFreeLancerOpen



# ###########################################################################################
# Setting up Env variables for browser type, url to open and keyword to be sent
# @param [String]: Browser
# @param [String]: URL needed to open
# @param [String]: keyword to be sent

  ENV['BROWSER'] = 'firefox'
  ENV['URL'] = 'https://upwork.com'
  String keyword = "testing"
# *****END*****
# ##########################################################################################

# #########################################################################################
# setting driver location and choosing driver type based on variable
#

  Selenium::WebDriver::Firefox.driver_path = File.expand_path('../Driver/geckodriver',__dir__ )
  Selenium::WebDriver::Chrome.driver_path = File.expand_path('../Driver/chromedriver',__dir__ )

  case ENV['BROWSER']
  when 'chrome'
    driver = Selenium::WebDriver.for :chrome

  when 'firefox'
    driver = Selenium::WebDriver.for :firefox
  end
# *****END*****
# ##########################################################################################


#------------------------------------------------------------------------------------------#
#                                           +Locators+                                     #
#------------------------------------------------------------------------------------------#
  String findFreelancerInput_ = "(//*[@placeholder='Find Freelancers'])[3]"
  String searchMagnifyingGlass_ = "(//*[@class='btn p-0-left-right'])[3]"
  String profileTitle_ = "//a[contains(@class,'freelancer-tile-name')]"
  String profile_ = "//section[@data-compose-log-data]"
  String profileTitleOpen_="//h3[contains(@class,'m-sm-bottom')]"
  String openProfileContent_ = "(//*[contains(@class,'air-card')])[1]"
#------------------------------------------------------------------------------------------#
#                                           +Locators+                                     #
#------------------------------------------------------------------------------------------#



# ###########################################################################################
#
# maximise the window size
# clear browser cookies
# navigating to upwork

# [1] Run `<browser>`
# [2] Clear `<browser>` cookies

  driver.manage.window.maximize
  driver.manage.delete_all_cookies
  Log.done

# [3] Go to www.upwork.com

  Log.step("Opening Upwork")
  driver.navigate.to ENV['URL']
  puts 'Upwork is loaded in '+ ENV['BROWSER'] +' browser'
  Log.done(ENV['URL'] + " Loaded")


# [4] Focus onto "Find freelancers"
# [5] Enter `<keyword>` into the search input right from the dropdown
# and submit it (click on the magnifying glass button)

  mainPageSearch = driver.find_element(:xpath,findFreelancerInput_)
  Log.step("Focusing on the SearchBox")
  mainPageSearch.click
  Log.step("Send keyword in SearchBox")
  mainPageSearch.send_key(keyword)
  searchEnter = driver.find_element(:xpath,searchMagnifyingGlass_)
  Log.step("Click on Magnifying icon")
  searchEnter.click

# ##########################################################################################
# Store the data in list
# Profiles tile
# Iterate through each tile and store/compare the text

# [6] Parse the 1st page with search results:
# store info given on the 1st page of search results as structured data of any chosen by you type

  searchPageProfileContent= Array.new
  $i=0
  profiles = driver.find_elements(:xpath,profile_)
  for profile in profiles
    data = profile.text
    searchPageProfileContent[$i]=data

# [7] Make sure at least one attribute (title, overview, skills, etc) of each item (found freelancer)
# from parsed search results contains `<keyword>` Log in stdout which freelancers and attributes contain `<keyword>` and which do not.
    if (data.downcase).include?(keyword.downcase)
      Log.done("Profile data(title or description or skills) contains Keyword \n")
    else
      Log.step("Profile doesn't contain keyword")
  end
  end
  profile_index = profiles.length
  random_profile = rand(1..profile_index)
  profileTitle = driver.find_elements(:xpath,profileTitle_)

# [8] Click on random freelancer's title
# [9] Get into that freelancer's profile

  Log.step("Opening random profile")
  sleep 3
  profiles[random_profile].click
  sleep 10
  Log.done
  Log.step("Fetching Profile data")

  profilesTitleOpen = driver.find_elements(:xpath,profileTitleOpen_)

# [10] Check that each attribute value is equal to one of those stored in the structure created in #67
  for profileTitleOpen in profilesTitleOpen
    titleText = (profileTitleOpen.text).downcase
    searchPageData = (searchPageProfileContent).map(&:downcase)
  end

# [11] Check whether at least one attribute contains `<keyword>`

  openProfileData= driver.find_element(:xpath,openProfileContent_).text
  downCaseData =openProfileData.downcase
  if searchPageData.include?(titleText)
    Log.done("Content Matched from search result")
  else
    Log.step("Content matched")
  end

  if downCaseData.include?(keyword)
    Log.done("Profile contains keyword")
  else
    Log.step("Keyword not found in profile it could be a agency account and keyword would be in Agency's contractor")
  end


  driver.quit

  Log.publish_results
end



# *****END*****
# ##########################################################################################