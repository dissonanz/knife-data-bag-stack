require 'chef/knife/data_bag_stack'

module ChefSpecs
  class ChefRest
    attr_reader :args_received
    def initialize
      @args_received = []
    end

    def post_rest(*args)
      @args_received << args
    end
  end
end



describe Chef::Knife::DataBagStack do

  before do

    @knife = Chef::Knife::DataBagStack.new
    @base_url   = "http://chef.example.com:4000"
    @rest = Chef::REST.new(@base_url, nil, nil)
    @knife.stub!(:rest).and_return(@rest)
    @stdout = StringIO.new
    @knife.ui.stub!(:stdout).and_return(@stdout)
  end

  it "returns help page when there is no argument" do
    pending
  end

  it "returns the same data bag if only one is given" do
#    File.stub(:read).with("/etc/chef/client.pem").returns("mykey")
    @rest.should_receive(:something)
    @knife.name_args = ["smegheads","Lister"]
    @knife.run
  end

end
