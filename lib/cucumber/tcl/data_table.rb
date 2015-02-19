module Cucumber
  module Tcl

    # Wraps the Cucumber DataTable so that when passed through to tcl, its
    # string representation is easy to parse into a tcl list.
    class DataTable
      def initialize(original)
        @original = original
      end

      def to_s
        rows = @original.raw.map { |row|
          cells = row.map { |cell| %{"#{cell}"} }
          to_tcl_list(cells)
        }
        to_tcl_list(rows)
      end

      private

      def to_tcl_list(array)
        "{" + array.join(" ") + "}"
      end
    end

  end
end

