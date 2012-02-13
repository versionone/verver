require 'verver/loader'

describe "Full tilt loading!" do

  it "works like a charm" do

    pending("waiting on access to local instance to try this out")

    @scope = find_or_create_2 :scope do |f|

      f.lookup :name, 'test_scope_4'

      f.attributes do |a|
        a.name 'test_scope_4'
        a.begin_date Time.now
      end

      f.relations do |r|
        r.parent 'Scope:0'
      end

    end

    @member1 = find_or_create_2 :member do |f|

      f.lookup :name, 'inky'

      f.attributes do |a|
        a.username 'inky'
        a.nickname 'inky'
        a.password 'inky'
        a.notify_via_email true
      end

      f.relations do |r|
        r.default_role 'Role:1'
      end

    end

    puts @member1

    @member2 = find_or_create_2 :member do |f|

      f.lookup :name, 'test_member_5'

      f.attributes do |a|
        a.name 'blinky'
        a.username 'blinky'
        a.nickname 'blinky'
        a.password 'blinky'
        a.notify_via_email false
      end

      f.relations do |r|
        r.default_role 'Role:1'
      end

    end

    @epic = find_or_create_2 :epic do |f|

      f.lookup :name, 'big work'

      f.relations do |r|
        r.scope @scope
      end

      f.mvrs do |m|
        m.owners @member1, @member2
      end

    end

  end

end
