class Books < ActiveRecord::Base
  
  validates_presence_of :title, :subject, :book_file_name

  default_scope :order => 'created_at DESC'

  cattr_reader :per_page
  @@per_page = 12
  
  
  def self.save(upload,bookid)
    name =  bookid+"_"+upload['datafile'].original_filename
    directory = "public/system/books"
    
    # create the file path
    path = File.join(directory, name)
    # write the file
    File.open(path, "wb") { |f| f.write(upload['datafile'].read) }
  end
  
  
end
