require 'watir'
require 'cucumber'

def browser_name
  (ENV['BROWSER'] ||= 'chrome').downcase.to_sym       #pass browser as a command line argument
end

def environment
  (ENV['ENVIRONMENT'] ||= 'prod').downcase.to_sym     #set environment for testing as argument.
end

Before do |scenario|
  def assert message, &block
    begin
      if (block.call)
        puts "Assertion PASSED for #{message}"
      else
        puts "Assertion FAILED for #{message}"
        Dir::mkdir('screenshots') if not File.directory?('screenshots')
        screenshot = "./screenshots/FAILED_#{message}-#{Time.now.strftime('%Y-%m-%d %H-%M-%S')}.png"
        @browser.driver.save_screenshot(screenshot)
        embed screenshot, 'image/png'
      end
    end
  end
  p "Starting #{scenario}"
  if environment == :prod
    @browser = Watir::Browser.new browser_name
  end
end
After do |scenario|
  if scenario.failed?
    Dir::mkdir('screenshots') if not File.directory?('screenshots')
    screenshot = "./screenshots/FAILED_#{scenario.name}-#{Time.now.strftime('%Y-%m-%d %H-%M-%S')}.png"
    @browser.driver.save_screenshot(screenshot)
    embed screenshot, 'image/png'
  end
  @browser.close
end

