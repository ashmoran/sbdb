Dependencies
============

You need first the [Bdb](http://github.com/DenisKnauf/bdb) and of course [ruby](http://ruby-lang.org).

Download
========

via git:

	git clone git://github.com/DenisKnauf/sbdb.git

Install
=======

	gem build sbdb.gemspec
	gem install sbdb-*.gem

Usage
=====

First, open environment and database

	require 'sbdb'
	Dir.mkdir 'newenv'  rescue Errno::EEXIST
	env = SBDB::Env.new 'newenv', SBDB::CREATE
	db = env.open SBDB::Btree, 'newdb.db', :flags => SBDB::CREATE

It works nearly like a Ruby-Hash:

	db['key'] = 'value'
	db['key']		# => 'value'
	db.to_hash		# => {'key'=>'value'}
	db.map {|k, v| [k, v].join ' => '}		# => ["key => value"]
	db.count		# => 1

SBDB::DB#each uses a SBDB::Cursor:

	cursor = db.cursor
	cursor.each {|k,v| puts "#{k}: ${v}" }

**Don't forget to close everything, you've opened!**

	cursor.close
	db.close
	env.close

But you can use a *lambda* to ensure to close everything:

	SBDB::Env.new( 'newenv', SBDB::CREATE) do |env|
		env.open SBDB::Btree, 'newdb.db', :flags => SBDB::CREATE do |db|
			db.to_hash
		end
	end

SBDB::DB#to_hash creates a cursor and close it later.
