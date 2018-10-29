require 'watir'
require 'cucumber'


Given(/^a user goes to Google$/) do
  @browser.goto "https://www.google.com"
end

When(/^they enter (.*) in the search box$/) do |query|
  @browser.text_field(:title => "Search").set "#{query}"
  @browser.send_keys :enter
end

Then(/^they will get results for (.*)$/) do |query|
  assert ("Matching websites for the keyword #{query} found!") {@browser.div(:id => "search").text.include? "#{query}"} #checks search div for exact match on keyword
end


