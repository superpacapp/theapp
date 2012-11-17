class CommitteeController < ActionController::API
  include ActionController::MimeResponds
  include ActionView::Helpers::NumberHelper

  #GET /committees
  def index
    @committees = Committee.includes(:committee_articles, :ads).where('committees.id=ads.committee_id').order('committees.cmte_name ASC, ads.upload_on DESC')

    #render json: @committees
    render "committees/index"

  end

  #GET /committees/C00009999
  def show
    @committee = Committee.find_all_by_cmte_id(params[:cmte_id], :include => [:ads, :committee_articles])

    #render json: @committee.to_json(:include => :ads)

    render "committees/show"
  end

  def preview
    @committees = Committee.includes(:ads).where('committees.id=ads.committee_id').order('committees.cmte_name ASC, ads.upload_on DESC')

    render "committees/preview"

  end

  def filter
      if !params[:so].nil?
        #pro romney = sup romney +opp obama + conservative
        #pro obama = sup obama + opp romney + liberal
          if params[:so]=='support obama'
            committee_conditions_clause = "lower(suppopp) in ('support obama', 'liberal', 'oppose romney')"
          else
            committee_conditions_clause = "lower(suppopp) in ('support romney', 'conservative', 'oppose obama')"
          end
      else
        committee_conditions_clause = "suppopp like '%'"
      end

      if !params[:tg].nil?
          if params[:tg] == 'love'
            tags_clause = "committees.cmte_id=ads.cmte_id and ads.id in (select id from ads where love > fishy and love > fail and love > fair)"
          end
          if params[:tg] == 'fair'
            tags_clause = "committees.cmte_id=ads.cmte_id and ads.id in (select id from ads where fair > fishy and fair > fail and fair > love)"
          end
          if params[:tg] == 'fishy'
            tags_clause = "committees.cmte_id=ads.cmte_id and ads.id in (select id from ads where fishy > love and fishy > fail and fishy > fair)"
          end
          if params[:tg] == 'fail'
            tags_clause = "committees.cmte_id=ads.cmte_id and ads.id in (select id from ads where fail > fishy and fail > love and fail > fair)"
          end
       else
        tags_clause = "committees.cmte_id=ads.cmte_id"
      end

      if !params[:t].nil?
        if params[:t]=='recent'
          if !params[:tg].nil?
            @committees = Committee.where(committee_conditions_clause).includes(:ads).where(tags_clause + " and ads.upload_on > current_date - integer '5'").order('ads.upload_on desc')
          else
            @committees = Committee.where(committee_conditions_clause).includes(:ads).where("ads.upload_on > current_date - integer '5'").order('ads.upload_on desc')
          end
        end
        if params[:t]=='popular'
          @committees = Committee.where(committee_conditions_clause).includes(:ads).where(tags_clause + ' and ads.id in (select id from ads where love+fair+fishy+fail > 50)').order('ads.upload_on desc')
        end
        if params[:t]=='recent,popular'
          @committees = Committee.where(committee_conditions_clause).includes(:ads).where(tags_clause + " and ads.upload_on > current_date-integer '5'" + ' and ads.id in (select id from ads where love+fair+fishy+fail > 50)').order('ads.upload_on desc')
        end
      else
        if !params[:tg].nil?
          @committees = Committee.where(committee_conditions_clause).includes(:ads).where(tags_clause)
        else
          @committees = Committee.where(committee_conditions_clause).includes(:ads).where('ads.cmte_id=committees.cmte_id')
        end
      end


    render "committees/filter"
  end

  def newsweek
    @committees = Committee.includes(:committee_articles, :ads).where('committees.id=ads.committee_id').limit(3)

    render "committees/index"
  end


end