require 'java'
require 'set'

def find_scala
  os = java.lang.System.getProperty 'os.name'
  
  if os.include? 'Windows'
    'C:/Program Files/Scala'
  elsif os.include? 'Linux' or os.include? 'Mac'
    `which scala`.gsub("/bin/scala\n", '')
  else
    raise 'Unable to auto-detect Scala path.  Please set SCALA_HOME'
  end
end

module Scala
  include_package 'scala'
end

begin
  Java::Scala::Collection::IndexedSeq
rescue
  SCALA_HOME = find_scala unless defined? SCALA_HOME
  
  require SCALA_HOME + '/lib/scala-library.jar'
end

OPERATORS = {"=" => "$eq", ">" => "$greater", "<" => "$less", \
        "+" => "$plus", "-" => "$minus", "*" => "$times", "/" => "div", \
        "!" => "$bang", "@" => "$at", "#" => "$hash", "%" => "$percent", \
        "^" => "$up", "&" => "$amp", "~" => "$tilde", "?" => "$qmark", \
        "|" => "$bar", "\\" => "$bslash"}

module OperatorRewrites
  @__operator_rewrites_included__ = true
  
  alias_method :__old_method_missing_in_scala_rb__, :method_missing
  def method_missing(sym, *args)
    str = sym.to_s
    
    str = $&[1] + '_=' if str =~ /^(.*[^\]=])=$/
    
    OPERATORS.each do |from, to|
      str.gsub!(from, to)
    end
    
    gen_with_args = proc do |name, args|
      code = "#{name}("
      
      unless args.empty?
        for i in 0..(args.size - 2)
          code += "args[#{i}], "
        end
        code += "args[#{args.size - 1}]"
      end
      
      code += ')'
    end
    
    if str == '[]'
      eval(gen_with_args.call('apply', args))
    elsif sym.to_s == '[]='
      eval gen_with_args.call('update', args)            # doesn't work right
    elsif sym == :call and type_of_scala_function self
      eval(gen_with_args.call('apply', args))
    elsif sym == :arity and (ar = type_of_scala_function self) != false
      ar
    elsif sym == :binding and type_of_scala_function self
      binding
    elsif sym == :to_proc and type_of_scala_function self
      self
    elsif methods.include? str
      send(str.to_sym, args)
    else
      __old_method_missing_in_scala_rb__(sym, args)
    end
  end

  private
  def type_of_scala_function(obj)
    if obj.java_kind_of? Scala::Function0
      0
    elsif obj.java_kind_of? Scala::Function1
      1
    elsif obj.java_kind_of? Scala::Function2
      2
    elsif obj.java_kind_of? Scala::Function3
      3
    elsif obj.java_kind_of? Scala::Function4
      4
    elsif obj.java_kind_of? Scala::Function5
      5
    elsif obj.java_kind_of? Scala::Function6
      6
    elsif obj.java_kind_of? Scala::Function7
      7
    elsif obj.java_kind_of? Scala::Function8
      8
    elsif obj.java_kind_of? Scala::Function9
      9
    elsif obj.java_kind_of? Scala::Function10
      10
    elsif obj.java_kind_of? Scala::Function11
      11
    elsif obj.java_kind_of? Scala::Function12
      12
    elsif obj.java_kind_of? Scala::Function13
      13
    elsif obj.java_kind_of? Scala::Function14
      14
    elsif obj.java_kind_of? Scala::Function15
      15
    elsif obj.java_kind_of? Scala::Function16
      16
    elsif obj.java_kind_of? Scala::Function17
      17
    elsif obj.java_kind_of? Scala::Function18
      18
    elsif obj.java_kind_of? Scala::Function19
      19
    elsif obj.java_kind_of? Scala::Function20
      20
    elsif obj.java_kind_of? Scala::Function21
      21
    elsif obj.java_kind_of? Scala::Function22
      22
    else
      false
    end
  end
end

class Java::JavaLang::Object
  include OperatorRewrites
end

class Module
  alias_method :__old_include_in_scala_rb__, :include
  def include(*modules)
    modules.each do |m|
      clazz = nil
      begin
        if m.java_class.interface?
          cl = m.java_class.class_loader
          mixin_methods_for_trait(cl, cl.loadClass(m.java_class.to_s))
          
          __old_include_in_scala_rb__ OperatorRewrites unless @__operator_rewrites_included__
        end
      rescue
      end
      
      if defined? @@trait_methods
        define_method :scala_reflective_trait_methods do
          @@trait_methods
        end
      end
    end
    
    modules.each {|m| __old_include_in_scala_rb__ m }
  end
  
  def mixin_methods_for_trait(cl, trait_class, done=Set.new)
    return if done.include? trait_class
    done << trait_class
    
    clazz = cl.loadClass "#{trait_class.name}$class"
    
    trait_class.interfaces.each do |i| 
      begin
        mixin_methods_for_trait(cl, i, done)
      rescue
      end
    end
    
    clazz.declared_methods.each do |meth|
      mod = meth.modifiers
      
      if java.lang.reflect.Modifier.isStatic mod and java.lang.reflect.Modifier.isPublic mod
        @@trait_methods ||= []
        
        unless meth.name.include? '$'
          module_eval <<CODE
def #{meth.name}(*args, &block)
  args.insert(0, self)
  args << block unless block.nil?
  
  args.map! do |a|
    if defined? a.java_object
      a.java_object
    else
      a
    end
  end
  
  begin
    scala_reflective_trait_methods[#{@@trait_methods.size}].invoke(nil, args.to_java)
  rescue java.lang.reflect.InvocationTargetException => e
    raise e.cause.message.to_s      # TODO  change over for 1.1.4
  end
end
CODE
          
          @@trait_methods << meth
        else
          define_method meth.name do |*args|    # fallback for methods with special names
            args.insert(0, self)
            
            begin
              meth.invoke(nil, args.to_java)
            rescue java.lang.reflectInvocationTargetException => e
              raise e.cause.message.to_s
            end
          end
        end
      end
    end
  end
end

module ScalaProc
  class ScalaFunction
    def initialize(delegate)
      @delegate = delegate
    end
    
  def apply(*args)
  arglist = "("

  unless args.empty?
    for i in 0..(args.size - 2)
      arglist += "args[#{i}], "
    end
    arglist += "args[#{args.size - 1}]"
  end

  arglist += ')'

  eval("@delegate.call#{arglist}")
end


  end
  
  for n in 0..22    # sneaky, but much more concise
    eval <<CLASS
class Function#{n} < ScalaFunction
  include Scala::Function#{n}
end
CLASS
  end
end

class Proc
  def to_function
    eval "ScalaProc::Function#{arity}.new self"
  end
  
  def java_object
    to_function
  end
  
  def scala_object
    to_function
  end
end

