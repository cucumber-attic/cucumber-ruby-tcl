require 'cucumber/tcl/data_table'
require 'cucumber/core/ast/data_table'

module Cucumber::Tcl
  describe DataTable do
    it "#to_s converts to Tcl list of lists" do
      raw = [["a", "b"], ["c", "d"]]
      original = Cucumber::Core::Ast::DataTable.new(raw, Cucumber::Core::Ast::Location.new(__FILE__, 8))
      table = DataTable.new(original)
      expect(table.to_s).to eq '{{"a" "b"} {"c" "d"}}'
    end
  end
end
