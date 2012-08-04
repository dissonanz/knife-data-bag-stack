require 'chef/knife'
require 'chef/mixin/release'



class Chef
  class Knife
    class DataBagMerge < Knife

      deps do
        require 'chef/data_bag'
        require 'chef/data_bag_item'
      end

      banner "knife data bag merge BAG FILE (options)"
      category "data bag"

      def run
        @data_bag_name, @data_bag_item_name = @name_args

        if @data_bag_name.nil?
          ui.fatal("You must specify a data bag name.")
        end

        set_release({"smegheads" => "Lister"})
        
      end
      
    end
  end
end
