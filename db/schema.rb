# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120906010722) do

  create_table "ad_claim_source", :id => false, :force => true do |t|
    t.string "cmte_name"
    t.string "user_name"
    t.string "video_url"
    t.string "video_id"
    t.string "ad_title"
    t.string "ad_claim"
    t.string "source_url"
    t.string "source_title"
    t.string "source_name"
    t.string "source_type"
  end

  create_table "ads", :force => true do |t|
    t.string  "title"
    t.string  "url"
    t.string  "cmte_id"
    t.string  "video_id"
    t.string  "user_name"
    t.integer "committee_id"
    t.string  "thumbnail_url"
    t.integer "length"
    t.integer "love",          :limit => 8, :default => 0
    t.integer "fair",          :limit => 8, :default => 0
    t.integer "fishy",         :limit => 8, :default => 0
    t.integer "fail",          :limit => 8, :default => 0
    t.string  "uuid"
    t.string  "upload_date"
    t.date    "upload_on"
    t.integer "view_count"
    t.integer "tunesat_count"
  end

  create_table "ads_08192012", :id => false, :force => true do |t|
    t.string   "video_id",     :limit => 20
    t.string   "cmte_name",    :limit => 150
    t.string   "user_name",    :limit => 100
    t.string   "url"
    t.string   "title"
    t.string   "uuid",         :limit => 100
    t.string   "cmte_id",      :limit => 20
    t.integer  "committee_id",                :null => false
    t.integer  "duration"
    t.datetime "upload_time"
  end

  create_table "ads_08212012", :id => false, :force => true do |t|
    t.string   "uuid"
    t.string   "title"
    t.string   "url"
    t.string   "cmte_id",   :limit => 12
    t.string   "video_id",  :limit => 20
    t.string   "user_name", :limit => 100
    t.integer  "duration"
    t.datetime "upload_on"
  end

  create_table "ads_08222012", :id => false, :force => true do |t|
    t.string   "uuid",      :limit => 100
    t.string   "title"
    t.string   "url"
    t.string   "cmte_id",   :limit => 12
    t.string   "video_id",  :limit => 15
    t.string   "user_name", :limit => 100
    t.integer  "duration"
    t.datetime "upload_on"
  end

  create_table "ads_08222012_a", :id => false, :force => true do |t|
    t.string   "uuid"
    t.string   "title"
    t.string   "url"
    t.string   "cmte_id",   :limit => 12
    t.string   "video_id",  :limit => 15
    t.string   "user_name", :limit => 20
    t.integer  "duration"
    t.datetime "upload_on"
  end

  create_table "ads_08232012", :id => false, :force => true do |t|
    t.string   "uuid",      :limit => 150
    t.string   "title"
    t.string   "url"
    t.string   "cmte_id",   :limit => 15
    t.string   "video_id",  :limit => 15
    t.string   "user_name", :limit => 20
    t.integer  "duration"
    t.datetime "upload_on"
  end

  create_table "ads_08242012", :id => false, :force => true do |t|
    t.string   "uuid",      :limit => 100
    t.string   "title"
    t.string   "url"
    t.string   "cmte_id",   :limit => 10
    t.string   "video_id",  :limit => 15
    t.string   "user_name", :limit => 100
    t.integer  "duration"
    t.datetime "upload_on"
  end

  create_table "ads_08252012", :id => false, :force => true do |t|
    t.string   "uuid",      :limit => 100
    t.string   "title"
    t.string   "url"
    t.string   "cmte_id",   :limit => 12
    t.string   "video_id",  :limit => 15
    t.string   "user_name", :limit => 100
    t.integer  "duration"
    t.datetime "upload_on"
  end

  create_table "ads_08262012", :id => false, :force => true do |t|
    t.string   "uuid",      :limit => 100
    t.string   "title",     :limit => 150
    t.string   "url"
    t.string   "cmte_id",   :limit => 12
    t.string   "video_id",  :limit => 15
    t.string   "user_name", :limit => 100
    t.integer  "duration"
    t.datetime "upload_on"
  end

  create_table "ads_08272012", :id => false, :force => true do |t|
    t.string   "uuid",      :limit => 100
    t.string   "title",     :limit => 150
    t.string   "url"
    t.string   "cmte_id",   :limit => 12
    t.string   "video_id",  :limit => 15
    t.string   "user_name", :limit => 50
    t.integer  "duration"
    t.datetime "upload_on"
  end

  create_table "ads_08282012", :id => false, :force => true do |t|
    t.string   "uuid",      :limit => 150
    t.string   "title",     :limit => 150
    t.string   "url"
    t.string   "cmte_id",   :limit => 12
    t.string   "video_id",  :limit => 15
    t.string   "user_name", :limit => 100
    t.integer  "duration"
    t.datetime "upload_on"
  end

  create_table "ads_08292012", :id => false, :force => true do |t|
    t.string   "uuid",      :limit => 100
    t.string   "title",     :limit => 150
    t.string   "url"
    t.string   "cmte_id",   :limit => 12
    t.string   "video_id",  :limit => 15
    t.string   "user_name", :limit => 50
    t.integer  "duration"
    t.datetime "upload_on"
  end

  create_table "ads_08302012", :id => false, :force => true do |t|
    t.string   "uuid",      :limit => 100
    t.string   "title",     :limit => 150
    t.string   "url"
    t.string   "cmte_id",   :limit => 12
    t.string   "video_id",  :limit => 15
    t.string   "user_name", :limit => 50
    t.integer  "duration"
    t.datetime "upload_on"
  end

  create_table "ads_08312012", :id => false, :force => true do |t|
    t.string   "uuid",      :limit => 100
    t.string   "title",     :limit => 150
    t.string   "url"
    t.string   "cmte_id",   :limit => 12
    t.string   "video_id",  :limit => 15
    t.string   "user_name", :limit => 50
    t.integer  "duration"
    t.datetime "upload_on"
  end

  create_table "ads_09022012", :id => false, :force => true do |t|
    t.string   "uuid",      :limit => 100
    t.string   "title",     :limit => 150
    t.string   "url"
    t.string   "cmte_id",   :limit => 10
    t.string   "video_id",  :limit => 20
    t.string   "user_name", :limit => 50
    t.integer  "duration"
    t.datetime "upload_on"
  end

  create_table "ads_09032012", :id => false, :force => true do |t|
    t.string   "uuid",      :limit => 100
    t.string   "title",     :limit => 200
    t.string   "url"
    t.string   "cmte_id",   :limit => 10
    t.string   "video_id",  :limit => 15
    t.string   "user_name", :limit => 50
    t.integer  "duration"
    t.datetime "upload_on"
  end

  create_table "ads_09042012", :id => false, :force => true do |t|
    t.string   "uuid",      :limit => 100
    t.string   "title",     :limit => 200
    t.string   "url"
    t.string   "cmte_id",   :limit => 10
    t.string   "video_id",  :limit => 15
    t.string   "user_name", :limit => 100
    t.integer  "duration"
    t.datetime "upload_on"
  end

  create_table "ads_claim_source_loading", :id => false, :force => true do |t|
    t.string "com_nam",      :limit => 100, :null => false
    t.string "user_name",    :limit => 100
    t.string "ad_title"
    t.string "ad_claim"
    t.string "source_url"
    t.string "source_title"
    t.string "type",         :limit => 100
    t.string "video_url"
    t.string "source_name",  :limit => 150
  end

  create_table "ads_claims", :id => false, :force => true do |t|
    t.integer "ad_id"
    t.integer "claim_id"
  end

  create_table "ads_claims_08212012", :id => false, :force => true do |t|
    t.string "cmte_name",    :limit => 150
    t.string "user_name",    :limit => 100
    t.string "url"
    t.string "video_id",     :limit => 20
    t.string "title"
    t.string "claim"
    t.string "source_url"
    t.string "source_title"
    t.string "source_name",  :limit => 125
    t.string "source_type",  :limit => 100
  end

  create_table "ads_claims_08222012", :id => false, :force => true do |t|
    t.string "cmte_name"
    t.string "user_name",    :limit => 100
    t.string "url"
    t.string "video_id",     :limit => 15
    t.string "title"
    t.string "claim"
    t.string "source_url"
    t.string "source_title"
    t.string "source_name"
    t.string "source_type",  :limit => 25
  end

  create_table "ads_claims_08232012", :id => false, :force => true do |t|
    t.string "cmte_name"
    t.string "user_name",    :limit => 100
    t.string "url"
    t.string "video_id",     :limit => 15
    t.string "title"
    t.string "claim"
    t.string "source_url"
    t.string "source_title"
    t.string "source_name"
    t.string "source_type"
  end

  create_table "ads_claims_08242012", :id => false, :force => true do |t|
    t.string "cmte_name",    :limit => 100
    t.string "user_name",    :limit => 100
    t.string "url"
    t.string "video_id",     :limit => 15
    t.string "title",        :limit => 100
    t.string "claim",        :limit => 150
    t.string "source_url"
    t.string "source_title", :limit => 150
    t.string "source_name",  :limit => 100
    t.string "source_type",  :limit => 50
  end

  create_table "ads_claims_08252012", :id => false, :force => true do |t|
    t.string "cmte_name",    :limit => 100
    t.string "user_name",    :limit => 100
    t.string "url"
    t.string "video_id",     :limit => 15
    t.string "title",        :limit => 150
    t.string "claim",        :limit => 150
    t.string "source_url"
    t.string "source_title", :limit => 100
    t.string "source_name",  :limit => 100
    t.string "source_type",  :limit => 50
  end

  create_table "ads_claims_08262012", :id => false, :force => true do |t|
    t.string "cmte_name",    :limit => 100
    t.string "user_name",    :limit => 25
    t.string "url"
    t.string "video_id",     :limit => 15
    t.string "title",        :limit => 150
    t.string "claim",        :limit => 150
    t.string "source_url"
    t.string "source_title", :limit => 150
    t.string "source_name",  :limit => 100
    t.string "source_type",  :limit => 50
  end

  create_table "ads_claims_08272012", :id => false, :force => true do |t|
    t.string "cmte_name",    :limit => 150
    t.string "user_name",    :limit => 100
    t.string "url"
    t.string "video_id",     :limit => 15
    t.string "title",        :limit => 150
    t.string "claim"
    t.string "source_link"
    t.string "source_title", :limit => 150
    t.string "source_name",  :limit => 100
    t.string "source_type",  :limit => 100
  end

  create_table "ads_claims_08282012", :id => false, :force => true do |t|
    t.string "cmte_name",    :limit => 150
    t.string "user_name",    :limit => 50
    t.string "url"
    t.string "video_id",     :limit => 15
    t.string "title",        :limit => 150
    t.string "claim",        :limit => 150
    t.string "source_url"
    t.string "source_title", :limit => 150
    t.string "source_name",  :limit => 100
    t.string "source_type",  :limit => 30
  end

  create_table "ads_claims_08292012", :id => false, :force => true do |t|
    t.string "cmte_name",    :limit => 150
    t.string "user_name",    :limit => 50
    t.string "url"
    t.string "video_id",     :limit => 15
    t.string "title",        :limit => 150
    t.string "claim"
    t.string "source_url"
    t.string "source_title", :limit => 150
    t.string "source_name",  :limit => 100
    t.string "source_type",  :limit => 50
  end

  create_table "ads_claims_08302012", :id => false, :force => true do |t|
    t.string "cmte_name",    :limit => 100
    t.string "user_name",    :limit => 50
    t.string "url"
    t.string "video_id",     :limit => 15
    t.string "title",        :limit => 150
    t.string "claim",        :limit => 150
    t.string "source_url"
    t.string "source_title", :limit => 150
    t.string "source_name",  :limit => 100
    t.string "source_type",  :limit => 100
  end

  create_table "ads_claims_08312012", :id => false, :force => true do |t|
    t.string "cmte_name",    :limit => 150
    t.string "user_name",    :limit => 100
    t.string "url"
    t.string "video_id",     :limit => 15
    t.string "title",        :limit => 150
    t.string "claim",        :limit => 150
    t.string "source_url"
    t.string "source_title", :limit => 150
    t.string "source_name",  :limit => 100
    t.string "source_type",  :limit => 50
  end

  create_table "ads_claims_09022012", :id => false, :force => true do |t|
    t.string "cmte_name",    :limit => 150
    t.string "user_name",    :limit => 50
    t.string "url"
    t.string "video_id",     :limit => 15
    t.string "title",        :limit => 200
    t.string "claim"
    t.string "source_url"
    t.string "source_title", :limit => 200
    t.string "source_name",  :limit => 100
    t.string "source_type",  :limit => 50
  end

  create_table "ads_claims_09032012", :id => false, :force => true do |t|
    t.string "cmte_name",    :limit => 150
    t.string "user_name",    :limit => 50
    t.string "url"
    t.string "video_id",     :limit => 15
    t.string "title",        :limit => 200
    t.string "claim",        :limit => 200
    t.string "source_url"
    t.string "source_title", :limit => 200
    t.string "source_name",  :limit => 100
    t.string "source_type",  :limit => 30
  end

  create_table "ads_claims_09042012", :id => false, :force => true do |t|
    t.string "cmte_name",    :limit => 100
    t.string "user_name",    :limit => 50
    t.string "url"
    t.string "video_id",     :limit => 15
    t.string "title",        :limit => 200
    t.string "claim",        :limit => 200
    t.string "source_link"
    t.string "source_title", :limit => 150
    t.string "source_name",  :limit => 100
    t.string "source_type",  :limit => 50
  end

  create_table "ads_claims_sources2", :id => false, :force => true do |t|
    t.string "cmte_name"
    t.string "user_name"
    t.string "video_url"
    t.string "video_id"
    t.string "title"
    t.string "claim"
    t.string "url"
    t.string "article_title"
    t.string "source_name"
    t.string "source_type"
  end

  create_table "ads_claims_sources_08172012", :id => false, :force => true do |t|
    t.string "cmte_name"
    t.string "user_name"
    t.string "video_url"
    t.string "video_id"
    t.string "ad_title"
    t.string "claim"
    t.string "claim_url"
    t.string "source_title"
    t.string "source_name"
    t.string "source_type"
    t.string "uuid",         :limit => 100
  end

  create_table "ads_copy", :id => false, :force => true do |t|
    t.string  "title"
    t.string  "url"
    t.string  "cmte_id"
    t.string  "video_id"
    t.string  "user_name"
    t.integer "committee_id"
    t.string  "thumbnail_url"
    t.integer "length"
    t.integer "love",          :limit => 8
    t.integer "fair",          :limit => 8
    t.integer "fishy",         :limit => 8
    t.integer "fail",          :limit => 8
    t.string  "uuid"
    t.string  "upload_date"
  end

  create_table "ads_from_google_docs", :id => false, :force => true do |t|
    t.string   "uuid"
    t.string   "title"
    t.string   "document_url"
    t.string   "cmte_id",      :limit => 11
    t.string   "video_id",     :limit => 15
    t.string   "user_name",    :limit => 100
    t.string   "duration",     :limit => 10
    t.datetime "upload_time"
    t.integer  "committee_id"
  end

  create_table "ads_loading", :id => false, :force => true do |t|
    t.string  "unique_id",      :limit => 100
    t.string  "meta_desc"
    t.string  "meta_keyword"
    t.string  "title"
    t.string  "document_url"
    t.string  "video_id"
    t.integer "down_votes"
    t.integer "num_views"
    t.string  "video_title"
    t.integer "up_votes"
    t.string  "user_name",      :limit => 150
    t.string  "category_name",  :limit => 100
    t.text    "tags"
    t.string  "license_name",   :limit => 150
    t.string  "upload_time",    :limit => 100
    t.integer "video_duration"
  end

  create_table "api_keys", :force => true do |t|
    t.string   "owner"
    t.string   "access_token"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "api_keys", ["owner"], :name => "index_api_keys_on_owner", :unique => true

  create_table "appcontacts", :force => true do |t|
    t.string   "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "claim_details", :force => true do |t|
    t.integer "claim_id"
    t.string  "source_name"
    t.string  "source_url"
    t.string  "source_title"
    t.string  "source_type"
  end

  create_table "claim_details_temp", :force => true do |t|
    t.integer "claim_id",                    :null => false
    t.string  "ad_title",     :limit => 200
    t.string  "claim_source"
    t.string  "source_url"
    t.string  "source_title", :limit => 200
    t.string  "source_name",  :limit => 100
    t.string  "type",         :limit => 50
  end

  create_table "claim_links", :force => true do |t|
    t.string   "link"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "claim_id"
    t.string   "claim_type"
    t.string   "source"
  end

  create_table "claims", :force => true do |t|
    t.string "claim"
  end

  create_table "claims-08212012", :id => false, :force => true do |t|
    t.string "claim"
  end

  create_table "claims_copy", :force => true do |t|
    t.string "claim"
  end

  create_table "claims_loading", :id => false, :force => true do |t|
    t.string  "claim"
    t.integer "ad_id"
  end

  create_table "committee_articles", :force => true do |t|
    t.integer "committee_id"
    t.string  "title"
    t.string  "url"
    t.string  "source"
  end

  create_table "committee_to_track_loaded", :id => false, :force => true do |t|
    t.string  "com_nam"
    t.string  "lin_ima"
    t.string  "com_typ",                    :limit => 10
    t.string  "fil_fre",                    :limit => 2
    t.string  "com_des",                    :limit => 2
    t.string  "add",                        :limit => 150
    t.string  "cit",                        :limit => 150
    t.string  "sta",                        :limit => 3
    t.string  "zip",                        :limit => 10
    t.string  "tre_nam"
    t.string  "com_id",                     :limit => 11
    t.integer "fec_ele_yea"
    t.decimal "ind_ite_con",                               :precision => 15, :scale => 2
    t.decimal "ind_uni_con",                               :precision => 15, :scale => 2
    t.decimal "ind_con",                                   :precision => 15, :scale => 2
    t.decimal "ind_ref",                                   :precision => 15, :scale => 2
    t.decimal "par_com_con",                               :precision => 15, :scale => 2
    t.decimal "oth_com_con",                               :precision => 15, :scale => 2
    t.decimal "oth_com_ref",                               :precision => 15, :scale => 2
    t.decimal "can_con",                                   :precision => 15, :scale => 2
    t.decimal "tot_con",                                   :precision => 15, :scale => 2
    t.decimal "tot_con_ref",                               :precision => 15, :scale => 2
    t.decimal "can_loa",                                   :precision => 15, :scale => 2
    t.decimal "can_loa_rep",                               :precision => 15, :scale => 2
    t.decimal "oth_loa",                                   :precision => 15, :scale => 2
    t.decimal "oth_loa_rep",                               :precision => 15, :scale => 2
    t.decimal "tot_loa",                                   :precision => 15, :scale => 2
    t.decimal "tot_loa_rep",                               :precision => 15, :scale => 2
    t.decimal "tra_fro_non_fed_acc",                       :precision => 15, :scale => 2
    t.decimal "tra_fro_non_fed_lev_acc",                   :precision => 15, :scale => 2
    t.decimal "tot_non_fed_tra",                           :precision => 15, :scale => 2
    t.decimal "oth_rec",                                   :precision => 15, :scale => 2
    t.decimal "tot_rec",                                   :precision => 15, :scale => 2
    t.decimal "tot_fed_rec",                               :precision => 15, :scale => 2
    t.decimal "ope_exp",                                   :precision => 15, :scale => 2
    t.decimal "sha_fed_ope_exp",                           :precision => 15, :scale => 2
    t.decimal "sha_non_fed_ope_exp",                       :precision => 15, :scale => 2
    t.decimal "tot_ope_exp",                               :precision => 15, :scale => 2
    t.decimal "off_to_ope_exp",                            :precision => 15, :scale => 2
    t.decimal "fed_sha_of_joi_act",                        :precision => 15, :scale => 2
    t.decimal "non_fed_sha_of_joi_act",                    :precision => 15, :scale => 2
    t.decimal "non_all_fed_ele_act_par",                   :precision => 15, :scale => 2
    t.decimal "tot_fed_ele_act",                           :precision => 15, :scale => 2
    t.decimal "fed_can_com_con",                           :precision => 15, :scale => 2
    t.decimal "fed_can_con_ref",                           :precision => 15, :scale => 2
    t.decimal "ind_exp_mad",                               :precision => 15, :scale => 2
    t.decimal "coo_exp_par",                               :precision => 15, :scale => 2
    t.decimal "loa_mad",                                   :precision => 15, :scale => 2
    t.decimal "loa_rep_rec",                               :precision => 15, :scale => 2
    t.decimal "tra_to_oth_aut_com",                        :precision => 15, :scale => 2
    t.decimal "fun_dis",                                   :precision => 15, :scale => 2
    t.decimal "off_to_fun_exp_pre",                        :precision => 15, :scale => 2
    t.decimal "exe_leg_acc_dis_pre",                       :precision => 15, :scale => 2
    t.decimal "off_to_leg_acc_exp_pre",                    :precision => 15, :scale => 2
    t.decimal "tot_off_to_ope_exp",                        :precision => 15, :scale => 2
    t.decimal "oth_dis",                                   :precision => 15, :scale => 2
    t.decimal "tot_fed_dis",                               :precision => 15, :scale => 2
    t.decimal "tot_dis",                                   :precision => 15, :scale => 2
    t.decimal "net_con",                                   :precision => 15, :scale => 2
    t.decimal "net_ope_exp",                               :precision => 15, :scale => 2
    t.decimal "cas_on_han_beg_of_per",                     :precision => 15, :scale => 2
    t.decimal "cas_on_han_clo_of_per",                     :precision => 15, :scale => 2
    t.decimal "deb_owe_by_com",                            :precision => 15, :scale => 2
    t.decimal "deb_owe_to_com",                            :precision => 15, :scale => 2
    t.string  "cov_sta_dat",                :limit => 30
    t.string  "cov_end_dat",                :limit => 30
    t.decimal "pol_par_com_ref",                           :precision => 11, :scale => 2
    t.string  "can_id",                     :limit => 9
    t.decimal "cas_on_han_beg_of_yea",                     :precision => 15, :scale => 2
    t.decimal "cas_on_han_clo_of_yea",                     :precision => 15, :scale => 2
    t.decimal "exp_sub_to_lim_pri_yea_pre",                :precision => 15, :scale => 2
    t.decimal "exp_sub_lim",                               :precision => 15, :scale => 2
    t.decimal "fed_fun",                                   :precision => 15, :scale => 2
    t.decimal "ite_con_exp_con_com",                       :precision => 15, :scale => 2
    t.decimal "ite_oth_dis",                               :precision => 15, :scale => 2
    t.decimal "ite_oth_inc",                               :precision => 15, :scale => 2
    t.decimal "ite_oth_ref_or_reb",                        :precision => 15, :scale => 2
    t.decimal "ite_ref_or_reb",                            :precision => 15, :scale => 2
    t.decimal "oth_fed_ope_exp",                           :precision => 15, :scale => 2
    t.decimal "sub_con_exp",                               :precision => 15, :scale => 2
    t.decimal "sub_oth_ref_or_reb",                        :precision => 15, :scale => 2
    t.decimal "sub_ref_or_reb",                            :precision => 15, :scale => 2
    t.decimal "tot_com_cos",                               :precision => 15, :scale => 2
    t.decimal "tot_exp_sub_to_lim_pre",                    :precision => 15, :scale => 2
    t.decimal "uni_con_exp",                               :precision => 15, :scale => 2
    t.decimal "uni_oth_dis",                               :precision => 15, :scale => 2
    t.decimal "uni_oth_inc",                               :precision => 15, :scale => 2
    t.decimal "uni_oth_ref_or_reb",                        :precision => 15, :scale => 2
    t.decimal "uni_ref_or_reb",                            :precision => 15, :scale => 2
  end

  create_table "committees", :force => true do |t|
    t.string  "cmte_id",                                                                    :null => false
    t.string  "cmte_name",                                                                  :null => false
    t.string  "suppopp"
    t.decimal "total_raised",             :precision => 15, :scale => 2
    t.decimal "total_spent",              :precision => 15, :scale => 2
    t.decimal "total_elecomm_spending",   :precision => 15, :scale => 2
    t.decimal "total_comm_cost_spending", :precision => 15, :scale => 2
    t.decimal "total_coordexp_spending",  :precision => 15, :scale => 2
    t.decimal "total_demfor",             :precision => 15, :scale => 2
    t.decimal "total_demagnst",           :precision => 15, :scale => 2
    t.decimal "total_repubfor",           :precision => 15, :scale => 2
    t.decimal "total_repubagnst",         :precision => 15, :scale => 2
    t.decimal "total_cash_on_hand",       :precision => 15, :scale => 2
    t.string  "run_date"
    t.string  "end_date"
    t.integer "min_cycle"
    t.integer "cycle",                                                   :default => 2012
    t.string  "disclose"
    t.string  "candidate_id"
    t.string  "candidate_name"
    t.boolean "is_pac",                                                  :default => false
    t.boolean "is_superpac",                                             :default => false
    t.boolean "is_527",                                                  :default => false
    t.boolean "is_c3",                                                   :default => false
    t.boolean "is_c4",                                                   :default => false
    t.boolean "is_c5",                                                   :default => false
    t.boolean "is_c6",                                                   :default => false
    t.decimal "total_outside",            :precision => 11, :scale => 2
    t.decimal "ind_exp",                  :precision => 11, :scale => 2
    t.string  "org_type"
    t.string  "user_name"
    t.text    "bio"
    t.string  "url"
  end

  create_table "committees_loading", :id => false, :force => true do |t|
    t.string  "cmte_id",                                                              :null => false
    t.string  "cmte_name",                                                            :null => false
    t.string  "suppopp"
    t.decimal "total_raised",                          :precision => 11, :scale => 2
    t.decimal "total_spent",                           :precision => 11, :scale => 2
    t.decimal "total_elecomm_spending",                :precision => 11, :scale => 2
    t.decimal "total_comm_cost_spending",              :precision => 11, :scale => 2
    t.decimal "total_coordexp_spending",               :precision => 11, :scale => 2
    t.decimal "total_demfor",                          :precision => 11, :scale => 2
    t.decimal "total_demagnst",                        :precision => 11, :scale => 2
    t.decimal "total_repubfor",                        :precision => 11, :scale => 2
    t.decimal "total_repubagnst",                      :precision => 11, :scale => 2
    t.decimal "total_cash_on_hand",                    :precision => 11, :scale => 2
    t.string  "run_date"
    t.string  "end_date"
    t.integer "min_cycle"
    t.integer "cycle"
    t.string  "disclose"
    t.string  "candidate_id"
    t.string  "candidate_name"
    t.string  "is_pac",                   :limit => 1
    t.string  "is_superpac",              :limit => 1
    t.string  "is_527",                   :limit => 1
    t.string  "is_c3",                    :limit => 1
    t.string  "is_c4",                    :limit => 1
    t.string  "is_c5",                    :limit => 1
    t.string  "is_c6",                    :limit => 1
    t.decimal "total_outside",                         :precision => 11, :scale => 2
    t.decimal "ind_exp",                               :precision => 11, :scale => 2
  end

  create_table "committees_to_track", :id => false, :force => true do |t|
    t.string "com_nam"
    t.string "user_name", :limit => 100
  end

  create_table "contacts", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "message"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "failed_ads", :force => true do |t|
    t.float    "lat"
    t.float    "long"
    t.string   "suppopp"
    t.string   "candidate"
    t.text     "comment"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "fec_committees_loading", :id => false, :force => true do |t|
    t.string  "com_nam"
    t.string  "lin_ima"
    t.string  "com_typ",                    :limit => 10
    t.string  "fil_fre",                    :limit => 2
    t.string  "com_des",                    :limit => 2
    t.string  "add",                        :limit => 150
    t.string  "cit",                        :limit => 150
    t.string  "sta",                        :limit => 3
    t.string  "zip",                        :limit => 10
    t.string  "tre_nam"
    t.string  "com_id",                     :limit => 11
    t.integer "fec_ele_yea"
    t.decimal "ind_ite_con",                               :precision => 15, :scale => 2
    t.decimal "ind_uni_con",                               :precision => 15, :scale => 2
    t.decimal "ind_con",                                   :precision => 15, :scale => 2
    t.decimal "ind_ref",                                   :precision => 15, :scale => 2
    t.decimal "par_com_con",                               :precision => 15, :scale => 2
    t.decimal "oth_com_con",                               :precision => 15, :scale => 2
    t.decimal "oth_com_ref",                               :precision => 15, :scale => 2
    t.decimal "can_con",                                   :precision => 15, :scale => 2
    t.decimal "tot_con",                                   :precision => 15, :scale => 2
    t.decimal "tot_con_ref",                               :precision => 15, :scale => 2
    t.decimal "can_loa",                                   :precision => 15, :scale => 2
    t.decimal "can_loa_rep",                               :precision => 15, :scale => 2
    t.decimal "oth_loa",                                   :precision => 15, :scale => 2
    t.decimal "oth_loa_rep",                               :precision => 15, :scale => 2
    t.decimal "tot_loa",                                   :precision => 15, :scale => 2
    t.decimal "tot_loa_rep",                               :precision => 15, :scale => 2
    t.decimal "tra_fro_non_fed_acc",                       :precision => 15, :scale => 2
    t.decimal "tra_fro_non_fed_lev_acc",                   :precision => 15, :scale => 2
    t.decimal "tot_non_fed_tra",                           :precision => 15, :scale => 2
    t.decimal "oth_rec",                                   :precision => 15, :scale => 2
    t.decimal "tot_rec",                                   :precision => 15, :scale => 2
    t.decimal "tot_fed_rec",                               :precision => 15, :scale => 2
    t.decimal "ope_exp",                                   :precision => 15, :scale => 2
    t.decimal "sha_fed_ope_exp",                           :precision => 15, :scale => 2
    t.decimal "sha_non_fed_ope_exp",                       :precision => 15, :scale => 2
    t.decimal "tot_ope_exp",                               :precision => 15, :scale => 2
    t.decimal "off_to_ope_exp",                            :precision => 15, :scale => 2
    t.decimal "fed_sha_of_joi_act",                        :precision => 15, :scale => 2
    t.decimal "non_fed_sha_of_joi_act",                    :precision => 15, :scale => 2
    t.decimal "non_all_fed_ele_act_par",                   :precision => 15, :scale => 2
    t.decimal "tot_fed_ele_act",                           :precision => 15, :scale => 2
    t.decimal "fed_can_com_con",                           :precision => 15, :scale => 2
    t.decimal "fed_can_con_ref",                           :precision => 15, :scale => 2
    t.decimal "ind_exp_mad",                               :precision => 15, :scale => 2
    t.decimal "coo_exp_par",                               :precision => 15, :scale => 2
    t.decimal "loa_mad",                                   :precision => 15, :scale => 2
    t.decimal "loa_rep_rec",                               :precision => 15, :scale => 2
    t.decimal "tra_to_oth_aut_com",                        :precision => 15, :scale => 2
    t.decimal "fun_dis",                                   :precision => 15, :scale => 2
    t.decimal "off_to_fun_exp_pre",                        :precision => 15, :scale => 2
    t.decimal "exe_leg_acc_dis_pre",                       :precision => 15, :scale => 2
    t.decimal "off_to_leg_acc_exp_pre",                    :precision => 15, :scale => 2
    t.decimal "tot_off_to_ope_exp",                        :precision => 15, :scale => 2
    t.decimal "oth_dis",                                   :precision => 15, :scale => 2
    t.decimal "tot_fed_dis",                               :precision => 15, :scale => 2
    t.decimal "tot_dis",                                   :precision => 15, :scale => 2
    t.decimal "net_con",                                   :precision => 15, :scale => 2
    t.decimal "net_ope_exp",                               :precision => 15, :scale => 2
    t.decimal "cas_on_han_beg_of_per",                     :precision => 15, :scale => 2
    t.decimal "cas_on_han_clo_of_per",                     :precision => 15, :scale => 2
    t.decimal "deb_owe_by_com",                            :precision => 15, :scale => 2
    t.decimal "deb_owe_to_com",                            :precision => 15, :scale => 2
    t.string  "cov_sta_dat",                :limit => 30
    t.string  "cov_end_dat",                :limit => 30
    t.decimal "pol_par_com_ref",                           :precision => 11, :scale => 2
    t.string  "can_id",                     :limit => 9
    t.decimal "cas_on_han_beg_of_yea",                     :precision => 15, :scale => 2
    t.decimal "cas_on_han_clo_of_yea",                     :precision => 15, :scale => 2
    t.decimal "exp_sub_to_lim_pri_yea_pre",                :precision => 15, :scale => 2
    t.decimal "exp_sub_lim",                               :precision => 15, :scale => 2
    t.decimal "fed_fun",                                   :precision => 15, :scale => 2
    t.decimal "ite_con_exp_con_com",                       :precision => 15, :scale => 2
    t.decimal "ite_oth_dis",                               :precision => 15, :scale => 2
    t.decimal "ite_oth_inc",                               :precision => 15, :scale => 2
    t.decimal "ite_oth_ref_or_reb",                        :precision => 15, :scale => 2
    t.decimal "ite_ref_or_reb",                            :precision => 15, :scale => 2
    t.decimal "oth_fed_ope_exp",                           :precision => 15, :scale => 2
    t.decimal "sub_con_exp",                               :precision => 15, :scale => 2
    t.decimal "sub_oth_ref_or_reb",                        :precision => 15, :scale => 2
    t.decimal "sub_ref_or_reb",                            :precision => 15, :scale => 2
    t.decimal "tot_com_cos",                               :precision => 15, :scale => 2
    t.decimal "tot_exp_sub_to_lim_pre",                    :precision => 15, :scale => 2
    t.decimal "uni_con_exp",                               :precision => 15, :scale => 2
    t.decimal "uni_oth_dis",                               :precision => 15, :scale => 2
    t.decimal "uni_oth_inc",                               :precision => 15, :scale => 2
    t.decimal "uni_oth_ref_or_reb",                        :precision => 15, :scale => 2
    t.decimal "uni_ref_or_reb",                            :precision => 15, :scale => 2
  end

  create_table "glassy_metadata", :id => false, :force => true do |t|
    t.string "Unique_ID"
    t.text   "Title"
    t.string "Document_URL"
    t.string "Video_ID"
    t.string "Upload_Time"
    t.string "Video_Duration"
    t.string "user_name"
  end

  create_table "ind_exp_loading", :id => false, :force => true do |t|
    t.string  "can_id",       :limit => 9
    t.string  "can_nam",      :limit => 100
    t.string  "spe_id",       :limit => 9
    t.string  "spe_nam",      :limit => 100
    t.string  "ele_typ",      :limit => 5
    t.string  "can_off_sta",  :limit => 2
    t.integer "can_off_dis",  :limit => 8
    t.string  "can_off",      :limit => 1
    t.string  "can_par_aff",  :limit => 3
    t.string  "exp_amo",      :limit => 100
    t.date    "exp_dat"
    t.string  "agg_amo",      :limit => 100
    t.string  "sup_opp",      :limit => 1
    t.string  "pur",          :limit => 100
    t.string  "pay",          :limit => 100
    t.integer "file_num",     :limit => 8
    t.string  "amn_ind",      :limit => 1
    t.string  "tra_id",       :limit => 32
    t.integer "ima_num",      :limit => 8
    t.date    "rec_dt"
    t.integer "prev_fil_num", :limit => 8
  end

  create_table "independent-expenditure", :id => false, :force => true do |t|
    t.string   "can_id"
    t.string   "can_nam"
    t.string   "spe_id"
    t.string   "spe_nam"
    t.string   "ele_typ"
    t.string   "can_off_sta"
    t.decimal  "can_off_dis",   :precision => 15, :scale => 2
    t.string   "can_off"
    t.string   "can_par_aff"
    t.string   "exp_amo"
    t.datetime "exp_dat"
    t.string   "agg_amo"
    t.string   "sup_opp"
    t.string   "pur"
    t.string   "pay"
    t.decimal  "file_num",      :precision => 15, :scale => 2
    t.string   "amn_ind"
    t.string   "tra_id"
    t.decimal  "ima_num",       :precision => 15, :scale => 2
    t.datetime "rec_dat"
    t.decimal  "prev_file_num", :precision => 15, :scale => 2
  end

  create_table "switchers_claims", :id => false, :force => true do |t|
    t.string "cmte_name",    :limit => 150
    t.string "user_name",    :limit => 150
    t.string "url"
    t.string "video_id",     :limit => 15
    t.string "title",        :limit => 150
    t.string "claim",        :limit => 200
    t.string "source_url"
    t.string "source_title", :limit => 150
    t.string "source_name",  :limit => 100
    t.string "source_type",  :limit => 50
  end

  create_table "tagged_ads", :force => true do |t|
    t.integer  "ad_id"
    t.string   "tag"
    t.float    "lat"
    t.float    "long"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "tunesat-video-ids", :id => false, :force => true do |t|
    t.string "video_id", :limit => 20
  end

  create_table "tunesat_glassy_test", :id => false, :force => true do |t|
    t.string   "uuid"
    t.string   "video_id"
    t.datetime "upload_on"
    t.datetime "updated_on"
    t.string   "user_name"
    t.string   "video_title"
    t.string   "thumbnail_url"
    t.string   "url"
  end

  create_table "video-claim", :id => false, :force => true do |t|
    t.string "video_id", :limit => 20
    t.string "claim"
  end

  create_table "yt_urls", :id => false, :force => true do |t|
    t.string "url"
  end

  create_table "yt_urls2", :id => false, :force => true do |t|
    t.string "url"
    t.string "video_id", :limit => 15
  end

  create_table "ytids", :id => false, :force => true do |t|
    t.string "UUID"
    t.string "video_id", :limit => 20
  end

end
