# -*- coding: utf-8 -*-
class User < ActiveRecord::Base

  attr_accessible :username, :email, :displayname

  validates_uniqueness_of :username
  validates :username, :displayname, :email,
      :presence => { :allow_blank => false }

  def toggle_admin
    self.update_attribute "is_admin", self.is_admin ? false : true
  end

  # Check credentials with the LDAP server
  def self.auth params
    if params["username"].empty? or params["password"].empty?
      logger.warn "#{Time.now} AUTH: #{params["username"]} failed to log in. Empty username or password"
      return false
    end
    ldap = connect
    if ldap.bind_as(:base => APP_CONFIG["ldap"]["base_dn"], :filter => "cn=#{params["username"]}", :password => params["password"] )
      true
    else
      logger.warn "#{Time.now} LDAP: #{params["username"]} failed to log in. #{ldap.get_operation_result}"
      false
    end
  end

  # Search the ldap server for usernames (cn). Return selected fields for matching records.
  def self.search username
    # Bind the proxy user account
    ldap = connect
    if ldap.bind
      users = []
      results = ldap.search(
        :base => APP_CONFIG["ldap"]["base_dn"],
        :attributes =>   %w[ cn displayname mail ],
        :filter => "cn=#{username}*",
        :return_result => true)
      results.each do |user|
        # Simplify structure and throw away records without email addresses
        begin
          users.push(
            :username => user.cn.first,
            :displayname => user.displayname.first.force_encoding('UTF-8'),
            :mail => user.mail.first
          )
        rescue
        end
      end
      users
    else
      logger.warn "#{Time.now} LDAP: Failed to bind proxy user. #{ldap.get_operation_result}"
      false
    end
  end

  # Connect to LDAP server with a proxy user account
  def self.connect
    Net::LDAP.new :host => APP_CONFIG["ldap"]["host"],
      :port => APP_CONFIG["ldap"]["port"],
      :encryption => {
        :method => :simple_tls
      },
      :auth => {
        :method => :simple,
        :username => APP_CONFIG["ldap"]["proxy_user"],
        :password => APP_CONFIG["ldap"]["proxy_password"]
      }
  end
end
