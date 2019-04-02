describe file('/') do
  its('owner') { should eq 'root' }
  its('group') { should eq 'root' }
end
