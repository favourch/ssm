class ClassHomeworks < ActiveRecord::Base
  belongs_to :batch
  belongs_to :subject
  
  validates_presence_of :batch, :subject, :title, :content
  
  default_scope :order => 'created_at DESC'

  cattr_reader :per_page
  @@per_page = 12
  
  def self.save(upload,classhomeworkid)
    name =  classhomeworkid+"_"+upload['datafile'].original_filename
    directory = "public/system/homeworks"
    
    # create the file path
    path = File.join(directory, name)
    # write the file
    File.open(path, "wb") { |f| f.write(upload['datafile'].read) }
  end
  
end
