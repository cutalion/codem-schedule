class Job < ActiveRecord::Base
  Scheduled   = 'scheduled'
  Transcoding = 'transcoding'
  OnHold      = 'on_hold'
  Completed   = 'complete'
  Failed      = 'failed'
  
  belongs_to :preset

  scope :scheduled,   :conditions => {:state => Scheduled}
  scope :transcoding, :conditions => {:state => Transcoding}  
  scope :on_hold,     :conditions => {:state => OnHold}
  scope :completed,   :conditions => {:state => Completed}
  scope :failed,      :conditions => {:state => Failed}
  
  validates :source_file, :destination_file, :preset_id, :presence => true
  
  after_initialize :set_initial_state

  def self.from_api(options)
    new(:source_file => options['input'],
        :destination_file => options['output'],
        :preset => Preset.find_by_name(options['preset']))
  end
  
  private
    def set_initial_state
      self.state ||= Scheduled
    end
end
