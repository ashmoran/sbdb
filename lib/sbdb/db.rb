require 'bdb'
require 'sbdb/cursor'

module SBDB
	TYPES = []
	class DB
		UNKNOWN = Bdb::Db::UNKNOWN
		BTREE = Bdb::Db::BTREE
		HASH = Bdb::Db::HASH
		QUEUE = Bdb::Db::QUEUE
		ARRAY = RECNO = Bdb::Db::RECNO
		RDONLY = READLONY = Bdb::DB_RDONLY
		CONSUME = Bdb::DB_CONSUME
		CONSUME_WAIT = Bdb::DB_CONSUME_WAIT

		attr_reader :home
		include Enumerable
		def bdb_object()  @db  end
		def sync()  @db.sync  end
		def close( f = nil)  @db.close f || 0  end
		def cursor( &e)  Cursor.new self, &e  end

		def [] k
			@db.get nil, k.nil? ? nil : k.to_s, nil, 0
		rescue Bdb::DbError
			return  if $!.code == Bdb::DB_KEYEMPTY
			raise $!
		end

		def []= k, v
			if v.nil?
				@db.del nil, k.to_s, 0
			else
				@db.put nil, k.nil? ? nil : k.to_s, v.to_s, 0
			end
		end

		class << self
			def new *p, &e
				x = super *p
				return x  unless e
				begin e.call x
				ensure
					x.sync
					x.close
				end
			end
			alias open new
		end

		def initialize file, name = nil, type = nil, flags = nil, mode = nil, txn = nil, env = nil
			flags ||= 0
			type ||= UNKNOWN
			#type = BTREE  if type == UNKNOWN and (flags & CREATE) == CREATE
			@home, @db = env, env ? env.bdb_object.db : Bdb::Db.new
			begin @db.open txn, file, name, type, flags, mode || 0
			rescue Object
				close
				raise $!
			end
		end

		def each k = nil, v = nil, &e
			cursor{|c|c.each k, v, &e}
		end

		def reverse k = nil, v = nil, &e
			cursor{|c|c.reverse k, v, &e}
		end

		def to_hash k = nil, v = nil
			h = {}
			each( k, v) {|k, v| h[ k] = v }
			h
		end
	end

	class Unknown < DB
		def self.new file, name, *p, &e
			db = super( file, name, UNKNOWN, *p) {|db| db.bdb_object.get_type }
			TYPES[dbt] ? TYPES[dbt].new( file, name, *p, &e) : super( file, name, UNKNOWN, *p, &e)
		end
	end

	class Btree < DB
		def self.new file, name = nil, *p, &e
			super file, name, BTREE, *p, &e
		end
	end
	TYPES[DB::BTREE] = Btree

	class Hash < DB
		def self.new file, name = nil, *p, &e
			super file, name, HASH, *p, &e
		end
	end
	TYPES[DB::HASH] = Hash

	class Recno < DB
		def self.new file, name = nil, *p, &e
			super file, name, RECNO, *p, &e
		end

		def [] k
			super [k].pack('I')
		end

		def []= k, v
			super [k].pack('I'), v
		end
	end
	Array = Recno
	TYPES[DB::RECNO] = Recno

	class Queue < DB
		def self.new file, name = nil, *p, &e
			super file, name, QUEUE, *p, &e
		end

		def [] k
			super [k].pack('I')
		end

		def []= k, v
			super [k].pack('I'), v
		end

		def unshift
			get nil, nil, nil, Bdb::DB_CONSUME
		end
	end
	TYPES[DB::QUEUE] = Queue
end
