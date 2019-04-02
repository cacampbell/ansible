Vagrant.configure("2") do |c|
    c.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        vb.memory = 2048
        vb.cpus = 2
    end
end
