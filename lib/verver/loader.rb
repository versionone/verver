require 'rest-client'
require 'nokogiri'

require 'verver/loader/config'
require 'verver/loader/utility'
require 'verver/loader/asset'
require 'verver/loader/api'
require 'verver/loader/api2'
require 'verver/loader/dsl'

#@scope = find_or_create :scope do |f|
#
#  f.lookup :name, 'test_scope_4'
#
#  f.attributes do |a|
#    a.name 'test_scope_4'
#    a.begin_date Time.now
#  end
#
#  f.relations do |r|
#    r.parent 'Scope:0'
#  end
#
#end
#
#puts @scope
#
#@member1 = find_or_create :member do |f|
#
#  f.lookup :name, 'test_member_6'
#
#  f.attributes do |a|
#    a.username 'test_member_6'
#    a.nickname 'test_member_6'
#    a.password 'test_member_6'
#    a.notify_via_email true
#  end
#
#  f.relations do |r|
#    r.default_role 'Role:1'
#  end
#
#end
#
#puts @member1
#
#@member2 = find_or_create :member do |f|
#
#  f.lookup :name, 'test_member_5'
#
#  f.attributes do |a|
#    a.name 'blinky'
#    a.username 'test_member_5'
#    a.nickname 'test_member_5'
#    a.password 'test_member_5'
#    a.notify_via_email false
#  end
#
#  f.relations do |r|
#    r.default_role 'Role:1'
#  end
#
#end
#
#puts @member2
#
#@epic = find_or_create :epic do |f|
#
#  f.lookup :name, 'test_epic_4'
#
#  f.relations do |r|
#    r.scope @scope
#  end
#
#  f.mvrs do |m|
#    m.owners @member1, @member2
#  end
#
#end
#
#puts @epic
