module Dan
  module Api
    module Resources
      module List
        attr_reader :client, :elements, :parent

        def initialize(client, elements = [], parent=nil)
          @client = client
          @elements = elements
          @parent = parent
        end

        def <<(element)
          elements << element
        end

        def [](reference)
          elements.find do |resource|
            resource.id == reference || resource.token == reference
          end
        end

        def clear
          @elements = []
        end
      end
    end
  end
end
