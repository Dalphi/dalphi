    require 'rubygems'
    require 'bundler/setup'

    # require your gems as usual
    require "selenium-webdriver"

    Selenium::WebDriver::Firefox.path = "/home/marc/Documents/firefox/firefox"
    profile = Selenium::WebDriver::Firefox::Profile.new
    proxy = Selenium::WebDriver::Proxy.new(:http => nil)
    profile.proxy = proxy
    driver = Selenium::WebDriver.for :firefox, :profile => profile
    driver.navigate.to "http://google.com"

    element = driver.find_element(:name, 'q')
    element.send_keys "Hello WebDriver!"
    element.submit

    puts driver.title

    driver.quit
