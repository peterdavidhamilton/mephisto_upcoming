module MephistoUpcoming
  class EventDrop < Liquid::Drop
    include Mephisto::Liquid::DropMethods
  
    def event
      @source
    end
  
    def initialize(source)
      @source = source
      @event_liquid = {
        'id' => @source.id,
        'name' => @source.name,
        'tags' => @source.tags.split(' '),
        'description' => @source.description,
        'start' => @source.start,
        'end' => @source.end, 
        'status' => @source.status
      }
    end
    
    def before_method(meth)
      @event_liquid[meth.to_s]
    end
  
    def venue
      @venue ||= @source.venue.to_liquid
    end
  
  end
end

class Upcoming::Event
  
  def to_liquid
    MephistoUpcoming::EventDrop.new(self)
  end
  
end

class Upcoming::Venue
  
  def to_liquid
    {
      'name' => name, 
      'address' => address, 
      'city' => city, 
      'zip' => zip, 
      'phone' => phone, 
      'url' => url, 
      'description' => description, 
      'longitude' => longitude, 
      'latitude' => latitude
    }
  end
  
end