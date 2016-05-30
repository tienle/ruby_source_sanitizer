require "sexp_processor"
require "ruby_parser"
require "ruby2ruby"

class RubySourceSanitizer < SexpProcessor
  VERSION = "0.1.0"

  def initialize
    super

    self.require_empty  = false
    self.strict         = false
  end

  def default_rewriter(exp)
    return nil unless permit?(exp)
    exp
  end

  def self.rewriters
    @rewriters ||= Hash.new(:default_rewriter)
  end

  def sanitize(source)
    sexp = RubyParser.new.process(source)
    sexp = process(sexp)
    Ruby2Ruby.new.process(sexp)
  end

  def self.permit(type)
    (@permitted_types ||= []) << type
  end

  def self.permitted_types
    @permitted_types
  end

  private

  def permit?(exp)
    return false if !exp || !exp.respond_to?(:first)

    self.class.permitted_types.include?(exp.first)
  end
end
