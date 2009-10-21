require 'rexml/document'
require 'uri'
require 'open-uri'
include REXML

host=ARGV[0]
port=ARGV[1]

    host="#{host}:#{port}"
    url = "http://#{host}/status?XML=true"
    start = Time.now
    xml = open(url){|f| f.read }
    elapsed = 1000 * (Time.now - start)
    doc= Document.new(xml)
    
    # guess at right connector
    httpconnector = doc.root.elements[3]    
    # now look for the right connector
    doc.root.elements.each do |connector|
      if (connector.attributes["name"] =~ /http/) then
        httpconnector = connector
      end
    end
    workers = httpconnector.elements["workers"].elements
    keepalive = 0
    parseing=0
    serving=0
    finishing=0
    ready=0
    total=0
    workers.each do |w|  
      total = total + 1
      stage = w.attributes["stage"]
      if  (stage =~ /S/ ) then
        serving = serving + 1
      elsif (stage =~/K/) then
        keepalive = keepalive + 1
      elsif (stage =~ /P/) then
        parseing=parseing + 1
      elsif (stage =~ /F/) then
        finishing = finishing + 1
      elsif (stage =~ /R/) then
        ready = ready + 1
      end
    end
    
    puts "OK|time=#{elapsed};;;;total=#{total};;;;keepalive=#{keepalive};;;;parse_req=#{parseing};;;;serving=#{serving};;;;ready=#{ready};;;;finishing=#{finishing}"
