# coding: utf-8

module IsVisitable
  class Visit < ::ActiveRecord::Base
    
    ASSOCIATIVE_FIELDS = [
        :visitable_id,
        :vistable_type,
        :visitor_id,
        :visitor_type,
        :ip
      ].freeze
    CONTENT_FIELDS = [
        :visits
      ].freeze
      
    # Associations.
    belongs_to :visitable, :polymorphic => true
    belongs_to :visitor, :polymorphic => true
    
    # Aliases.
    alias :object :visitable
    alias :owner  :visitor
    
    # Named scopes: Order.
    scope :in_order,            :order => 'created_at ASC'
    scope :most_recent,         :order => 'created_at DESC'
    scope :lowest_visits,       :order => 'visits ASC'
    scope :highest_visits,      :order => 'visits DESC'
    
    # Named scopes: Filters.
    scope :since,               lambda { |created_at_datetime|  where("created_at >= ?", created_at_datetime) }
    scope :recent,              lambda { |arg|
                                        if [::ActiveSupport::TimeWithZone, ::DateTime].any? { |c| c.is_a?(arg) }
                                          where("created_at >= ?", arg)
                                        else
                                          limit(arg)
                                        end
                                      }
    scope :between_dates,       lambda { |from_date, to_date|    where(:created_at => (from_date..to_date)) }
    scope :with_visits,         lambda { |visits_value_or_range|  where(:visits => visits_value_or_range) }
    scope :of_visitable_type,   lambda { |type|       where(Support.polymorphic_conditions_for(type, :visitable, :type)) }
    scope :by_visitor_type,     lambda { |type|       where(Support.polymorphic_conditions_for(type, :visitor, :type)) }
    scope :on,                  lambda { |visitable|  where(Support.polymorphic_conditions_for(visitable, :visitable)) }
    scope :by,                  lambda { |visitor|    where(Support.polymorphic_conditions_for(visitor, :visitor)) }
    
  end
end
