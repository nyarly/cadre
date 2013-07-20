class Uuu < RSpec::Core::Formatters::ProgressFormatter
  def example_passed(example)
    if @failed_examples.empty?
      super
    else
      output.print red("u")
    end
  end
end
