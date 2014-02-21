class VotesController < ApplicationController

  def create
    
    @remix = Remix.find(params[:id])
    
    @vote = Vote.new(:remix_id => @remix.id, :ip_address => request.remote_ip)

    respond_to do |format|
      
      if @vote.save
                
        format.html {
          flash[:notice] = 'Hvala na glasu!'
          redirect_to @remix
        }
        format.js{
          render :update do |page|
            page.replace_html "vote_link_#{@remix.id}", "&nbsp;"
            page.replace_html "vote_count_#{@remix.id}", pluralize((@remix.votes_count + 1), 'vote')
          end
        }
        
      else
        
        error = 'Vec ste glasali za ovaj mix.'
        
        format.html { 
          flash[:notice] = error
          redirect_to @remix
        }
        format.js{ render :js => "alert('#{error}');" }
        
      end
      
    end
    
  end
  
end
