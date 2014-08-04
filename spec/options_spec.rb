require_relative '../lib/namespacing'

class Object
  include Namespacing
end

describe Namespacing do

  context 'constants' do

    it 'option can optionally specify module constants' do
      ns 'my_app.dojo.util.options', { :constants => {
        :APPLES => "3",
        :ORANGES=> "14",
        :PEARS  => "159"
      }} do
        def my_module_constants
          self::APPLES + MyApp::Dojo::Util::Options::ORANGES + const_get(:PEARS)
        end
      end
      expect(MyApp::Dojo::Util::Options.my_module_constants).to eq("314159")
    end

  end

end
