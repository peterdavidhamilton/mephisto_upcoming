module Liquid
  
  class CollectionTagBase < Liquid::Block
    Syntax = /((#{Liquid::TagAttributes}\s?,?\s?)*)as\s(#{Liquid::AllowedVariableCharacters}+)/
    
    def initialize(markup, tokens)
      super
      if markup =~ Syntax
        @options = parse_options($1)
        @as = $5
        raise Liquid::SyntaxError.new("Syntax Error in tag '#{tagname}' - required options not given.") unless has_required_options? @options
      else
        raise Liquid::SyntaxError.new("Syntax Error in tag '#{tagname}' - Valid syntax: #{tagname} [ opt : 'val', opt : 'val' ] as [name]")
      end
    end
    
    private
      
    def parse_options(opt_string)
      pairs, opts = opt_string.split(','), {}
      pairs.each do |pair|
        opt, value = pair.split(':')
        opts[opt.strip.to_sym] = value.strip
      end
      return opts
    end
    
    def evaluate(options, context)
      evaluated = {}
      options.each { |opt, value| evaluated[opt] = context[value]  }
      return evaluated
    end
    
    def tagname
      self.class.name.downcase
    end
    
    def has_required_options?(options)
      true
    end
  
  end
  
end