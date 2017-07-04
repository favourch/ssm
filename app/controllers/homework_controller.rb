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

class HomeworkController < ApplicationController
  before_filter :login_required
  #filter_access_to :all

  def add
    @batches = Batch.active
    @subjects = []
    @classhomeworks = ClassHomeworks.new(params[:classhomeworks])
    
    if request.post? and @classhomeworks.save 
       if params[:upload]!=nil
        ClassHomeworks.save(params[:upload],(@classhomeworks.id).to_s)
        @classhomeworks.attachment_file_name = (@classhomeworks.id).to_s+"_"+params[:upload][:datafile].original_filename
        @classhomeworks.update_attribute(:attachment_file_name,@classhomeworks.attachment_file_name)
      end
      
      flash[:notice] = "Homework Added Successfully... "
      redirect_to :controller => 'homework', :action => 'view', :id => @classhomeworks.id
     
    end
  end
  
  def list_subjects
    @subjects = Subject.find_all_by_batch_id(params[:batch_id],:conditions=>"is_deleted=false")
    render(:update) do |page|
      page.replace_html 'subject-select', :partial=>'subject_select'
    end
  end
  
  def all
    @classhomeworks = ClassHomeworks.paginate :page => params[:page]
  end

  def delete
    @classhomeworks = ClassHomeworks.find(params[:id]).destroy
    flash[:notice] = "Homework Deleted Successfully..."
    redirect_to :controller => 'homework', :action => 'index'
  end

  def edit
    @batches = Batch.active
    @subjects = []
    @classhomeworks = ClassHomeworks.find(params[:id])
    @subjects =  Subject.find_all_by_batch_id(@classhomeworks['batch_id'],:conditions=>"is_deleted=false")
    if request.post? and @classhomeworks.update_attributes(params[:classhomeworks])
      
       if params[:upload]!=nil
        ClassHomeworks.save(params[:upload],(@classhomeworks.id).to_s)
        @classhomeworks.attachment_file_name = (@classhomeworks.id).to_s+"_"+params[:upload][:datafile].original_filename
        @classhomeworks.update_attribute(:attachment_file_name,@classhomeworks.attachment_file_name)
      end
      
      flash[:notice] = "Homework Updated Successfully..."
      redirect_to :controller => 'homework', :action => 'view', :id => @classhomeworks.id
    end
  end

  def index
    @current_user = current_user
    @batches = Batch.active
    @classhomeworks = []
    if request.get?
      if params[:exam_report]
        unless params[:exam_report][:batch_id].empty?
          @batch_id = params[:exam_report][:batch_id]
          @homework_date = params[:classhomeworks][:date].to_date
          @classhomeworks = ClassHomeworks.find_all_by_batch_id(@batch_id, :conditions =>{:date => @homework_date}) unless @batch_id.nil?
        end
      end
    end
  end

  def search_news_ajax
    @news = nil
    conditions = ["title LIKE ?", "%#{params[:query]}%"]
    @news = News.find(:all, :conditions => conditions) unless params[:query] == ''
    render :layout => false
  end
  
  def generated_homework
    
  end

  def view
    @current_user = current_user
    @classhomeworks = ClassHomeworks.find(params[:id])
    #@comments = @news.comments
  end
end
