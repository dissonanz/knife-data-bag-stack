require 'chef/knife/data_bag_merge'

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



describe Chef::Knife::DataBagMerge do

  before do
    @knife = Chef::Knife::DataBagMerge.new
    @rest = ChefSpecs::ChefRest.new
    @knife.stub!(:rest).and_return(@rest)
    @stdout = StringIO.new
    @knife.ui.stub!(:stdout).and_return(@stdout)
  end

  it "returns help page when there is no argument" do
    pending
  end

  it "returns the same data bag if only one is given" do
    @knife.name_args = ["smegheads","Lister"]
    @knife.run

end
