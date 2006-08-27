require_gem 'upcoming'
require 'liquid_tag_base/liquid_collection_tag_base'
require 'event_drop'

module MephistoUpcoming
  
  class UpcomingWatchlistError < StandardError; end
  
  def self.authenticate(options={})
    UpcomingWatchlist.token = if options[:frob]
      Upcoming::authenticate_with_frob(options[:api_key], options[:frob])    
    elsif options[:token]
      Upcoming::authenticate(options[:api_key], options[:token])
    else
      raise UpcomingWatchlistError, "Incorrect upcoming authentication details given.  You must supply an api_key and either a frob or token.  Man, don't ask me. It's well over complicated."
    end
  end
  
  class UpcomingWatchlist < Liquid::CollectionTagBase
    
    @@token = nil
    cattr_accessor :token
    
    def render(context)
      raise UpcomingWatchlistError, "Please supply Upcoming authentication details." unless token
      result, options = [], evaluate(@options, context)
      
      watchlist = Upcoming::User.get_watchlist(token.user_id)
      watchlist = watchlist.select { |event| event.status == options[:status] } if options[:status]
      watchlist = watchlist[0..options[:count] - 1] if options[:count]
      
      watchlist.collect(&:to_liquid).each_with_index do |item, index|
        context.stack do
          context[tagname] = { 'index' => index + 1 }
          context[@as] = item
          result << render_all(@nodelist, context)
        end
      end
      
      result
    end
  end
  
end