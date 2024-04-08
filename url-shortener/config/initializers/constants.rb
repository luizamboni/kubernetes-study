begin
    f = open('/etc/hostname')
    INTERNAL_HOSTNAME = f.read()
    f.close()    
rescue
    INTERNAL_HOSTNAME = ""
end
