require 'java'

# 1. used my own path
# 2. added double method and import statement
require '/Users/AOK/Downloads/otp_src_R14B01/lib/jinterface/priv/OtpErlang.jar'
#require '/opt/local/lib/erlang/lib/jinterface/priv/OtpErlang.jar'

module Erlang
  import com.ericsson.otp.erlang.OtpSelf
  import com.ericsson.otp.erlang.OtpPeer
  import com.ericsson.otp.erlang.OtpErlangLong
  import com.ericsson.otp.erlang.OtpErlangObject
  import com.ericsson.otp.erlang.OtpErlangList
  import com.ericsson.otp.erlang.OtpErlangTuple
  import com.ericsson.otp.erlang.OtpErlangDouble

  class << self
    def tuple(*args)
      OtpErlangTuple.new(args.to_java(OtpErlangObject))
    end

    def list(*args)
      OtpErlangList.new(args.to_java(OtpErlangObject))
    end

    def client(name, cookie)
      yield OtpSelf.new(name, cookie)
    end

    def num(value)
      OtpErlangLong.new(value)
    end
    
    def double(value)
      OtpErlangDouble.new(value)
    end

    def server(name, cookie)
      server = OtpSelf.new(name, cookie)
      server.publish_port

      while true
        yield server, server.accept  
      end
    end
  end
end