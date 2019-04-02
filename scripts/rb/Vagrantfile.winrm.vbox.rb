Vagrant.configure("2") do |c|
    c.vm.provision :shell do |shell|
        shell.path = "https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1"
        shell.args = " -EnableCredSSP -ForceNewSSLCert"
    end

    c.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        vb.memory = 2048
        vb.cpus = 2
    end
end
