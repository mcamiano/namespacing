module Namespacing
  def ns(namespace, opts={}, &block)
    options = {:delimiter => '.', :constants => {}}.merge opts
    make_namespaces(namespace.split(options[:delimiter]), options, block)
  end

  private
  def make_namespaces(namespaces, opts={:constants=>{}}, block)
    modules = namespaces.each_with_object([Kernel]) do |namespace, modules|
      modules << constant_in(modules.last, to_const(namespace)).tap do |mod|
        make_module_methods_accessible(mod)
      end
    end
    opts[:constants].each { |k,v| modules.last.const_set(k.to_s,v) }
    modules.last.module_exec(&block)
  end

  def constant_in(obj, str)
    return obj.const_get(str) if obj.const_defined?(str)
    obj.const_set(str, Module.new)
  end

  def make_module_methods_accessible(mod)
    mod.module_exec { extend self }
  end

  def to_const(str)
    str.split('_').map(&:capitalize).join
  end
end
