module Cucumber
  module Tcl

    # Wraps the Cucumber DataTable so that when passed through to tcl, its
    # string representation is easy to parse into a tcl list.
    class DataTable
      def initialize(original)
        @original = original
      end

      def to_s
        to_tcl_list(@original.raw.map { |row| to_tcl_list(row) })
      end

      private

      def to_tcl_list(array)
        array.map { |element| "{" + element + "}" }.join(" ")
      end
    end

  end
end

