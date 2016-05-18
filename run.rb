#!/usr/bin/env ruby

require 'dotenv'
Dotenv.load

require 'csv'
require 'rest-client'

class SlackResponse < OpenStruct
  def members
    self[:members].map { |m| Member.new(m) }
  end

  def full_time_members
    members.select(&:is_full_time?)
  end
end

class Member < OpenStruct
  def print_name
    if profile.real_name == ''
      name
    else
      profile.real_name
    end
  end

  def csv_row
    [print_name, profile.email]
  end

  def is_full_time?
    !deleted && !is_bot && !is_restricted && name != 'slackbot'
  end
end

res = JSON.parse(
  RestClient.get("https://slack.com/api/users.list?token=#{ENV['SLACK_TOKEN']}", accept: :json),
  object_class: SlackResponse
)
raise "Oops! Response was not ok: #{res}" unless res.ok

CSV.open('team.csv', 'w') do |csv|
  csv << %w(Name Email)
  res.full_time_members.map(&:csv_row).each { |row| csv << row }
end
