#Fedena
#Copyright 2011 Foradian Technologies Private Limited
#
#This product includes software developed at
#Project Fedena - http://www.projectfedena.org/
#
#Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an "AS IS" BASIS,
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#See the License for the specific language governing permissions and
#limitations under the License.

class ElibraryController < ApplicationController
  before_filter :login_required
  #filter_access_to :all

  def add
    @books = Books.new(params[:books])
    @books.book_file_name = 'test'
    if request.post? and @books.save 

      if params[:upload]!=nil
        Books.save(params[:upload],(@books.id).to_s)
        @books.book_file_name = (@books.id).to_s+"_"+params[:upload][:datafile].original_filename
        @books.update_attribute(:book_file_name,@books.book_file_name)
      end
      flash[:notice] = "Book Uploaded Successfully..."
      redirect_to :controller => 'elibrary', :action => 'view', :id => @books.id
    end
    
  end

  def add_comment
    #@cmnt = NewsComment.new(params[:comment])
    #@cmnt.author = current_user
    #@cmnt.save
  end

  def all
    @books = Books.paginate :page => params[:page]
  end

  def delete
    @books = Books.find(params[:id]).destroy
    flash[:notice] = "Book Deleted Successfully.."
    redirect_to :controller => 'elibrary', :action => 'index'
  end

  def delete_comment
    #@comment = NewsComment.find(params[:id])
    #NewsComment.destroy(params[:id])
  end

  def edit
    @books = Books.find(params[:id])
    if request.post? and @books.update_attributes(params[:books])
      
       if params[:upload]!=nil
        Books.save(params[:upload],(@books.id).to_s)
        @books.book_file_name = (@books.id).to_s+"_"+params[:upload][:datafile].original_filename
        @books.update_attribute(:book_file_name,@books.book_file_name)
      end
      flash[:notice] = "Book Updated Successfully.."
      redirect_to :controller => 'elibrary', :action => 'view', :id => @books.id
    end
  end

  def index
    @current_user = current_user
    @books = []
    if request.get?
      @books = Books.title_like_all params[:query].split unless params[:query].nil?
    end
  end

  def search_books_ajax
    @books = nil
    conditions = ["title LIKE ?", "%#{params[:query]}%"]
    @books = Books.find(:all, :conditions => conditions) unless params[:query] == ''
    render :layout => false
  end

  def view
    @current_user = current_user
    @books = Books.find(params[:id])
    #@comments = @news.comments
  end

end
