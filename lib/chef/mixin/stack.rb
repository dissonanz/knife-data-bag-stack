#######################################################################################
#                                                                                     #
# Release management for Chef                                                         #
# by Sean Nolen <sean.m.nolen@gmail.com>                                              #
#                                                                                     #
# This library adds functionality for .rb files for roles and environments to include #
# a deep_merged stack of data bags in their attribute statements.                     #
#                                                                                     #
#######################################################################################

require 'chef'

class Chef
  module Mixin
    module Stack
      def data_bag_stack(stackables)
        raise ArgumentError, "Options must be a Hash." unless stackables.kind_of?(Hash)
        raise ArgumentError, "Please give me something to work with." unless stackables.keys.count > 0

        output = Hash.new

        stackables.each do |bag,items|
          case items
          when String
            Chef::Mixin::DeepMerge.deep_merge!(Chef::DataBagItem.load(bag,items).to_hash, output)
          when Array
            items.each do |item|
              Chef::Mixin::DeepMerge.deep_merge!(Chef::DataBagItem.load(bag,item).to_hash, output)
            end
          else
            raise ArgumentError, "Value should be a String or an Array."
          end
        end

        return output

      end
    end
  end
end
